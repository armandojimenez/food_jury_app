import '../../decision/data/models/food_option.dart';

/// A local pass-the-phone session. Individual ballots are never retained.
class JurySession {
  /// Creates a session for two to five diners.
  JurySession(this.participants) {
    if (participants < 2 || participants > 5) {
      throw ArgumentError.value(participants, 'participants');
    }
  }

  /// Number of nominations and votes required.
  final int participants;
  final List<FoodOption> _options = [];
  final Map<String, int> _counts = {};
  int _votesCast = 0;

  /// Immutable nominees in nomination order.
  List<FoodOption> get options => List.unmodifiable(_options);

  /// Number of sealed ballots, without identifying voters.
  int get votesCast => _votesCast;

  /// Whether every diner has nominated a distinct dish.
  bool get readyToVote => _options.length == participants;

  /// Whether every diner has voted.
  bool get complete => _votesCast == participants;

  /// Adds a named, distinct nominee before voting starts.
  void nominate(FoodOption option) {
    if (readyToVote || _votesCast != 0) throw StateError('Nominations closed');
    final name = option.name.trim().toLowerCase();
    if (name.isEmpty ||
        _options.any(
          (o) => o.id == option.id || o.name.trim().toLowerCase() == name,
        )) {
      throw ArgumentError('Choose a distinct, named dish');
    }
    _options.add(option.snapshot());
    _counts[option.id] = 0;
  }

  /// Seals one valid ballot. The voter-to-dish association is discarded.
  void vote(String optionId) {
    if (!readyToVote || complete) throw StateError('Voting is not open');
    if (!_counts.containsKey(optionId)) throw ArgumentError.value(optionId);
    _counts[optionId] = _counts[optionId]! + 1;
    _votesCast++;
  }

  /// Counts remain hidden until all ballots are sealed.
  Map<String, int> get results {
    if (!complete) throw StateError('Voting is private until complete');
    return Map.unmodifiable(_counts);
  }

  /// All nominees tied for the highest vote count.
  List<FoodOption> get leaders {
    final scores = results;
    final highest = scores.values.reduce((a, b) => a > b ? a : b);
    return List.unmodifiable(_options.where((o) => scores[o.id] == highest));
  }
}
