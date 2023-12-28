import 'package:flutter/material.dart';

class Cart {
  List<Map<String, dynamic>> products = [];

  void addProduct(String productId, String productName, int price) {
    // Kiểm tra xem sản phẩm đã tồn tại trong giỏ hàng chưa
    int existingIndex = products.indexWhere((item) => item['id'] == productId);

    if (existingIndex != -1) {
      // Nếu sản phẩm đã tồn tại, tăng số lượng
      products[existingIndex]['quantity']++;
    } else {
      // Nếu sản phẩm chưa tồn tại, thêm mới vào giỏ hàng
      products.add({
        'id': productId,
        'name': productName,
        'price': price,
        'quantity': 1,
      });
    }
  }

  void removeProduct(String productId) {
    products.removeWhere((item) => item['id'] == productId);
  }
}

class CartPage extends StatelessWidget {
  final Cart cart;
  CartPage({Key? key, required this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: ListView.builder(
        itemCount: cart.products.length, // Sửa đổi ở đây
        itemBuilder: (context, index) {
          final product = cart.products[index];
          return ListTile(
            title: Text('Product ID: ${product['id']}'),
            subtitle: Text('Name: ${product['name']}'),
            trailing: Text('Quantity: ${product['quantity']}'),
            // Thêm các thông tin sản phẩm khác tùy thuộc vào cần thiết
          );
        },
      ),
    );
  }
}
