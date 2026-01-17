import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product_image.dart';

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
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(toJson()),
    );
    return response.statusCode == 201;
  }

 
  Future<bool> updateProduct() async {
    final response = await http.put(
      Uri.parse("$baseUrl/$productId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(toJson()),
    );
    return response.statusCode == 200;
  }

 
  Future<bool> deleteProduct() async {
    final response = await http.delete(Uri.parse("$baseUrl/$productId"));
    return response.statusCode == 200;
  }

  
  static Future<List<Product>> getAllProducts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    }
    return [];
  }

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json['productId'],
        category: json['category'],
        brand: json['brand'],
        model: json['model'],
        name: json['name'],
        price: json['price'].toDouble(),
        warranty: json['warranty'],
        customerService: json['customerService'],
        addedBy: json['addedBy'],
        shopName: json['shopName'],
        shopAddress: json['shopAddress'],
        shopTown: json['shopTown'],
        shopLatitude: json['shopLatitude'].toDouble(),
        shopLongitude: json['shopLongitude'].toDouble(),
        images: json['images'] != null
            ? (json['images'] as List)
                .map((img) => ProductImage(
                      imageId: '',
                      productId: json['productId'],
                      url: img is String ? img : img['url'],
                      uploadedBy: '',
                      timestamp: DateTime.now(),
                    ))
                .toList()
            : [],
      );
}

