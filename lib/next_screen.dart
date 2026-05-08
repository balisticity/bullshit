import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'third_screen.dart';

class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset('assets/waves.png', fit: BoxFit.cover),
            ),
            Positioned(
              top: 75,
              left: 24,
              right: 24,
              child: Text(
                "Defined by\nsimplicity,\ndriven by\nattraction.",
                style: GoogleFonts.geologica(
                  fontSize: 38,
                  height: 1.2,
                  color: Colors.black,
                ),
              ),
            ),
            Positioned(
              bottom: -15,
              right: 0,
              left: 130,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.80,
                width: MediaQuery.of(context).size.width * 0.93,
                child: Image.asset(
                  'assets/john.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            // BUTTON → goes to 3rd screen
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
                          const ThirdScreen(),
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
                    SizedBox(width: 3),
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
