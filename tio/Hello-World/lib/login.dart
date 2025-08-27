import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFFAF6EA),
      body: Stack(
        children: [
          // --- Background Image ---
          SizedBox(
            child: Image.asset(
              'assets/images/loginbg.png', // Change to your background image
              fit: BoxFit.cover,
            ),
          ),

          // --- Foreground content ---
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo
                    // SizedBox(
                    //   height: 100,
                    //   width: 100,
                    //   child: Image.asset(
                    //     'assets/images/welcome.png',
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    const SizedBox(height: 20),

                    const Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF603B17),
                      ),
                    ),
                    const SizedBox(height: 30),

                    _buildInputField(
                      label: 'Email',
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      label: 'Password',
                      icon: Icons.lock_outlined,
                      isPassword: true,
                    ),
                    const SizedBox(height: 30),

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE27D19),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          // Handle login action
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // RichText
                    RichText(
                      text: TextSpan(
                        text: 'Don’t have an account? ',
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          color: const Color(0xFF603B17),
                        ),
                        children: [
                          TextSpan(
                            text: 'Create account here',
                            style: GoogleFonts.quicksand(
                              fontSize: 14,
                              color: const Color(0xFFE27D19),
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper for input fields ---
  Widget _buildInputField({
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFCF9F2),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
              color: Color(0x19B8B8B8), blurRadius: 2, offset: Offset(0, 1)),
          BoxShadow(
              color: Color(0x16B8B8B8), blurRadius: 4, offset: Offset(0, 4)),
          BoxShadow(
              color: Color(0x0CB8B8B8), blurRadius: 5, offset: Offset(0, 8)),
          BoxShadow(
              color: Color(0x02B8B8B8), blurRadius: 6, offset: Offset(0, 14)),
          BoxShadow(
              color: Color(0x00B8B8B8), blurRadius: 6, offset: Offset(0, 22)),
        ],
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFFD4D0C2),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFFD4D0C2),
            size: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        ),
      ),
    );
  }
}
