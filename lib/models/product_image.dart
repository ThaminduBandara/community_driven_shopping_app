import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductImage {
  String imageId;
  String productId;
  String url;
  String uploadedBy;
  DateTime timestamp;

  ProductImage({
    required this.imageId,
    required this.productId,
    required this.url,
    required this.uploadedBy,
    required this.timestamp,
  });

  static const String baseUrl = "http://localhost:8080/api/products";

  Map<String, dynamic> toJson() => {
        "imageId": imageId,
        "productId": productId,
        "url": url,
        "uploadedBy": uploadedBy,
        "timestamp": timestamp.toIso8601String(),
      };

  Future<bool> uploadImage() async {
    final response = await http.post(
      Uri.parse("$baseUrl/$productId/images"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(toJson()),
    );
    return response.statusCode == 201;
  }

  Future<bool> deleteImage() async {
    final response = await http.delete(
      Uri.parse("$baseUrl/$productId/images/$imageId"),
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteImagesByProduct(String productId) async {
    final response = await http.delete(Uri.parse("$baseUrl/$productId/images"));
    return response.statusCode == 200;
  }

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
        imageId: json['imageId'],
        productId: json['productId'],
        url: json['url'],
        uploadedBy: json['uploadedBy'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}


