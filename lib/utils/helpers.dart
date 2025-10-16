import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class Helpers {
  static String formatPrice(double price) {
    final formatter = NumberFormat('#,##0', 'uz_UZ');
    return '${formatter.format(price)} ${AppConstants.currencySymbol}';
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
  }

  static String formatWeight(double weight) {
    if (weight >= 1000) {
      return '${(weight / 1000).toStringAsFixed(1)} tonna';
    }
    return '${weight.toStringAsFixed(1)} kg';
  }

  static String getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.isEmpty) return '';
    
    if (words.length == 1) {
      return words[0].substring(0, 1).toUpperCase();
    }
    
    return '${words[0].substring(0, 1)}${words[1].substring(0, 1)}'.toUpperCase();
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  static String getOrderStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Kutilmoqda';
      case 'confirmed':
        return 'Tasdiqlangan';
      case 'preparing':
        return 'Tayyorlanmoqda';
      case 'ready':
        return 'Tayyor';
      case 'on_delivery':
        return 'Yetkazilmoqda';
      case 'delivered':
        return 'Yetkazilgan';
      case 'cancelled':
        return 'Bekor qilingan';
      default:
        return status;
    }
  }

  static String getPaymentMethodText(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return 'Naqd pul';
      case 'card':
        return 'Karta orqali';
      case 'bank_transfer':
        return 'Bank o\'tkazmasi';
      case 'digital_wallet':
        return 'Raqamli hamyon';
      default:
        return method;
    }
  }

  static double calculateDeliveryFee(double subtotal) {
    if (subtotal >= AppConstants.freeDeliveryThreshold) {
      return 0;
    }
    return AppConstants.defaultDeliveryFee;
  }

  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} kun oldin';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} soat oldin';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} daqiqa oldin';
    } else {
      return 'Hozir';
    }
  }

  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\+998[0-9]{9}$');
    return phoneRegex.hasMatch(phone);
  }

  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String formatPhoneNumber(String phone) {
    if (phone.startsWith('+998')) {
      return phone;
    }
    if (phone.startsWith('998')) {
      return '+$phone';
    }
    if (phone.startsWith('8')) {
      return '+998${phone.substring(1)}';
    }
    return '+998$phone';
  }
}
