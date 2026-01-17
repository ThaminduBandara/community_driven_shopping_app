import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/product_image.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String? _error;

  // User location for distance calculation
  double _userLatitude = 6.9271; // Default: Colombo
  double _userLongitude = 79.8612;

  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setUserLocation(double latitude, double longitude) {
    _userLatitude = latitude;
    _userLongitude = longitude;
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await Product.getAllProducts();
      _filteredProducts = List.from(_products);
      _error = null;
    } catch (e) {
      _error = 'Failed to load products: $e';
      _products = [];
      _filteredProducts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void applyFilters({
    String? type,
    String? brand,
    double? minPrice,
    double? maxPrice,
    int? minWarranty,
    String? sortBy,
  }) {
    _filteredProducts = List.from(_products);

    // Apply filters
    if (type != null && type.isNotEmpty) {
      _filteredProducts = _filteredProducts
          .where((p) => p.category.toLowerCase() == type.toLowerCase())
          .toList();
    }

    if (brand != null && brand.isNotEmpty) {
      _filteredProducts = _filteredProducts
          .where((p) => p.brand.toLowerCase() == brand.toLowerCase())
          .toList();
    }

    if (minPrice != null) {
      _filteredProducts =
          _filteredProducts.where((p) => p.price >= minPrice).toList();
    }

    if (maxPrice != null) {
      _filteredProducts =
          _filteredProducts.where((p) => p.price <= maxPrice).toList();
    }

    if (minWarranty != null) {
      _filteredProducts =
          _filteredProducts.where((p) => p.warranty >= minWarranty).toList();
    }

    // Apply sorting
    if (sortBy != null) {
      final service = ProductService();
      switch (sortBy.toLowerCase()) {
        case 'price':
          _filteredProducts = service.sortByPrice(_filteredProducts);
          break;
        case 'warranty':
          _filteredProducts = service.sortByWarranty(_filteredProducts);
          break;
        case 'distance':
          _filteredProducts = service.sortByDistance(
            _filteredProducts,
            _userLatitude,
            _userLongitude,
          );
          break;
      }
    }

    notifyListeners();
  }

  Future<bool> addProduct({
    required String productId,
    required String category,
    required String brand,
    required String model,
    required String name,
    required double price,
    required int warranty,
    required String customerService,
    required String addedBy,
    required String shopName,
    required String shopAddress,
    required String shopTown,
    required double shopLatitude,
    required double shopLongitude,
    required List<ProductImage> images,
  }) async {
    try {
      final product = Product(
        productId: productId,
        category: category,
        brand: brand,
        model: model,
        name: name,
        price: price,
        warranty: warranty,
        customerService: customerService,
        addedBy: addedBy,
        shopName: shopName,
        shopAddress: shopAddress,
        shopTown: shopTown,
        shopLatitude: shopLatitude,
        shopLongitude: shopLongitude,
        images: images,
      );

      final success = await product.addProduct();
      
      if (success) {
        // Refresh the product list
        await fetchProducts();
      }
      
      return success;
    } catch (e) {
      _error = 'Failed to add product: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
      final success = await product.updateProduct();
      
      if (success) {
        await fetchProducts();
      }
      
      return success;
    } catch (e) {
      _error = 'Failed to update product: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      final product = _products.firstWhere((p) => p.productId == productId);
      final success = await product.deleteProduct();
      
      if (success) {
        _products.removeWhere((p) => p.productId == productId);
        _filteredProducts.removeWhere((p) => p.productId == productId);
        notifyListeners();
      }
      
      return success;
    } catch (e) {
      _error = 'Failed to delete product: $e';
      notifyListeners();
      return false;
    }
  }
}
