import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_jury/core/theme/app_colors.dart';
import 'package:food_jury/core/theme/app_dimensions.dart';
import 'package:food_jury/core/widgets/judge_bite.dart';

class LoadingOverlay extends StatefulWidget {
  final String? message;

  const LoadingOverlay({super.key, this.message});

  @override
  State<LoadingOverlay> createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay> {
  final List<String> _defaultMessages = [
    "The court is in session...",
    "Examining the evidence...",
    "Deliberating...",
    "Consulting the flavor laws...",
    "Reviewing the taste precedents...",
  ];

  late String _currentMessage;
  late Timer _timer;
  int _messageIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentMessage = widget.message ?? _defaultMessages[0];

    if (widget.message == null) {
      // Rotate messages every 2 seconds if no specific message provided
      _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
        if (!mounted) return;
        setState(() {
          _messageIndex = (_messageIndex + 1) % _defaultMessages.length;
          _currentMessage = _defaultMessages[_messageIndex];
        });
      });
    }
  }

  @override
  void dispose() {
    if (widget.message == null) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.overlay,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Thinking Judge
          const JudgeBite(
            pose: JudgeBitePose.thinking,
            size: AppDimensions.judgeBiteLg,
          ),

          const SizedBox(height: AppDimensions.spaceLg),

          // Rotating text
          AnimatedSwitcher(
            duration: AppDimensions.durationMedium,
            child: Text(
              _currentMessage,
              key: ValueKey<String>(_currentMessage),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textInverse,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.spaceMd),

          const CircularProgressIndicator(color: AppColors.primary),
        ],
      ),
    );
  }
}
