import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static const List<String> _notifications = [
    'Your order #001 has been shipped!',
    'New arrivals: Check out the latest Gravity collection.',
    'Flash sale: 20% off on all Tshirts this weekend.',
    'Your wishlist item "Regular Fit Polo" is back in stock!',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications',
          style: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _notifications.length,
        separatorBuilder: (_, _) =>
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
        itemBuilder: (_, i) => ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          leading: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 18,
            ),
          ),
          title: Text(
            _notifications[i],
            style: GoogleFonts.dmSans(fontSize: 13, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
