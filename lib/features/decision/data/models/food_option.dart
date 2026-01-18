import 'dart:typed_data';

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
    this.imageBytes,
  });

  /// Unique identifier for this option.
  final String id;

  /// Name of the food option (e.g., "Pepperoni Pizza").
  final String name;

  /// Optional notes about this option.
  final String? notes;

  /// Optional image bytes (optimized JPEG).
  /// Used for display and AI analysis.
  final Uint8List? imageBytes;

  /// Whether this option has an image.
  bool get hasImage => imageBytes != null && imageBytes!.isNotEmpty;

  @override
  List<Object?> get props => [id, name, notes, imageBytes];

  /// Creates a copy with updated fields.
  FoodOption copyWith({
    String? id,
    String? name,
    String? notes,
    Uint8List? imageBytes,
    bool clearImage = false,
  }) {
    return FoodOption(
      id: id ?? this.id,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      imageBytes: clearImage ? null : (imageBytes ?? this.imageBytes),
    );
  }
}
