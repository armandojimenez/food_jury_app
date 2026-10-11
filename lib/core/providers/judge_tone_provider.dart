import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/decision/data/models/verdict.dart';

/// Persisted personality used by both settings and new food cases.
final judgeToneProvider = NotifierProvider<JudgeToneNotifier, JudgeTone>(
  JudgeToneNotifier.new,
);

/// Keeps late preference loads from overwriting a user's fresh selection.
class JudgeToneNotifier extends Notifier<JudgeTone> {
  bool _disposed = false;
  int _revision = 0;

  /// Completes after the saved personality is available.
  late Future<void> ready;

  @override
  JudgeTone build() {
    ref.onDispose(() => _disposed = true);
    ready = _load();
    return JudgeTone.stern;
  }

  Future<void> _load() async {
    final revision = _revision;
    final prefs = await SharedPreferences.getInstance();
    if (_disposed || revision != _revision) return;
    final name = prefs.getString('judge_tone');
    state = JudgeTone.values.firstWhere(
      (tone) => tone.name == name,
      orElse: () => JudgeTone.stern,
    );
  }

  /// Selects immediately and saves the preference for future app launches.
  Future<void> select(JudgeTone tone) async {
    _revision++;
    state = tone;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('judge_tone', tone.name);
  }
}
