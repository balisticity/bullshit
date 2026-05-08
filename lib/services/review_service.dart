import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/review.dart';

class ReviewService {
  static const String _fileName = 'reviews.json';

  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  static Future<List<Review>> _readAll() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      final data = jsonDecode(contents) as Map<String, dynamic>;
      final list = data['reviews'] as List<dynamic>;
      return list
          .map((e) => Review.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> _writeAll(List<Review> reviews) async {
    final file = await _getFile();
    final data = jsonEncode({
      'reviews': reviews.map((r) => r.toJson()).toList(),
    });
    await file.writeAsString(data);
  }

  /// All reviews for a product, newest first.
  static Future<List<Review>> getReviews(String productId) async {
    final all = await _readAll();
    return all.where((r) => r.productId == productId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Adds a review — unlimited, no duplicate check.
  static Future<void> addReview(Review review) async {
    final all = await _readAll();
    all.add(review);
    await _writeAll(all);
  }
}
