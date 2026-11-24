import 'package:flutter/material.dart';

import '../core/app_theme.dart';

/// Imagine încărcată din URL (din JSON), cu fallback pe un asset local
/// sau pe inițiale dacă nu există internet.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.url,
    required this.size,
    this.name = '',
    this.fallbackAsset,
    this.circle = true,
    this.radius = 8,
  });

  final String url;
  final double size;
  final String name;
  final String? fallbackAsset;
  final bool circle;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final Widget image = url.isEmpty
        ? _fallback()
        : Image.network(
            url,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _fallback(),
            loadingBuilder: (context, child, progress) => progress == null
                ? child
                : Container(
                    width: size,
                    height: size,
                    color: AppColors.fieldBg,
                  ),
          );

    return circle
        ? ClipOval(child: image)
        : ClipRRect(borderRadius: BorderRadius.circular(radius), child: image);
  }

  Widget _fallback() {
    if (fallbackAsset != null) {
      return Image.asset(
        fallbackAsset!,
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    }
    final initials = name
        .replaceFirst(RegExp(r'^Dr\.?\s*'), '')
        .split(' ')
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      color: AppColors.iconBg,
      child: Text(
        initials,
        style: outfit(size * 0.34, FontWeight.w600, AppColors.primary),
      ),
    );
  }
}
