import 'package:admin/pages/product_detail_page.dart';
import 'package:admin/read%20data/get_product_image.dart';
import 'package:admin/read%20data/get_product_name.dart';
import 'package:admin/read%20data/get_product_price.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FindPage extends StatefulWidget {
  final String timkiem;

  FindPage({Key? key, required this.timkiem}) : super(key: key);

  @override
  State<FindPage> createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
  List<String> docIDs = [];

  Future getDocId() async {
    // print("Matching DocIDs: ${widget.timkiem}");

    await FirebaseFirestore.instance
        .collection('Store')
        .where('name', isEqualTo: widget.timkiem)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        print(element.reference);
        docIDs.add(element.reference.id);
      });
      // print("Matching DocIDs: $docIDs");
    });
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
      backgroundColor: Color.fromARGB(255, 208, 249, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 109, 130, 221),
        elevation: 0,
        title: Text(
          "Tìm kiếm",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
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
    );
  }
}
