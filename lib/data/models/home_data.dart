import 'doctor.dart';

class AppUser {
  const AppUser({
    required this.name,
    required this.greeting,
    required this.subtitle,
    required this.avatarUrl,
  });

  final String name;
  final String greeting;
  final String subtitle;
  final String avatarUrl;

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    name: json['name'] as String,
    greeting: json['greeting'] as String? ?? 'Hi, ${json['name']}',
    subtitle: json['subtitle'] as String? ?? '',
    avatarUrl: json['avatarUrl'] as String? ?? '',
  );
}

class AppointmentDoctor {
  const AppointmentDoctor({
    required this.name,
    required this.specialty,
    required this.avatarUrl,
  });

  final String name;
  final String specialty;
  final String avatarUrl;

  factory AppointmentDoctor.fromJson(Map<String, dynamic> json) =>
      AppointmentDoctor(
        name: json['name'] as String,
        specialty: json['specialty'] as String? ?? '',
        avatarUrl: json['avatarUrl'] as String? ?? '',
      );
}

class UpcomingAppointment {
  const UpcomingAppointment({
    required this.title,
    required this.date,
    required this.time,
    required this.doctor,
  });

  final String title;
  final String date;
  final String time;
  final AppointmentDoctor doctor;

  factory UpcomingAppointment.fromJson(Map<String, dynamic> json) =>
      UpcomingAppointment(
        title: json['title'] as String? ?? 'Appointment',
        date: json['date'] as String,
        time: json['time'] as String,
        doctor: AppointmentDoctor.fromJson(
          json['doctor'] as Map<String, dynamic>,
        ),
      );
}

class HealthService {
  const HealthService({
    required this.id,
    required this.name,
    required this.iconUrl,
  });

  final String id;
  final String name;
  final String iconUrl;

  /// Iconițele din JSON sunt SVG (nu se afișează cu Image.network),
  /// așa că folosim PNG-urile locale cu același id.
  String get localIcon => 'assets/images/ic_$id.png';

  factory HealthService.fromJson(Map<String, dynamic> json) => HealthService(
    id: json['id'] as String,
    name: json['name'] as String,
    iconUrl: json['iconUrl'] as String? ?? '',
  );
}

/// Toate datele pentru ecranul principal (secțiunea "homeScreen" din JSON).
class HomeData {
  const HomeData({
    required this.user,
    required this.hasUnreadNotifications,
    required this.searchHint,
    required this.appointment,
    required this.healthServices,
    required this.nearbyDoctors,
  });

  final AppUser user;
  final bool hasUnreadNotifications;
  final String searchHint;
  final UpcomingAppointment appointment;
  final List<HealthService> healthServices;
  final List<Doctor> nearbyDoctors;

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
    user: AppUser.fromJson(json['user'] as Map<String, dynamic>),
    hasUnreadNotifications:
        (json['notifications'] as Map<String, dynamic>?)?['hasUnread']
            as bool? ??
        false,
    searchHint:
        (json['search'] as Map<String, dynamic>?)?['hint'] as String? ??
        'Search',
    appointment: UpcomingAppointment.fromJson(
      json['appointment'] as Map<String, dynamic>,
    ),
    healthServices: (json['healthServices'] as List<dynamic>? ?? [])
        .map((e) => HealthService.fromJson(e as Map<String, dynamic>))
        .toList(),
    nearbyDoctors: (json['nearbyDoctors'] as List<dynamic>? ?? [])
        .map((e) => Doctor.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
