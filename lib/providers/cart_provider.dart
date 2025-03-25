import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../services/local_storage_service.dart';

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  final localStorageService = ref.watch(localStorageServiceProvider);
  return CartNotifier(localStorageService);
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  final LocalStorageService _localStorageService;

  CartNotifier(this._localStorageService) : super([]) {
    _loadCart();
  }

  Future<void> _loadCart() async {
    final cartItems = await _localStorageService.getCart();
    state = cartItems;
  }

  Future<void> _saveCart() async {
    await _localStorageService.saveCart(state);
  }

  void addToCart(Product product) {
    final existingIndex = state.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      final updatedCart = [...state];
      updatedCart[existingIndex] = updatedCart[existingIndex].copyWith(
        quantity: updatedCart[existingIndex].quantity + 1,
      );
      state = updatedCart;
    } else {
      state = [...state, CartItem(product: product, quantity: 1)];
    }
    _saveCart();
  }

  void removeFromCart(int productId) {
    state = state.where((item) => item.product.id != productId).toList();
    _saveCart();
  }

  void incrementQuantity(int productId) {
    state = state.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: item.quantity + 1);
      }
      return item;
    }).toList();
    _saveCart();
  }

  void decrementQuantity(int productId) {
    state = state.map((item) {
      if (item.product.id == productId && item.quantity > 1) {
        return item.copyWith(quantity: item.quantity - 1);
      }
      return item;
    }).toList();
    _saveCart();
  }

  double get totalAmount {
    return state.fold(0, (total, item) => total + item.totalPrice);
  }

  int get totalQuantity {
    return state.fold(0, (total, item) => total + item.quantity);
  }

  void clearCart() {
    state = [];
    _localStorageService.clearCart();
  }
}
