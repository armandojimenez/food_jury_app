import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_ai/firebase_ai.dart';

import '../../features/decision/data/models/food_option.dart';
import '../../features/decision/data/models/objective.dart';
import '../../features/decision/data/models/verdict.dart';
import 'ai_service.dart';

/// AI service implementation using Firebase AI Logic with Gemini.
class GeminiAiService implements AiService {
  GeminiAiService() : _model = _createModel();

  final GenerativeModel _model;

  static GenerativeModel _createModel() {
    return FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.5-flash-lite',
      generationConfig: GenerationConfig(
        temperature: 0.8,
        topP: 0.95,
        maxOutputTokens: 1024,
        responseMimeType: 'application/json',
      ),
    );
  }

  @override
  Future<Verdict> generateVerdict({
    required List<FoodOption> options,
    required Objective objective,
    required JudgeTone tone,
    required Locale locale,
  }) async {
    try {
      final prompt = _buildPrompt(options, objective, tone, locale);
      final parts = await _buildContentParts(prompt, options);

      final response = await _model.generateContent([Content.multi(parts)]);
      final text = response.text;

      if (text == null || text.isEmpty) {
        throw const AiServiceException('Empty response from AI');
      }

      return _parseResponse(text, options, objective, tone);
    } on AiServiceException {
      rethrow;
    } catch (e) {
      throw AiServiceException('Failed to generate verdict', e);
    }
  }

  String _buildPrompt(
    List<FoodOption> options,
    Objective objective,
    JudgeTone tone,
    Locale locale,
  ) {
    final isSpanish = locale.languageCode == 'es';
    final optionsList = options.asMap().entries.map((entry) {
      final i = entry.key;
      final o = entry.value;
      final notes = o.notes?.isNotEmpty == true ? o.notes : 'None';
      final hasImage =
          o.imagePath != null ? '(image provided)' : '(no image)';
      return '${i + 1}. "${o.name}" $hasImage\n   Notes: $notes';
    }).join('\n');

    if (isSpanish) {
      return _buildSpanishPrompt(optionsList, objective, tone);
    }
    return _buildEnglishPrompt(optionsList, objective, tone);
  }

  String _buildEnglishPrompt(
    String optionsList,
    Objective objective,
    JudgeTone tone,
  ) {
    return '''
You are Judge Bite, a gavel-shaped food court judge mascot. Your personality is: ${tone.name}.

PERSONALITY GUIDELINES:
- stern: Formal, authoritative, dry wit. Use phrases like "The court finds..." and "After careful deliberation..."
- sassy: Playful, opinionated, witty. Use phrases like "Honestly? Let me break this down..." and "Listen..."
- enthusiastic: Excited, celebratory, uses caps for emphasis. Use phrases like "OH WOW!" and "This is AMAZING!"
- chill: Casual, relaxed, uses "like" and "vibe". Use phrases like "So like, here's the deal..." and "Trust the process"

THE USER'S GOAL: ${_objectiveDescriptionEn(objective)}

FOOD OPTIONS TO JUDGE:
$optionsList

YOUR TASK:
1. Analyze each option against the "${objective.name}" goal
2. Consider any notes and images provided
3. Pick ONE winner that best fits the goal
4. Rank all options from best to worst
5. Write 2-3 sentences of reasoning IN CHARACTER as Judge Bite with the ${tone.name} personality

RESPOND WITH THIS EXACT JSON FORMAT:
{
  "winner": <1-based index of winning option>,
  "rankings": [<array of 1-based indices from best to worst>],
  "verdict": "<your reasoning in character, 2-3 sentences>"
}

Example for 3 options where option 2 wins:
{"winner": 2, "rankings": [2, 1, 3], "verdict": "The court finds in favor of the salad! After careful deliberation, the nutritional balance sealed the deal. Court is adjourned."}
''';
  }

  String _buildSpanishPrompt(
    String optionsList,
    Objective objective,
    JudgeTone tone,
  ) {
    return '''
Eres Juez Bite, una mascota con forma de mazo que es juez del tribunal de comida. Tu personalidad es: ${_toneNameEs(tone)}.

GUIA DE PERSONALIDAD:
- stern (serio): Formal, autoritario, humor seco. Usa frases como "El tribunal dictamina..." y "Tras una cuidadosa deliberacion..."
- sassy (sarcastico): Jugueton, con opiniones fuertes, ingenioso. Usa frases como "A ver, dejame explicarte..." y "Escucha..."
- enthusiastic (entusiasta): Emocionado, celebratorio, usa mayusculas para enfatizar. Usa frases como "INCREIBLE!" y "Esto es ASOMBROSO!"
- chill (relajado): Casual, tranquilo, usa "tipo" y "onda". Usa frases como "Mira, la cosa es asi..." y "Confia en el proceso"

EL OBJETIVO DEL USUARIO: ${_objectiveDescriptionEs(objective)}

OPCIONES DE COMIDA A JUZGAR:
$optionsList

TU TAREA:
1. Analiza cada opcion segun el objetivo "${_objectiveNameEs(objective)}"
2. Considera las notas e imagenes proporcionadas
3. Elige UN ganador que mejor cumpla el objetivo
4. Clasifica todas las opciones de mejor a peor
5. Escribe 2-3 oraciones de razonamiento EN PERSONAJE como Juez Bite con la personalidad ${_toneNameEs(tone)}

RESPONDE CON ESTE FORMATO JSON EXACTO:
{
  "winner": <indice del ganador empezando en 1>,
  "rankings": [<array de indices de mejor a peor, empezando en 1>],
  "verdict": "<tu razonamiento en personaje, 2-3 oraciones EN ESPANOL>"
}

Ejemplo para 3 opciones donde la opcion 2 gana:
{"winner": 2, "rankings": [2, 1, 3], "verdict": "El tribunal dictamina a favor de la ensalada! Tras cuidadosa deliberacion, el balance nutricional sello el veredicto. Se levanta la sesion."}
''';
  }

  String _toneNameEs(JudgeTone tone) {
    switch (tone) {
      case JudgeTone.stern:
        return 'serio';
      case JudgeTone.sassy:
        return 'sarcastico';
      case JudgeTone.enthusiastic:
        return 'entusiasta';
      case JudgeTone.chill:
        return 'relajado';
    }
  }

  String _objectiveNameEs(Objective objective) {
    switch (objective) {
      case Objective.fun:
        return 'diversion';
      case Objective.healthy:
        return 'saludable';
      case Objective.fit:
        return 'fitness';
      case Objective.quick:
        return 'rapido';
    }
  }

  String _objectiveDescriptionEn(Objective objective) {
    switch (objective) {
      case Objective.fun:
        return 'FUN - They want something indulgent, enjoyable, a treat!';
      case Objective.healthy:
        return 'HEALTHY - They want nutritious, balanced, good for the body';
      case Objective.fit:
        return 'FIT - They want something that supports fitness goals, protein-rich, energizing';
      case Objective.quick:
        return 'QUICK - They want something fast, convenient, minimal wait time';
    }
  }

  String _objectiveDescriptionEs(Objective objective) {
    switch (objective) {
      case Objective.fun:
        return 'DIVERSION - Quieren algo indulgente, disfrutable, un capricho!';
      case Objective.healthy:
        return 'SALUDABLE - Quieren algo nutritivo, balanceado, bueno para el cuerpo';
      case Objective.fit:
        return 'FITNESS - Quieren algo que apoye sus metas de ejercicio, rico en proteina, energizante';
      case Objective.quick:
        return 'RAPIDO - Quieren algo rapido, conveniente, sin mucha espera';
    }
  }

  Future<List<Part>> _buildContentParts(
    String prompt,
    List<FoodOption> options,
  ) async {
    final parts = <Part>[TextPart(prompt)];

    // Add images for options that have them
    for (final option in options) {
      if (option.imagePath != null) {
        try {
          final file = File(option.imagePath!);
          if (await file.exists()) {
            final bytes = await file.readAsBytes();
            final mimeType = _getMimeType(option.imagePath!);
            parts.add(InlineDataPart(mimeType, bytes));
          }
        } catch (_) {
          // Skip images that can't be read
        }
      }
    }

    return parts;
  }

  String _getMimeType(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.gif')) return 'image/gif';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg'; // Default to JPEG
  }

  Verdict _parseResponse(
    String responseText,
    List<FoodOption> options,
    Objective objective,
    JudgeTone tone,
  ) {
    try {
      final json = jsonDecode(responseText) as Map<String, dynamic>;

      final winnerIndex = (json['winner'] as int) - 1;
      final rankingsRaw = json['rankings'] as List<dynamic>;
      final verdict = json['verdict'] as String;

      if (winnerIndex < 0 || winnerIndex >= options.length) {
        throw const AiServiceException('Invalid winner index from AI');
      }

      final rankings = rankingsRaw.map((i) => options[(i as int) - 1]).toList();

      return Verdict(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        winner: options[winnerIndex],
        rankings: rankings,
        reasoning: verdict,
        objective: objective,
        judgeTone: tone,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      if (e is AiServiceException) rethrow;
      throw AiServiceException('Failed to parse AI response', e);
    }
  }
}
