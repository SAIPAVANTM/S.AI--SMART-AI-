import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:sai/welcome_screen.dart';



void main() {
  runApp(const SmartAIApp());
}

class SmartAIApp extends StatelessWidget {
  const SmartAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SAI - Smart AI',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Literata', // Set global font
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Set status bar background color and icon brightness
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    // Start animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Navigate to WelcomeScreen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
        }
      });
    });

  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/logo.png', // Ensure your logo image is here
                width: 180,
              ),
              const SizedBox(height: 40),

              // Title
              const Text(
                'SAI - SMART AI',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFAAAAAA), // Light gray
                ),
              ),

              const SizedBox(height: 10),

              // Tagline
              const Text(
                'Empowering Minds',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF888888), // Medium gray
                ),
              ),

              const SizedBox(height: 50),

              // Custom animated orange loading ring
              SizedBox(
                width: 40,
                height: 40,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: LoadingRingPainter(_controller.value),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Version Text
              const Text(
                'Version 1.0',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF777777), // Gray
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Painter for the orange circular loading ring
class LoadingRingPainter extends CustomPainter {
  final double progress;
  LoadingRingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 4.0;
    final rect = Offset.zero & size;

    final backgroundPaint = Paint()
      ..color = Colors.grey.shade800
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final foregroundPaint = Paint()
      ..shader = SweepGradient(
        startAngle: 0.0,
        endAngle: 2 * pi,
        stops: [progress, progress],
        colors: [
          const Color(0xFFFF6C1A), // Bright orange
          Colors.transparent,
        ],
      ).createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    canvas.drawCircle(center, radius, backgroundPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant LoadingRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
