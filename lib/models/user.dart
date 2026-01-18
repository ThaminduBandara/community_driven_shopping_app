import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String userId;
  String username;
  String email;
  String passwordHash;
  String? token;

  User({
    required this.userId,
    required this.username,
    required this.email,
    required this.passwordHash,
    this.token,
  });

  static const String baseUrl = "http://localhost:8080/api/users";

  // Signup
  Future<bool> signup() async {
    final response = await http.post(
      Uri.parse("$baseUrl/signup"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": passwordHash,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      userId = data['userId'];
      token = data['token'];
      return true;
    }
    return false;
  }


  static Future<User?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User(
        userId: data['userId'],
        username: data['username'],
        email: data['email'],
        passwordHash: data['passwordHash'] ?? '',
        token: data['token'],
      );
    } else {
      return null;
    }
  }


  Future<bool> updateProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.put(
        Uri.parse("$baseUrl/$userId"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "username": username,
          "email": email,
        }),
      );

      if (response.statusCode == 200) {
      
        await prefs.setString('username', username);
        await prefs.setString('email', email);
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }
}

