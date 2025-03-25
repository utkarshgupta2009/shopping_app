import 'package:intl/intl.dart';
import '../config/app_config.dart';

class PriceUtils {
  static final NumberFormat _currencyFormat = NumberFormat.currency(symbol: AppConfig.currencySymbol);

  static String formatPrice(double price) {
    return _currencyFormat.format(price);
  }

  static double calculateDiscountedPrice(double originalPrice, double discountPercentage) {
    return originalPrice - (originalPrice * discountPercentage / 100);
  }

  static double calculateTotalPrice(double price, int quantity) {
    return price * quantity;
  }
}