import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException(this.message, {this.statusCode, this.data});

  @override
  String toString() => message;
}

class ApiClient {
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  static const Duration timeout = Duration(seconds: 30);

  static Future<http.Response> get(
    String url, {
    Map<String, String>? headers,
    int retryCount = 0,
  }) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(timeout);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else if (response.statusCode >= 500 && retryCount < maxRetries) {
        await Future.delayed(retryDelay);
        return get(url, headers: headers, retryCount: retryCount + 1);
      } else {
        throw ApiException(
          _getErrorMessage(response),
          statusCode: response.statusCode,
          data: _tryParseJson(response.body),
        );
      }
    } on TimeoutException {
      if (retryCount < maxRetries) {
        await Future.delayed(retryDelay);
        return get(url, headers: headers, retryCount: retryCount + 1);
      }
      throw ApiException('Request timed out. Please check your internet connection.');
    } catch (e) {
      if (e is ApiException) rethrow;
      if (retryCount < maxRetries) {
        await Future.delayed(retryDelay);
        return get(url, headers: headers, retryCount: retryCount + 1);
      }
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  static Future<http.Response> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
    int retryCount = 0,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: headers,
            body: body,
          )
          .timeout(timeout);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else if (response.statusCode >= 500 && retryCount < maxRetries) {
        await Future.delayed(retryDelay);
        return post(url, headers: headers, body: body, retryCount: retryCount + 1);
      } else {
        throw ApiException(
          _getErrorMessage(response),
          statusCode: response.statusCode,
          data: _tryParseJson(response.body),
        );
      }
    } on TimeoutException {
      if (retryCount < maxRetries) {
        await Future.delayed(retryDelay);
        return post(url, headers: headers, body: body, retryCount: retryCount + 1);
      }
      throw ApiException('Request timed out. Please check your internet connection.');
    } catch (e) {
      if (e is ApiException) rethrow;
      if (retryCount < maxRetries) {
        await Future.delayed(retryDelay);
        return post(url, headers: headers, body: body, retryCount: retryCount + 1);
      }
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  static Future<http.Response> put(
    String url, {
    Map<String, String>? headers,
    dynamic body,
    int retryCount = 0,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse(url),
            headers: headers,
            body: body,
          )
          .timeout(timeout);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else if (response.statusCode >= 500 && retryCount < maxRetries) {
        await Future.delayed(retryDelay);
        return put(url, headers: headers, body: body, retryCount: retryCount + 1);
      } else {
        throw ApiException(
          _getErrorMessage(response),
          statusCode: response.statusCode,
          data: _tryParseJson(response.body),
        );
      }
    } on TimeoutException {
      if (retryCount < maxRetries) {
        await Future.delayed(retryDelay);
        return put(url, headers: headers, body: body, retryCount: retryCount + 1);
      }
      throw ApiException('Request timed out. Please check your internet connection.');
    } catch (e) {
      if (e is ApiException) rethrow;
      if (retryCount < maxRetries) {
        await Future.delayed(retryDelay);
        return put(url, headers: headers, body: body, retryCount: retryCount + 1);
      }
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  static Future<http.Response> delete(
    String url, {
    Map<String, String>? headers,
    int retryCount = 0,
  }) async {
    try {
      final response = await http
          .delete(Uri.parse(url), headers: headers)
          .timeout(timeout);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else if (response.statusCode >= 500 && retryCount < maxRetries) {
        await Future.delayed(retryDelay);
        return delete(url, headers: headers, retryCount: retryCount + 1);
      } else {
        throw ApiException(
          _getErrorMessage(response),
          statusCode: response.statusCode,
          data: _tryParseJson(response.body),
        );
      }
    } on TimeoutException {
      if (retryCount < maxRetries) {
        await Future.delayed(retryDelay);
        return delete(url, headers: headers, retryCount: retryCount + 1);
      }
      throw ApiException('Request timed out. Please check your internet connection.');
    } catch (e) {
      if (e is ApiException) rethrow;
      if (retryCount < maxRetries) {
        await Future.delayed(retryDelay);
        return delete(url, headers: headers, retryCount: retryCount + 1);
      }
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  static String _getErrorMessage(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      if (data is Map && data.containsKey('message')) {
        return data['message'];
      }
    } catch (e) {
      // Ignore JSON parsing errors
    }
    
    switch (response.statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Access denied.';
      case 404:
        return 'Resource not found.';
      case 409:
        return 'Conflict. Resource already exists.';
      case 422:
        return 'Invalid data provided.';
      case 500:
        return 'Server error. Please try again later.';
      case 503:
        return 'Service unavailable. Please try again later.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  static dynamic _tryParseJson(String body) {
    try {
      return jsonDecode(body);
    } catch (e) {
      return null;
    }
  }
}
