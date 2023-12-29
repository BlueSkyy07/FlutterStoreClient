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
  int sl = 1;
  String name = '';
  int price = 0;
  List<String> docIDs = [];
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

  Future<void> _showOrderSuccessDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Đặt hàng thành công'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Cảm ơn bạn đã đặt hàng!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // Điều hướng về trang trước đó
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pop(); // Đối với trình tự điều hướng của bạn
              },
            ),
          ],
        );
      },
    );
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
      'trangthai': 0
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Image.network(
                widget.urlImage,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),

            Text('${widget.name}',
                style: TextStyle(fontSize: 20, color: Colors.black)),
            SizedBox(height: 10),

            Text('${widget.price} VND',
                style: TextStyle(fontSize: 16, color: Colors.red)),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
            SizedBox(height: 10),

            Text(
              'Địa chỉ giao hàng: ',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),

            // Text(user.email!),
            Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Địa chỉ'),
                  ),
                )),
            SizedBox(height: 20),

            ElevatedButton(
                onPressed: () {
                  dathang();
                  _showOrderSuccessDialog();
                },
                child: Text('Đặt hàng'))
          ],
        ),
      ),
    );
  }
}
