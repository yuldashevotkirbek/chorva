class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email kiriting';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'To\'g\'ri email kiriting';
    }
    
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Parol kiriting';
    }
    
    if (value.length < 6) {
      return 'Parol kamida 6 belgi bo\'lishi kerak';
    }
    
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ism kiriting';
    }
    
    if (value.length < 2) {
      return 'Ism kamida 2 belgi bo\'lishi kerak';
    }
    
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefon raqam kiriting';
    }
    
    final phoneRegex = RegExp(r'^\+998[0-9]{9}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'To\'g\'ri telefon raqam kiriting (+998XXXXXXXXX)';
    }
    
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName kiriting';
    }
    
    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Parolni tasdiqlang';
    }
    
    if (value != password) {
      return 'Parollar mos kelmaydi';
    }
    
    return null;
  }
}
