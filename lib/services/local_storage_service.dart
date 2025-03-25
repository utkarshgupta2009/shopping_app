import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import 'json_service.dart';

class LocalStorageService {
  static const String cartKey = AppConfig.cartKey;

  Future<void> saveCart(List<CartItem> cartItems) async {
    final prefs = await SharedPreferences.getInstance();
    final cartItemsJson = cartItems.map((item) => {
      'product': {
        'id': item.product.id,
        'title': item.product.title,
        'description': item.product.description,
        'category': item.product.category,
        'price': item.product.price,
        'discountPercentage': item.product.discountPercentage,
        'rating': item.product.rating,
        'stock': item.product.stock,
        'tags': item.product.tags,
        'brand': item.product.brand,
        'sku': item.product.sku,
        'thumbnail': item.product.thumbnail,
        'images': item.product.images,
        'availabilityStatus': item.product.availabilityStatus,
      },
      'quantity': item.quantity,
    }).toList();
    
    await prefs.setString(cartKey, JsonService.encode({'cart': cartItemsJson}));
  }

  Future<List<CartItem>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString(cartKey);
    
    if (cartString == null) {
      return [];
    }
    
    try {
      final cartJson = JsonService.decode(cartString);
      final cartItemsList = (cartJson['cart'] as List).map((item) {
        final product = Product.fromJson(item['product']);
        return CartItem(
          product: product,
          quantity: item['quantity'],
        );
      }).toList();
      
      return cartItemsList;
    } catch (e) {
      return [];
    }
  }

  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(cartKey);
  }
}