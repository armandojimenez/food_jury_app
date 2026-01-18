import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// Result of an image pick operation.
class ImagePickResult {
  const ImagePickResult._({this.imageBytes, this.error});

  /// Success with optimized image bytes.
  factory ImagePickResult.success(Uint8List bytes) =>
      ImagePickResult._(imageBytes: bytes);

  /// User cancelled the operation.
  factory ImagePickResult.cancelled() => const ImagePickResult._();

  /// Error occurred.
  factory ImagePickResult.error(ImagePickError error) =>
      ImagePickResult._(error: error);

  /// The optimized image bytes (null if cancelled or error).
  final Uint8List? imageBytes;

  /// The error that occurred (null if success or cancelled).
  final ImagePickError? error;

  /// Whether the operation was successful.
  bool get isSuccess => imageBytes != null;

  /// Whether the user cancelled.
  bool get isCancelled => imageBytes == null && error == null;

  /// Whether an error occurred.
  bool get isError => error != null;
}

/// Types of errors that can occur during image picking.
enum ImagePickError {
  /// Camera permission denied.
  cameraPermissionDenied,

  /// Photo library permission denied.
  galleryPermissionDenied,

  /// Camera permission permanently denied (needs settings).
  cameraPermissionPermanentlyDenied,

  /// Photo library permission permanently denied (needs settings).
  galleryPermissionPermanentlyDenied,

  /// Failed to read the image file.
  fileReadError,

  /// Image is too large to process.
  imageTooLarge,

  /// Unknown error occurred.
  unknown,
}

/// Service for picking and optimizing images for food options.
///
/// Features:
/// - Camera and gallery selection
/// - Permission handling with graceful error states
/// - Image optimization (resize + compress for AI tokens)
/// - Retains enough quality for beautiful display
class ImagePickerService {
  ImagePickerService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  /// Maximum dimension for images (width or height).
  /// Keeps images looking great while being reasonable for AI.
  static const int maxDimension = 800;

  /// JPEG quality (0-100). 85 is a good balance.
  static const int jpegQuality = 85;

  /// Maximum file size in bytes (500KB).
  static const int maxFileSize = 500 * 1024;

  /// Picks an image from the camera.
  Future<ImagePickResult> pickFromCamera() async {
    // Check camera permission
    final permissionResult = await _checkCameraPermission();
    if (permissionResult != null) {
      return ImagePickResult.error(permissionResult);
    }

    return _pickImage(ImageSource.camera);
  }

  /// Picks an image from the photo gallery.
  Future<ImagePickResult> pickFromGallery() async {
    // Check gallery permission
    final permissionResult = await _checkGalleryPermission();
    if (permissionResult != null) {
      return ImagePickResult.error(permissionResult);
    }

    return _pickImage(ImageSource.gallery);
  }

  /// Checks camera permission and returns error if denied.
  Future<ImagePickError?> _checkCameraPermission() async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      return null;
    }

    if (status.isPermanentlyDenied) {
      return ImagePickError.cameraPermissionPermanentlyDenied;
    }

    // Request permission
    final result = await Permission.camera.request();

    if (result.isGranted) {
      return null;
    }

    if (result.isPermanentlyDenied) {
      return ImagePickError.cameraPermissionPermanentlyDenied;
    }

    return ImagePickError.cameraPermissionDenied;
  }

  /// Checks gallery permission and returns error if denied.
  Future<ImagePickError?> _checkGalleryPermission() async {
    // On iOS 14+, we need to check photos permission
    // On Android, we need to check storage or photos depending on version
    Permission permission;

    if (Platform.isIOS) {
      permission = Permission.photos;
    } else {
      // Android 13+ uses photos, older uses storage
      permission = Permission.photos;
    }

    final status = await permission.status;

    if (status.isGranted || status.isLimited) {
      return null;
    }

    if (status.isPermanentlyDenied) {
      return ImagePickError.galleryPermissionPermanentlyDenied;
    }

    // Request permission
    final result = await permission.request();

    if (result.isGranted || result.isLimited) {
      return null;
    }

    if (result.isPermanentlyDenied) {
      return ImagePickError.galleryPermissionPermanentlyDenied;
    }

    return ImagePickError.galleryPermissionDenied;
  }

  /// Picks and optimizes an image from the given source.
  Future<ImagePickResult> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: maxDimension.toDouble(),
        maxHeight: maxDimension.toDouble(),
        imageQuality: jpegQuality,
      );

      if (pickedFile == null) {
        return ImagePickResult.cancelled();
      }

      // Read the file bytes
      final bytes = await pickedFile.readAsBytes();

      // Check file size
      if (bytes.length > maxFileSize * 2) {
        // If still too large, the image_picker should have handled it
        // but we do a sanity check
        debugPrint(
          'Warning: Image size ${bytes.length} exceeds expected maximum',
        );
      }

      return ImagePickResult.success(bytes);
    } catch (e) {
      debugPrint('Error picking image: $e');
      return ImagePickResult.error(ImagePickError.fileReadError);
    }
  }

  /// Opens app settings for the user to grant permissions.
  Future<bool> openSettings() async {
    return await openAppSettings();
  }
}
