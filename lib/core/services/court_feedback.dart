import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/diner_motion.dart';

/// User-controlled, quiet-by-default feedback for meaningful court actions.
@immutable
class CourtFeedbackPreferences {
  const CourtFeedbackPreferences({this.sound = false, this.haptics = true});

  final bool sound;
  final bool haptics;
}

/// Persists only presentation preferences, never food evidence or case data.
final courtFeedbackPreferencesProvider =
    NotifierProvider<
      CourtFeedbackPreferencesNotifier,
      CourtFeedbackPreferences
    >(CourtFeedbackPreferencesNotifier.new);

class CourtFeedbackPreferencesNotifier
    extends Notifier<CourtFeedbackPreferences> {
  bool _disposed = false;
  int _revision = 0;
  Future<void> _writes = Future.value();
  late Future<void> ready;

  @override
  CourtFeedbackPreferences build() {
    ref.onDispose(() => _disposed = true);
    ready = _load();
    return const CourtFeedbackPreferences();
  }

  Future<void> _load() async {
    final revision = _revision;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_disposed || revision != _revision) return;
      state = CourtFeedbackPreferences(
        sound: prefs.getBool('court_sound') ?? false,
        haptics: prefs.getBool('court_haptics') ?? true,
      );
    } catch (_) {
      // Optional feedback must never prevent a case from opening.
    }
  }

  Future<void> setSound(bool enabled) => _set(sound: enabled);
  Future<void> setHaptics(bool enabled) => _set(haptics: enabled);

  Future<void> _set({bool? sound, bool? haptics}) async {
    await ready;
    if (_disposed) return;
    _revision++;
    state = CourtFeedbackPreferences(
      sound: sound ?? state.sound,
      haptics: haptics ?? state.haptics,
    );
    final value = state;
    final write = _writes.catchError((Object _) {}).then((_) async {
      final prefs = await SharedPreferences.getInstance();
      final soundSaved = await prefs.setBool('court_sound', value.sound);
      final hapticsSaved = await prefs.setBool('court_haptics', value.haptics);
      if (!soundSaved || !hapticsSaved) {
        throw StateError('Feedback preference could not be saved');
      }
    });
    _writes = write;
    await write;
  }
}

/// A short cue, never a repeating soundtrack or simulated loading progress.
enum CourtCue { selection, verdict, file, objection }

abstract final class CourtFeedback {
  /// Honors saved preferences, system reduced motion, and hidden routes.
  static Future<void> play(
    BuildContext context,
    WidgetRef ref,
    CourtCue cue,
  ) async {
    if (!context.mounted || reduceDinerMotion(context)) return;
    await ref.read(courtFeedbackPreferencesProvider.notifier).ready;
    if (!context.mounted ||
        reduceDinerMotion(context) ||
        ModalRoute.of(context)?.isCurrent == false) {
      return;
    }
    final prefs = ref.read(courtFeedbackPreferencesProvider);
    try {
      if (prefs.haptics) {
        switch (cue) {
          case CourtCue.selection:
            await HapticFeedback.selectionClick();
          case CourtCue.verdict:
            await HapticFeedback.mediumImpact();
          case CourtCue.file:
          case CourtCue.objection:
            await HapticFeedback.lightImpact();
        }
      }
      if (prefs.sound) await SystemSound.play(SystemSoundType.click);
    } on PlatformException catch (_) {
      // Haptics and system click support vary by device.
    } on MissingPluginException catch (_) {
      // Keep isolated previews functional without a platform sound service.
    }
  }
}
