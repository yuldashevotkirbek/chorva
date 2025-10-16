class AppConstants {
  // App Information
  static const String appName = 'Chorva Yem';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.chorvayem.uz';
  static const String apiVersion = '/v1';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String cartDataKey = 'cart_data';
  static const String languageKey = 'language';
  static const String themeKey = 'theme';
  
  // Default Values
  static const double defaultDeliveryFee = 50000.0; // 50,000 so'm
  static const double freeDeliveryThreshold = 500000.0; // 500,000 so'm
  static const int maxCartItems = 50;
  static const int defaultPageSize = 20;
  
  // Delivery Time
  static const int minDeliveryTime = 2; // hours
  static const int maxDeliveryTime = 24; // hours
  
  // Image Configuration
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  
  // Currency
  static const String currency = 'UZS';
  static const String currencySymbol = 'so\'m';
  
  // Categories
  static const List<String> mainCategories = [
    'Qoramol yemi',
    'Qo\'y yemi',
    'Tovuq yemi',
    'Baliq yemi',
    'Vitaminlar',
    'Mineral moddalar',
    'O\'simlik o\'g\'itlari',
  ];
  
  // Units
  static const List<String> productUnits = [
    'kg',
    'tonna',
    'quti',
    'paket',
    'litr',
  ];
  
  // Order Status Colors
  static const Map<String, int> orderStatusColors = {
    'pending': 0xFFFF9800, // Orange
    'confirmed': 0xFF2196F3, // Blue
    'preparing': 0xFF9C27B0, // Purple
    'ready': 0xFF4CAF50, // Green
    'onDelivery': 0xFF3F51B5, // Indigo
    'delivered': 0xFF4CAF50, // Green
    'cancelled': 0xFFF44336, // Red
  };
  
  // Payment Methods
  static const Map<String, String> paymentMethods = {
    'cash': 'Naqd pul',
    'card': 'Karta orqali',
    'bankTransfer': 'Bank o\'tkazmasi',
    'digitalWallet': 'Raqamli hamyon',
  };
  
  // Error Messages
  static const String networkError = 'Internet aloqasi yo\'q';
  static const String serverError = 'Server xatoligi';
  static const String unknownError = 'Noma\'lum xatolik';
  static const String invalidCredentials = 'Noto\'g\'ri ma\'lumotlar';
  static const String userNotFound = 'Foydalanuvchi topilmadi';
  static const String productNotFound = 'Mahsulot topilmadi';
  static const String orderNotFound = 'Buyurtma topilmadi';
  
  // Success Messages
  static const String loginSuccess = 'Muvaffaqiyatli kirildi';
  static const String registerSuccess = 'Muvaffaqiyatli ro\'yxatdan o\'tildi';
  static const String orderPlaced = 'Buyurtma muvaffaqiyatli berildi';
  static const String profileUpdated = 'Profil yangilandi';
  static const String passwordChanged = 'Parol o\'zgartirildi';
}
