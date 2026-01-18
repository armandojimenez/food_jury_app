import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/image_picker_service.dart';

/// Provider for the image picker service.
///
/// Provides camera/gallery access with permission handling
/// and image optimization for AI consumption.
final imagePickerServiceProvider = Provider<ImagePickerService>((ref) {
  return ImagePickerService();
});
