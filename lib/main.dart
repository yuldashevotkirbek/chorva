import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'constants/app_constants.dart';
import 'providers/auth_provider.dart';
import 'services/admin_auth_service.dart';
import 'screens/splash_screen.dart';
import 'screens/admin/admin_login_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'utils/platform_utils.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize services
  final authProvider = AuthProvider();
  final adminAuthService = AdminAuthService();
  
  if (PlatformUtils.isWeb) {
    await adminAuthService.initialize();
  } else {
    await authProvider.initialize();
  }
  
  runApp(ChorvaYemApp(
    authProvider: authProvider,
    adminAuthService: adminAuthService,
  ));
}

class ChorvaYemApp extends StatelessWidget {
  final AuthProvider authProvider;
  final AdminAuthService adminAuthService;
  
  const ChorvaYemApp({
    super.key,
    required this.authProvider,
    required this.adminAuthService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: adminAuthService),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: PlatformUtils.isWeb ? Colors.blue : Colors.green,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: PlatformUtils.isWeb ? Colors.blue : Colors.green,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: PlatformUtils.isWeb ? Colors.blue : Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        home: PlatformUtils.isWeb 
            ? Consumer<AdminAuthService>(
                builder: (context, adminAuthService, child) {
                  if (adminAuthService.isLoggedIn) {
                    return const AdminDashboardScreen();
                  } else {
                    return const AdminLoginScreen();
                  }
                },
              )
            : const SplashScreen(),
      ),
    );
  }
}
