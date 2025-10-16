import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/admin_model.dart';

class AdminAuthService extends ChangeNotifier {
  static final AdminAuthService _instance = AdminAuthService._internal();
  factory AdminAuthService() => _instance;
  AdminAuthService._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  AdminModel? _currentAdmin;
  
  AdminModel? get currentAdmin => _currentAdmin;
  bool get isLoggedIn => _firebaseAuth.currentUser != null && _currentAdmin != null;

  Future<AuthResult> login(String email, String password) async {
    try {
      // Firebase Authentication
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Check if user is admin
        final adminDoc = await _firestore
            .collection('admins')
            .doc(credential.user!.uid)
            .get();

        if (!adminDoc.exists) {
          await _firebaseAuth.signOut();
          return AuthResult.error('Bu hisob admin emas');
        }

        final adminData = adminDoc.data()!;
        if (!adminData['isActive']) {
          await _firebaseAuth.signOut();
          return AuthResult.error('Admin hisobi o\'chirilgan');
        }

        _currentAdmin = AdminModel.fromJson({
          'id': credential.user!.uid,
          'email': credential.user!.email!,
          'name': adminData['name'],
          'role': adminData['role'],
          'isActive': adminData['isActive'],
          'createdAt': adminData['createdAt'],
          'lastLogin': DateTime.now().toIso8601String(),
          'permissions': adminData['permissions'] ?? [],
        });

        // Update last login
        await _firestore
            .collection('admins')
            .doc(credential.user!.uid)
            .update({'lastLogin': DateTime.now()});

        notifyListeners();
        return AuthResult.success(_currentAdmin!);
      } else {
        return AuthResult.error('Kirishda xatolik yuz berdi');
      }
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_handleFirebaseError(e));
    } catch (e) {
      return AuthResult.error('Noma\'lum xatolik: $e');
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    _currentAdmin = null;
    notifyListeners();
  }

  Future<void> initialize() async {
    _firebaseAuth.authStateChanges().listen((User? user) async {
      if (user == null) {
        _currentAdmin = null;
        notifyListeners();
      } else {
        // Check if user is still admin
        final adminDoc = await _firestore
            .collection('admins')
            .doc(user.uid)
            .get();

        if (adminDoc.exists && adminDoc.data()!['isActive']) {
          final adminData = adminDoc.data()!;
          _currentAdmin = AdminModel.fromJson({
            'id': user.uid,
            'email': user.email!,
            'name': adminData['name'],
            'role': adminData['role'],
            'isActive': adminData['isActive'],
            'createdAt': adminData['createdAt'],
            'lastLogin': adminData['lastLogin'],
            'permissions': adminData['permissions'] ?? [],
          });
        } else {
          await _firebaseAuth.signOut();
          _currentAdmin = null;
        }
        notifyListeners();
      }
    });
  }

  String _handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Admin topilmadi';
      case 'wrong-password':
        return 'Noto\'g\'ri parol';
      case 'invalid-email':
        return 'Noto\'g\'ri email formati';
      case 'user-disabled':
        return 'Admin hisobi o\'chirilgan';
      case 'too-many-requests':
        return 'Juda ko\'p urinish, keyinroq urinib ko\'ring';
      default:
        return e.message ?? 'Noma\'lum xatolik';
    }
  }
}

class AuthResult {
  final bool isSuccess;
  final AdminModel? admin;
  final String? error;

  AuthResult._({
    required this.isSuccess,
    this.admin,
    this.error,
  });

  factory AuthResult.success(AdminModel admin) {
    return AuthResult._(
      isSuccess: true,
      admin: admin,
    );
  }

  factory AuthResult.error(String error) {
    return AuthResult._(
      isSuccess: false,
      error: error,
    );
  }
}
