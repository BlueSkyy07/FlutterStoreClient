import 'package:admin/pages/cart_manager.dart';
import 'package:admin/pages/cart_page.dart';
import 'package:admin/pages/cartnow_page.dart';
import 'package:admin/values/app_assets.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;

  // final Cart cart;
  ProductDetailPage({
    required this.productId,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late firebase_storage.Reference ref;
  List<String> docIDs = [];
  @override
  Widget build(BuildContext context) {
    CollectionReference products =
        FirebaseFirestore.instance.collection('Store');

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        items: [
          BottomNavigationBarItem(icon: Image.asset(AppAssets.home), label: ''),
          BottomNavigationBarItem(
              icon: Image.asset(AppAssets.favorite), label: ''),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CartPage()),
                );
              },
              child: Image.asset(AppAssets.cart),
            ),
            label: '',
          ),
          BottomNavigationBarItem(icon: Image.asset(AppAssets.chat), label: ''),
        ],
      ),
      body: FutureBuilder(
        future: products.doc(widget.productId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            String name = data['name'] ?? '';
            int price = data['price'] ?? '';
            String description = data['description'] ?? '';
            String imageUrl = data['imageLink'] ?? '';

            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 16),
                  // Hiển thị tên sản phẩm

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'Name: ',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: '$name',
                            style: TextStyle(fontSize: 18, color: Colors.black))
                      ])),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Hiển thị giá sản phẩm
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'Price: ',
                            style: TextStyle(fontSize: 18, color: Colors.red)),
                        TextSpan(
                            text: '$price VND',
                            style: TextStyle(fontSize: 18, color: Colors.black))
                      ])),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Hiển thị mô tả sản phẩm
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: RichText(
                            softWrap: true,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: 'Description: ',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.red)),
                              TextSpan(
                                  text: '$description',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black))
                            ])),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CartNowPage(
                                    name: name,
                                    price: price,
                                    urlImage: imageUrl,
                                  )));
                    },
                    child: Icon(Icons.shopping_cart_checkout_outlined),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add the current product to the cart
                      CartManager.addToCart(CartItem(
                        productId: widget.productId,
                        name: name,
                        price: price,
                        imageUrl: imageUrl,
                      ));
                      // Optionally, you can show a snackbar or navigate to the cart page
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Product added to cart'),
                        ),
                      );
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CartPage()));
                    },
                    child: Text('Thêm vào giỏ hàng'),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
