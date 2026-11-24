import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../data/models/home_data.dart';
import 'app_avatar.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.user, required this.hasUnread});

  final AppUser user;
  final bool hasUnread;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppAvatar(
          url: user.avatarUrl,
          name: user.name,
          size: 42,
          fallbackAsset: 'assets/images/user_jonathan.jpg',
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.greeting,
                style: outfit(15, FontWeight.w600, AppColors.dark),
              ),
              const SizedBox(height: 2),
              Text(
                user.subtitle,
                style: outfit(10, FontWeight.w400, AppColors.grey),
              ),
            ],
          ),
        ),
        Badge(
          isLabelVisible: hasUnread,
          smallSize: 8,
          backgroundColor: AppColors.red,
          child: const Icon(
            Icons.notifications_none_rounded,
            size: 26,
            color: AppColors.dark,
          ),
        ),
      ],
    );
  }
}

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onTap,
  });

  final UpcomingAppointment appointment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final white = outfit(12, FontWeight.w400, Colors.white);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 180,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF45C0CC), Color(0xFF25A7B6)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          appointment.title,
                          style: outfit(11, FontWeight.w500, Colors.white),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.edit_calendar_outlined,
                                  color: Colors.white,
                                  size: 17,
                                ),
                                const SizedBox(width: 6),
                                Text(appointment.date, style: white),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time_rounded,
                                  color: Colors.white,
                                  size: 17,
                                ),
                                const SizedBox(width: 6),
                                Text(appointment.time, style: white),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          color: AppColors.teal,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              left: 14,
              right: 30,
              bottom: -24,
              child: Container(
                height: 64,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    AppAvatar(
                      url: appointment.doctor.avatarUrl,
                      name: appointment.doctor.name,
                      size: 42,
                      circle: false,
                      radius: 4,
                      fallbackAsset: 'assets/images/dr_richar.jpg',
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.doctor.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: outfit(13, FontWeight.w600, AppColors.dark),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            appointment.doctor.specialty,
                            style: outfit(10, FontWeight.w400, AppColors.grey),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chat_outlined,
                      size: 20,
                      color: AppColors.dark,
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HealthServicesRow extends StatelessWidget {
  const HealthServicesRow({super.key, required this.services});

  final List<HealthService> services;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final s in services)
          Column(
            children: [
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.tileBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  s.localIcon,
                  width: 40,
                  height: 40,
                  errorBuilder: (_, _, _) => const Icon(
                    Icons.medical_services_outlined,
                    color: AppColors.teal,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(s.name, style: outfit(12, FontWeight.w400, AppColors.grey)),
            ],
          ),
      ],
    );
  }
}
