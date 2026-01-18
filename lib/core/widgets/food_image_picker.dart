import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/image_picker_provider.dart';
import '../services/image_picker_service.dart';
import '../theme/theme.dart';
import '../utils/l10n_extensions.dart';
import 'app_dialog.dart';
import 'app_snackbar.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusLg),
          ),
          border: Border.all(
            color: colorScheme.secondary,
            width: AppDimensions.borderThick,
          ),
        ),
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
              decoration: BoxDecoration(
                color: colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Text(
              widget.imageBytes != null
                  ? context.l10n.image_changePhoto
                  : context.l10n.image_addPhoto,
              style: AppTypography.headlineSmall.copyWith(
                color: colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: AppDimensions.spaceLg),

            // Options
            _SourceOption(
              icon: Icons.camera_alt,
              label: context.l10n.image_takePhoto,
              color: colorScheme.primary,
              onTap: () {
                Navigator.pop(context);
                _pickFromCamera();
              },
            ),

            const SizedBox(height: AppDimensions.spaceSm),

            _SourceOption(
              icon: Icons.photo_library,
              label: context.l10n.image_chooseFromGallery,
              color: AppColors.info,
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery();
              },
            ),

            // Remove option (if image exists)
            if (widget.imageBytes != null && widget.onImageRemoved != null) ...[
              const SizedBox(height: AppDimensions.spaceSm),
              _SourceOption(
                icon: Icons.delete_outline,
                label: context.l10n.image_removePhoto,
                color: AppColors.error,
                onTap: () {
                  Navigator.pop(context);
                  _removeImage();
                },
              ),
            ],

            SizedBox(
              height:
                  MediaQuery.of(context).padding.bottom + AppDimensions.spaceMd,
            ),
          ],
        ),
      ),
    );
  }

  void _removeImage() {
    widget.onImageRemoved!();
    // Use the parent widget's context for the snackbar
    AppSnackbar.showInfo(context, message: context.l10n.snackbar_photoRemoved);
  }

  Future<void> _pickFromCamera() async {
    setState(() => _isLoading = true);

    try {
      final service = ref.read(imagePickerServiceProvider);
      final result = await service.pickFromCamera();

      if (!mounted) return;

      if (result.isSuccess) {
        widget.onImageSelected(result.imageBytes!);
        AppSnackbar.showSuccess(
          context,
          message: context.l10n.snackbar_photoAdded,
        );
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
        AppSnackbar.showSuccess(
          context,
          message: context.l10n.snackbar_photoAdded,
        );
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
    final colorScheme = Theme.of(context).colorScheme;
    final hasImage = widget.imageBytes != null;

    return Semantics(
      label: hasImage
          ? context.l10n.image_changePhoto
          : context.l10n.image_addPhoto,
      button: true,
      child: GestureDetector(
        onTap: _isLoading ? null : _showSourcePicker,
        child: AnimatedContainer(
          duration: AppDimensions.durationMedium,
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            color: hasImage
                ? colorScheme.surface
                : colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: AppDimensions.borderRadiusMd,
            border: Border.all(
              color: hasImage ? colorScheme.secondary : colorScheme.primary,
              width: hasImage
                  ? AppDimensions.borderThick
                  : AppDimensions.borderMedium,
            ),
            boxShadow: hasImage ? AppDimensions.shadowRetro : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              AppDimensions.radiusMd - AppDimensions.borderThick,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image or empty state
                if (hasImage)
                  _ImageDisplay(imageBytes: widget.imageBytes!)
                else
                  _EmptyState(isLoading: _isLoading),

                // Loading overlay
                if (_isLoading)
                  Container(
                    color: colorScheme.surface.withValues(alpha: 0.8),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spaceSm),
                          Text(
                            context.l10n.common_loading,
                            style: AppTypography.labelMedium.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Edit badge (when has image)
                if (hasImage && !_isLoading)
                  Positioned(
                    top: AppDimensions.spaceSm,
                    right: AppDimensions.spaceSm,
                    child: Container(
                      padding: const EdgeInsets.all(AppDimensions.spaceXs),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.secondary,
                          width: 2,
                        ),
                        boxShadow: AppDimensions.shadowRetroSm,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: colorScheme.secondary,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Empty state for image picker.
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isLoading) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Camera icon with retro styling
        Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.add_a_photo,
                color: colorScheme.primary,
                size: 28,
              ),
            )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.05, 1.05),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeInOut,
            ),

        const SizedBox(height: AppDimensions.spaceMd),

        Text(
          context.l10n.image_photoEvidence,
          style: AppTypography.labelLarge.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),

        const SizedBox(height: AppDimensions.spaceXs),

        Text(
          context.l10n.option_tapToAddPhoto,
          style: AppTypography.bodySmall.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Displays the selected image with a polaroid effect.
class _ImageDisplay extends StatelessWidget {
  const _ImageDisplay({required this.imageBytes});

  final Uint8List imageBytes;

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      imageBytes,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const _ImageErrorState();
      },
    ).animate().fadeIn(duration: AppDimensions.durationMedium);
  }
}

/// Error state when image fails to load.
class _ImageErrorState extends StatelessWidget {
  const _ImageErrorState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: AppColors.error.withValues(alpha: 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.broken_image, color: AppColors.error, size: 32),
          const SizedBox(height: AppDimensions.spaceSm),
          Text(
            context.l10n.error_imageLoad,
            style: AppTypography.bodySmall.copyWith(color: colorScheme.error),
          ),
        ],
      ),
    );
  }
}

/// Source option button in the bottom sheet.
class _SourceOption extends StatelessWidget {
  const _SourceOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppDimensions.borderRadiusMd,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceMd,
              vertical: AppDimensions.spaceMd,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: AppDimensions.borderRadiusMd,
              border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 22),
                ),
                const SizedBox(width: AppDimensions.spaceMd),
                Expanded(
                  child: Text(
                    label,
                    style: AppTypography.titleMedium.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
