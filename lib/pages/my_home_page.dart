import 'package:admin/pages/cart_page.dart';
import 'package:admin/pages/product_detail_page.dart';
import 'package:admin/pages/timkiem_page.dart';
import 'package:admin/read%20data/get_product_image.dart';
import 'package:admin/read%20data/get_product_name.dart';
import 'package:admin/read%20data/get_product_price.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:admin/values/app_assets.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final user = FirebaseAuth.instance.currentUser!;

  List<String> docIDs = [];
  String searchQuery = '';
  final _timkiem = TextEditingController();

  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('Store')
        .get()
        .then((snapshot) => snapshot.docs.forEach((element) {
              print(element.reference);
              docIDs.add(element.reference.id);
            }));
  }

  Future<void> updateProducts() async {
    docIDs.clear();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromARGB(255, 208, 249, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 109, 130, 221),
        elevation: 0,
        leading: InkWell(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Image.asset(AppAssets.admin),
        ),
        title: Text(
          "Minh Thái",
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Center(
              child: Container(
                child: Text(
                  'Xin chào!' + user.email!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MaterialButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 145, 115, 202),
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      "Sign out",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        items: [
          BottomNavigationBarItem(icon: Image.asset(AppAssets.home), label: ''),
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
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Stack(
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: TextField(
                        controller: _timkiem,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Nhập từ tìm kiếm'),
                      ),
                    )),
                Positioned(
                    right: 0,
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => FindPage(
                                      timkiem: _timkiem.text.trim(),
                                    )),
                          );
                        },
                        icon: Icon(Icons.search)))
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await updateProducts();
              },
              child: FutureBuilder(
                future: getDocId(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: docIDs.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailPage(
                                  productId: docIDs[index],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black38,
                                  offset: Offset(2, 3),
                                  blurRadius: 3,
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 130,
                                  width: double.infinity,
                                  child: GetProductImage(
                                    documentId: docIDs[index],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  alignment: Alignment.bottomLeft,
                                  child: GetProductName(
                                    documentId: docIDs[index],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 5),
                                  alignment: Alignment.bottomLeft,
                                  child: GetProductPrice(
                                    documentId: docIDs[index],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
