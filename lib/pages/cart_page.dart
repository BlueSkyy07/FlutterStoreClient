import 'package:flutter/material.dart';
import 'cart_manager.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Shopping Cart'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: CartManager.cartItems.length,
                itemBuilder: (context, index) {
                  CartItem item = CartManager.cartItems[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('${item.price} VND'),
                    leading: Image.network(item.imageUrl),
                    // Add more information or actions as needed
                  );
                },
              ),
            ),
            ElevatedButton(onPressed: () {}, child: Text('dat hang'))
          ],
        ));
  }
}
