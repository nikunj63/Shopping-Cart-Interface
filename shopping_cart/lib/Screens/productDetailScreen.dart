import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shopping_cart/Models/ProductModel.dart';
import 'package:shopping_cart/Bloc/cart_bloc.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    double originalPrice = widget.product.price / (1 - (widget.product.discountPercentage / 100)); 
    double discountedPrice = widget.product.price; 

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade50,
        title: Text(widget.product.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Center(
                child: Image.network(
                  widget.product.thumbnail,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),

              // Title & Brand
              Text(widget.product.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text("Brand: ${widget.product.brand}", style: const TextStyle(fontSize: 16, color: Colors.grey)),
              Text("Category: ${widget.product.category}", style: const TextStyle(fontSize: 16, color: Colors.grey)),

              const SizedBox(height: 8),

              // Price & Discount
              Row(
                children: [
                  Text(
                    "₹${originalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 18, color: Colors.grey, decoration: TextDecoration.lineThrough),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "\₹${discountedPrice.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${widget.product.discountPercentage}% OFF",
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Rating
              Row(
                children: [
                  RatingBarIndicator(
                    rating: widget.product.rating.toDouble(),
                    itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
                    itemCount: 5,
                    itemSize: 30.0,
                    direction: Axis.horizontal,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.product.rating.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Description
              const Text("Description:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(widget.product.description, style: const TextStyle(fontSize: 16)),

              const SizedBox(height: 16),

              // Stock Status
              Text(
                "Stock: ${widget.product.stock > 0 ? "Available (${widget.product.stock})" : "Out of Stock"}",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: widget.product.stock > 0 ? Colors.green.shade700 : Colors.red),
              ),
            ],
          ),
        ),
      ),

      // Add to Cart Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (widget.product.stock > 0) {
                    // Add product to cart using CartBloc
                    context.read<CartBloc>().add(AddToCart(widget.product.copyWith(quantity: widget.product.quantity)));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${widget.product.title} added to cart!"),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${widget.product.title} is out of stock!"),
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.all(16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20), 
          ],
        ),
      ),
    );
  }
}
