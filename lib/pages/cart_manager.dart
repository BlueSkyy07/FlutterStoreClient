class CartManager {
  static List<CartItem> cartItems = [];

  static void addToCart(CartItem item) {
    cartItems.add(item);
  }
}

class CartItem {
  final String productId;
  final String name;
  final int price;
  final String imageUrl;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}
