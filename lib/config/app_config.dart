class AppConfig {
  static const String appName = 'Shopping App';
  static const String apiBaseUrl = 'https://dummyjson.com';
  static const String appVersion = '1.0.0';
  static const int defaultPageSize = 10;
  static const String currencySymbol = '₹';
  
  // Local Storage Keys
  static const String cartKey = 'cart_items';
  static const String userKey = 'user_data';
  static const String settingsKey = 'app_settings';

  // API Endpoints
  static String productsEndpoint = '/products';
  static String productEndpoint(int id) => '/products/$id';
  static String categoryEndpoint(String category) => '/products/category/$category';
  static String searchEndpoint(String query) => '/products/search?q=$query';
}