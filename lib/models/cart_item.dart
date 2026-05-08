import 'product.dart';

class CartItem {
  final Product product;
  final String size;
  int quantity;

  CartItem({required this.product, required this.size, required this.quantity});

  double get total => product.price * quantity;
}
