import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/booking.dart';
import '../data/dummy_data.dart';
import '../providers/theme_provider.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const BookingCard({Key? key, required this.booking, required this.onDelete, required this.onEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final cardColor = isDark ? const Color(0xFF1A1A2E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor = isDark ? Colors.white54 : Colors.black45;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE94560).withOpacity(isDark ? 0.4 : 0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.2 : 0.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(booking.namaFilm,
                      style: const TextStyle(color: Color(0xFFE94560), fontSize: 17, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE94560).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE94560).withOpacity(0.4)),
                  ),
                  child: Text(booking.studio, style: const TextStyle(color: Color(0xFFE94560), fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _infoRow(Icons.person_outline, booking.namaPemesan, subColor, textColor),
            const SizedBox(height: 5),
            _infoRow(Icons.schedule_outlined, booking.jadwal, subColor, textColor),
            const SizedBox(height: 5),
            _infoRow(Icons.event_seat_outlined, 'Kursi ${booking.kursi}', subColor, textColor),
            const SizedBox(height: 5),
            _infoRow(Icons.phone_outlined, booking.noHp, subColor, textColor),
            const SizedBox(height: 5),
            _infoRow(Icons.local_activity_outlined, formatHarga(booking.harga), subColor, textColor),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _actionBtn(icon: Icons.edit_outlined, label: 'Edit', color: Colors.blueAccent, onTap: onEdit),
                const SizedBox(width: 10),
                _actionBtn(icon: Icons.delete_outline, label: 'Hapus', color: const Color(0xFFE94560),
                    onTap: () => _confirmDelete(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, Color iconColor, Color textColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 15),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 13), overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  Widget _actionBtn({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 15),
            const SizedBox(width: 5),
            Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: const Color(0xFFE94560).withOpacity(0.4)),
        ),
        title: Text('Hapus Booking?', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
        content: Text(
          'Yakin ingin menghapus booking "${booking.namaFilm}" atas nama ${booking.namaPemesan}?',
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal', style: TextStyle(color: isDark ? Colors.white54 : Colors.black45)),
          ),
          ElevatedButton(
            onPressed: () { Navigator.pop(ctx); onDelete(); },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE94560)),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}