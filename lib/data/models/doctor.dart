/// Un doctor din lista "Nearby Doctor".
class Doctor {
  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.distance,
    required this.avatarUrl,
    this.isFavorite = false,
  });

  final String id;
  final String name;
  final String specialty;

  /// Text complet, ex: "3167 Durgan Shores - 500M from you".
  final String distance;
  final String avatarUrl;
  final bool isFavorite;

  /// Distanța în metri extrasă din text ("500M" -> 500). Folosită la sortare.
  int get distanceMeters {
    final match = RegExp(r'(\d+)\s*M\b').firstMatch(distance);
    return match == null ? 1 << 30 : int.parse(match.group(1)!);
  }

  /// Adresa fără partea cu distanța.
  String get address => distance.split(' - ').first;

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
    id: json['id'] as String,
    name: json['name'] as String,
    specialty: json['specialty'] as String,
    distance: json['distance'] as String? ?? '',
    avatarUrl: json['avatarUrl'] as String? ?? '',
    isFavorite: json['isFavorite'] as bool? ?? false,
  );
}
