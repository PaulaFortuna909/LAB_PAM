import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/doctor.dart';
import '../logic/home/home_cubit.dart';
import '../logic/home/home_state.dart';
import '../widgets/common.dart';
import '../widgets/doctor_tile.dart';
import '../widgets/filter_sheet.dart';
import '../widgets/home_sections.dart';
import '../widgets/state_views.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openDoctor(BuildContext context, Doctor doctor) {
    final details = context.read<HomeCubit>().state.appointmentDetails!;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            DetailsScreen.forDoctor(doctor: doctor, details: details),
      ),
    );
  }

  void _openAppointment(BuildContext context) {
    final details = context.read<HomeCubit>().state.appointmentDetails!;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DetailsScreen.forAppointment(details: details),
      ),
    );
  }

  void _clearAll(HomeCubit cubit) {
    _searchController.clear();
    cubit.clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final cubit = context.read<HomeCubit>();
            switch (state.status) {
              case HomeStatus.loading:
                return const LoadingView(message: 'Loading doctors...');
              case HomeStatus.error:
                return ErrorView(
                  message: state.errorMessage ?? 'Unknown error',
                  onRetry: cubit.load,
                );
              case HomeStatus.success:
              case HomeStatus.empty:
                return _content(context, state, cubit);
            }
          },
        ),
      ),
    );
  }

  Widget _content(BuildContext context, HomeState state, HomeCubit cubit) {
    final data = state.data!;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        HomeHeader(user: data.user, hasUnread: data.hasUnreadNotifications),
        const SizedBox(height: 22),
        SearchField(
          controller: _searchController,
          hint: data.searchHint,
          onChanged: cubit.search,
          onFilterTap: () => FilterSheet.show(context),
          filtersActive: state.specialty != null || state.favoritesOnly,
        ),
        const SizedBox(height: 22),
        AppointmentCard(
          appointment: data.appointment,
          onTap: () => _openAppointment(context),
        ),
        const SizedBox(height: 36),
        const SectionTitle('Health Services', trailing: 'See All'),
        const SizedBox(height: 14),
        HealthServicesRow(services: data.healthServices),
        const SizedBox(height: 22),
        SectionTitle(
          'Nearby Doctor',
          trailing: state.hasActiveFilters ? 'Clear filters' : null,
          onTrailing: () => _clearAll(cubit),
        ),
        const SizedBox(height: 14),
        if (state.status == HomeStatus.empty)
          EmptyView(onClear: () => _clearAll(cubit))
        else
          for (final doctor in state.visibleDoctors) ...[
            DoctorTile(
              doctor: doctor,
              isFavorite: state.isFavorite(doctor.id),
              onTap: () => _openDoctor(context, doctor),
              onFavoriteTap: () => cubit.toggleFavorite(doctor.id),
            ),
            const SizedBox(height: 18),
          ],
      ],
    );
  }
}
