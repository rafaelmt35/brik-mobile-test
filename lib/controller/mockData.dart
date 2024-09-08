// ignore_for_file: file_names

import 'dart:convert';
import 'package:brik_mobile_test/controller/repository.dart';
import 'package:brik_mobile_test/model/product_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MockDataInput {
  String? apiUrl = dotenv.env['API_URL'];

  ProductRepository repository = ProductRepository();

  Future<void> postMockData() async {
    List<Product> products = await repository.fetchAllProducts();

    int newId = products.isNotEmpty ? products.last.id + 1 : 1;
    final product = {
      "id": newId,
      "CategoryId": 15,
      "categoryName": "Cemilan",
      "sku": "SKU001",
      "name": "Makanan $newId",
      "description": "Makanan nomer $newId enak",
      "weight": 501,
      "width": 5,
      "length": 5,
      "height": 5,
      "image":
          "https://cdn.antaranews.com/cache/1200x800/2022/08/03/ayam-geprek.png",
      "harga": 20000 + (newId * 100),
    };

    await postProduct(product);
  }

  Future<void> postProduct(Map<String, dynamic> product) async {
    final response = await http.post(
      Uri.parse(apiUrl!),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product),
    );

    if (response.statusCode == 201) {
      print("Product posted: ${product['name']}");
    } else {
      print("Failed to post product: ${response.body}");
    }
  }
}
