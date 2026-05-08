class Product {
  final String id;
  final String name;
  final double price;
  final String imagePath;
  final String category;
  final List<String> sizes;
  final String description;
  final List<String> extraImages;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.category,
    required this.sizes,
    this.description = '',
    this.extraImages = const [],
  });
}

final List<Product> allProducts = [
  Product(
    id: '1',
    name: 'Textured Knitted Polo Shirt',
    price: 1299,
    imagePath: 'assets/products/knitted_polo.png',
    category: 'Tops',
    sizes: ['XS', 'S', 'M', 'L', 'XL'],
    extraImages: [
      'assets/products/knitted_polo2.png',
      'assets/products/knitted_polo3.png',
      'assets/products/knitted_polo4.png',
      'assets/products/knitted_polo5.png',
    ],
  ),
  Product(
    id: '2',
    name: 'Plain Black T-Shirt',
    price: 999,
    imagePath: 'assets/products/tshirt.png',
    category: 'Tops',
    sizes: ['XS', 'S', 'M', 'L'],
    extraImages: [
      'assets/products/tshirt2.png',
      'assets/products/tshirt3.png',
      'assets/products/tshirt4.png',
      'assets/products/tshirt5.png',
    ],
  ),
  Product(
    id: '3',
    name: 'Hooded Jacket',
    price: 3799,
    imagePath: 'assets/products/hoodie.png',
    category: 'Tops',
    sizes: ['XS', 'S', 'M', 'L', 'XL'],
    extraImages: [
      'assets/products/hoodie2.png',
      'assets/products/hoodie3.png',
      'assets/products/hoodie4.png',
      'assets/products/hoodie5.png',
    ],
  ),
  Product(
    id: '4',
    name: 'Long Sleeve Polo Shirt',
    price: 3499,
    imagePath: 'assets/products/longsleeve.png',
    category: 'Tops',
    sizes: ['S', 'M', 'L', 'XL'],
    extraImages: [
      'assets/products/longsleeve2.png',
      'assets/products/longsleeve3.png',
      'assets/products/longsleeve4.png',
      'assets/products/longsleeve2.png',
    ],
  ),
  Product(
    id: '5',
    name: 'Tailored Trousers',
    price: 2799,
    imagePath: 'assets/products/trouser.png',
    category: 'Bottoms',
    sizes: ['28', '30', '32', '34'],
    extraImages: [
      'assets/products/trouser2.png',
      'assets/products/trouser3.png',
      'assets/products/trouser4.png',
      'assets/products/trouser5.png',
    ],
  ),
  Product(
    id: '6',
    name: 'Classic Brown Loafers',
    price: 3499,
    imagePath: 'assets/products/loafers2.png',
    category: 'Footwear',
    sizes: ['40', '41', '42', '43', '44'],
    extraImages: [
      'assets/products/loafers.png',
      'assets/products/loafers3.png',
      'assets/products/loafers4.png',
      'assets/products/loafers.png',
    ],
  ),
];
