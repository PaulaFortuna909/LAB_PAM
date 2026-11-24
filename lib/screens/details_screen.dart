import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/app_theme.dart';
import '../data/models/appointment_details.dart';
import '../data/models/doctor.dart';
import '../logic/appointment/appointment_cubit.dart';
import '../logic/home/home_cubit.dart';
import '../logic/home/home_state.dart';
import '../widgets/app_avatar.dart';
import '../widgets/common.dart';
import '../widgets/favorite_button.dart';

const _black = Color(0xFF111111);

/// Pagina de detalii / programare.
/// Poate fi deschisă pentru un doctor din listă sau pentru programarea
/// din cardul de pe ecranul principal.
class DetailsScreen extends StatelessWidget {
  const DetailsScreen._({
    required this.details,
    required this.name,
    required this.subtitle,
    required this.avatarUrl,
    this.doctorId,
    this.fallbackAsset,
  });

  factory DetailsScreen.forDoctor({
    required Doctor doctor,
    required AppointmentDetails details,
  }) => DetailsScreen._(
    details: details,
    name: doctor.name,
    subtitle: doctor.specialty,
    avatarUrl: doctor.avatarUrl,
    doctorId: doctor.id,
  );

  factory DetailsScreen.forAppointment({required AppointmentDetails details}) =>
      DetailsScreen._(
        details: details,
        name: details.doctorName,
        subtitle: details.clinic,
        avatarUrl: details.doctorAvatarUrl,
        fallbackAsset: 'assets/images/dr_upul.jpg',
      );

  final AppointmentDetails details;
  final String name;
  final String subtitle;
  final String avatarUrl;
  final String? doctorId;
  final String? fallbackAsset;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppointmentCubit(details, doctorName: name),
      child: BlocListener<AppointmentCubit, AppointmentState>(
        listenWhen: (_, s) => s.bookedMessage != null,
        listener: (context, s) => ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(s.bookedMessage!))),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                _TopBar(title: details.title, doctorId: doctorId),
                Expanded(child: _body()),
                _BookButton(
                  label: details.bookLabel,
                  enabled: details.bookEnabled,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return BlocBuilder<AppointmentCubit, AppointmentState>(
      builder: (context, state) {
        final cubit = context.read<AppointmentCubit>();
        return ListView(
          padding: const EdgeInsets.only(top: 18, bottom: 16),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _doctorInfo(context),
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    details.detailsTitle,
                    style: openSans(16, FontWeight.w700, _black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    details.description,
                    textAlign: TextAlign.justify,
                    style: openSans(
                      11,
                      FontWeight.w400,
                      const Color(0xFF8A8A8A),
                      h: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _sectionHeader(details.workingHours.title),
            const SizedBox(height: 12),
            SelectableChips(
              labels: details.workingHours.slots.map((s) => s.label).toList(),
              selected: state.hourIndex,
              onSelected: cubit.selectHour,
            ),
            const SizedBox(height: 20),
            _sectionHeader(details.dates.title),
            const SizedBox(height: 12),
            SelectableChips(
              labels: details.dates.slots.map((s) => s.label).toList(),
              selected: state.dateIndex,
              onSelected: cubit.selectDate,
            ),
          ],
        );
      },
    );
  }

  Widget _doctorInfo(BuildContext context) {
    void soon(String what) => ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$what $name...')));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: doctorId != null ? 'doctor-$doctorId' : 'appointment-doctor',
          child: AppAvatar(
            url: avatarUrl,
            name: name,
            size: 90,
            circle: false,
            fallbackAsset: fallbackAsset,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(name, style: openSans(16, FontWeight.w700, _black)),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: openSans(12, FontWeight.w600, AppColors.mint),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  RoundIcon(
                    Icons.chat_bubble_outline_rounded,
                    onTap: () => soon('Messaging'),
                  ),
                  const SizedBox(width: 8),
                  RoundIcon(Icons.phone_outlined, onTap: () => soon('Calling')),
                  const SizedBox(width: 8),
                  RoundIcon(
                    Icons.videocam_outlined,
                    onTap: () => soon('Video call with'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    details.paymentLabel,
                    style: openSans(14, FontWeight.w600, _black),
                  ),
                  const Spacer(),
                  Text(
                    details.paymentFormatted,
                    style: openSans(14, FontWeight.w700, AppColors.mint),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(title, style: openSans(16, FontWeight.w700, _black)),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, this.doctorId});

  final String title;
  final String? doctorId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 12,
            child: IconButton(
              tooltip: 'Back',
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 22,
                color: _black,
              ),
            ),
          ),
          Text(title, style: openSans(20, FontWeight.w700, AppColors.primary)),
          if (doctorId != null)
            Positioned(
              right: 16,
              // Favoritele sunt în HomeCubit, deci se sincronizează cu lista.
              child: BlocBuilder<HomeCubit, HomeState>(
                buildWhen: (a, b) => a.favoriteIds != b.favoriteIds,
                builder: (context, state) => FavoriteButton(
                  size: 24,
                  isFavorite: state.isFavorite(doctorId!),
                  onTap: () =>
                      context.read<HomeCubit>().toggleFavorite(doctorId!),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BookButton extends StatelessWidget {
  const _BookButton({required this.label, required this.enabled});

  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentCubit, AppointmentState>(
      buildWhen: (a, b) => a.isBooking != b.isBooking,
      builder: (context, state) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton(
            onPressed: enabled && !state.isBooking
                ? context.read<AppointmentCubit>().book
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: state.isBooking
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    label,
                    style: openSans(15, FontWeight.w700, Colors.white),
                  ),
          ),
        ),
      ),
    );
  }
}
