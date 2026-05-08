import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';

class AuthService {
  static const String _fileName = 'accounts.json';

  // In-memory store for reset codes: email -> code
  static final Map<String, String> _resetCodes = {};

  // ─── File helpers ────────────────────────────────────────────────────────────

  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  static Future<List<Map<String, dynamic>>> _readAccounts() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      final data = jsonDecode(contents) as Map<String, dynamic>;
      final accounts = data['accounts'] as List<dynamic>;
      return accounts.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> _writeAccounts(
    List<Map<String, dynamic>> accounts,
  ) async {
    final file = await _getFile();
    final data = jsonEncode({'accounts': accounts});
    await file.writeAsString(data);
  }

  // ─── Public API ──────────────────────────────────────────────────────────────

  static Future<RegisterResult> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final accounts = await _readAccounts();
      final emailExists = accounts.any(
        (a) => (a['email'] as String).toLowerCase() == email.toLowerCase(),
      );
      if (emailExists) return RegisterResult.emailAlreadyExists;
      accounts.add({
        'fullName': fullName,
        'email': email.toLowerCase(),
        'password': password,
        'createdAt': DateTime.now().toIso8601String(),
      });
      await _writeAccounts(accounts);
      return RegisterResult.success;
    } catch (e) {
      return RegisterResult.error;
    }
  }

  static Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    try {
      final accounts = await _readAccounts();
      final match = accounts.firstWhere(
        (a) =>
            (a['email'] as String).toLowerCase() == email.toLowerCase() &&
            a['password'] == password,
        orElse: () => {},
      );
      return match.isNotEmpty ? match : null;
    } catch (e) {
      return null;
    }
  }

  /// Checks if email is registered. If yes, generates + stores a 6-digit code
  /// and returns it (in a real app you'd email this; here we return it so the
  /// app can show/simulate it). Returns null if email not found.
  static Future<String?> sendResetCode({required String email}) async {
    final accounts = await _readAccounts();
    final exists = accounts.any(
      (a) => (a['email'] as String).toLowerCase() == email.toLowerCase(),
    );
    if (!exists) return null;

    // Generate a 6-digit code
    final code = (100000 + Random().nextInt(900000)).toString();
    _resetCodes[email.toLowerCase()] = code;
    return code;
  }

  /// Validates the code the user entered.
  static bool verifyResetCode({required String email, required String code}) {
    final stored = _resetCodes[email.toLowerCase()];
    return stored != null && stored == code.trim();
  }

  /// Updates the password for a given email, then clears the reset code.
  static Future<bool> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      final accounts = await _readAccounts();
      final idx = accounts.indexWhere(
        (a) => (a['email'] as String).toLowerCase() == email.toLowerCase(),
      );
      if (idx == -1) return false;
      accounts[idx]['password'] = newPassword;
      await _writeAccounts(accounts);
      _resetCodes.remove(email.toLowerCase());
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<int> accountCount() async {
    final accounts = await _readAccounts();
    return accounts.length;
  }

  static Future<List<Map<String, dynamic>>> getAllAccounts() async {
    return _readAccounts();
  }

  static Future<void> clearAll() async {
    await _writeAccounts([]);
  }
}

enum RegisterResult { success, emailAlreadyExists, error }
