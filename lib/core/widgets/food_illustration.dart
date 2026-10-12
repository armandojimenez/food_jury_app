import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../../features/food_library/data/food_catalog.dart';

/// Name-matched decorative food art. Unknown foods use a neutral covered dish;
/// illustrations never replace, describe or get sent as user photo evidence.
String foodIllustrationFor(String name) {
  final n = name.toLowerCase();
  for (final entry in _foodNamePatterns.entries) {
    if (entry.value.hasMatch(n)) return entry.key;
  }
  return 'meal';
}

// Specific dishes precede ingredients: "chicken burrito" is a burrito. Boundaries
// avoid guessing a different food from a substring such as "eggplant".
final _foodNamePatterns =
    <String, String>{
      'pizza': r'pizzas?',
      'tacos': r'tacos?',
      'burrito': r'burritos?',
      'quesadilla': r'quesadillas?',
      'burger': r'burgers?|hamburguesas?',
      'hotdog': r'hot\s?dogs?|perritos? calientes?',
      'nachos': r'nachos?',
      'sushi': r'sushi|maki|nigiri',
      'salad': r'salads?|ensaladas?',
      'lasagna': r'lasagn[ae]|lasaña',
      'ramen': r'ramen',
      'dumplings': r'dumplings?|gyozas?|wontons?|dim sum',
      'curry': r'curr(?:y|ies)|masala|korma',
      'pasta': r'pasta|spaghetti|espagueti|penne',
      'bowl': r'noodles?|fideos?',
      'sandwich': r'sandwich(?:es)?|sándwich(?:es)?|grilled cheese',
      'wings': r'(?:chicken )?wings?|alitas?',
      'empanadas': r'empanadas?|empanadillas?|pastelillos?',
      'arepas': r'arepas?',
      'mofongo': r'mofongos?',
      'tostones': r'tostones|patacones',
      'breakfast': r'pancakes?|panqueques?|hotcakes?|tortitas?',
      'waffles': r'waffles?|gofres?',
      'avocado_toast':
          r'avocado toast|tostadas? (?:de |con )?(?:aguacate|palta)',
      'bagel': r'bagels?',
      'soup': r'soups?|sopas?|stews?|caldos?|guisos?',
      'rice': r'rice|arroz',
      'eggs': r'eggs?|huevos?',
      'fruit': r'fruit(?: bowl)?|frutas?',
      'icecream': r'ice\s?cream|helados?|gelato|mantecado',
      'donut': r'do(?:ugh)?nuts?|donas?|rosquillas?',
      'cookies': r'cookies?|galletas?',
      'coffee': r'coffee|caf[eé]|espresso|latte|cappuccino|capuchino',
      'fries': r'fries|papas fritas|patatas fritas',
      'shrimp': r'shrimp|prawns?|camar[oó]n(?:es)?|camarones|gambas?',
      'fish': r'fish|pescado|salm[oó]n|tuna|at[uú]n',
      'steak': r'steaks?|bistec',
      'chicken': r'chicken|pollo',
      'vegetables': r'veggies|vegetables|vegetales|verduras|tofu',
      'dessert': r'cakes?|pastel|bizcocho|brownies?|pie',
      'drink': r'milkshakes?|smoothies?|batidos?|jugos?|juice',
    }.map(
      (asset, pattern) => MapEntry(
        asset,
        RegExp('(?:^|[^a-záéíóúüñ0-9_])(?:$pattern)(?=\$|[^a-záéíóúüñ0-9_])'),
      ),
    );

/// Transparent food artwork in the same illustrated world as Judge Bite.
class FoodIllustration extends StatelessWidget {
  /// Creates a decorative food cutout that is never AI evidence.
  const FoodIllustration({
    required this.name,
    this.illustrationId,
    this.size = DinerTokens.thumbnail,
    super.key,
  });

  /// User-entered food name used for the decorative category fallback.
  final String name;
  final String? illustrationId;

  /// Logical extent of the artwork or lettering before text scaling.
  final double size;
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Image.asset(
      'assets/images/food_illustrations/${foodArtById(illustrationId)?.asset ?? foodIllustrationFor(name)}.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      cacheWidth: (size * MediaQuery.devicePixelRatioOf(context)).ceil(),
      errorBuilder: (context, error, stack) => SizedBox.square(
        dimension: size,
        child: const Icon(Icons.room_service_rounded, color: AppColors.accent),
      ),
    ),
  );
}
