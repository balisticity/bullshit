import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/auth_service.dart';
import '../helpers/avatar_helper.dart';
import 'login_screen.dart';
import 'address_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final name = provider.currentUserName.isNotEmpty
        ? provider.currentUserName
        : 'Guest';
    final bio = provider.currentUserBio.isNotEmpty
        ? provider.currentUserBio
        : 'No Bio';

    String locationDisplay = 'Set Now';
    if (provider.city.isNotEmpty) {
      locationDisplay = provider.city;
    } else if (provider.location.isNotEmpty) {
      locationDisplay = provider.location;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 28),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          'Account',
          style: GoogleFonts.dmSans(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFEEEEEE), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 28),

            // ── Avatar + pencil ──────────────────────────────────────────
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black26, width: 2),
                    ),
                    child: ClipOval(
                      child: buildAvatar(provider.avatarIndex, size: 90),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _showAvatarPicker(context, provider),
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black26),
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            Text(
              name,
              style: GoogleFonts.dmSans(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              bio,
              style: GoogleFonts.dmSans(fontSize: 13, color: Colors.black45),
            ),

            const SizedBox(height: 28),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),

            // ── Menu tiles ───────────────────────────────────────────────
            _tile(
              label: 'Name',
              value: name,
              onTap: () => _showEditFieldSheet(
                context: context,
                title: 'Edit Name',
                hint: 'Full name',
                icon: Icons.person_outline,
                current: provider.currentUserName,
                onSave: (val) {
                  if (val.isNotEmpty) provider.setCurrentUserName(val);
                },
              ),
            ),
            _divider(),

            _tile(
              label: 'Bio',
              value: provider.currentUserBio.isNotEmpty
                  ? provider.currentUserBio
                  : 'Set Now',
              onTap: () => _showEditFieldSheet(
                context: context,
                title: 'Edit Bio',
                hint: 'Tell something about yourself',
                icon: Icons.info_outline,
                current: provider.currentUserBio,
                maxLines: 3,
                onSave: (val) => provider.setBio(val),
              ),
            ),
            _divider(),

            _tile(
              label: 'Payment Method',
              value: provider.paymentMethod.isNotEmpty
                  ? provider.paymentMethod
                  : 'Set Now',
              onTap: () => _showEditFieldSheet(
                context: context,
                title: 'Payment Method',
                hint: 'e.g. GCash, Credit Card',
                icon: Icons.payment_outlined,
                current: provider.paymentMethod,
                onSave: (val) => provider.setPaymentMethod(val),
              ),
            ),
            _divider(),

            // ── Location → goes to AddressScreen ────────────────────────
            _tile(
              label: 'Location',
              value: locationDisplay,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const AddressScreen(mode: AddressScreenMode.fromAccount),
                ),
              ),
            ),
            _divider(),

            _tile(
              label: 'Phone',
              value: provider.phone.isNotEmpty ? provider.phone : 'Set Now',
              onTap: () => _showEditFieldSheet(
                context: context,
                title: 'Phone',
                hint: 'e.g. 09123456789',
                icon: Icons.phone_outlined,
                current: provider.phone,
                keyboardType: TextInputType.phone,
                onSave: (val) => provider.setPhone(val),
              ),
            ),
            _divider(),

            _tile(
              label: 'Change Password',
              value: 'Set Now',
              onTap: () => _showChangePasswordSheet(context, provider),
            ),

            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 8),

            // ── Logout ───────────────────────────────────────────────────
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 2,
              ),
              leading: const Icon(Icons.logout, color: Colors.red, size: 20),
              title: Text(
                'Logout',
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
              onTap: () => _confirmLogout(context, provider),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ── Avatar picker ──────────────────────────────────────────────────────────
  void _showAvatarPicker(BuildContext context, AppProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sheetHandle(),
            const SizedBox(height: 16),
            Text(
              'Choose your avatar',
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: kAvatarPresets.length,
              itemBuilder: (_, i) {
                final selected = i == provider.avatarIndex;
                return GestureDetector(
                  onTap: () {
                    provider.setAvatarIndex(i);
                    Navigator.pop(sheetCtx);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected ? Colors.black : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: buildAvatar(i, size: 52),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _tile({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      title: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: GoogleFonts.dmSans(fontSize: 14, color: Colors.black45),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Colors.black38, size: 20),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _divider() =>
      const Divider(height: 1, color: Color(0xFFEEEEEE), indent: 20);

  void _showEditFieldSheet({
    required BuildContext context,
    required String title,
    required String hint,
    required IconData icon,
    required String current,
    required void Function(String) onSave,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    final ctrl = TextEditingController(text: current);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sheetHandle(),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            _fieldInput(
              controller: ctrl,
              hint: hint,
              icon: icon,
              maxLines: maxLines,
              keyboardType: keyboardType,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  onSave(ctrl.text.trim());
                  Navigator.pop(sheetCtx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Save',
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordSheet(BuildContext context, AppProvider provider) {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sheetHandle(),
            const SizedBox(height: 16),
            Text(
              'Change Password',
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            _fieldInput(
              controller: currentCtrl,
              hint: 'Current password',
              icon: Icons.lock_outline,
              obscure: true,
            ),
            const SizedBox(height: 12),
            _fieldInput(
              controller: newCtrl,
              hint: 'New password',
              icon: Icons.lock_outline,
              obscure: true,
            ),
            const SizedBox(height: 12),
            _fieldInput(
              controller: confirmCtrl,
              hint: 'Confirm new password',
              icon: Icons.lock_outline,
              obscure: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () async {
                  final current = currentCtrl.text.trim();
                  final newPass = newCtrl.text.trim();
                  final confirm = confirmCtrl.text.trim();
                  if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
                    _snack(sheetCtx, 'Please fill in all fields.');
                    return;
                  }
                  if (newPass.length < 6) {
                    _snack(sheetCtx, 'Password must be at least 6 characters.');
                    return;
                  }
                  if (newPass != confirm) {
                    _snack(sheetCtx, 'Passwords do not match.');
                    return;
                  }
                  final account = await AuthService.login(
                    email: provider.currentUserEmail,
                    password: current,
                  );
                  if (account == null) {
                    if (!sheetCtx.mounted) return;
                    _snack(sheetCtx, 'Current password is incorrect.');
                    return;
                  }
                  await AuthService.resetPassword(
                    email: provider.currentUserEmail,
                    newPassword: newPass,
                  );
                  if (!sheetCtx.mounted) return;
                  Navigator.pop(sheetCtx);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Password changed!',
                        style: GoogleFonts.dmSans(color: Colors.white),
                      ),
                      backgroundColor: Colors.black,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Save',
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(
          'Logout',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.dmSans(fontSize: 14, color: Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.dmSans(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              provider.clearCurrentUser();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: Text(
              'Logout',
              style: GoogleFonts.dmSans(
                color: Colors.red,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sheetHandle() => Center(
    child: Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );

  Widget _fieldInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 1.2),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: GoogleFonts.dmSans(fontSize: 15, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.dmSans(fontSize: 15, color: Colors.black38),
          prefixIcon: Icon(icon, color: Colors.black, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.dmSans(color: Colors.white)),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
