import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartNowPage extends StatefulWidget {
  final String name;
  final int price;
  final String urlImage;

  CartNowPage(
      {Key? key,
      required this.name,
      required this.price,
      required this.urlImage})
      : super(key: key);

  @override
  State<CartNowPage> createState() => _CartNowPageState();
}

class _CartNowPageState extends State<CartNowPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final _addressController = TextEditingController();
  int sl = 0;
  String name = '';
  int price = 0;
  void increment() {
    setState(() {
      sl++;
    });
  }

  void decrement() {
    if (sl > 0) {
      setState(() {
        sl--;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    name = widget.name;
    price = widget.price;
  }

  Future dathang() async {
    thongtin(name, price, sl, (price * sl), _addressController.text.trim(),
        user.email!);
  }

  Future thongtin(String name, int gia, int sl, int thanhtien, String diachi,
      String email) async {
    await FirebaseFirestore.instance.collection('order').add({
      'name': name,
      'gia': gia,
      'soluong': sl,
      'tongtien': thanhtien,
      'diachi': diachi,
      'email': email,
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sử dụng giá trị `name` ở đây
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Now'),
      ),
      body: Center(
          child: Column(
        children: [
          Container(
            child: Image.network(
              widget.urlImage,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: 'Name: ',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)),
            TextSpan(
                text: '${widget.name}',
                style: TextStyle(fontSize: 18, color: Colors.black))
          ])),
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: 'Price: ',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                    fontWeight: FontWeight.bold)),
            TextSpan(
                text: '${widget.price}',
                style: TextStyle(fontSize: 18, color: Colors.black))
          ])),
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Số lượng:  ',
                style: TextStyle(fontSize: 20),
              ),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: decrement,
              ),
              SizedBox(height: 20),
              Text(
                '$sl',
                style: TextStyle(fontSize: 20),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: increment,
              ),
            ],
          )),
          Text(
            'Địa chỉ giao hàng: ',
            style: TextStyle(fontSize: 18),
          ),
          // Text(user.email!),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: TextField(
                    controller: _addressController,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Địa chỉ'),
                  ),
                )),
          ),
          ElevatedButton(
              onPressed: () {
                dathang();
              },
              child: Text('Đặt hàng'))
        ],
      )),
    );
  }
}
