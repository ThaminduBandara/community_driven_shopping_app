import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'product_image.dart';
import 'review.dart';

class Product {
  String productId;
  String category;
  String brand;
  String model;
  String name;
  double price;
  int warranty;
  String customerService;
  String addedBy;
  String shopName;
  String shopAddress;
  String shopTown;
  double shopLatitude;
  double shopLongitude;
  List<ProductImage> images;
  List<Review> reviews;
  double averageRating;
  int reviewCount;

  Product({
    required this.productId,
    required this.category,
    required this.brand,
    required this.model,
    required this.name,
    required this.price,
    required this.warranty,
    required this.customerService,
    required this.addedBy,
    required this.shopName,
    required this.shopAddress,
    required this.shopTown,
    required this.shopLatitude,
    required this.shopLongitude,
    this.images = const [],
    this.reviews = const [],
    this.averageRating = 0.0,
    this.reviewCount = 0,
  });

  static const String baseUrl = "http://localhost:8080/api/products";

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "category": category,
        "brand": brand,
        "model": model,
        "name": name,
        "price": price,
        "warranty": warranty,
        "customerService": customerService,
        "addedBy": addedBy,
        "shopName": shopName,
        "shopAddress": shopAddress,
        "shopTown": shopTown,
        "shopLatitude": shopLatitude,
        "shopLongitude": shopLongitude,
        "images": images.map((img) => img.url).toList(),
      };

  // Add product
  Future<bool> addProduct() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode(toJson()),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  // Update product
  Future<bool> updateProduct() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    final response = await http.put(
      Uri.parse("$baseUrl/$productId"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode(toJson()),
    );
    return response.statusCode == 200;
  }

  // Delete product
  Future<bool> deleteProduct() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    final response = await http.delete(
      Uri.parse("$baseUrl/$productId"),
      headers: {
        if (token != null) "Authorization": "Bearer $token",
      },
    );
    return response.statusCode == 200;
  }

  // Get all products
  static Future<List<Product>> getAllProducts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      // Handle both array and object with "products" array
      final List data = responseData is List ? responseData : responseData['products'];
      return data.map((json) => Product.fromJson(json)).toList();
    }
    return [];
  }

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json['productId'] ?? json['_id'] ?? '',
        category: json['category'] ?? '',
        brand: json['brand'] ?? '',
        model: json['model'] ?? '',
        name: json['name'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        warranty: json['warranty'] ?? 0,
        customerService: json['customerService'] ?? '',
        addedBy: json['addedBy'] is String ? json['addedBy'] : (json['addedBy']?['_id'] ?? ''),
        shopName: json['shopName'] ?? '',
        shopAddress: json['shopAddress'] ?? '',
        shopTown: json['shopTown'] ?? '',
        shopLatitude: (json['shopLatitude'] ?? 0).toDouble(),
        shopLongitude: (json['shopLongitude'] ?? 0).toDouble(),
        images: json['images'] != null && json['images'] is List
            ? (json['images'] as List)
                .where((img) => img != null)
                .map((img) => ProductImage(
                      imageId: '',
                      productId: json['productId'] ?? json['_id'] ?? '',
                      url: img is String ? img : (img['url'] ?? ''),
                      uploadedBy: '',
                      timestamp: DateTime.now(),
                    ))
                .toList()
            : [],
        reviews: json['reviews'] != null && json['reviews'] is List
            ? (json['reviews'] as List)
                .map((reviewJson) => Review.fromJson(reviewJson))
                .toList()
            : [],
        averageRating: (json['averageRating'] ?? 0).toDouble(),
        reviewCount: json['reviewCount'] ?? 0,
      );

  // Add review to product
  static Future<bool> addReview(String productId, double rating, String comment, {double? serviceRating}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    if (token == null) return false;
    
    final response = await http.post(
      Uri.parse("$baseUrl/$productId/reviews"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "rating": rating,
        "comment": comment,
        if (serviceRating != null) "serviceRating": serviceRating,
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  // Get reviews for product
  static Future<Map<String, dynamic>> getReviews(String productId) async {
    final response = await http.get(Uri.parse("$baseUrl/$productId/reviews"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'reviews': (data['reviews'] as List).map((json) => Review.fromJson(json)).toList(),
        'averageRating': (data['averageRating'] ?? 0).toDouble(),
        'reviewCount': data['reviewCount'] ?? 0,
      };
    }
    return {'reviews': [], 'averageRating': 0.0, 'reviewCount': 0};
  }
}

