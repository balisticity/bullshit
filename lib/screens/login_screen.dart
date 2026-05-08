import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/auth_service.dart';
import '../widgets/gravity_text_field.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'main_shell.dart';

const double logoTop = 120;
const double logoLeft = 28;
const double logoRight = 28;
const double welcomeTop = 210;
const double welcomeLeft = 28;
const double welcomeRight = 28;
const double emailTop = 270;
const double emailLeft = 28;
const double emailRight = 28;
const double passwordTop = 330;
const double passwordLeft = 28;
const double passwordRight = 28;
const double forgotTop = 390;
const double forgotRight = 28;
const double buttonTop = 430;
const double buttonLeft = 28;
const double buttonRight = 28;
const double signupTop = 500;
const double privacyBottom = 40;
const double logoFontSize = 44;
const double welcomeFontSize = 22;
const double buttonFontSize = 16;
const double forgotFontSize = 13;
const double signupFontSize = 14;
const double privacyFontSize = 13;
const double buttonHeight = 52;
const double buttonBorderRadius = 10;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill in all fields.', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    final account = await AuthService.login(email: email, password: password);
    setState(() => _isLoading = false);

    if (account != null) {
      if (mounted) {
        // Save logged-in user into AppProvider so any screen can read it
        context.read<AppProvider>().setCurrentUser(
          email: account['email'] as String,
          name: account['fullName'] as String,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainShell()),
        );
      }
    } else {
      _showSnackBar('Invalid email or password.', isError: true);
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
            Positioned(
              top: welcomeTop,
              left: welcomeLeft,
              right: welcomeRight,
              child: Text(
                'Welcome Back!',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: welcomeFontSize,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            Positioned(
              top: emailTop,
              left: emailLeft,
              right: emailRight,
              child: GravityTextField(
                controller: _emailController,
                hintText: 'Email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Positioned(
              top: passwordTop,
              left: passwordLeft,
              right: passwordRight,
              child: GravityTextField(
                controller: _passwordController,
                hintText: 'Password',
                prefixIcon: Icons.lock_outline,
                obscureText: true,
              ),
            ),
            Positioned(
              top: forgotTop,
              right: forgotRight,
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ForgotPasswordScreen(),
                  ),
                ),
                child: Text(
                  'Forgot your password?',
                  style: GoogleFonts.dmSans(
                    fontSize: forgotFontSize,
                    color: Colors.black54,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.black54,
                  ),
                ),
              ),
            ),
            Positioned(
              top: buttonTop,
              left: buttonLeft,
              right: buttonRight,
              child: SizedBox(
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signIn,
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
                          'Sign in',
                          style: GoogleFonts.dmSans(
                            fontSize: buttonFontSize,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                ),
              ),
            ),
            Positioned(
              top: signupTop,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: GoogleFonts.dmSans(
                      fontSize: signupFontSize,
                      color: Colors.black45,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    ),
                    child: Text(
                      'Sign up',
                      style: GoogleFonts.dmSans(
                        fontSize: signupFontSize,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
