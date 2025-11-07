import 'dart:math';
import '../models/product.dart';

class ProductService {


  List<Product> sortByPrice(List<Product> products) {
    products.sort((a, b) => a.price.compareTo(b.price));
    return products;
  }

  List<Product> sortByWarranty(List<Product> products) {
    products.sort((a, b) => b.warranty.compareTo(a.warranty));
    return products;
  }

  List<Product> sortByDistance(List<Product> products, double userLat, double userLong) {
    products.sort((a, b) {
      double distanceA = _calculateDistance(userLat, userLong, a.shopLatitude, a.shopLongitude);
      double distanceB = _calculateDistance(userLat, userLong, b.shopLatitude, b.shopLongitude);
      return distanceA.compareTo(distanceB);
    });
    return products;
  }

  List<Product> sortByMultipleCriteria(
      List<Product> products,
      double userLat,
      double userLong, {
      bool byPrice = true,
      bool byDistance = true,
      bool byWarranty = true,
    }) {
    products.sort((a, b) {
      if (byDistance) {
        double dA = _calculateDistance(userLat, userLong, a.shopLatitude, a.shopLongitude);
        double dB = _calculateDistance(userLat, userLong, b.shopLatitude, b.shopLongitude);
        if (dA != dB) return dA.compareTo(dB);
      }
      if (byPrice && a.price != b.price) return a.price.compareTo(b.price);
      if (byWarranty && a.warranty != b.warranty) return b.warranty.compareTo(a.warranty);
      return 0;
    });
    return products;
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) *
            (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}


