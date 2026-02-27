import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../data/dummy_data.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const BookingCard({
    Key? key,
    required this.booking,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE94560).withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE94560).withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: judul film + studio
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking.namaFilm,
                    style: const TextStyle(
                      color: Color(0xFFE94560),
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE94560).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE94560).withOpacity(0.4)),
                  ),
                  child: Text(
                    booking.studio,
                    style: const TextStyle(color: Color(0xFFE94560), fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _infoRow(Icons.person_outline, booking.namaPemesan),
            const SizedBox(height: 5),
            _infoRow(Icons.schedule_outlined, booking.jadwal),
            const SizedBox(height: 5),
            _infoRow(Icons.event_seat_outlined, 'Kursi ${booking.kursi}'),
            const SizedBox(height: 5),
            _infoRow(Icons.phone_outlined, booking.noHp),
            const SizedBox(height: 5),
            _infoRow(Icons.local_activity_outlined, formatHarga(booking.harga)),
            const SizedBox(height: 14),
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _actionBtn(
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  color: Colors.blueAccent,
                  onTap: onEdit,
                ),
                const SizedBox(width: 10),
                _actionBtn(
                  icon: Icons.delete_outline,
                  label: 'Hapus',
                  color: const Color(0xFFE94560),
                  onTap: () => _confirmDelete(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white38, size: 15),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 13), overflow: TextOverflow.ellipsis),
        ),
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
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: const Color(0xFFE94560).withOpacity(0.4)),
        ),
        title: const Text('Hapus Booking?', style: TextStyle(color: Colors.white)),
        content: Text(
          'Yakin ingin menghapus booking "${booking.namaFilm}" atas nama ${booking.namaPemesan}?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.white54)),
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