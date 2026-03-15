import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/supabase_config.dart';
import '../data/dummy_data.dart';
import '../providers/theme_provider.dart';

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
  bool _isLoading = false;

  List<String> get _jadwalList => _selectedFilm != null ? (jadwalPerFilm[_selectedFilm] ?? []) : [];
  List<String> get _kursiList => _selectedStudio != null ? (kursiPerStudio[_selectedStudio] ?? []) : [];

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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedFilm == null || _selectedJadwal == null || _selectedKursi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua pilihan terlebih dahulu'), backgroundColor: Color(0xFFE94560)),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final userId = SupabaseConfig.client.auth.currentUser!.id;
      await SupabaseConfig.client.from('bookings').insert({
        'nama_film': _selectedFilm,
        'jadwal': _selectedJadwal,
        'studio': _selectedStudio,
        'kursi': _selectedKursi,
        'harga': _harga,
        'nama_pemesan': _namaController.text.trim(),
        'no_hp': _hpController.text.trim(),
        'email': _emailController.text.trim(),
        'user_id': userId,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking berhasil disimpan!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final bgColor = isDark ? const Color(0xFF0D0D1A) : const Color(0xFFF5F5F5);
    final cardColor = isDark ? const Color(0xFF1A1A2E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor = isDark ? Colors.white54 : Colors.black45;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Booking Baru', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(2), child: Container(height: 2, color: const Color(0xFFE94560))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionLabel('Pilih Film', const Color(0xFFE94560), textColor),
              const SizedBox(height: 12),
              _buildDropdown(value: _selectedFilm, hint: 'Pilih Film', icon: Icons.movie_outlined,
                  items: daftarFilm, onChanged: _onFilmChanged, cardColor: cardColor, textColor: textColor),

              const SizedBox(height: 20),
              _sectionLabel('Pilih Jadwal', const Color(0xFFE94560), textColor),
              const SizedBox(height: 12),
              _buildDropdown(
                  value: _selectedJadwal,
                  hint: _selectedFilm == null ? 'Pilih film dahulu' : 'Pilih Jadwal',
                  icon: Icons.schedule_outlined,
                  items: _jadwalList,
                  onChanged: _selectedFilm != null ? _onJadwalChanged : null,
                  cardColor: cardColor,
                  textColor: textColor),

              if (_selectedStudio != null) ...[
                const SizedBox(height: 12),
                _studioHargaInfo(_selectedStudio!, _harga, cardColor, textColor),
              ],

              const SizedBox(height: 20),
              _sectionLabel('Pilih Kursi', const Color(0xFFE94560), textColor),
              const SizedBox(height: 12),
              _buildDropdown(
                  value: _selectedKursi,
                  hint: _selectedJadwal == null ? 'Pilih jadwal dahulu' : 'Pilih Kursi',
                  icon: Icons.event_seat_outlined,
                  items: _kursiList,
                  onChanged: _selectedJadwal != null ? (v) => setState(() => _selectedKursi = v) : null,
                  cardColor: cardColor,
                  textColor: textColor),

              const SizedBox(height: 24),
              _sectionLabel('Data Pemesan', Colors.blueAccent, textColor),
              const SizedBox(height: 12),
              _buildTextField(controller: _namaController, label: 'Nama Lengkap', icon: Icons.person_outline,
                  cardColor: cardColor, textColor: textColor, subColor: subColor,
                  accentColor: Colors.blueAccent,
                  validator: (v) => v!.isEmpty ? 'Nama wajib diisi' : null),
              const SizedBox(height: 14),
              _buildTextField(
                  controller: _hpController, label: 'Nomor HP', icon: Icons.phone_outlined,
                  cardColor: cardColor, textColor: textColor, subColor: subColor,
                  accentColor: Colors.blueAccent,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v!.isEmpty) return 'Nomor HP wajib diisi';
                    if (!RegExp(r'^\d+$').hasMatch(v)) return 'Nomor HP hanya boleh angka';
                    if (v.length < 10 || v.length > 13) return 'Nomor HP harus 10-13 digit';
                    return null;
                  }),
              const SizedBox(height: 14),
              _buildTextField(
                  controller: _emailController, label: 'Email', icon: Icons.email_outlined,
                  cardColor: cardColor, textColor: textColor, subColor: subColor,
                  accentColor: Colors.blueAccent,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v!.isEmpty) return 'Email wajib diisi';
                    if (!v.endsWith('@gmail.com')) return 'Email harus berformat @gmail.com';
                    if (v.trim() == '@gmail.com') return 'Email tidak valid';
                    return null;
                  }),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE94560),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 6,
                  ),
                  child: _isLoading
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Konfirmasi Booking', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text, Color accent, Color textColor) {
    return Row(
      children: [
        Container(width: 4, height: 18, decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 10),
        Text(text, style: TextStyle(color: textColor, fontSize: 15, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _studioHargaInfo(String studio, int harga, Color cardColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE94560).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.theaters_outlined, color: Color(0xFFE94560), size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(studio, style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 13))),
          Text(formatHarga(harga), style: const TextStyle(color: Color(0xFFE94560), fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
    required Color cardColor,
    required Color textColor,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: cardColor,
      style: TextStyle(color: textColor, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: textColor.withOpacity(0.3)),
        prefixIcon: Icon(icon, color: const Color(0xFFE94560), size: 20),
        filled: true,
        fillColor: cardColor,
      ),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color cardColor,
    required Color textColor,
    required Color subColor,
    required Color accentColor,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: subColor),
        prefixIcon: Icon(icon, color: accentColor, size: 20),
        filled: true,
        fillColor: cardColor,
      ),
    );
  }
}