// lib/core/utils/formatters.dart
import 'package:intl/intl.dart';

class AppFormatters {
  static String currency(double amount, {String symbol = '₨', int decimals = 0}) {
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimals,
    );
    return formatter.format(amount);
  }

  static String currencyCompact(double amount, {String symbol = '₨'}) {
    if (amount >= 10000000) {
      return '$symbol${(amount / 10000000).toStringAsFixed(2)} Cr';
    } else if (amount >= 100000) {
      return '$symbol${(amount / 100000).toStringAsFixed(2)} L';
    } else if (amount >= 1000) {
      return '$symbol${(amount / 1000).toStringAsFixed(1)} K';
    }
    return '$symbol${amount.toStringAsFixed(0)}';
  }

  static String date(DateTime date, {String format = 'dd MMM yyyy'}) =>
      DateFormat(format).format(date);

  static String dateTime(DateTime date) =>
      DateFormat('dd MMM yyyy, hh:mm a').format(date);

  static String monthYear(DateTime date) => DateFormat('MMMM yyyy').format(date);

  static String shortDate(DateTime date) => DateFormat('dd MMM').format(date);

  static String relativeDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return AppFormatters.date(date);
  }

  static String fileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  static String monthName(int month) =>
      DateFormat('MMMM').format(DateTime(2024, month));

  static String shortMonthName(int month) =>
      DateFormat('MMM').format(DateTime(2024, month));
}

// lib/core/utils/constants.dart

class AppConstants {
  static const List<String> assetTypes = [
    'gold', 'silver', 'cash', 'land', 'business', 'vehicle', 'other'
  ];

  static const Map<String, String> assetTypeLabels = {
    'gold': 'Gold',
    'silver': 'Silver',
    'cash': 'Cash & Savings',
    'land': 'Land & Property',
    'business': 'Business Assets',
    'vehicle': 'Vehicle',
    'other': 'Other',
  };

  static const Map<String, String> assetTypeIcons = {
    'gold': '🥇',
    'silver': '🥈',
    'cash': '💵',
    'land': '🏠',
    'business': '🏢',
    'vehicle': '🚗',
    'other': '📦',
  };

  static const List<String> liabilityTypes = [
    'loan_taken', 'loan_given', 'committee', 'debt'
  ];

  static const Map<String, String> liabilityTypeLabels = {
    'loan_taken': 'Loan Taken',
    'loan_given': 'Loan Given',
    'committee': 'Committee',
    'debt': 'Debt',
  };

  static const List<String> paymentMethods = ['cash', 'bank', 'mobile_wallet'];

  static const Map<String, String> paymentMethodLabels = {
    'cash': 'Cash',
    'bank': 'Bank Transfer',
    'mobile_wallet': 'Mobile Wallet (JazzCash/Easypaisa)',
  };

  static const Map<String, String> paymentMethodIcons = {
    'cash': '💵',
    'bank': '🏦',
    'mobile_wallet': '📱',
  };
}

// lib/core/utils/validators.dart

class AppValidators {
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    return null;
  }

  static String? amount(String? value) {
    if (value == null || value.trim().isEmpty) return 'Amount is required';
    final parsed = double.tryParse(value.replaceAll(',', ''));
    if (parsed == null) return 'Enter a valid number';
    if (parsed <= 0) return 'Amount must be greater than 0';
    if (parsed > 999999999999) return 'Amount is too large';
    return null;
  }

  static String? pin(String? value) {
    if (value == null || value.isEmpty) return 'PIN is required';
    if (value.length != 4 && value.length != 6) return 'PIN must be 4 or 6 digits';
    if (!RegExp(r'^\d+$').hasMatch(value)) return 'PIN must contain only numbers';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return null; // optional
    if (!RegExp(r'^03\d{9}$').hasMatch(value.trim())) {
      return 'Enter a valid Pakistani number (03XXXXXXXXX)';
    }
    return null;
  }
}
