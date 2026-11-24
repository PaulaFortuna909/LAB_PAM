import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/appointment_details.dart';
import '../models/home_data.dart';

/// Rezultatul încărcării fișierului JSON.
class ClinicData {
  const ClinicData({required this.home, required this.appointmentDetails});

  final HomeData home;
  final AppointmentDetails appointmentDetails;
}

/// Sursa de date a aplicației. Este abstractă ca să poată fi înlocuită
/// în teste (sau mai târziu cu un API real).
abstract class ClinicRepository {
  Future<ClinicData> load();
}

/// Încarcă asincron datele din `assets/data/lab_v2.json`.
class JsonClinicRepository implements ClinicRepository {
  JsonClinicRepository({
    AssetBundle? bundle,
    this.assetPath = 'assets/data/lab_v2.json',
    this.delay = const Duration(milliseconds: 800),
  }) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  final String assetPath;

  /// Întârziere artificială ca să se vadă starea Loading.
  final Duration delay;

  @override
  Future<ClinicData> load() async {
    await Future<void>.delayed(delay);
    final raw = await _bundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return ClinicData(
      home: HomeData.fromJson(json['homeScreen'] as Map<String, dynamic>),
      appointmentDetails: AppointmentDetails.fromJson(
        json['appointmentDetails'] as Map<String, dynamic>,
      ),
    );
  }
}
