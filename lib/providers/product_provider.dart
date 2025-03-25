import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService();
});

final productsParamsProvider = StateProvider<Map<String, dynamic>>((ref) {
  return {
    'skip': 0,
    'limit': 10,
    'category': null,
  };
});

final allProductsProvider = StateNotifierProvider<ProductsNotifier, List<Product>>((ref) {
  return ProductsNotifier();
});

final imageIndexProvider = StateProvider.autoDispose.family<int, int>((ref, productId) => 0);

class ProductsNotifier extends StateNotifier<List<Product>> {
  ProductsNotifier() : super([]);
  
  void addProducts(List<Product> products, bool reset) {
    if (reset) {
      state = products;
    } else {
      final existingIds = state.map((p) => p.id).toSet();
      final newProducts = products.where((p) => !existingIds.contains(p.id)).toList();
      state = [...state, ...newProducts];
    }
  }
  
  void clearProducts() {
    state = [];
  }
}

final productsProvider = AutoDisposeFutureProvider<ApiResponse>((ref) async {
  final productService = ref.watch(productServiceProvider);
  final params = ref.watch(productsParamsProvider);
  

  
  final response = await productService.getProducts(
    limit: params['limit'] ?? 10,
    skip: params['skip'] ?? 0,
    category: params['category'],
  );
  
  final bool isFirstPage = (params['skip'] ?? 0) == 0;
  ref.read(allProductsProvider.notifier).addProducts(response.products, isFirstPage);
  
  return response;
});

final productDetailsProvider = FutureProvider.family<Product, int>((ref, productId) async {
  final productService = ref.watch(productServiceProvider);
  return await productService.getProductById(productId);
});

