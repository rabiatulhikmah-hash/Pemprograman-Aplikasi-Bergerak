import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../providers/theme_provider.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await SupabaseConfig.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE94560).withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.movie_outlined, color: Color(0xFFE94560), size: 40),
                      ),
                      const SizedBox(height: 16),
                      Text('CineBook', style: TextStyle(color: textColor, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                      const SizedBox(height: 4),
                      Text('BOOKING TIKET BIOSKOP', style: TextStyle(color: const Color(0xFFE94560), fontSize: 11, letterSpacing: 3)),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Text('Masuk', style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Silakan login untuk melanjutkan', style: TextStyle(color: subColor, fontSize: 13)),
                const SizedBox(height: 28),

                // Email
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  cardColor: cardColor,
                  isDark: isDark,
                  validator: (v) {
                    if (v!.isEmpty) return 'Email wajib diisi';
                    if (!v.contains('@')) return 'Format email tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: TextStyle(color: textColor),
                  validator: (v) => v!.isEmpty ? 'Password wajib diisi' : null,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline, color: const Color(0xFFE94560), size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: subColor, size: 20),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    filled: true,
                    fillColor: cardColor,
                  ),
                ),
                const SizedBox(height: 32),

                // Tombol Login
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE94560),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 6,
                    ),
                    child: _isLoading
                        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Masuk', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),

                // Link ke Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Belum punya akun? ', style: TextStyle(color: subColor)),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage())),
                      child: const Text('Daftar', style: TextStyle(color: Color(0xFFE94560), fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),

                // Toggle Theme
                const SizedBox(height: 24),
                Center(
                  child: Consumer<ThemeProvider>(
                    builder: (ctx, theme, _) => GestureDetector(
                      onTap: theme.toggleTheme,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(theme.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                              color: subColor, size: 18),
                          const SizedBox(width: 6),
                          Text(theme.isDarkMode ? 'Light Mode' : 'Dark Mode',
                              style: TextStyle(color: subColor, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color cardColor,
    required bool isDark,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final textColor = isDark ? Colors.white : Colors.black87;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFE94560), size: 20),
        filled: true,
        fillColor: cardColor,
      ),
    );
  }
}