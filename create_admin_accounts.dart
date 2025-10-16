import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'lib/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  // Admin 1: Super Admin
  try {
    final userCredential1 = await firebaseAuth.createUserWithEmailAndPassword(
      email: 'admin@chorvayem.uz',
      password: 'admin123456',
    );

    await userCredential1.user!.updateDisplayName('Super Admin');

    await firestore.collection('admins').doc(userCredential1.user!.uid).set({
      'email': 'admin@chorvayem.uz',
      'name': 'Super Admin',
      'role': 'super_admin',
      'isActive': true,
      'createdAt': DateTime.now().toIso8601String(),
      'lastLogin': DateTime.now().toIso8601String(),
      'permissions': [
        'manage_users',
        'manage_products',
        'manage_orders',
        'view_analytics',
        'manage_admins',
      ],
    });

    print('✅ Super Admin yaratildi: admin@chorvayem.uz / admin123456');
  } catch (e) {
    print('❌ Super Admin yaratishda xatolik: $e');
  }

  // Admin 2: Manager
  try {
    final userCredential2 = await firebaseAuth.createUserWithEmailAndPassword(
      email: 'manager@chorvayem.uz',
      password: 'manager123456',
    );

    await userCredential2.user!.updateDisplayName('Manager');

    await firestore.collection('admins').doc(userCredential2.user!.uid).set({
      'email': 'manager@chorvayem.uz',
      'name': 'Manager',
      'role': 'admin',
      'isActive': true,
      'createdAt': DateTime.now().toIso8601String(),
      'lastLogin': DateTime.now().toIso8601String(),
      'permissions': [
        'manage_products',
        'manage_orders',
        'view_analytics',
      ],
    });

    print('✅ Manager yaratildi: manager@chorvayem.uz / manager123456');
  } catch (e) {
    print('❌ Manager yaratishda xatolik: $e');
  }

  print('\n🎉 Admin hisoblar yaratildi!');
  print('Web brauzerda loyihani ishga tushiring va admin hisoblar bilan kiring.');
}
