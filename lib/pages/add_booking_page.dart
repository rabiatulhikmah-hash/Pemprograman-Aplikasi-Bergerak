import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../data/dummy_data.dart';

class AddBookingPage extends StatefulWidget {
  const AddBookingPage({Key? key}) : super(key: key);

  @override
  State<AddBookingPage> createState() => _AddBookingPageState();
}

class _AddBookingPageState extends State<AddBookingPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _hpController = TextEditingController();
  final _emailController = TextEditingController();

  String? _selectedFilm;
  String? _selectedJadwal;
  String? _selectedKursi;
  String? _selectedStudio;
  int _harga = 0;

  List<String> get _jadwalList =>
      _selectedFilm != null ? (jadwalPerFilm[_selectedFilm] ?? []) : [];

  List<String> get _kursiList =>
      _selectedStudio != null ? (kursiPerStudio[_selectedStudio] ?? []) : [];

  void _onFilmChanged(String? film) {
    setState(() {
      _selectedFilm = film;
      _selectedJadwal = null;
      _selectedStudio = null;
      _selectedKursi = null;
      _harga = 0;
    });
  }

  void _onJadwalChanged(String? jadwal) {
    setState(() {
      _selectedJadwal = jadwal;
      _selectedStudio = jadwal != null ? studioPerJadwal[jadwal] : null;
      _selectedKursi = null;
      _harga = _selectedStudio != null ? getHarga(_selectedStudio!) : 0;
    });
  }

  void _onKursiChanged(String? kursi) {
    setState(() => _selectedKursi = kursi);
  }

  void _submit() {
    if (_formKey.currentState!.validate() &&
        _selectedFilm != null &&
        _selectedJadwal != null &&
        _selectedKursi != null) {
      final booking = Booking(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        namaFilm: _selectedFilm!,
        jadwal: _selectedJadwal!,
        studio: _selectedStudio!,
        kursi: _selectedKursi!,
        harga: _harga,
        namaPemesan: _namaController.text.trim(),
        noHp: _hpController.text.trim(),
        email: _emailController.text.trim(),
      );
      Navigator.pop(context, booking);
    } else {
      // Tampilkan snackbar jika dropdown belum dipilih
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lengkapi semua pilihan terlebih dahulu'),
          backgroundColor: Color(0xFFE94560),
        ),
      );
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hpController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Booking Baru', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(height: 2, color: const Color(0xFFE94560)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── PILIH FILM ──
              _sectionLabel('Pilih Film', const Color(0xFFE94560)),
              const SizedBox(height: 12),
              _buildDropdown(
                value: _selectedFilm,
                hint: 'Pilih Film',
                icon: Icons.movie_outlined,
                items: daftarFilm,
                onChanged: _onFilmChanged,
              ),

              const SizedBox(height: 20),

              // ── PILIH JADWAL ──
              _sectionLabel('Pilih Jadwal', const Color(0xFFE94560)),
              const SizedBox(height: 12),
              _buildDropdown(
                value: _selectedJadwal,
                hint: _selectedFilm == null ? 'Pilih film dahulu' : 'Pilih Jadwal',
                icon: Icons.schedule_outlined,
                items: _jadwalList,
                onChanged: _selectedFilm != null ? _onJadwalChanged : null,
              ),

              // Info studio & harga (muncul setelah jadwal dipilih)
              if (_selectedStudio != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE94560).withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.theaters_outlined, color: Color(0xFFE94560), size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _selectedStudio!,
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ),
                      Text(
                        formatHarga(_harga),
                        style: const TextStyle(
                          color: Color(0xFFE94560),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // ── PILIH KURSI ──
              _sectionLabel('Pilih Kursi', const Color(0xFFE94560)),
              const SizedBox(height: 12),
              _buildDropdown(
                value: _selectedKursi,
                hint: _selectedJadwal == null ? 'Pilih jadwal dahulu' : 'Pilih Kursi',
                icon: Icons.event_seat_outlined,
                items: _kursiList,
                onChanged: _selectedJadwal != null ? _onKursiChanged : null,
              ),

              const SizedBox(height: 24),

              // ── DATA PEMESAN ──
              _sectionLabel('Data Pemesan', Colors.blueAccent),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _namaController,
                label: 'Nama Lengkap',
                icon: Icons.person_outline,
                validator: (v) => v!.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 14),
              _buildTextField(
                controller: _hpController,
                label: 'Nomor HP',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v!.isEmpty) return 'Nomor HP wajib diisi';
                  if (!RegExp(r'^\d+$').hasMatch(v)) return 'Nomor HP hanya boleh angka';
                  if (v.length < 10 || v.length > 13) return 'Nomor HP harus 10-13 digit';
                  return null;
                },
              ),
              const SizedBox(height: 14),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v!.isEmpty) return 'Email wajib diisi';
                  if (!v.endsWith('@gmail.com')) return 'Email harus berformat @gmail.com';
                  if (v.trim() == '@gmail.com') return 'Email tidak boleh kosong sebelum @gmail.com';
                  return null;
                },
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE94560),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 6,
                  ),
                  child: const Text(
                    'Konfirmasi Booking',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text, Color color) {
    return Row(
      children: [
        Container(width: 4, height: 18, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: const Color(0xFF1A1A2E),
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: Icon(icon, color: const Color(0xFFE94560), size: 20),
        filled: true,
        fillColor: const Color(0xFF1A1A2E),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE94560), width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white10),
        ),
      ),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.blueAccent, size: 20),
        filled: true,
        fillColor: const Color(0xFF1A1A2E),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),
    );
  }
}