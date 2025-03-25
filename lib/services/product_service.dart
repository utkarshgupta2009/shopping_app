import 'dart:developer';

import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/product_model.dart';
import 'json_service.dart';

class ProductService {
  final String baseUrl = AppConfig.apiBaseUrl;

  Future<ApiResponse> getProducts({
    int limit = 10,
    int skip = 0,
    String? category,
  }) async {
    try {
      final String url = category != null && category.isNotEmpty
          ? '$baseUrl/products/category/$category'
          : '$baseUrl/products?limit=$limit&skip=$skip';

      log('Fetching products from: $url');

      final response = await http.get(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        log('Received successful response with status: ${response.statusCode}');
        final Map<String, dynamic> data = JsonService.decode(response.body);
        log('Response data: ${data.keys}');
        final apiResponse = ApiResponse.fromJson(data);
        log('Parsed ${apiResponse.products.length} products');
        return apiResponse;
      } else {
        log('Failed to load products: status ${response.statusCode}, body: ${response.body}');
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception in getProducts: $e');
      throw Exception('Failed to load products: $e');
    }
  }

  Future<Product> getProductById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/$id'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = JsonService.decode(response.body);
        return Product.fromJson(data);
      } else {
        log('Failed to load product $id: status ${response.statusCode}');
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception in getProductById: $e');
      throw Exception('Failed to load product: $e');
    }
  }
}