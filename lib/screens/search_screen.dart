import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  List<Product> _results = [];

  void _search(String query) {
    final q = query.toLowerCase().trim();
    setState(() {
      _results = q.isEmpty
          ? []
          : allProducts
                .where(
                  (p) =>
                      p.name.toLowerCase().contains(q) ||
                      p.category.toLowerCase().contains(q),
                )
                .toList();
    });
  }

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
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: _search,
          style: GoogleFonts.dmSans(fontSize: 15, color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Search products...',
            hintStyle: GoogleFonts.dmSans(fontSize: 15, color: Colors.black38),
            border: InputBorder.none,
          ),
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: () {
                _controller.clear();
                _search('');
              },
            ),
        ],
      ),
      body: _controller.text.isEmpty
          ? Center(
              child: Text(
                'Search for a product by name or category.',
                style: GoogleFonts.dmSans(fontSize: 14, color: Colors.black38),
                textAlign: TextAlign.center,
              ),
            )
          : _results.isEmpty
          ? Center(
              child: Text(
                'No results for "${_controller.text}".',
                style: GoogleFonts.dmSans(fontSize: 14, color: Colors.black38),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 12,
                childAspectRatio: 0.62,
              ),
              itemCount: _results.length,
              itemBuilder: (_, i) => ProductCard(product: _results[i]),
            ),
    );
  }
}
