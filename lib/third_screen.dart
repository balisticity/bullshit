import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'fouth_screen.dart';

class ThirdScreen extends StatelessWidget {
  const ThirdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // BACKGROUND WAVES
            Positioned.fill(
              child: Image.asset('assets/waves.png', fit: BoxFit.cover),
            ),

            // TEXT
            Positioned(
              top: 75,
              left: 24,
              right: 24,
              child: Text(
                "Simple fits,\nstrong\nvibe.",
                style: GoogleFonts.geologica(
                  fontSize: 38,
                  height: 1.2,
                  color: Colors.black,
                ),
              ),
            ),

            // IMAGE
            Positioned(
              bottom: 0,
              right: 70,
              left: 130,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.80,
                width: MediaQuery.of(context).size.width * 0.93,
                child: Image.asset(
                  'assets/renzil.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),

            // BUTTON
            Positioned(
              bottom: 65,
              left: 45,
              right: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      // FIX: unique parameter names instead of duplicate `_`
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const FourthScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            final tween = Tween(
                              begin: begin,
                              end: end,
                            ).chain(CurveTween(curve: Curves.ease));
                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Next",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 35),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
