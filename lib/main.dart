import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart'; // ← adjust path if yours differs
import 'next_screen.dart';

// ─── FIX: wrap the entire app with MultiProvider so that AppProvider
//     is available to every route, including MainShell and its children.
void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AppProvider())],
      child: const MyApp(),
    ),
  );
}

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

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  late final Animation<double> _opacity = Tween<double>(
    begin: 0,
    end: 1,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  late final Animation<double> _lineWidth = Tween<double>(
    begin: 0,
    end: 260,
  ).animate(_controller);

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const NextScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return Stack(
              children: [
                SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset.zero,
                    end: const Offset(-1, 0),
                  ).animate(animation),
                  child: const _StaticSplash(),
                ),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ],
            );
          },
        ),
      );
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
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _opacity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "GRAVITY",
                style: GoogleFonts.getFont(
                  'Holtwood One SC',
                  fontSize: 48,
                  height: 1,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedBuilder(
                animation: _lineWidth,
                builder: (context, child) => Container(
                  height: 2,
                  width: _lineWidth.value,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Extracted static widget used during the slide-out transition so we
// don't reference animation controllers that may already be disposed.
class _StaticSplash extends StatelessWidget {
  const _StaticSplash();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "GRAVITY",
              style: GoogleFonts.getFont(
                'Holtwood One SC',
                fontSize: 48,
                height: 1,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Container(height: 2, width: 260, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
