import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../utils/animated_route.dart';
import '../utils/error_handler.dart';
import '../widgets/category_filter.dart';
import '../widgets/loading_widget.dart';
import '../widgets/product_card.dart';
import '../widgets/search_bar.dart';
import 'cart_screen.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  int currentPage = 0;
  final int itemsPerPage = 10;
  String? selectedCategory;
  String searchText = '';
  bool isLoadingMore = false;
  bool isFirstLoad = true;
  final List<String> categories = ['beauty', 'fragrances', 'furniture', 'groceries'];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productsParamsProvider.notifier).state = {
        'skip': 0,
        'limit': itemsPerPage,
        'category': null,
      };
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9 &&
        !isLoadingMore) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (isLoadingMore) return;

    final totalProducts = ref.read(productsProvider).valueOrNull?.total ?? 0;
    final displayedProducts = ref.read(allProductsProvider);

    if (displayedProducts.length >= totalProducts) return;

    setState(() {
      isLoadingMore = true;
    });

    try {
      ref.read(productsParamsProvider.notifier).state = {
        'skip': (currentPage + 1) * itemsPerPage,
        'limit': itemsPerPage,
        'category': selectedCategory,
      };
      currentPage++;
    } catch (e) {
      log('Error loading more products: $e');
    } finally {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  void _resetAndRefresh() {
    setState(() {
      currentPage = 0;
      isFirstLoad = true;
    });

    ref.invalidate(productsProvider);
    ref.read(productsParamsProvider.notifier).state = {
      'skip': 0,
      'limit': itemsPerPage,
      'category': selectedCategory,
    };
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final productsAsyncValue = ref.watch(productsProvider);
    final displayedProducts = ref.watch(allProductsProvider);
    final totalQuantity = ref.watch(cartProvider.notifier).totalQuantity;


    final filteredProducts = searchText.isNotEmpty
        ? displayedProducts.where(
            (product) =>
                product.title.toLowerCase().contains(searchText.toLowerCase()) ||
                product.brand.toLowerCase().contains(searchText.toLowerCase()),
          ).toList()
        : displayedProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue'),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              SizedBox(
                width: 50,
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      SlideRightRoute(
                        page: const CartScreen(),
                      ),
                    );
                  },
                ),
              ),
              if (cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$totalQuantity',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          CategoryFilter(
            categories: categories,
            selectedCategory: selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                selectedCategory = category;
              });

              ref.invalidate(productsProvider);
              ref.read(productsParamsProvider.notifier).state = {
                'skip': 0,
                'limit': itemsPerPage,
                'category': category,
              };
            },
          ),
          ProductSearchBar(
            searchText: searchText,
            onSearch: (value) {
              setState(() {
                searchText = value;
              });
            },
            onClear: () {
              setState(() {
                searchText = '';
              });
            },
          ),
          Expanded(
            child: productsAsyncValue.when(
              data: (_) => _buildProductGrid(filteredProducts),
              loading: () => displayedProducts.isEmpty
                  ? const LoadingWidget(message: 'Loading products...')
                  : _buildProductGrid(filteredProducts),
              error: (error, stackTrace) => ErrorHandler.buildErrorWidget(
                'Failed to load products: ${ErrorHandler.getErrorMessage(error)}',
                () {
                  ref.invalidate(productsProvider);
                  _resetAndRefresh();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List<dynamic> products) {
    if (products.isEmpty) {
      return const Center(child: Text('No products found'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        _resetAndRefresh();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: products.length + (isLoadingMore ? 1 : 0), // Add extra item for loader
            itemBuilder: (context, index) {
              if (index == products.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final product = products[index];
              return ProductCard(product: product);
            },
          ),
        ],
      ),
    );
  }
}
