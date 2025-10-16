import 'package:flutter/foundation.dart';

class PlatformUtils {
  static bool get isWeb => kIsWeb;
  static bool get isMobile => !kIsWeb;
  static bool get isAdmin => kIsWeb;
  static bool get isUser => !kIsWeb;
}
