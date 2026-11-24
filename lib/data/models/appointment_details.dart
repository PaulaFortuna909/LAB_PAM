/// Secțiunea "appointmentDetails" din JSON.
class AppointmentDetails {
  const AppointmentDetails({
    required this.title,
    required this.doctorName,
    required this.clinic,
    required this.doctorAvatarUrl,
    required this.paymentLabel,
    required this.paymentFormatted,
    required this.detailsTitle,
    required this.description,
    required this.workingHours,
    required this.dates,
    required this.bookLabel,
    required this.bookEnabled,
  });

  final String title;
  final String doctorName;
  final String clinic;
  final String doctorAvatarUrl;
  final String paymentLabel;
  final String paymentFormatted;
  final String detailsTitle;
  final String description;
  final SlotGroup workingHours;
  final SlotGroup dates;
  final String bookLabel;
  final bool bookEnabled;

  factory AppointmentDetails.fromJson(Map<String, dynamic> json) {
    final doctor = json['doctor'] as Map<String, dynamic>;
    final payment = json['payment'] as Map<String, dynamic>;
    final details = json['details'] as Map<String, dynamic>;
    final book =
        (json['actions'] as Map<String, dynamic>)['bookAppointment']
            as Map<String, dynamic>;
    return AppointmentDetails(
      title: json['title'] as String? ?? 'Appointment',
      doctorName: doctor['name'] as String,
      clinic: doctor['clinic'] as String? ?? '',
      doctorAvatarUrl: doctor['avatarUrl'] as String? ?? '',
      paymentLabel: payment['label'] as String? ?? 'Payment',
      paymentFormatted:
          payment['formatted'] as String? ??
          '\$${(payment['amount'] as num).toStringAsFixed(2)}',
      detailsTitle: details['title'] as String? ?? 'Details',
      description: details['description'] as String? ?? '',
      workingHours: SlotGroup.fromJson(
        json['workingHours'] as Map<String, dynamic>,
      ),
      dates: SlotGroup.fromJson(json['date'] as Map<String, dynamic>),
      bookLabel: book['label'] as String? ?? 'Book an Appointment',
      bookEnabled: book['enabled'] as bool? ?? true,
    );
  }
}

class SlotGroup {
  const SlotGroup({required this.title, required this.slots});

  final String title;
  final List<Slot> slots;

  /// Indexul slotului marcat "selected": true în JSON (sau 0).
  int get initialIndex {
    final i = slots.indexWhere((s) => s.selected);
    return i < 0 ? 0 : i;
  }

  factory SlotGroup.fromJson(Map<String, dynamic> json) => SlotGroup(
    title: json['title'] as String,
    slots: (json['slots'] as List<dynamic>)
        .map((e) => Slot.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

class Slot {
  const Slot({required this.id, required this.label, required this.selected});

  final String id;
  final String label;
  final bool selected;

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
    id: json['id'] as String,
    label: json['label'] as String,
    selected: json['selected'] as bool? ?? false,
  );
}
