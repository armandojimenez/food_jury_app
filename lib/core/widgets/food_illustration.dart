import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Name-matched decorative food art. Unknown foods use a neutral covered dish;
/// illustrations never replace, describe or get sent as user photo evidence.
String foodIllustrationFor(String name) {
  final n = name.toLowerCase();
  if (RegExp(r'\bpizz[ae]?\b').hasMatch(n)) return 'pizza';
  if (RegExp(r'\btacos?\b|\bburritos?\b|\bquesadillas?\b').hasMatch(n)) {
    return 'tacos';
  }
  if (RegExp(r'burger|hamburguesa').hasMatch(n)) return 'burger';
  if (RegExp(r'salad|ensalada').hasMatch(n)) return 'salad';
  if (RegExp(r'sushi|maki|nigiri').hasMatch(n)) return 'sushi';
  if (RegExp(r'noodle|ramen|pasta|fideo|spaghetti|espagueti').hasMatch(n)) {
    return 'bowl';
  }
  return 'meal';
}

/// Transparent food artwork in the same illustrated world as Judge Bite.
class FoodIllustration extends StatelessWidget {
  /// Creates a decorative food cutout that is never AI evidence.
  const FoodIllustration({
    required this.name,
    this.size = DinerTokens.thumbnail,
    super.key,
  });

  /// User-entered food name used for the decorative category fallback.
  final String name;

  /// Logical extent of the artwork or lettering before text scaling.
  final double size;
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Image.asset(
      'assets/images/food_illustrations/${foodIllustrationFor(name)}.png',
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
