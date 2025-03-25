import 'package:dio/dio.dart';
import 'package:shopping_cart/Models/ProductModel.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<Product>> fetchProducts() async {
    try {
    final response = await _dio.get('https://dummyjson.com/products');
    print("API Response: ${response.data}"); // for debugging
    if (response.statusCode == 200) {
      List productsJson = response.data['products'];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    }
    throw Exception('Failed to load products');
  } catch (e) {
    print("API Error: $e"); // Catch  errors
    throw Exception('Failed to load products');
  }
}
}
