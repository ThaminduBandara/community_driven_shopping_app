import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_client.dart';
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
  double? distance; // Distance from user in km

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
    this.distance,
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
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      // Check if we have file images
      List<ProductImage> fileImages = images.where((img) => img.url.startsWith('/')).toList();
      List<ProductImage> urlImages = images.where((img) => !img.url.startsWith('/')).toList();
      
      if (fileImages.isNotEmpty) {
        // Use multipart form data for file upload
        final request = http.MultipartRequest('POST', Uri.parse(baseUrl));
        
        // Add authorization header
        if (token != null) {
          request.headers['Authorization'] = 'Bearer $token';
        }
        
        // Add form fields
        request.fields['category'] = category;
        request.fields['brand'] = brand;
        request.fields['model'] = model;
        request.fields['name'] = name;
        request.fields['price'] = price.toString();
        request.fields['warranty'] = warranty.toString();
        request.fields['customerService'] = customerService;
        request.fields['addedBy'] = addedBy;
        request.fields['shopName'] = shopName;
        request.fields['shopAddress'] = shopAddress;
        request.fields['shopTown'] = shopTown;
        request.fields['shopLatitude'] = shopLatitude.toString();
        request.fields['shopLongitude'] = shopLongitude.toString();
        
        // Add URL-based images
        request.fields['imageUrls'] = jsonEncode(urlImages.map((img) => img.url).toList());
        
        // Add file images
        for (int i = 0; i < fileImages.length; i++) {
          final file = File(fileImages[i].url);
          if (file.existsSync()) {
            request.files.add(
              await http.MultipartFile.fromPath(
                'images',
                file.path,
              ),
            );
          }
        }
        
        final response = await request.send();
        return response.statusCode == 200 || response.statusCode == 201;
      } else {
        // Use JSON for URL-only images
        final response = await ApiClient.post(
          baseUrl,
          headers: {
            "Content-Type": "application/json",
            if (token != null) "Authorization": "Bearer $token",
          },
          body: jsonEncode(toJson()),
        );
        return response.statusCode == 200 || response.statusCode == 201;
      }
    } on ApiException catch (e) {
      print('Error adding product: $e');
      rethrow;
    } catch (e) {
      print('Error adding product: $e');
      rethrow;
    }
  }

  // Update product
  Future<bool> updateProduct() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      final response = await ApiClient.put(
        "$baseUrl/$productId",
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode(toJson()),
      );
      return response.statusCode == 200;
    } on ApiException catch (e) {
      print('Error updating product: $e');
      rethrow;
    }
  }

  // Delete product
  Future<bool> deleteProduct() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      final response = await ApiClient.delete(
        "$baseUrl/$productId",
        headers: {
          if (token != null) "Authorization": "Bearer $token",
        },
      );
      return response.statusCode == 200;
    } on ApiException catch (e) {
      print('Error deleting product: $e');
      rethrow;
    }
  }

  // Get all products
  static Future<List<Product>> getAllProducts() async {
    try {
      final response = await ApiClient.get(Uri.parse(baseUrl).toString());
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Handle both array and object with "products" array
        final List data = responseData is List ? responseData : responseData['products'];
        return data.map((json) => Product.fromJson(json)).toList();
      }
      return [];
    } on ApiException catch (e) {
      print('Error fetching products: $e');
      return [];
    }
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
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token == null) return false;
      
      final response = await ApiClient.post(
        "$baseUrl/$productId/reviews",
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
    } on ApiException catch (e) {
      print('Error adding review: $e');
      return false;
    }
  }

  // Get reviews for product
  static Future<Map<String, dynamic>> getReviews(String productId) async {
    try {
      final response = await ApiClient.get("$baseUrl/$productId/reviews");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'reviews': (data['reviews'] as List).map((json) => Review.fromJson(json)).toList(),
          'averageRating': (data['averageRating'] ?? 0).toDouble(),
          'reviewCount': data['reviewCount'] ?? 0,
        };
      }
      return {'reviews': [], 'averageRating': 0.0, 'reviewCount': 0};
    } on ApiException catch (e) {
      print('Error fetching reviews: $e');
      return {'reviews': [], 'averageRating': 0.0, 'reviewCount': 0};
    }
  }
}

