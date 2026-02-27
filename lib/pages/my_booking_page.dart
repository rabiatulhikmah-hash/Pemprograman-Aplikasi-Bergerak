import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../widgets/booking_card.dart';
import '../data/dummy_data.dart';
import 'edit_booking_page.dart';

class MyBookingPage extends StatefulWidget {
  final List<Booking> bookings;
  final Function(String) onDelete;
  final Function(Booking) onUpdate;

  const MyBookingPage({
    Key? key,
    required this.bookings,
    required this.onDelete,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<MyBookingPage> createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage> {
  void _navigateToEdit(Booking booking) async {
    final result = await Navigator.push<Booking>(
      context,
      MaterialPageRoute(builder: (_) => EditBookingPage(booking: booking)),
    );
    if (result != null) {
      widget.onUpdate(result);
      setState(() {});
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
        title: const Text('Booking Saya', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(height: 2, color: Colors.blueAccent),
        ),
      ),
      body: widget.bookings.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.confirmation_number_outlined, size: 72, color: Colors.white12),
                  SizedBox(height: 16),
                  Text('Belum ada booking', style: TextStyle(color: Colors.white38, fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Kembali ke Home untuk membuat booking', style: TextStyle(color: Colors.white24, fontSize: 13)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: widget.bookings.length,
              itemBuilder: (context, index) {
                final booking = widget.bookings[index];
                return BookingCard(
                  booking: booking,
                  onDelete: () {
                    widget.onDelete(booking.id);
                    setState(() {});
                  },
                  onEdit: () => _navigateToEdit(booking),
                );
              },
            ),
    );
  }
}