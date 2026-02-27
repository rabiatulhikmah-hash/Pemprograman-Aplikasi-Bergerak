import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../data/dummy_data.dart';

class EditBookingPage extends StatefulWidget {
  final Booking booking;
  const EditBookingPage({Key? key, required this.booking}) : super(key: key);

  @override
  State<EditBookingPage> createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _namaController;
  late TextEditingController _hpController;
  late TextEditingController _emailController;

  late String? _selectedFilm;
  late String? _selectedJadwal;
  late String? _selectedKursi;
  late String? _selectedStudio;
  late int _harga;

  List<String> get _jadwalList =>
      _selectedFilm != null ? (jadwalPerFilm[_selectedFilm] ?? []) : [];
  List<String> get _kursiList =>
      _selectedStudio != null ? (kursiPerStudio[_selectedStudio] ?? []) : [];

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.booking.namaPemesan);
    _hpController = TextEditingController(text: widget.booking.noHp);
    _emailController = TextEditingController(text: widget.booking.email);
    _selectedFilm = widget.booking.namaFilm;
    _selectedJadwal = widget.booking.jadwal;
    _selectedStudio = widget.booking.studio;
    _selectedKursi = widget.booking.kursi;
    _harga = widget.booking.harga;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hpController.dispose();
    _emailController.dispose();
    super.dispose();
  }

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

  void _submit() {
    if (_formKey.currentState!.validate() &&
        _selectedFilm != null &&
        _selectedJadwal != null &&
        _selectedKursi != null) {
      final updated = Booking(
        id: widget.booking.id,
        namaFilm: _selectedFilm!,
        jadwal: _selectedJadwal!,
        studio: _selectedStudio!,
        kursi: _selectedKursi!,
        harga: _harga,
        namaPemesan: _namaController.text.trim(),
        noHp: _hpController.text.trim(),
        email: _emailController.text.trim(),
      );
      Navigator.pop(context, updated);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lengkapi semua pilihan terlebih dahulu'),
          backgroundColor: Colors.blueAccent,
        ),
      );
    }
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
        title: const Text('Edit Booking', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(height: 2, color: Colors.blueAccent),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info badge
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.edit_note, color: Colors.blueAccent, size: 18),
                    SizedBox(width: 10),
                    Text('Mode Edit — Ubah data booking', style: TextStyle(color: Colors.blueAccent, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _sectionLabel('Pilih Film', Colors.blueAccent),
              const SizedBox(height: 12),
              _buildDropdown(
                value: _selectedFilm,
                hint: 'Pilih Film',
                icon: Icons.movie_outlined,
                items: daftarFilm,
                onChanged: _onFilmChanged,
                accentColor: Colors.blueAccent,
              ),

              const SizedBox(height: 20),

              _sectionLabel('Pilih Jadwal', Colors.blueAccent),
              const SizedBox(height: 12),
              _buildDropdown(
                value: _jadwalList.contains(_selectedJadwal) ? _selectedJadwal : null,
                hint: _selectedFilm == null ? 'Pilih film dahulu' : 'Pilih Jadwal',
                icon: Icons.schedule_outlined,
                items: _jadwalList,
                onChanged: _selectedFilm != null ? _onJadwalChanged : null,
                accentColor: Colors.blueAccent,
              ),

              if (_selectedStudio != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.theaters_outlined, color: Colors.blueAccent, size: 18),
                      const SizedBox(width: 10),
                      Expanded(child: Text(_selectedStudio!, style: const TextStyle(color: Colors.white70, fontSize: 13))),
                      Text(formatHarga(_harga), style: const TextStyle(color: Colors.blueAccent, fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),

              _sectionLabel('Pilih Kursi', Colors.blueAccent),
              const SizedBox(height: 12),
              _buildDropdown(
                value: _kursiList.contains(_selectedKursi) ? _selectedKursi : null,
                hint: _selectedJadwal == null ? 'Pilih jadwal dahulu' : 'Pilih Kursi',
                icon: Icons.event_seat_outlined,
                items: _kursiList,
                onChanged: _selectedJadwal != null ? (v) => setState(() => _selectedKursi = v) : null,
                accentColor: Colors.blueAccent,
              ),

              const SizedBox(height: 24),

              _sectionLabel('Data Pemesan', Colors.blueAccent),
              const SizedBox(height: 12),
              _buildTextField(controller: _namaController, label: 'Nama Lengkap', icon: Icons.person_outline,
                  validator: (v) => v!.isEmpty ? 'Nama wajib diisi' : null),
              const SizedBox(height: 14),
              _buildTextField(controller: _hpController, label: 'Nomor HP', icon: Icons.phone_outlined,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v!.isEmpty) return 'Nomor HP wajib diisi';
                    if (!RegExp(r'^\d+$').hasMatch(v)) return 'Nomor HP hanya boleh angka';
                    if (v.length < 10 || v.length > 13) return 'Nomor HP harus 10-13 digit';
                    return null;
                  }),
              const SizedBox(height: 14),
              _buildTextField(controller: _emailController, label: 'Email', icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v!.isEmpty) return 'Email wajib diisi';
                    if (!v.endsWith('@gmail.com')) return 'Email harus berformat @gmail.com';
                    if (v.trim() == '@gmail.com') return 'Email tidak boleh kosong sebelum @gmail.com';
                    return null;
                  }),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 6,
                  ),
                  child: const Text('Simpan Perubahan',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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
    required Color accentColor,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: const Color(0xFF1A1A2E),
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: Icon(icon, color: accentColor, size: 20),
        filled: true,
        fillColor: const Color(0xFF1A1A2E),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white12)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: accentColor, width: 1.5)),
        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white10)),
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
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white12)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.redAccent)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),
    );
  }
}