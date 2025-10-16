import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  Future<void> initialize() async {
    _setLoading(true);
    try {
      await _authService.initialize();
      _user = _authService.currentUser;
    } catch (e) {
      _setError('Initialization failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _authService.login(email, password);
      
      if (result.isSuccess) {
        _user = result.user;
        notifyListeners();
        return true;
      } else {
        _setError(result.error!);
        return false;
      }
    } catch (e) {
      _setError('Login failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _authService.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      
      if (result.isSuccess) {
        _user = result.user;
        notifyListeners();
        return true;
      } else {
        _setError(result.error!);
        return false;
      }
    } catch (e) {
      _setError('Registration failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _authService.resetPassword(email);
      
      if (result.isSuccess) {
        return true;
      } else {
        _setError(result.error!);
        return false;
      }
    } catch (e) {
      _setError('Password reset failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      
      if (result.isSuccess) {
        return true;
      } else {
        _setError(result.error!);
        return false;
      }
    } catch (e) {
      _setError('Password change failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? profileImage,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _authService.updateProfile(
        name: name,
        phone: phone,
        profileImage: profileImage,
      );
      
      if (result.isSuccess) {
        _user = result.user;
        notifyListeners();
        return true;
      } else {
        _setError(result.error!);
        return false;
      }
    } catch (e) {
      _setError('Profile update failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    
    try {
      await _authService.logout();
      _user = null;
      notifyListeners();
    } catch (e) {
      _setError('Logout failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
