# E-Commerce App

A Flutter e-commerce application with shopping cart functionality.

## Features

- Display products from API with pagination
- Add products to cart
- Update quantity of products in cart
- Calculate total price in cart
- Persistent cart using shared preferences
- Discount price calculation
- Category filtering
- Search functionality
- Product details view

## Project Structure

- `lib/models/` - Data models
- `lib/providers/` - Riverpod state management
- `lib/screens/` - App screens
- `lib/services/` - API and storage services
- `lib/theme/` - App theme
- `lib/utils/` - Utility functions
- `lib/widgets/` - Reusable UI components

## How to Run

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

## Dependencies

- flutter_riverpod: ^2.3.6
- http: ^1.1.0
- cached_network_image: ^3.2.3
- intl: ^0.18.1
- shared_preferences: ^2.2.0

## API

The app uses [DummyJSON](https://dummyjson.com/products) for product data.

## Screenshots

### Catalog Screen

The main screen showing products grid with category filters and search functionality.
![2](https://github.com/user-attachments/assets/552324e1-9b4a-408f-b5df-15d6e9f9b878)

### Cart Screen

Shows all items added to cart with quantity controls and total price.
![3](https://github.com/user-attachments/assets/a7ea898e-231a-4454-bd07-6e083d9222fc)

### Product Details Screen

Detailed view of a product with its images, description, and specifications.
![1](https://github.com/user-attachments/assets/4515f4d3-7565-4051-84d5-27f78b460743)
