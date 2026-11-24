import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lab3/data/repositories/clinic_repository.dart';
import 'package:lab3/logic/home/home_cubit.dart';
import 'package:lab3/logic/home/home_state.dart';
import 'package:lab3/main.dart';

/// Returnează date deja încărcate (evită I/O real în testele de widget).
class _PreloadedRepo implements ClinicRepository {
  _PreloadedRepo(this.data);
  final ClinicData data;
  @override
  Future<ClinicData> load() async => data;
}

class _FailingRepo implements ClinicRepository {
  @override
  Future<ClinicData> load() async => throw Exception('boom');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  JsonClinicRepository repo() => JsonClinicRepository(delay: Duration.zero);
  late ClinicData loaded;
  setUpAll(() async => loaded = await repo().load());

  group('HomeCubit', () {
    test('loads JSON -> success with 2 doctors', () async {
      final cubit = HomeCubit(repo());
      await cubit.load();
      expect(cubit.state.status, HomeStatus.success);
      expect(cubit.state.visibleDoctors.length, 2);
      expect(cubit.state.appointmentDetails!.doctorName, 'Dr.Upul');
    });

    test('search with no match -> empty, clear -> success', () async {
      final cubit = HomeCubit(repo());
      await cubit.load();
      cubit.search('zzz');
      expect(cubit.state.status, HomeStatus.empty);
      cubit.clearFilters();
      expect(cubit.state.status, HomeStatus.success);
    });

    test('search, filter, sort, favorites', () async {
      final cubit = HomeCubit(repo());
      await cubit.load();

      cubit.search('sonja');
      expect(cubit.state.visibleDoctors.single.id, 'doctor-002');
      cubit.search('');

      cubit.filterBySpecialty('Dental Specialist');
      expect(cubit.state.visibleDoctors.single.id, 'doctor-002');
      cubit.filterBySpecialty(null);

      cubit.sortBy(DoctorSort.distance);
      expect(cubit.state.visibleDoctors.first.id, 'doctor-001');
      cubit.sortBy(DoctorSort.nameDesc);
      expect(cubit.state.visibleDoctors.first.id, 'doctor-002');

      cubit.setFavoritesOnly(true);
      expect(cubit.state.status, HomeStatus.empty);
      cubit.toggleFavorite('doctor-001');
      expect(cubit.state.visibleDoctors.single.id, 'doctor-001');
      cubit.toggleFavorite('doctor-001');
      expect(cubit.state.status, HomeStatus.empty);
    });

    test('repository failure -> error', () async {
      final cubit = HomeCubit(_FailingRepo());
      await cubit.load();
      expect(cubit.state.status, HomeStatus.error);
    });
  });

  testWidgets('loading -> home -> details', (tester) async {
    await tester.pumpWidget(Lab3App(repository: _PreloadedRepo(loaded)));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(); // Future-ul se rezolvă -> Success
    await tester.pumpAndSettle();
    expect(find.text('Hi, Jonathan'), findsOneWidget);
    expect(find.text('Dr. Emmly Lestiryno'), findsOneWidget);

    await tester.tap(find.text('Dr. Emmly Lestiryno'));
    await tester.pumpAndSettle();
    expect(find.text('Book an Appointment'), findsOneWidget);
    expect(find.text('General Practitioner'), findsOneWidget);
  });

  testWidgets('error state shows retry', (tester) async {
    await tester.pumpWidget(Lab3App(repository: _FailingRepo()));
    await tester.pumpAndSettle();
    expect(find.text('Retry'), findsOneWidget);
  });
}
