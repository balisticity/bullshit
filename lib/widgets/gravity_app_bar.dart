import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../screens/search_screen.dart';
import '../screens/notification_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/message_screen.dart';

class GravityAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;
  final bool showMessage; // show message icon instead of search

  const GravityAppBar({
    super.key,
    this.showBack = false,
    this.showMessage = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: showBack
          ? IconButton(
              icon: const Icon(
                Icons.chevron_left,
                color: Colors.black,
                size: 28,
              ),
              onPressed: () => Navigator.pop(context),
            )
          : IconButton(
              icon: showMessage
                  ? const Icon(Icons.chat_bubble_outline, color: Colors.black)
                  : const Icon(Icons.search, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => showMessage
                        ? const MessageScreen()
                        : const SearchScreen(),
                  ),
                );
              },
            ),
      title: Text(
        'GRAVITY',
        style: GoogleFonts.getFont(
          'Holtwood One SC',
          fontSize: 25,
          color: Colors.black,
          letterSpacing: 0,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationScreen()),
            );
          },
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
            ),
            if (provider.cartCount > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${provider.cartCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 9),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
