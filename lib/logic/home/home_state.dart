import '../../data/models/appointment_details.dart';
import '../../data/models/doctor.dart';
import '../../data/models/home_data.dart';

/// Stările principale ale ecranului.
enum HomeStatus { loading, success, empty, error }

/// Criterii de sortare pentru lista de doctori.
enum DoctorSort {
  nameAsc('Name (A-Z)'),
  nameDesc('Name (Z-A)'),
  distance('Nearest first');

  const DoctorSort(this.label);
  final String label;
}

class HomeState {
  const HomeState({
    this.status = HomeStatus.loading,
    this.data,
    this.appointmentDetails,
    this.errorMessage,
    this.query = '',
    this.specialty,
    this.favoritesOnly = false,
    this.sort = DoctorSort.nameAsc,
    this.favoriteIds = const {},
    this.visibleDoctors = const [],
  });

  final HomeStatus status;
  final HomeData? data;
  final AppointmentDetails? appointmentDetails;
  final String? errorMessage;

  // --- căutare / filtrare / sortare ---
  final String query;

  /// `null` = toate specialitățile.
  final String? specialty;
  final bool favoritesOnly;
  final DoctorSort sort;

  final Set<String> favoriteIds;

  /// Lista finală afișată (după căutare, filtrare și sortare).
  final List<Doctor> visibleDoctors;

  bool isFavorite(String doctorId) => favoriteIds.contains(doctorId);

  /// Specialitățile disponibile pentru filtru.
  List<String> get specialties {
    final all =
        data?.nearbyDoctors.map((d) => d.specialty).toSet().toList() ??
        <String>[];
    return all..sort();
  }

  bool get hasActiveFilters =>
      query.isNotEmpty || specialty != null || favoritesOnly;

  HomeState copyWith({
    HomeStatus? status,
    HomeData? data,
    AppointmentDetails? appointmentDetails,
    String? errorMessage,
    String? query,
    String? Function()? specialty,
    bool? favoritesOnly,
    DoctorSort? sort,
    Set<String>? favoriteIds,
    List<Doctor>? visibleDoctors,
  }) {
    return HomeState(
      status: status ?? this.status,
      data: data ?? this.data,
      appointmentDetails: appointmentDetails ?? this.appointmentDetails,
      errorMessage: errorMessage ?? this.errorMessage,
      query: query ?? this.query,
      specialty: specialty != null ? specialty() : this.specialty,
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
      sort: sort ?? this.sort,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      visibleDoctors: visibleDoctors ?? this.visibleDoctors,
    );
  }
}
