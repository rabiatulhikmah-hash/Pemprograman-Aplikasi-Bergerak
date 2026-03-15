import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/supabase_config.dart';
import '../providers/theme_provider.dart';
import 'add_booking_page.dart';
import 'my_booking_page.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    await SupabaseConfig.client.auth.signOut();
    if (context.mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final bgColor = isDark ? const Color(0xFF0D0D1A) : const Color(0xFFF5F5F5);
    final cardColor = isDark ? const Color(0xFF1A1A2E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor = isDark ? Colors.white54 : Colors.black45;

    final user = SupabaseConfig.client.auth.currentUser;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              decoration: BoxDecoration(
                color: cardColor,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('🎬 CineBook', style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                      const SizedBox(height: 2),
                      const Text('BOOKING TIKET BIOSKOP', style: TextStyle(color: Color(0xFFE94560), fontSize: 10, letterSpacing: 3, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  Row(
                    children: [
                      // Toggle theme
                      IconButton(
                        onPressed: themeProvider.toggleTheme,
                        icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined, color: subColor),
                        tooltip: isDark ? 'Light Mode' : 'Dark Mode',
                      ),
                      // Logout
                      IconButton(
                        onPressed: () => _logout(context),
                        icon: const Icon(Icons.logout, color: Color(0xFFE94560)),
                        tooltip: 'Logout',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Greeting
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE94560).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE94560).withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.person_outline, color: Color(0xFFE94560), size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Halo, ${user?.email ?? 'Pengguna'}',
                              style: TextStyle(color: textColor, fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    _menuCard(
                      context: context,
                      icon: Icons.add_circle_outline,
                      title: 'Buat Booking Baru',
                      subtitle: 'Pilih film, jadwal, dan kursi favoritmu',
                      color: const Color(0xFFE94560),
                      cardColor: cardColor,
                      textColor: textColor,
                      subColor: subColor,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddBookingPage())),
                    ),
                    const SizedBox(height: 16),
                    _menuCard(
                      context: context,
                      icon: Icons.confirmation_number_outlined,
                      title: 'Booking Saya',
                      subtitle: 'Lihat dan kelola semua booking',
                      color: Colors.blueAccent,
                      cardColor: cardColor,
                      textColor: textColor,
                      subColor: subColor,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyBookingPage())),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color cardColor,
    required Color textColor,
    required Color subColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: textColor, fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 3),
                  Text(subtitle, style: TextStyle(color: subColor, fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color.withOpacity(0.5), size: 15),
          ],
        ),
      ),
    );
  }
}