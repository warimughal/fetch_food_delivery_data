// ignore_for_file: prefer_const_constructors, file_names, avoid_print, unused_element, unused_local_variable, unnecessary_brace_in_string_interps, dead_code, prefer_const_literals_to_create_immutables, unnecessary_cast, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int totalCartPrice = 0; // Change to double

  @override
  void initState() {
    super.initState();
    _calculateTotalPrice(); // Initialize totalCartPrice
  }

  Future<void> _deleteCartItem(String documentId) async {
    try {
      await _firestore.collection("cart").doc(documentId).delete();
    } catch (e) {
      print("Error deleting item from Firestore: $e");
    }
  }

  Future<void> _updateCartItemQuantity(
      String documentId, int newQuantity) async {
    try {
      await _firestore
          .collection("cart")
          .doc(documentId)
          .update({"quantity": newQuantity});
    } catch (e) {
      print("Error updating item quantity in Firestore: $e");
    }
  }

  void _calculateTotalPrice() {
    int totalPrice = 0;

    // Retrieve the cart items and calculate the total price
    _firestore.collection("cart").get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        var data = doc.data() as Map<String, dynamic>;
        var quantity = data['quantity'] ?? 1;
        var productPrice = data['productPrice'];

        try {
          int itemPrice =
              quantity * int.parse(productPrice); // Change to double
          totalPrice += itemPrice;
        } catch (e) {
          print("Error parsing productPrice: $e");
        }
      });

      setState(() {
        totalCartPrice = totalPrice;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Cart",
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black),
        ),
        automaticallyImplyLeading: true,
      ),
      backgroundColor: Colors.yellow,
      body: StreamBuilder(
        stream: _firestore.collection("cart").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Something went wrong"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Cart is empty"));
          }

          // Calculate the total price here
          int totalCartPrice = 0; // Initialize to 0
          snapshot.data!.docs.forEach((doc) {
            var data = doc.data() as Map<String, dynamic>;
            var quantity = data['quantity'] ?? 1;
            var productPrice = data['productPrice'];

            try {
              int itemPrice = quantity * int.parse(productPrice);
              totalCartPrice += itemPrice;
            } catch (e) {
              print("Error parsing productPrice: $e");
            }
          });

          return Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    var data = doc.data() as Map<String, dynamic>;
                    var documentId = doc.id;
                    var imageUrl = data['imageUrl'];
                    var productName = data['productName'];

                    var quantity = data['quantity'] ?? 1;
                    var productPrice = data['productPrice'];
                    var subtotal = 0;
                    try {
                      subtotal = quantity * int.parse(productPrice);
                    } catch (e) {
                      print("Error parsing productPrice: $e");
                    }

                    return ListTile(
                      title: Text(productName),
                      subtitle: Text(productPrice),
                      leading: Image.network(imageUrl),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              if (quantity > 1) {
                                _updateCartItemQuantity(
                                    documentId, quantity - 1);
                              }
                            },
                          ),
                          Text(quantity.toString()),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              _updateCartItemQuantity(documentId, quantity + 1);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteCartItem(documentId);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Total Price: \$${totalCartPrice}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
