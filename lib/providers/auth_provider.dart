import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  String? _token;
  bool _isAuthenticated = false;

  User? get currentUser => _currentUser;
  String? get token => _token;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _loadUserFromPrefs();
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final userId = prefs.getString('userId');
    final username = prefs.getString('username');
    final email = prefs.getString('email');

    if (_token != null && userId != null && username != null && email != null) {
      _currentUser = User(
        userId: userId,
        username: username,
        email: email,
        passwordHash: '',
      );
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      // Call the User.login method
      final user = await User.login(email, password);
      
      if (user != null) {
        _currentUser = user;
        _isAuthenticated = true;
        _token = 'dummy_token_${user.userId}'; // TODO: Get actual token from API
        
        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('userId', user.userId);
        await prefs.setString('username', user.username);
        await prefs.setString('email', user.email);
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  Future<bool> signup(String username, String email, String password) async {
    try {
      // Create user and call signup
      final user = User(
        userId: '',
        username: username,
        email: email,
        passwordHash: password,
      );
      final success = await user.signup();
      return success;
    } catch (e) {
      debugPrint('Signup error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    _token = null;
    _isAuthenticated = false;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    notifyListeners();
  }
}
