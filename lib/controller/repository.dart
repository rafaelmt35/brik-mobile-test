import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/product_model.dart';

class ProductRepository {
  String? apiUrl = dotenv.env['API_URL'];

  // Fetch all products
  Future<List<Product>> fetchAllProducts() async {
    final response = await http.get(Uri.parse(apiUrl!));

    if (response.statusCode == 200) {
      List<dynamic> productList = json.decode(response.body);
      return productList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Add product
  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse(apiUrl!),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add product');
    }
  }
}
