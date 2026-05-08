import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class AppProvider extends ChangeNotifier {
  // ─── Current Session ───────────────────────────────────────────────────────
  String _currentUserEmail = '';
  String _currentUserName = '';
  String _currentUserBio = '';
  String _paymentMethod = '';
  String _location = '';
  String _address = '';
  String _city = '';
  String _phone = '';
  int _avatarIndex = 0;

  String get currentUserEmail => _currentUserEmail;
  String get currentUserName => _currentUserName;
  String get currentUserBio => _currentUserBio;
  String get paymentMethod => _paymentMethod;
  String get location => _location;
  String get address => _address;
  String get city => _city;
  String get phone => _phone;
  int get avatarIndex => _avatarIndex;
  bool get isLoggedIn => _currentUserEmail.isNotEmpty;

  /// True when the user has all delivery info filled in
  bool get hasDeliveryInfo =>
      _phone.isNotEmpty && _address.isNotEmpty && _city.isNotEmpty;

  void setCurrentUser({required String email, required String name}) {
    _currentUserEmail = email;
    _currentUserName = name;
    notifyListeners();
  }

  void setCurrentUserName(String name) {
    _currentUserName = name;
    notifyListeners();
  }

  void setBio(String bio) {
    _currentUserBio = bio;
    notifyListeners();
  }

  void setPaymentMethod(String value) {
    _paymentMethod = value;
    notifyListeners();
  }

  void setLocation(String value) {
    _location = value;
    notifyListeners();
  }

  void setAddress(String value) {
    _address = value;
    notifyListeners();
  }

  void setCity(String value) {
    _city = value;
    notifyListeners();
  }

  void setPhone(String value) {
    _phone = value;
    notifyListeners();
  }

  void setAvatarIndex(int index) {
    _avatarIndex = index;
    notifyListeners();
  }

  void clearCurrentUser() {
    _currentUserEmail = '';
    _currentUserName = '';
    _currentUserBio = '';
    _paymentMethod = '';
    _location = '';
    _address = '';
    _city = '';
    _phone = '';
    _avatarIndex = 0;
    notifyListeners();
  }

  // ─── Cart ──────────────────────────────────────────────────────────────────
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);
  int get cartCount => _cartItems.fold(0, (s, i) => s + i.quantity);
  double get cartTotal => _cartItems.fold(0.0, (s, i) => s + i.total);

  void addToCart(Product product, String size, int quantity) {
    final existing = _cartItems.firstWhere(
      (item) => item.product.id == product.id && item.size == size,
      orElse: () => CartItem(product: product, size: size, quantity: 0),
    );
    if (_cartItems.contains(existing)) {
      existing.quantity += quantity;
    } else {
      _cartItems.add(
        CartItem(product: product, size: size, quantity: quantity),
      );
    }
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  void updateCartQuantity(CartItem item, int delta) {
    item.quantity += delta;
    if (item.quantity <= 0) _cartItems.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // ─── Wishlist ──────────────────────────────────────────────────────────────
  final List<Product> _wishlist = [];

  List<Product> get wishlist => List.unmodifiable(_wishlist);

  bool isWishlisted(String productId) =>
      _wishlist.any((p) => p.id == productId);

  void toggleWishlist(Product product) {
    if (isWishlisted(product.id)) {
      _wishlist.removeWhere((p) => p.id == product.id);
    } else {
      _wishlist.add(product);
    }
    notifyListeners();
  }

  // ─── Orders ────────────────────────────────────────────────────────────────
  final List<List<CartItem>> _orders = [];

  List<List<CartItem>> get orders => List.unmodifiable(_orders);

  void placeOrder() {
    if (_cartItems.isEmpty) return;
    _orders.add(List.from(_cartItems));
    _cartItems.clear();
    notifyListeners();
  }

  // ─── Notifications ─────────────────────────────────────────────────────────
  final List<String> notifications = [
    'Your order #001 has been shipped!',
    'New arrivals: Check out the latest Gravity collection.',
    'Flash sale: 20% off on all Tshirts this weekend.',
    'Your wishlist item "Regular Fit Polo" is back in stock!',
  ];
}
