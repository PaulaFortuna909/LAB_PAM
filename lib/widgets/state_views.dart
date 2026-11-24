import 'package:flutter/material.dart';

import '../core/app_theme.dart';

/// Starea Loading.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.message = 'Loading...'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.teal),
          const SizedBox(height: 16),
          Text(message, style: outfit(13, FontWeight.w400, AppColors.grey)),
        ],
      ),
    );
  }
}

/// Mesaj generic cu icon, titlu, subtitlu și buton opțional.
/// Folosit pentru stările Empty și Error.
class MessageView extends StatelessWidget {
  const MessageView({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.iconColor = AppColors.grey,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: iconColor),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: outfit(16, FontWeight.w600, AppColors.dark),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: outfit(12, FontWeight.w400, AppColors.grey),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onAction,
                style: FilledButton.styleFrom(backgroundColor: AppColors.teal),
                child: Text(
                  actionLabel!,
                  style: outfit(13, FontWeight.w600, Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Starea Empty.
class EmptyView extends StatelessWidget {
  const EmptyView({super.key, this.onClear});

  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return MessageView(
      icon: Icons.search_off_rounded,
      title: 'No doctors found',
      subtitle: 'Try another search term or change the filters.',
      actionLabel: onClear == null ? null : 'Clear filters',
      onAction: onClear,
    );
  }
}

/// Starea Error.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MessageView(
      icon: Icons.error_outline_rounded,
      iconColor: AppColors.red,
      title: 'Something went wrong',
      subtitle: message,
      actionLabel: 'Retry',
      onAction: onRetry,
    );
  }
}
