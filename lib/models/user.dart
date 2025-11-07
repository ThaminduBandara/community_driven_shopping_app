import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  String userId;
  String username;
  String email;
  String passwordHash;

  User({
    required this.userId,
    required this.username,
    required this.email,
    required this.passwordHash,
  });

  static const String baseUrl = "http://localhost:9090/api/users";

  
  Future<bool> signup() async {
    final response = await http.post(
      Uri.parse("$baseUrl/signup"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "username": username,
        "email": email,
        "passwordHash": passwordHash,
      }),
    );

    return response.statusCode == 201;
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
        passwordHash: data['passwordHash'],
      );
    } else {
      return null;
    }
  }
}

