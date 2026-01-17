import 'package:uuid/uuid.dart';

class FoodOption {
  final String id;
  final String name;
  final String? notes;
  final String? imagePath;

  FoodOption({String? id, required this.name, this.notes, this.imagePath})
    : id = id ?? const Uuid().v4();

  FoodOption copyWith({String? name, String? notes, String? imagePath}) {
    return FoodOption(
      id: id,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
