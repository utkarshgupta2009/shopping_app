import '../utils/price_utils.dart';

class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String brand;
  final String sku;
  final String thumbnail;
  final List<String> images;
  final String availabilityStatus;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    required this.brand,
    required this.sku,
    required this.thumbnail,
    required this.images,
    required this.availabilityStatus,
  });

  double get discountedPrice {
    return PriceUtils.calculateDiscountedPrice(price, discountPercentage);
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discountPercentage: (json['discountPercentage'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      tags: json['tags'] != null 
          ? List<String>.from(json['tags']) 
          : [],
      brand: json['brand'] ?? '',
      sku: json['sku'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      images: json['images'] != null 
          ? List<String>.from(json['images']) 
          : [],
      availabilityStatus: json['availabilityStatus'] ?? 'Out of Stock',
    );
  }
}

class ApiResponse {
  final List<Product> products;
  final int total;
  final int skip;
  final int limit;

  ApiResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      products: (json['products'] as List)
          .map((product) => Product.fromJson(product))
          .toList(),
      total: json['total'] ?? 0,
      skip: json['skip'] ?? 0,
      limit: json['limit'] ?? 0,
    );
  }
}