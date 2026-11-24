import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/appointment_details.dart';

class AppointmentState {
  const AppointmentState({
    required this.hourIndex,
    required this.dateIndex,
    this.isBooking = false,
    this.bookedMessage,
  });

  final int hourIndex;
  final int dateIndex;
  final bool isBooking;

  /// Setat după o rezervare reușită (afișat într-un SnackBar).
  final String? bookedMessage;

  AppointmentState copyWith({
    int? hourIndex,
    int? dateIndex,
    bool? isBooking,
    String? bookedMessage,
  }) => AppointmentState(
    hourIndex: hourIndex ?? this.hourIndex,
    dateIndex: dateIndex ?? this.dateIndex,
    isBooking: isBooking ?? this.isBooking,
    bookedMessage: bookedMessage,
  );
}

/// Starea paginii de detalii: ora și data selectate + rezervarea.
class AppointmentCubit extends Cubit<AppointmentState> {
  AppointmentCubit(this.details, {required this.doctorName})
    : super(
        AppointmentState(
          hourIndex: details.workingHours.initialIndex,
          dateIndex: details.dates.initialIndex,
        ),
      );

  final AppointmentDetails details;
  final String doctorName;

  void selectHour(int i) => emit(state.copyWith(hourIndex: i));

  void selectDate(int i) => emit(state.copyWith(dateIndex: i));

  /// Simulează o cerere asincronă de rezervare.
  Future<void> book() async {
    if (state.isBooking) return;
    emit(state.copyWith(isBooking: true));
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final date = details.dates.slots[state.dateIndex].label;
    final hour = details.workingHours.slots[state.hourIndex].label;
    emit(
      state.copyWith(
        isBooking: false,
        bookedMessage: 'Booked: $date at $hour with $doctorName',
      ),
    );
  }
}
