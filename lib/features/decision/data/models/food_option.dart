import 'package:equatable/equatable.dart';

/// Represents a food option in a decision.
///
/// Used during the decision creation flow before saving to database.
class FoodOption extends Equatable {
  /// Creates a food option.
  const FoodOption({
    required this.id,
    required this.name,
    this.notes,
    this.imagePath,
  });

  /// Unique identifier for this option.
  final String id;

  /// Name of the food option (e.g., "Pepperoni Pizza").
  final String name;

  /// Optional notes about this option.
  final String? notes;

  /// Optional path to image file.
  /// Will be used in Phase 4 when image picker is integrated.
  final String? imagePath;

  @override
  List<Object?> get props => [id, name, notes, imagePath];

  /// Creates a copy with updated fields.
  FoodOption copyWith({
    String? id,
    String? name,
    String? notes,
    String? imagePath,
  }) {
    return FoodOption(
      id: id ?? this.id,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
