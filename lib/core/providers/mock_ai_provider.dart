import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../env/env.dart';
part 'mock_ai_provider.g.dart';

/// Developer-only AI choice, loaded before the first request is resolved.
@riverpod
class MockAiNotifier extends _$MockAiNotifier {
  bool _disposed = false;
  int _revision = 0;

  /// Completes when the saved developer setting is available.
  late Future<void> ready;

  @override
  bool build() {
    ref.onDispose(() => _disposed = true);
    ready = Env.isProd ? Future<void>.value() : _load();
    return false;
  }

  Future<void> _load() async {
    final revision = _revision;
    final prefs = await SharedPreferences.getInstance();
    if (_disposed || revision != _revision) return;
    state = prefs.getBool('use_mock_ai') ?? false;
  }

  /// Toggle the currently selected service.
  Future<void> toggle() => setUseMockAi(!state);

  /// Persist the choice without allowing a late initial read to replace it.
  Future<void> setUseMockAi(bool useMock) async {
    if (Env.isProd || _disposed) return;
    _revision++;
    state = useMock;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('use_mock_ai', useMock);
  }
}
