import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/widgets.dart' show StringCharacters;
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../features/decision/data/models/food_option.dart';
import '../../features/decision/data/models/objective.dart';
import '../../features/decision/data/models/verdict.dart';
import '../providers/ai_consent_provider.dart';
import 'ai_service.dart';

/// Safe categories; response bodies, photos and credentials never enter errors.
enum AiGatewayError {
  configuration,
  invalidInput,
  network,
  timeout,
  unauthorized,
  rateLimit,
  consentRequired,
  consentOutdated,
  contentFilter,
  payloadTooLarge,
  server,
  invalidResponse,
}

class AiGatewayException extends AiServiceException {
  const AiGatewayException(
    this.code,
    String message, {
    this.statusCode,
    this.retryAfter,
    Object? cause,
  }) : super(message, cause);

  final AiGatewayError code;
  final int? statusCode;
  final Duration? retryAfter;

  @override
  String toString() =>
      'AiGatewayException(${code.name}, $statusCode): $message';
}

/// FoodJury's client for the shared gateway. Provider models and fallback live
/// on the gateway; an explicit user retry remains one client request.
class AiGatewayService implements AiService {
  AiGatewayService({
    required this.baseUrl,
    required this.token,
    required this.environment,
    required this.deviceId,
    required this.acceptedConsentVersion,
    http.Client? client,
    this.requestTimeout = const Duration(seconds: 40),
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final String token;
  final String environment;
  final String Function() deviceId;
  final Future<String?> Function() acceptedConsentVersion;
  final Duration requestTimeout;
  final http.Client _client;

  /// Matches FoodJury's gateway limit and includes base64 expansion and text.
  static const maxRequestBytes = 11000000;
  static const maxImageBytes = 1500000;
  static const maxTextCharacters = 12000;
  static const consentVersion = aiConsentVersion;

  /// Release connections when the owning provider is disposed.
  void close() => _client.close();

  Uri _endpoint() {
    final base = Uri.tryParse(baseUrl);
    if (base == null ||
        base.scheme != 'https' ||
        base.host.isEmpty ||
        base.userInfo.isNotEmpty ||
        base.hasQuery ||
        base.hasFragment ||
        (base.path.isNotEmpty && base.path != '/') ||
        token.trim().isEmpty ||
        token.contains(RegExp(r'[\r\n]')) ||
        !const ['dev', 'prod'].contains(environment)) {
      throw const AiGatewayException(
        AiGatewayError.configuration,
        'AI gateway configuration is unavailable',
      );
    }
    return base.resolve('/v1/chat');
  }

  @override
  Future<Verdict> generateVerdict({
    required List<FoodOption> options,
    required Objective objective,
    required JudgeTone tone,
    required Locale locale,
  }) async {
    final endpoint = _endpoint();
    if (options.length < 2 ||
        options.length > 5 ||
        options.any(
          (o) =>
              o.id.isEmpty ||
              o.name.trim().isEmpty ||
              o.name.characters.length > 80 ||
              (o.notes?.characters.length ?? 0) > 500,
        ) ||
        options.map((o) => o.id).toSet().length != options.length) {
      throw const AiGatewayException(
        AiGatewayError.invalidInput,
        'A verdict requires 2–5 distinct named food options',
      );
    }
    final evidence = List<FoodOption>.unmodifiable(
      options.map((o) => o.snapshot()),
    );
    for (final option in evidence) {
      if ((option.imageBytes?.length ?? 0) > maxImageBytes) {
        throw const AiGatewayException(
          AiGatewayError.payloadTooLarge,
          'A photo is too large for an AI request',
        );
      }
    }
    final content = <Map<String, dynamic>>[
      {
        'type': 'text',
        'text': jsonEncode({
          'v': 1,
          'task': 'verdict',
          'objective': objective.name,
          'tone': tone.name,
          'options': [
            for (final (index, option) in evidence.indexed)
              {
                'index': index + 1,
                'name': option.name,
                'notes': option.notes,
                'photo': option.hasImage,
              },
          ],
        }),
      },
      for (final (index, option) in evidence.indexed)
        if (option.hasImage) ...[
          {
            'type': 'text',
            'text': jsonEncode({'photo_for_option': index + 1}),
          },
          {
            'type': 'image_url',
            'image_url': {
              'url':
                  'data:${_imageMime(option.imageBytes!)};base64,${base64Encode(option.imageBytes!)}',
            },
          },
        ],
    ];
    final textCharacters = content
        .where((part) => part['type'] == 'text')
        .fold<int>(0, (total, part) => total + (part['text'] as String).length);
    if (textCharacters > maxTextCharacters) {
      throw const AiGatewayException(
        AiGatewayError.payloadTooLarge,
        'The food details are too long for one AI request',
      );
    }
    // Prompts, model choice, output schema and token limits are server-owned.
    final body = utf8.encode(
      jsonEncode({
        'messages': [
          {'role': 'user', 'content': content},
        ],
      }),
    );
    if (body.length > maxRequestBytes) {
      throw const AiGatewayException(
        AiGatewayError.payloadTooLarge,
        'The photos are too large for one AI request',
      );
    }

    final consent = await acceptedConsentVersion();
    if (consent != consentVersion) {
      throw const AiGatewayException(
        AiGatewayError.consentRequired,
        'AI consent is required before sending food details or photos',
      );
    }
    final installId = deviceId();
    if (!RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
    ).hasMatch(installId)) {
      throw const AiGatewayException(
        AiGatewayError.configuration,
        'The AI gateway install identity is unavailable',
      );
    }
    final abort = Completer<void>();
    final request =
        http.AbortableRequest('POST', endpoint, abortTrigger: abort.future)
          ..headers.addAll({
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
            'x-app-id': 'foodjury',
            'x-env': environment,
            'x-task': 'verdict',
            'x-locale': locale.languageCode == 'es' ? 'es' : 'en',
            'x-device-id': installId,
            'x-consent-version': consent!,
          })
          ..bodyBytes = body;
    try {
      final response = await _send(request).timeout(
        requestTimeout,
        onTimeout: () {
          abort.complete();
          throw TimeoutException(
            'AI gateway request timed out',
            requestTimeout,
          );
        },
      );
      if (response.statusCode != 200) throw _statusError(response);
      final envelope = jsonDecode(utf8.decode(response.bodyBytes));
      if (envelope is! Map<String, dynamic> ||
          envelope['text'] is! String ||
          (envelope['text'] as String).trim().isEmpty) {
        throw const FormatException('Missing gateway text');
      }
      return _parseVerdict(
        envelope['text'] as String,
        evidence,
        objective,
        tone,
      );
    } on AiGatewayException {
      rethrow;
    } on TimeoutException {
      throw AiGatewayException(
        AiGatewayError.timeout,
        'The AI request timed out',
        cause: TimeoutException('AI gateway request timed out', requestTimeout),
      );
    } on SocketException {
      throw _networkError();
    } on HttpException {
      throw _networkError();
    } on http.ClientException {
      throw _networkError();
    } catch (_) {
      throw const AiGatewayException(
        AiGatewayError.invalidResponse,
        'The AI returned an incomplete or invalid verdict',
      );
    }
  }

  Future<http.Response> _send(http.BaseRequest request) async =>
      http.Response.fromStream(await _client.send(request));

  static AiGatewayException _networkError() => const AiGatewayException(
    AiGatewayError.network,
    'The AI gateway could not be reached',
    cause: SocketException('AI gateway connection failed'),
  );

  static AiGatewayException _statusError(http.Response response) {
    final status = response.statusCode;
    Duration? retryAfter;
    try {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final seconds = data is Map ? data['retry_after_seconds'] : null;
      if (seconds is num && seconds.isFinite && seconds > 0) {
        retryAfter = Duration(seconds: seconds.ceil().clamp(1, 604800));
      }
    } catch (_) {
      // Only the typed retry interval is read; raw provider errors stay private.
    }
    return AiGatewayException(
      switch (status) {
        401 || 403 => AiGatewayError.unauthorized,
        412 => AiGatewayError.consentOutdated,
        429 => AiGatewayError.rateLimit,
        451 => AiGatewayError.contentFilter,
        413 => AiGatewayError.payloadTooLarge,
        408 || 504 => AiGatewayError.timeout,
        404 => AiGatewayError.configuration,
        _ => AiGatewayError.server,
      },
      'The AI gateway could not complete this request',
      statusCode: status,
      retryAfter: retryAfter,
      cause: status == 408 || status == 504
          ? TimeoutException('AI gateway request timed out')
          : null,
    );
  }

  /// Recognizes actual encoded bytes; original photo data is never relabeled
  /// as JPEG or silently omitted when the gallery supplies another format.
  static String _imageMime(Uint8List bytes) {
    if (bytes.length >= 3 &&
        bytes[0] == 0xff &&
        bytes[1] == 0xd8 &&
        bytes[2] == 0xff) {
      return 'image/jpeg';
    }
    if (bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4e &&
        bytes[3] == 0x47 &&
        bytes[4] == 0x0d &&
        bytes[5] == 0x0a &&
        bytes[6] == 0x1a &&
        bytes[7] == 0x0a) {
      return 'image/png';
    }
    if (bytes.length >= 6 &&
        (ascii.decode(bytes.sublist(0, 6), allowInvalid: true) == 'GIF87a' ||
            ascii.decode(bytes.sublist(0, 6), allowInvalid: true) ==
                'GIF89a')) {
      return 'image/gif';
    }
    if (bytes.length >= 12 &&
        ascii.decode(bytes.sublist(0, 4), allowInvalid: true) == 'RIFF' &&
        ascii.decode(bytes.sublist(8, 12), allowInvalid: true) == 'WEBP') {
      return 'image/webp';
    }
    throw const AiGatewayException(
      AiGatewayError.invalidInput,
      'A photo has an unsupported image format',
    );
  }

  static Verdict _parseVerdict(
    String text,
    List<FoodOption> options,
    Objective objective,
    JudgeTone tone,
  ) {
    // A single enclosing JSON fence is harmless; prose around JSON is rejected.
    var source = text.trim();
    final fence = RegExp(
      r'^```(?:json)?\s*([\s\S]*?)\s*```$',
      caseSensitive: false,
    ).firstMatch(source);
    if (fence != null) source = fence.group(1)!;
    final data = jsonDecode(source);
    const fields = ['winner', 'rankings', 'verdict', 'bonus_type', 'bonus'];
    if (data is! Map<String, dynamic> ||
        data.length != fields.length ||
        fields.any((field) => !data.containsKey(field))) {
      throw const FormatException('Expected complete verdict object');
    }
    final winner = data['winner'];
    final raw = data['rankings'];
    final reasoning = data['verdict'];
    if (winner is! int ||
        winner < 1 ||
        winner > options.length ||
        raw is! List ||
        raw.length != options.length ||
        raw.any((v) => v is! int || v < 1 || v > options.length) ||
        raw.toSet().length != options.length ||
        raw.first != winner ||
        reasoning is! String ||
        reasoning.trim().isEmpty ||
        reasoning.runes.length > 700) {
      throw const FormatException('Incomplete or inconsistent verdict');
    }
    final bonus = data['bonus'];
    final bonusType = data['bonus_type'];
    if (bonus is! String ||
        bonus.trim().isEmpty ||
        bonus.runes.length > 250 ||
        !const ['joke', 'fun_fact', 'tip', 'story'].contains(bonusType)) {
      throw const FormatException('Invalid bonus content');
    }
    return Verdict(
      id: const Uuid().v4(),
      contenders: options,
      winner: options[winner - 1],
      rankings: List.unmodifiable(raw.map((i) => options[(i as int) - 1])),
      reasoning: reasoning.trim(),
      objective: objective,
      judgeTone: tone,
      createdAt: DateTime.now(),
      bonus: bonus.trim(),
      bonusType: switch (bonusType) {
        'joke' => BonusType.joke,
        'fun_fact' => BonusType.funFact,
        'tip' => BonusType.tip,
        'story' => BonusType.story,
        _ => null,
      },
    );
  }
}
