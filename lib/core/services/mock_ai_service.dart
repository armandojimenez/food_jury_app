import 'dart:math';
import 'dart:ui';

import '../../features/decision/data/models/food_option.dart';
import '../../features/decision/data/models/objective.dart';
import '../../features/decision/data/models/verdict.dart';
import 'ai_service.dart';

/// Mock AI service for generating verdicts during development.
///
/// Simulates a 2-3 second delay and returns mock verdicts
/// with personality based on the selected judge tone.
class MockAiService implements AiService {
  MockAiService();

  final _random = Random();

  /// Generates a mock verdict for the given options and objective.
  ///
  /// Simulates network delay and AI processing time.
  /// Note: Mock service only returns English responses for simplicity.
  @override
  Future<Verdict> generateVerdict({
    required List<FoodOption> options,
    required Objective objective,
    required JudgeTone tone,
    required Locale locale,
  }) async {
    // Simulate AI processing time (2-3 seconds)
    final delay = 2000 + _random.nextInt(1000);
    await Future.delayed(Duration(milliseconds: delay));

    // Randomly select a winner
    final shuffled = List<FoodOption>.from(options)..shuffle(_random);
    final winner = shuffled.first;
    final rankings = shuffled;

    // Generate reasoning based on tone and objective
    final reasoning = _generateReasoning(
      winner: winner,
      objective: objective,
      tone: tone,
      optionsCount: options.length,
    );

    return Verdict(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      winner: winner,
      rankings: rankings,
      reasoning: reasoning,
      objective: objective,
      judgeTone: tone,
      createdAt: DateTime.now(),
    );
  }

  String _generateReasoning({
    required FoodOption winner,
    required Objective objective,
    required JudgeTone tone,
    required int optionsCount,
  }) {
    final objectiveReasons = _getObjectiveReasons(objective, winner.name);
    final toneIntro = _getToneIntro(tone);
    final toneClosing = _getToneClosing(tone, winner.name);

    return '$toneIntro $objectiveReasons $toneClosing';
  }

  String _getToneIntro(JudgeTone tone) {
    switch (tone) {
      case JudgeTone.stern:
        return 'After careful deliberation, the court has reached a verdict.';
      case JudgeTone.sassy:
        return 'Okay, let me break this down for you.';
      case JudgeTone.enthusiastic:
        return 'OH WOW! This was such a fun case to judge!';
      case JudgeTone.chill:
        return 'So like, I checked out all the options and here\'s the vibe:';
    }
  }

  String _getObjectiveReasons(Objective objective, String winnerName) {
    switch (objective) {
      case Objective.fun:
        return _randomChoice([
          'When it comes to having a good time, $winnerName brings pure joy to the table.',
          '$winnerName is basically a party on a plate. No contest here.',
          'Life\'s too short for boring food. $winnerName knows how to live!',
          'For maximum enjoyment, $winnerName hits all the right notes.',
        ]);
      case Objective.healthy:
        return _randomChoice([
          '$winnerName offers the best nutritional balance without sacrificing taste.',
          'Looking at the health factors, $winnerName is the clear winner.',
          'Your body will thank you for choosing $winnerName.',
          '$winnerName brings the nutrients while keeping things delicious.',
        ]);
      case Objective.fit:
        return _randomChoice([
          '$winnerName aligns perfectly with fitness goals while still being satisfying.',
          'For your fitness journey, $winnerName provides the fuel you need.',
          '$winnerName hits that sweet spot between gains and gains.',
          'Protein, energy, and taste? $winnerName delivers on all fronts.',
        ]);
      case Objective.quick:
        return _randomChoice([
          '$winnerName gets you fed fast without cutting corners on quality.',
          'Time is precious, and $winnerName respects that.',
          'When speed matters, $winnerName is the efficient choice.',
          '$winnerName: maximum satisfaction, minimum wait time.',
        ]);
    }
  }

  String _getToneClosing(JudgeTone tone, String winnerName) {
    switch (tone) {
      case JudgeTone.stern:
        return 'The verdict is final. Court is adjourned.';
      case JudgeTone.sassy:
        return 'You\'re welcome. Now go enjoy that $winnerName!';
      case JudgeTone.enthusiastic:
        return 'I am SO excited for you to try $winnerName! This is going to be AMAZING!';
      case JudgeTone.chill:
        return 'Anyway, $winnerName is the move. Trust the process.';
    }
  }

  String _randomChoice(List<String> options) {
    return options[_random.nextInt(options.length)];
  }
}

/// Mock loading messages that cycle during AI processing.
class MockLoadingMessages {
  static const List<String> messages = [
    'The court is in session...',
    'Examining the evidence...',
    'Deliberating...',
    'Consulting the food archives...',
    'Weighing the options...',
    'Almost there...',
  ];

  static String getRandomMessage() {
    final random = Random();
    return messages[random.nextInt(messages.length)];
  }
}
