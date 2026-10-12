import 'package:flutter_test/flutter_test.dart';
import 'package:food_jury/core/widgets/food_illustration.dart';

void main() {
  test('specific dishes take precedence over their ingredients', () {
    expect(foodIllustrationFor('Chicken burrito'), 'burrito');
    expect(foodIllustrationFor('Shrimp ramen'), 'ramen');
    expect(foodIllustrationFor('Chicken wings'), 'wings');
    expect(foodIllustrationFor('Egg fried rice'), 'rice');
    expect(foodIllustrationFor('Chicken soup with rice'), 'soup');
    expect(foodIllustrationFor('Tofu curry'), 'curry');
  });

  test('Spanish names and punctuation retain their own artwork', () {
    expect(foodIllustrationFor('¡CAFÉ!'), 'coffee');
    expect(foodIllustrationFor('Lasaña de vegetales'), 'lasagna');
    expect(foodIllustrationFor('Tostada con aguacate'), 'avocado_toast');
    expect(foodIllustrationFor('Camarones al ajillo'), 'shrimp');
    expect(foodIllustrationFor('Salmón a la plancha'), 'fish');
    expect(foodIllustrationFor('Dona de chocolate'), 'donut');
  });

  test('unknown dishes never match a food hidden inside another word', () {
    for (final name in [
      '',
      'Eggplant',
      'Cafeteria special',
      'Moonpies',
      'Pizzazz',
    ]) {
      expect(foodIllustrationFor(name), 'meal', reason: name);
    }
  });

  test('formerly shared artwork now distinguishes everyday dishes', () {
    expect(foodIllustrationFor('Tacos'), 'tacos');
    expect(foodIllustrationFor('Burritos'), 'burrito');
    expect(foodIllustrationFor('Quesadillas'), 'quesadilla');
    expect(foodIllustrationFor('Pasta'), 'pasta');
    expect(foodIllustrationFor('Noodles'), 'bowl');
    expect(foodIllustrationFor('Ramen'), 'ramen');
  });
}
