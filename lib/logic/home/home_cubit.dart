import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/doctor.dart';
import '../../data/repositories/clinic_repository.dart';
import 'home_state.dart';

/// Gestionează încărcarea datelor, căutarea, filtrarea, sortarea
/// și lista de favorite.
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repository) : super(const HomeState());

  final ClinicRepository _repository;

  Future<void> load() async {
    emit(const HomeState(status: HomeStatus.loading));
    try {
      final result = await _repository.load();
      final favorites = result.home.nearbyDoctors
          .where((d) => d.isFavorite)
          .map((d) => d.id)
          .toSet();
      _apply(
        HomeState(
          status: HomeStatus.success,
          data: result.home,
          appointmentDetails: result.appointmentDetails,
          favoriteIds: favorites,
        ),
      );
    } catch (e) {
      emit(
        HomeState(
          status: HomeStatus.error,
          errorMessage: 'Could not load data.\n$e',
        ),
      );
    }
  }

  void search(String query) => _apply(state.copyWith(query: query.trim()));

  void filterBySpecialty(String? specialty) =>
      _apply(state.copyWith(specialty: () => specialty));

  void setFavoritesOnly(bool value) =>
      _apply(state.copyWith(favoritesOnly: value));

  void sortBy(DoctorSort sort) => _apply(state.copyWith(sort: sort));

  void clearFilters() => _apply(
    state.copyWith(
      query: '',
      specialty: () => null,
      favoritesOnly: false,
      sort: DoctorSort.nameAsc,
    ),
  );

  void toggleFavorite(String doctorId) {
    final favorites = {...state.favoriteIds};
    if (!favorites.remove(doctorId)) favorites.add(doctorId);
    _apply(state.copyWith(favoriteIds: favorites));
  }

  /// Recalculează lista vizibilă și decide între Success și Empty.
  void _apply(HomeState next) {
    final data = next.data;
    if (data == null) {
      emit(next);
      return;
    }

    final q = next.query.toLowerCase();
    final list = data.nearbyDoctors.where((Doctor d) {
      final matchesQuery =
          q.isEmpty ||
          d.name.toLowerCase().contains(q) ||
          d.specialty.toLowerCase().contains(q) ||
          d.address.toLowerCase().contains(q);
      final matchesSpecialty =
          next.specialty == null || d.specialty == next.specialty;
      final matchesFav = !next.favoritesOnly || next.isFavorite(d.id);
      return matchesQuery && matchesSpecialty && matchesFav;
    }).toList();

    switch (next.sort) {
      case DoctorSort.nameAsc:
        list.sort((a, b) => _cleanName(a).compareTo(_cleanName(b)));
      case DoctorSort.nameDesc:
        list.sort((a, b) => _cleanName(b).compareTo(_cleanName(a)));
      case DoctorSort.distance:
        list.sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
    }

    emit(
      next.copyWith(
        visibleDoctors: list,
        status: list.isEmpty ? HomeStatus.empty : HomeStatus.success,
      ),
    );
  }

  static String _cleanName(Doctor d) =>
      d.name.replaceFirst(RegExp(r'^Dr\.?\s*'), '').toLowerCase();
}
