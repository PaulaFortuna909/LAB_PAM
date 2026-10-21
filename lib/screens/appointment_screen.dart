import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _primary = Color(0xFF1A8FA8);
const _mint = Color(0xFF7CC4B4);
const _iconBg = Color(0xFFD5ECEC);
const _chipBg = Color(0xFFF0F0F0);
const _black = Color(0xFF111111);

TextStyle _open(double size, FontWeight weight, Color color, {double? h}) =>
    GoogleFonts.openSans(
        fontSize: size, fontWeight: weight, color: color, height: h);

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  static const _hours = ['10.00 AM', '11.00 AM', '12.00 PM', '01.00 PM', '02.00 PM'];
  static const _dates = ['Sun 4', 'Mon 5', 'Tue 6', 'Wed 7', 'Thu 8'];

  int _hour = 1;
  int _date = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 18, bottom: 16),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _doctorInfo(),
                  ),
                  const SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _details(),
                  ),
                  const SizedBox(height: 30),
                  _sectionHeader('Working Hours'),
                  const SizedBox(height: 12),
                  _chips(_hours, _hour, (i) => setState(() => _hour = i)),
                  const SizedBox(height: 20),
                  _sectionHeader('Date'),
                  const SizedBox(height: 12),
                  _chips(_dates, _date, (i) => setState(() => _date = i)),
                ],
              ),
            ),
            _bookButton(context),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 12,
            child: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 22, color: _black),
            ),
          ),
          Text('Appointment', style: _open(20, FontWeight.w700, _primary)),
        ],
      ),
    );
  }

  Widget _doctorInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            'assets/images/dr_upul.jpg',
            width: 90,
            height: 90,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Row(
                children: [
                  Text('Dr.Upul', style: _open(16, FontWeight.w700, _black)),
                  const Spacer(),
                  const _RoundIcon(Icons.chat_bubble_outline_rounded),
                  const SizedBox(width: 8),
                  const _RoundIcon(Icons.phone_outlined),
                  const SizedBox(width: 8),
                  const _RoundIcon(Icons.videocam_outlined),
                ],
              ),
              const SizedBox(height: 4),
              Text('Denteeth', style: _open(12, FontWeight.w600, _mint)),
              const SizedBox(height: 18),
              Row(
                children: [
                  Text('Payment', style: _open(14, FontWeight.w600, _black)),
                  const Spacer(),
                  Text('\$120.00', style: _open(14, FontWeight.w700, _mint)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _details() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Details', style: _open(16, FontWeight.w700, _black)),
        const SizedBox(height: 10),
        Text(
          'Worem ipsum dolor sit amet, consectetur adipiscing elit. Nunc '
          'vulputate libero et velit interdum, ac aliquet odio mattis. Class '
          'aptent taciti sociosqu ad litora torquent per conubia nostra, per '
          'inceptos himenaeos. Curabitur tempus urna at turpis condimentum '
          'lobortis. Ut commodo efficitur neque. Ut diam quam, semper iaculis '
          'condimentum ac, vestibulum eu nisl.',
          textAlign: TextAlign.justify,
          style: _open(9, FontWeight.w400, const Color(0xFF8A8A8A), h: 1.4),
        ),
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: _open(16, FontWeight.w700, _black)),
          ),
          Text('See All', style: _open(11, FontWeight.w400, _black)),
        ],
      ),
    );
  }

  Widget _chips(List<String> labels, int selected, ValueChanged<int> onTap) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: labels.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final isSel = i == selected;
          return GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 86,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSel ? _primary : _chipBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                labels[i],
                style: _open(13, FontWeight.w400,
                    isSel ? Colors.white : _black),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _bookButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Booked: ${_dates[_date]} at ${_hours[_hour]} with Dr.Upul'),
            ));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
          child: Text('Book an Appointment',
              style: _open(15, FontWeight.w700, Colors.white)),
        ),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(color: _iconBg, shape: BoxShape.circle),
      child: Icon(icon, size: 12, color: _black),
    );
  }
}
