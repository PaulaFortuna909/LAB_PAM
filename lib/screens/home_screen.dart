import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'appointment_screen.dart';

const _teal = Color(0xFF2AB0BE);
const _dark = Color(0xFF1D1D29);
const _grey = Color(0xFF8E94A3);
const _fieldBg = Color(0xFFF4F5FA);
const _tileBg = Color(0xFFF9F9F9);

TextStyle _outfit(double size, FontWeight weight, Color color) =>
    GoogleFonts.outfit(fontSize: size, fontWeight: weight, color: color);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openAppointment(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AppointmentScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            const _Header(),
            const SizedBox(height: 22),
            const _SearchBar(),
            const SizedBox(height: 22),
            _AppointmentCard(onTap: () => _openAppointment(context)),
            const SizedBox(height: 36),
            _SectionTitle('Health Services', onSeeAll: () {}),
            const SizedBox(height: 14),
            const _HealthServices(),
            const SizedBox(height: 22),
            _SectionTitle('Nearby Doctor', onSeeAll: () {}),
            const SizedBox(height: 14),
            _DoctorTile(
              photo: 'assets/images/dr_emmly.jpg',
              name: 'Dr. Emmly Lestiryno',
              specialty: 'General Practitioner',
              address: '3167 Durgan Shores - 500M from you',
              onTap: () => _openAppointment(context),
            ),
            const SizedBox(height: 18),
            _DoctorTile(
              photo: 'assets/images/dr_sonja.jpg',
              name: 'Dr. Sonja Littel',
              specialty: 'Dental Specialist',
              address: '950 Sigrid Port - 753M from you',
              onTap: () => _openAppointment(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const ClipOval(
          child: SizedBox(
            width: 42,
            height: 42,
            child: Image(
              image: AssetImage('assets/images/user_jonathan.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hi, Jonathan', style: _outfit(15, FontWeight.w600, _dark)),
              const SizedBox(height: 2),
              Text('May you always be healthy',
                  style: _outfit(10, FontWeight.w400, _grey)),
            ],
          ),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.notifications_none_rounded, size: 26, color: _dark),
            Positioned(
              right: 3,
              top: 2,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFFF03E3E),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.2),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: _fieldBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: Color(0xFF9CA3B8), size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: _outfit(13, FontWeight.w400, _dark),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: 'Search something',
                hintStyle: _outfit(13, FontWeight.w400, const Color(0xFFAAB0C0)),
              ),
            ),
          ),
          const Icon(Icons.tune_rounded, color: Color(0xFF9CA3B8), size: 22),
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final white = _outfit(12, FontWeight.w400, Colors.white);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        // room for the doctor card overflowing below the teal box
        padding: const EdgeInsets.only(bottom: 24),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 180,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF45C0CC), Color(0xFF25A7B6)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('Appointment',
                            style: _outfit(11, FontWeight.w500, Colors.white)),
                      ),
                      const Icon(Icons.chevron_right_rounded,
                          color: Colors.white, size: 20),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              const Icon(Icons.edit_calendar_outlined,
                                  color: Colors.white, size: 17),
                              const SizedBox(width: 6),
                              Text('22 October, 2023', style: white),
                            ]),
                            const SizedBox(height: 12),
                            Row(children: [
                              const Icon(Icons.access_time_rounded,
                                  color: Colors.white, size: 17),
                              const SizedBox(width: 6),
                              Text('08:00 AM - 10.30 AM', style: white),
                            ]),
                          ],
                        ),
                      ),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit_outlined,
                            color: _teal, size: 22),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              left: 14,
              right: 30,
              bottom: -24,
              child: Container(
                height: 64,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const SizedBox(
                        width: 42,
                        height: 42,
                        child: Image(
                          image: AssetImage('assets/images/dr_richar.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dr. Richar Kandowen',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: _outfit(13, FontWeight.w600, _dark)),
                          const SizedBox(height: 2),
                          Text('Child Specialist',
                              style: _outfit(10, FontWeight.w400, _grey)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chat_outlined, size: 20, color: _dark),
                    const SizedBox(width: 6),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, {required this.onSeeAll});

  final String title;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: _outfit(17, FontWeight.w600, _dark)),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: Text('See All', style: _outfit(10, FontWeight.w500, _teal)),
        ),
      ],
    );
  }
}

class _HealthServices extends StatelessWidget {
  const _HealthServices();

  static const _items = [
    ('assets/images/ic_tooth.png', 'Tooth'),
    ('assets/images/ic_eye.png', 'Eye'),
    ('assets/images/ic_lungs.png', 'Lungs'),
    ('assets/images/ic_ear.png', 'Ear'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final (icon, label) in _items)
          Column(
            children: [
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _tileBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(icon, width: 40, height: 40),
              ),
              const SizedBox(height: 8),
              Text(label, style: _outfit(12, FontWeight.w400, _grey)),
            ],
          ),
      ],
    );
  }
}

class _DoctorTile extends StatelessWidget {
  const _DoctorTile({
    required this.photo,
    required this.name,
    required this.specialty,
    required this.address,
    required this.onTap,
  });

  final String photo;
  final String name;
  final String specialty;
  final String address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: Image.asset(photo, width: 44, height: 44, fit: BoxFit.cover),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: _outfit(13, FontWeight.w600, _dark)),
                const SizedBox(height: 2),
                Text(specialty, style: _outfit(10, FontWeight.w400, _grey)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: _teal),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(address,
                          style: _outfit(10, FontWeight.w400, _dark)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const _FavButton(),
        ],
      ),
    );
  }
}

class _FavButton extends StatefulWidget {
  const _FavButton();

  @override
  State<_FavButton> createState() => _FavButtonState();
}

class _FavButtonState extends State<_FavButton> {
  bool _fav = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _fav = !_fav),
      child: Icon(
        _fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        size: 20,
        color: _fav ? const Color(0xFFF03E3E) : _grey,
      ),
    );
  }
}
