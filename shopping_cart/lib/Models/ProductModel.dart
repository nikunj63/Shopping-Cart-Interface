import 'dart:convert';

class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String category;
  final String thumbnail;
  final List<String> images;
  final String sku;
  int quantity;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
    required this.sku, 
    this.quantity = 1,
  });

  // Factory method to create a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? "No Title",  
      description: json['description'] ?? "No description available",  
      category: json['category'] ?? "Unknown Category",
      price: (json['price'] ?? 0).toDouble(),  
      discountPercentage: (json['discountPercentage'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      brand: json['brand'] ?? "Unknown Brand",
      sku: json['sku'] ?? "N/A", 
      thumbnail: json['thumbnail'] ?? "", 
      images: (json['images'] as List?)?.map((img) => img.toString()).toList() ?? [], 
    );
  }

  // Convert Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'brand': brand,
      'category': category,
      'thumbnail': thumbnail,
      'images': images,
      'sku': sku,
    };
  }

   Product copyWith({int? quantity}) {
    return Product(
      id: id,
      title: title,
      description: description,
      price: price,
      discountPercentage: discountPercentage,
      rating: rating,
      stock: stock,
      brand: brand,
      category: category,
      thumbnail: thumbnail,
      images: images,
      sku: sku,
      quantity: quantity ?? this.quantity,
    );
  }

  // Method to create a list of products from JSON response
  static List<Product> fromJsonList(String jsonStr) {
    final Map<String, dynamic> data = json.decode(jsonStr);
    final List<dynamic> productList = data['products'];
    return productList.map((json) => Product.fromJson(json)).toList();
  }
}
