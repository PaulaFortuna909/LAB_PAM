import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../data/models/doctor.dart';
import 'app_avatar.dart';
import 'favorite_button.dart';

/// Un rând din lista de doctori.
class DoctorTile extends StatelessWidget {
  const DoctorTile({
    super.key,
    required this.doctor,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
  });

  final Doctor doctor;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'doctor-${doctor.id}',
            child: AppAvatar(
              url: doctor.avatarUrl,
              name: doctor.name,
              size: 44,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: outfit(13, FontWeight.w600, AppColors.dark),
                ),
                const SizedBox(height: 2),
                Text(
                  doctor.specialty,
                  style: outfit(10, FontWeight.w400, AppColors.grey),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppColors.teal,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        doctor.distance,
                        style: outfit(10, FontWeight.w400, AppColors.dark),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          FavoriteButton(isFavorite: isFavorite, onTap: onFavoriteTap),
        ],
      ),
    );
  }
}
