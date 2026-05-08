import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../widgets/gravity_text_field.dart';
import 'login_screen.dart';

// ============================================================
//   POSITION ADJUSTERS — just like CSS top/left/right/bottom
// ============================================================

// --- GRAVITY Logo ---
const double logoTop = 100; // distance from top
const double logoLeft = 28;
const double logoRight = 28;

// --- Underline below GRAVITY ---
const double lineTop = 152; // distance from top
const double lineWidth = 240; // width of line
const double lineHeight = 1.5; // thickness of line

// --- "Style that pulls them in." ---
const double taglineTop = 155; // distance from top
const double taglineLeft = 28;
const double taglineRight = 28;

// --- "Create your account." ---
const double headingTop = 200; // distance from top
const double headingLeft = 28;
const double headingRight = 28;

// --- Full Name Field ---
const double nameTop = 250; // distance from top
const double nameLeft = 28;
const double nameRight = 28;

// --- Email Field ---
const double emailTop = 330; // distance from top
const double emailLeft = 28;
const double emailRight = 28;

// --- Password Field ---
const double passwordTop = 410; // distance from top
const double passwordLeft = 28;
const double passwordRight = 28;

// --- Sign Up Button ---
const double buttonTop = 490; // distance from top
const double buttonLeft = 28;
const double buttonRight = 28;

// --- Already have an account? ---
const double signinTop = 570; // distance from top

// --- Privacy & Terms ---
const double privacyBottom = 40; // distance from bottom

// --- Font Sizes ---
const double logoFontSize = 42;
const double taglineFontSize = 13;
const double headingFontSize = 22;
const double buttonFontSize = 16;
const double signinFontSize = 14;
const double privacyFontSize = 13;

// --- Button ---
const double buttonHeight = 52;
const double buttonBorderRadius = 10;

// ============================================================

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill in all fields.', isError: true);
      return;
    }
    if (!email.contains('@') || !email.contains('.')) {
      _showSnackBar('Please enter a valid email address.', isError: true);
      return;
    }
    if (password.length < 6) {
      _showSnackBar('Password must be at least 6 characters.', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final result = await AuthService.register(
      fullName: fullName,
      email: email,
      password: password,
    );

    setState(() => _isLoading = false);

    switch (result) {
      case RegisterResult.success:
        _showSnackBar('Account created successfully!');
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
        break;
      case RegisterResult.emailAlreadyExists:
        _showSnackBar('This email is already registered.', isError: true);
        break;
      case RegisterResult.error:
        _showSnackBar('Something went wrong. Please try again.', isError: true);
        break;
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.dmSans(color: Colors.white)),
        backgroundColor: isError ? Colors.red.shade700 : Colors.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Stack(
          children: [
            // ── GRAVITY Logo ──────────────────────────────────
            Positioned(
              top: logoTop,
              left: logoLeft,
              right: logoRight,
              child: Text(
                'GRAVITY',
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont(
                  'Holtwood One SC',
                  fontSize: logoFontSize,
                  color: Colors.black,
                ),
              ),
            ),

            // ── Underline ─────────────────────────────────────
            Positioned(
              top: lineTop,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: lineWidth,
                  height: lineHeight,
                  color: Colors.black,
                ),
              ),
            ),

            // ── Tagline ───────────────────────────────────────
            Positioned(
              top: taglineTop,
              left: taglineLeft,
              right: taglineRight,
              child: Text(
                'Style that pulls them in.',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: taglineFontSize,
                  color: Colors.black,
                  letterSpacing: 0.3,
                ),
              ),
            ),

            // ── Create your account. ──────────────────────────
            Positioned(
              top: headingTop,
              left: headingLeft,
              right: headingRight,
              child: Text(
                'Create your account.',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: headingFontSize,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),

            // ── Full Name Field ───────────────────────────────
            Positioned(
              top: nameTop,
              left: nameLeft,
              right: nameRight,
              child: GravityTextField(
                controller: _fullNameController,
                hintText: 'Enter your full name',
                prefixIcon: Icons.person_outline,
              ),
            ),

            // ── Email Field ───────────────────────────────────
            Positioned(
              top: emailTop,
              left: emailLeft,
              right: emailRight,
              child: GravityTextField(
                controller: _emailController,
                hintText: 'Enter your email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
            ),

            // ── Password Field ────────────────────────────────
            Positioned(
              top: passwordTop,
              left: passwordLeft,
              right: passwordRight,
              child: GravityTextField(
                controller: _passwordController,
                hintText: 'Enter your password',
                prefixIcon: Icons.lock_outline,
                obscureText: true,
              ),
            ),

            // ── Sign Up Button ────────────────────────────────
            Positioned(
              top: buttonTop,
              left: buttonLeft,
              right: buttonRight,
              child: SizedBox(
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(buttonBorderRadius),
                    ),
                    disabledBackgroundColor: Colors.black54,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'Sign up',
                          style: GoogleFonts.dmSans(
                            fontSize: buttonFontSize,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                ),
              ),
            ),

            // ── Already have an account? ──────────────────────
            Positioned(
              top: signinTop,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: GoogleFonts.dmSans(
                      fontSize: signinFontSize,
                      color: Colors.black45,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: Text(
                      'Sign in',
                      style: GoogleFonts.dmSans(
                        fontSize: signinFontSize,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Privacy & Terms ───────────────────────────────
            Positioned(
              bottom: privacyBottom,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Privacy',
                      style: GoogleFonts.dmSans(
                        fontSize: privacyFontSize,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Terms',
                      style: GoogleFonts.dmSans(
                        fontSize: privacyFontSize,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
