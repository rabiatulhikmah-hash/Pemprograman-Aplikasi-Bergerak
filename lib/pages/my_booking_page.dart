import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/supabase_config.dart';
import '../models/booking.dart';
import '../providers/theme_provider.dart';
import '../widgets/booking_card.dart';
import 'edit_booking_page.dart';

class MyBookingPage extends StatefulWidget {
  const MyBookingPage({Key? key}) : super(key: key);

  @override
  State<MyBookingPage> createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage> {
  List<Booking> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    setState(() => _isLoading = true);
    try {
      final userId = SupabaseConfig.client.auth.currentUser!.id;
      final response = await SupabaseConfig.client
          .from('bookings')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      setState(() {
        _bookings = (response as List).map((e) => Booking.fromMap(e)).toList();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteBooking(String id) async {
    try {
      await SupabaseConfig.client.from('bookings').delete().eq('id', id);
      setState(() => _bookings.removeWhere((b) => b.id == id));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking berhasil dihapus'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  Future<void> _navigateToEdit(Booking booking) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => EditBookingPage(booking: booking)),
    );
    if (result == true) _fetchBookings();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final bgColor = isDark ? const Color(0xFF0D0D1A) : const Color(0xFFF5F5F5);
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Booking Saya', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(2), child: Container(height: 2, color: Colors.blueAccent)),
        actions: [
          IconButton(
            onPressed: _fetchBookings,
            icon: Icon(Icons.refresh, color: textColor),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFE94560)))
          : _bookings.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.confirmation_number_outlined, size: 72, color: isDark ? Colors.white12 : Colors.black12),
                      const SizedBox(height: 16),
                      Text('Belum ada booking', style: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('Kembali ke Home untuk membuat booking',
                          style: TextStyle(color: isDark ? Colors.white24 : Colors.black26, fontSize: 13)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchBookings,
                  color: const Color(0xFFE94560),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: _bookings.length,
                    itemBuilder: (context, index) {
                      final booking = _bookings[index];
                      return BookingCard(
                        booking: booking,
                        onDelete: () => _deleteBooking(booking.id),
                        onEdit: () => _navigateToEdit(booking),
                      );
                    },
                  ),
                ),
    );
  }
}