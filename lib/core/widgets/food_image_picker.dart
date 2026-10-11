import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/image_picker_provider.dart';
import '../services/image_picker_service.dart';
import '../theme/theme.dart';
import '../utils/l10n_extensions.dart';
import 'app_dialog.dart';
import 'app_snackbar.dart';
import 'diner_components.dart';
import 'loading_overlay.dart';

/// A retro-styled image picker widget for food options.
///
/// Features:
/// - Beautiful "Polaroid" style frame
/// - Camera and gallery options in a bottom sheet
/// - Permission handling with user-friendly dialogs
/// - Animated states (empty, loading, with image)
class FoodImagePicker extends ConsumerStatefulWidget {
  const FoodImagePicker({
    super.key,
    this.imageBytes,
    required this.onImageSelected,
    this.onImageRemoved,
  });

  /// Current image bytes (if any).
  final Uint8List? imageBytes;

  /// Called when an image is selected.
  final ValueChanged<Uint8List> onImageSelected;

  /// Called when the image is removed.
  final VoidCallback? onImageRemoved;

  @override
  ConsumerState<FoodImagePicker> createState() => _FoodImagePickerState();
}

class _FoodImagePickerState extends ConsumerState<FoodImagePicker> {
  bool _isLoading = false;

  Future<void> _showSourcePicker() async {
    await AppBottomSheet.show<void>(
      context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DinerHeading(
            widget.imageBytes != null
                ? context.l10n.image_changePhoto
                : context.l10n.image_addPhoto,
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          DinerButton(
            label: context.l10n.image_takePhoto,
            icon: Icons.camera_alt_outlined,
            onPressed: () {
              Navigator.of(context).pop();
              _pickFromCamera();
            },
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          DinerButton(
            label: context.l10n.image_chooseFromGallery,
            icon: Icons.photo_library_outlined,
            style: DinerButtonStyle.outline,
            onPressed: () {
              Navigator.of(context).pop();
              _pickFromGallery();
            },
          ),
          if (widget.imageBytes != null && widget.onImageRemoved != null) ...[
            const SizedBox(height: AppDimensions.spaceMd),
            DinerButton(
              label: context.l10n.image_removePhoto,
              icon: Icons.delete_outline,
              style: DinerButtonStyle.outline,
              onPressed: () {
                Navigator.of(context).pop();
                _removeImage();
              },
            ),
          ],
        ],
      ),
    );
  }

  void _removeImage() {
    widget.onImageRemoved!();
  }

  Future<void> _pickFromCamera() async {
    setState(() => _isLoading = true);

    try {
      final service = ref.read(imagePickerServiceProvider);
      final result = await service.pickFromCamera();

      if (!mounted) return;

      if (result.isSuccess) {
        widget.onImageSelected(result.imageBytes!);
      } else if (result.isError) {
        _handleError(result.error!);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickFromGallery() async {
    setState(() => _isLoading = true);

    try {
      final service = ref.read(imagePickerServiceProvider);
      final result = await service.pickFromGallery();

      if (!mounted) return;

      if (result.isSuccess) {
        widget.onImageSelected(result.imageBytes!);
      } else if (result.isError) {
        _handleError(result.error!);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleError(ImagePickError error) {
    final l10n = context.l10n;

    switch (error) {
      case ImagePickError.cameraPermissionDenied:
        AppSnackbar.showError(context, message: l10n.permission_cameraMessage);
        break;

      case ImagePickError.galleryPermissionDenied:
        AppSnackbar.showError(context, message: l10n.permission_galleryMessage);
        break;

      case ImagePickError.cameraPermissionPermanentlyDenied:
        _showSettingsDialog(
          title: l10n.permission_cameraTitle,
          message: l10n.permission_deniedMessage,
        );
        break;

      case ImagePickError.galleryPermissionPermanentlyDenied:
        _showSettingsDialog(
          title: l10n.permission_galleryTitle,
          message: l10n.permission_deniedMessage,
        );
        break;

      case ImagePickError.fileReadError:
      case ImagePickError.imageTooLarge:
      case ImagePickError.unknown:
        AppSnackbar.showError(context, message: l10n.error_imageLoad);
        break;
    }
  }

  Future<void> _showSettingsDialog({
    required String title,
    required String message,
  }) async {
    final confirmed = await AppDialog.showConfirmation(
      context,
      title: title,
      message: message,
      confirmText: context.l10n.permission_openSettings,
      cancelText: context.l10n.common_cancel,
    );

    if (confirmed && mounted) {
      final service = ref.read(imagePickerServiceProvider);
      await service.openSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasImage = widget.imageBytes != null;
    final label = hasImage
        ? context.l10n.image_changePhoto
        : context.l10n.image_addPhoto;
    return Semantics(
      button: true,
      enabled: !_isLoading,
      label: label,
      child: Material(
        color: scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusMd,
          side: BorderSide(color: scheme.onSurface, width: DinerTokens.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _isLoading ? null : _showSourcePicker,
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spaceMd),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isLoading)
                  const AppLoadingIndicator()
                else if (hasImage)
                  ClipRRect(
                    borderRadius: AppDimensions.borderRadiusSm,
                    child: Image.memory(
                      widget.imageBytes!,
                      height: DinerTokens.photoPreview,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      cacheWidth: DinerTokens.photoDecodeWidth,
                      errorBuilder: (_, error, stack) =>
                          Text(context.l10n.error_imageLoad),
                    ),
                  )
                else
                  const Icon(
                    Icons.add_a_photo_outlined,
                    size: AppDimensions.iconSizeXl,
                  ),
                const SizedBox(height: AppDimensions.spaceSm),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (!hasImage)
                  Text(
                    context.l10n.option_tapToAddPhoto,
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
