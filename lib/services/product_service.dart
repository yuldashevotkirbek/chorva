import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../constants/app_constants.dart';
import 'auth_service.dart';

class ProductService {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;
  ProductService._internal();

  final AuthService _authService = AuthService();

  Future<List<ProductModel>> getProducts({
    String? categoryId,
    String? searchQuery,
    int page = 1,
    int limit = AppConstants.defaultPageSize,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (categoryId != null) queryParams['categoryId'] = categoryId;
      if (searchQuery != null) queryParams['search'] = searchQuery;
      if (sortBy != null) queryParams['sortBy'] = sortBy;
      if (sortOrder != null) queryParams['sortOrder'] = sortOrder;

      final uri = Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/products')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (_authService.token != null) 'Authorization': 'Bearer ${_authService.token}',
        },
      ).timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final products = (data['products'] as List<dynamic>)
            .map((product) => ProductModel.fromJson(product))
            .toList();
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<ProductModel> getProductById(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/products/$productId'),
        headers: {
          'Content-Type': 'application/json',
          if (_authService.token != null) 'Authorization': 'Bearer ${_authService.token}',
        },
      ).timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ProductModel.fromJson(data['product']);
      } else {
        throw Exception('Product not found');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/categories'),
        headers: {
          'Content-Type': 'application/json',
          if (_authService.token != null) 'Authorization': 'Bearer ${_authService.token}',
        },
      ).timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final categories = (data['categories'] as List<dynamic>)
            .map((category) => CategoryModel.fromJson(category))
            .toList();
        return categories;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<ProductModel>> getFeaturedProducts() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/products/featured'),
        headers: {
          'Content-Type': 'application/json',
          if (_authService.token != null) 'Authorization': 'Bearer ${_authService.token}',
        },
      ).timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final products = (data['products'] as List<dynamic>)
            .map((product) => ProductModel.fromJson(product))
            .toList();
        return products;
      } else {
        throw Exception('Failed to load featured products');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<ProductModel>> getPopularProducts() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/products/popular'),
        headers: {
          'Content-Type': 'application/json',
          if (_authService.token != null) 'Authorization': 'Bearer ${_authService.token}',
        },
      ).timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final products = (data['products'] as List<dynamic>)
            .map((product) => ProductModel.fromJson(product))
            .toList();
        return products;
      } else {
        throw Exception('Failed to load popular products');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/products/search')
            .replace(queryParameters: {'q': query}),
        headers: {
          'Content-Type': 'application/json',
          if (_authService.token != null) 'Authorization': 'Bearer ${_authService.token}',
        },
      ).timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final products = (data['products'] as List<dynamic>)
            .map((product) => ProductModel.fromJson(product))
            .toList();
        return products;
      } else {
        throw Exception('Search failed');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
