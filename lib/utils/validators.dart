class InputValidator {
  static const String emailRegex =
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
  
  static const String urlRegex =
      r"^https?://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]$";

  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final regex = RegExp(emailRegex);
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain an uppercase letter';
    }
    
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain a number';
    }
    
    return null;
  }

  // Username validation
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    
    if (value.length > 30) {
      return 'Username must be less than 30 characters';
    }
    
    if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(value)) {
      return 'Username can only contain letters, numbers, underscore and hyphen';
    }
    
    return null;
  }

  // Product name validation
  static String? validateProductName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Product name is required';
    }
    
    if (value.length < 3) {
      return 'Product name must be at least 3 characters';
    }
    
    if (value.length > 200) {
      return 'Product name must be less than 200 characters';
    }
    
    return null;
  }

  // Price validation
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price is required';
    }
    
    try {
      final price = double.parse(value);
      if (price <= 0) {
        return 'Price must be greater than 0';
      }
      if (price > 100000000) {
        return 'Price is too high';
      }
    } catch (e) {
      return 'Please enter a valid price';
    }
    
    return null;
  }

  // Warranty validation
  static String? validateWarranty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Warranty is required';
    }
    
    try {
      final warranty = int.parse(value);
      if (warranty < 0) {
        return 'Warranty cannot be negative';
      }
      if (warranty > 120) {
        return 'Warranty cannot exceed 120 months';
      }
    } catch (e) {
      return 'Please enter a valid warranty period';
    }
    
    return null;
  }

  // Shop name validation
  static String? validateShopName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Shop name is required';
    }
    
    if (value.length < 2) {
      return 'Shop name must be at least 2 characters';
    }
    
    if (value.length > 200) {
      return 'Shop name must be less than 200 characters';
    }
    
    return null;
  }

  // Address validation
  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    }
    
    if (value.length < 5) {
      return 'Address must be at least 5 characters';
    }
    
    if (value.length > 500) {
      return 'Address must be less than 500 characters';
    }
    
    return null;
  }

  // Generic field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // URL validation
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }
    
    final regex = RegExp(urlRegex);
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    
    return null;
  }

  // Comment validation
  static String? validateComment(String? value) {
    if (value == null || value.isEmpty) {
      return 'Comment cannot be empty';
    }
    
    if (value.length < 5) {
      return 'Comment must be at least 5 characters';
    }
    
    if (value.length > 1000) {
      return 'Comment must be less than 1000 characters';
    }
    
    return null;
  }

  // Latitude validation
  static String? validateLatitude(String? value) {
    if (value == null || value.isEmpty) {
      return 'Latitude is required';
    }
    
    try {
      final lat = double.parse(value);
      if (lat < -90 || lat > 90) {
        return 'Latitude must be between -90 and 90';
      }
    } catch (e) {
      return 'Please enter a valid latitude';
    }
    
    return null;
  }

  // Longitude validation
  static String? validateLongitude(String? value) {
    if (value == null || value.isEmpty) {
      return 'Longitude is required';
    }
    
    try {
      final lon = double.parse(value);
      if (lon < -180 || lon > 180) {
        return 'Longitude must be between -180 and 180';
      }
    } catch (e) {
      return 'Please enter a valid longitude';
    }
    
    return null;
  }
}
