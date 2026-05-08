import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

// Root app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

// Splash screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> slideIn;
  late Animation<double> lineWidth;

  @override
  void initState() {
    super.initState();

    // Controls intro animation
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Slide in animation
    slideIn = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    // Underline animation (line grows)
    lineWidth = Tween<double>(
      begin: 0,
      end: 260, // adjust line length here
    ).animate(controller);

    controller.forward();

    // Wait then navigate
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (_, _, _) => const NextScreen(),
            transitionsBuilder: (_, animation, _, child) {
              // LEFT swipe transition
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SlideTransition(
          position: slideIn,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TEXT with Google Font
              Text(
                "GRAVITY",
                style: GoogleFonts.holtwoodOneSc(
                  fontSize: 40,
                  color: Colors.black,
                  letterSpacing: 3,
                ),
              ),

              const SizedBox(height: 8),

              // Animated underline
              AnimatedBuilder(
                animation: lineWidth,
                builder: (context, child) {
                  return Container(
                    height: 2,
                    width: lineWidth.value,
                    color: Colors.black,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Next screen
class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Home Screen", style: TextStyle(fontSize: 24))),
    );
  }
}
