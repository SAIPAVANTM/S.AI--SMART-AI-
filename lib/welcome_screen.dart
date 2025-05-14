import 'package:flutter/material.dart';
import 'package:sai/login_screen.dart';
import 'package:sai/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0), // generous horizontal padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/logo.png',
                  width: 180,
                ),
                const SizedBox(height: 40),

                // Title
                const Text(
                  'WELCOME TO\nSMART AI',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFAAAAAA),
                    letterSpacing: 2.0, // Increased letter spacing
                  ),
                ),
                const SizedBox(height: 12),

                // Tagline
                const Text(
                  'Empowering Minds',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF888888),
                  ),
                ),
                const SizedBox(height: 50),

                // Log In button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF2C2C2C),
                      foregroundColor: const Color(0xFFAAAAAA), // Grey text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      // Navigate to sign up screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                      ),);
                    },
                    child: const Text('Log In'),
                  ),
                ),
                const SizedBox(height: 16),

                // Sign Up button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF2C2C2C),
                      foregroundColor: const Color(0xFFAAAAAA), // Grey text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      // Navigate to sign up screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text('Sign Up'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}