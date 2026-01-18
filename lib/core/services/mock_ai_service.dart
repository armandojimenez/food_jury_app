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

    // Generate bonus content based on tone
    final (bonusType, bonus) = _generateBonus(tone, winner.name);

    return Verdict(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      winner: winner,
      rankings: rankings,
      reasoning: reasoning,
      objective: objective,
      judgeTone: tone,
      createdAt: DateTime.now(),
      bonus: bonus,
      bonusType: bonusType,
    );
  }

  /// Generates bonus content based on judge tone.
  (BonusType, String) _generateBonus(JudgeTone tone, String winnerName) {
    switch (tone) {
      case JudgeTone.stern:
        return (
          BonusType.tip,
          _randomChoice([
            'Pro tip: Always taste your food before adding extra seasoning. A wise palate makes wise choices.',
            'The court advises: Store leftovers within two hours to maintain food safety standards.',
            'Judicial wisdom: Hydration is key. Pair your meal with water for optimal digestion.',
            'Legal advice: Reading nutrition labels is not optional. Knowledge is power.',
          ]),
        );
      case JudgeTone.sassy:
        return (
          BonusType.joke,
          _randomChoice([
            'Why did the $winnerName break up with the salad? It found someone with more... substance.',
            'I told my diet I was seeing other foods. It said, "I knew it was $winnerName!"',
            'What did the food critic say? "This $winnerName is groundbreaking!" ...because I dropped it.',
            'My relationship with $winnerName is like a romcom. We meet, I eat it, I regret nothing.',
          ]),
        );
      case JudgeTone.enthusiastic:
        return (
          BonusType.funFact,
          _randomChoice([
            'DID YOU KNOW?! The average person makes over 200 food decisions per day! You just made a GREAT one!',
            'FUN FACT ALERT! Your taste buds regenerate every 10-14 days, so you might love $winnerName even MORE next time!',
            'AMAZING TRIVIA! The color of your plate can affect how food tastes. Science is SO COOL!',
            'MIND = BLOWN! Honey never spoils. Archaeologists found 3000-year-old honey still perfectly edible!',
          ]),
        );
      case JudgeTone.chill:
        return (
          BonusType.story,
          _randomChoice([
            'So like, one time I was just vibing at a food truck and discovered the best $winnerName ever. Sometimes the universe just knows, you know?',
            'Real talk: my grandma always said food tastes better when you\'re happy. She was onto something.',
            'There\'s this cozy spot downtown that makes amazing $winnerName. The vibe is immaculate. Just saying.',
            'I once took a whole afternoon to just enjoy a meal in the park. No rush, no stress. That\'s the energy.',
          ]),
        );
    }
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
