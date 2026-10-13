import 'package:flutter_test/flutter_test.dart';
import 'package:food_jury/features/decision/data/models/food_option.dart';
import 'package:food_jury/features/jury/data/jury_session.dart';

const pizza = FoodOption(id: 'pizza', name: 'Pizza');
const tacos = FoodOption(id: 'tacos', name: 'Tacos');
const sushi = FoodOption(id: 'sushi', name: 'Sushi');

void main() {
  test('sessions accept only two to five participants', () {
    expect(() => JurySession(1), throwsArgumentError);
    expect(() => JurySession(6), throwsArgumentError);
    expect(JurySession(5).participants, 5);
  });

  test('duplicate nominations and premature or invalid votes are rejected', () {
    final session = JurySession(2)..nominate(pizza);
    expect(() => session.vote(pizza.id), throwsStateError);
    expect(
      () =>
          session.nominate(const FoodOption(id: 'different', name: ' PIZZA ')),
      throwsArgumentError,
    );
    expect(
      () => session.nominate(const FoodOption(id: 'empty', name: ' ')),
      throwsArgumentError,
    );
    session.nominate(tacos);
    expect(() => session.nominate(sushi), throwsStateError);
    expect(() => session.vote('not-a-nominee'), throwsArgumentError);
    expect(session.votesCast, 0);
  });

  test('individual ballots stay hidden until the last juror votes', () {
    final session = JurySession(3)
      ..nominate(pizza)
      ..nominate(tacos)
      ..nominate(sushi);
    session.vote(tacos.id);
    expect(session.votesCast, 1);
    expect(() => session.results, throwsStateError);
    expect(() => session.leaders, throwsStateError);
    session.vote(pizza.id);
    session.vote(tacos.id);
    expect(session.results, {'pizza': 1, 'tacos': 2, 'sushi': 0});
    expect(session.leaders, [tacos]);
    expect(() => session.vote(sushi.id), throwsStateError);
    expect(() => session.results['pizza'] = 12, throwsUnsupportedError);
  });

  test('only joint leaders enter a tie-breaker', () {
    final session = JurySession(4)
      ..nominate(pizza)
      ..nominate(tacos)
      ..nominate(sushi)
      ..nominate(const FoodOption(id: 'ramen', name: 'Ramen'));
    session.vote(pizza.id);
    session.vote(tacos.id);
    session.vote(pizza.id);
    session.vote(tacos.id);
    expect(session.leaders, [pizza, tacos]);
  });
}
