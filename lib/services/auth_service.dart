import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../constants/app_constants.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? _token;
  UserModel? _currentUser;

  String? get token => _token;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _firebaseAuth.currentUser != null && _currentUser != null;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(AppConstants.userTokenKey);
    
    final userData = prefs.getString(AppConstants.userDataKey);
    if (userData != null) {
      _currentUser = UserModel.fromJson(json.decode(userData));
    }
    
    // Firebase auth state listener
    _firebaseAuth.authStateChanges().listen((User? user) {
      if (user == null) {
        _currentUser = null;
        _token = null;
      }
    });
  }

  Future<AuthResult> login(String email, String password) async {
    try {
      // Firebase Authentication
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Get user data from Firebase
        final firebaseUser = credential.user!;
        _token = await firebaseUser.getIdToken();
        
        // Create UserModel from Firebase user
        _currentUser = UserModel(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'Foydalanuvchi',
          email: firebaseUser.email!,
          phone: firebaseUser.phoneNumber ?? '',
          profileImage: firebaseUser.photoURL,
          addresses: [],
          createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
          updatedAt: firebaseUser.metadata.lastSignInTime ?? DateTime.now(),
        );

        // Save to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.userTokenKey, _token!);
        await prefs.setString(AppConstants.userDataKey, json.encode(_currentUser!.toJson()));

        return AuthResult.success(_currentUser!);
      } else {
        return AuthResult.error('Kirishda xatolik yuz berdi');
      }
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_handleFirebaseError(e));
    } catch (e) {
      return AuthResult.error(_handleError(e));
    }
  }

  Future<AuthResult> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      // Firebase Authentication
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Update user profile
        await credential.user!.updateDisplayName(name);
        
        // Get user data from Firebase
        final firebaseUser = credential.user!;
        _token = await firebaseUser.getIdToken();
        
        // Create UserModel from Firebase user
        _currentUser = UserModel(
          id: firebaseUser.uid,
          name: name,
          email: firebaseUser.email!,
          phone: phone,
          profileImage: firebaseUser.photoURL,
          addresses: [],
          createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
          updatedAt: firebaseUser.metadata.lastSignInTime ?? DateTime.now(),
        );

        // Save to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.userTokenKey, _token!);
        await prefs.setString(AppConstants.userDataKey, json.encode(_currentUser!.toJson()));

        return AuthResult.success(_currentUser!);
      } else {
        return AuthResult.error('Ro\'yxatdan o\'tishda xatolik yuz berdi');
      }
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_handleFirebaseError(e));
    } catch (e) {
      return AuthResult.error(_handleError(e));
    }
  }

  Future<AuthResult> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return AuthResult.success(null, message: 'Parol tiklash havolasi emailingizga yuborildi');
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_handleFirebaseError(e));
    } catch (e) {
      return AuthResult.error(_handleError(e));
    }
  }

  Future<AuthResult> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/auth/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: json.encode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      ).timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        return AuthResult.success(null, message: AppConstants.passwordChanged);
      } else {
        final error = json.decode(response.body);
        return AuthResult.error(error['message'] ?? 'Parol o\'zgartirishda xatolik');
      }
    } catch (e) {
      return AuthResult.error(_handleError(e));
    }
  }

  Future<AuthResult> updateProfile({
    String? name,
    String? phone,
    String? profileImage,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: json.encode({
          if (name != null) 'name': name,
          if (phone != null) 'phone': phone,
          if (profileImage != null) 'profileImage': profileImage,
        }),
      ).timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _currentUser = UserModel.fromJson(data['user']);

        // Update local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.userDataKey, json.encode(_currentUser!.toJson()));

        return AuthResult.success(_currentUser!, message: AppConstants.profileUpdated);
      } else {
        final error = json.decode(response.body);
        return AuthResult.error(error['message'] ?? 'Profil yangilashda xatolik');
      }
    } catch (e) {
      return AuthResult.error(_handleError(e));
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    _token = null;
    _currentUser = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userTokenKey);
    await prefs.remove(AppConstants.userDataKey);
  }

  String _handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Foydalanuvchi topilmadi';
      case 'wrong-password':
        return 'Noto\'g\'ri parol';
      case 'email-already-in-use':
        return 'Bu email allaqachon ishlatilgan';
      case 'weak-password':
        return 'Parol juda zaif';
      case 'invalid-email':
        return 'Noto\'g\'ri email formati';
      case 'user-disabled':
        return 'Foydalanuvchi hisobi o\'chirilgan';
      case 'too-many-requests':
        return 'Juda ko\'p urinish, keyinroq urinib ko\'ring';
      default:
        return e.message ?? AppConstants.unknownError;
    }
  }

  String _handleError(dynamic error) {
    if (error.toString().contains('SocketException') || 
        error.toString().contains('NetworkException')) {
      return AppConstants.networkError;
    } else if (error.toString().contains('TimeoutException')) {
      return 'Vaqt tugadi, qaytadan urinib ko\'ring';
    } else {
      return AppConstants.unknownError;
    }
  }
}

class AuthResult {
  final bool isSuccess;
  final UserModel? user;
  final String? error;
  final String? message;

  AuthResult._({
    required this.isSuccess,
    this.user,
    this.error,
    this.message,
  });

  factory AuthResult.success(UserModel? user, {String? message}) {
    return AuthResult._(
      isSuccess: true,
      user: user,
      message: message,
    );
  }

  factory AuthResult.error(String error) {
    return AuthResult._(
      isSuccess: false,
      error: error,
    );
  }
}
