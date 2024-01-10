// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, use_key_in_widget_constructors, unused_local_variable, unnecessary_null_in_if_null_operators, prefer_const_constructors_in_immutables, file_names, sized_box_for_whitespace, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FriesTab extends StatefulWidget {
  final String searchQuery; // Accept the search query as a parameter

  FriesTab({required this.searchQuery});

  @override
  _FriesTabState createState() => _FriesTabState();
}

class _FriesTabState extends State<FriesTab> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Function to show the product details dialog
  void _showProductDetailsDialog(
      String imageUrl, String productName, String productDescription) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: 300,
            height: 400,
            child: AlertDialog(
              backgroundColor: Colors.yellow,
              title: Center(child: Text(productName)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(
                    imageUrl,
                    width: 200,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10),
                  Text(productDescription),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Add cart item
  Future<void> _addItemToFirestore(
      String imageUrl, String productName, String productPrice) async {
    try {
      await _firestore.collection("cart").add({
        "imageUrl": imageUrl,
        "productName": productName,
        "productPrice": productPrice,
      });
    } catch (e) {
      print("Error adding item to Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.collection("fries").snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No Data Found"));
        }

        // Define filteredData based on the searchQuery
        var filteredData = snapshot.data!.docs.where((doc) {
          var snapshotData = doc.data() as Map<String, dynamic>;
          var productName =
              snapshotData['productName'].toString().toLowerCase();
          return productName.contains(widget.searchQuery.toLowerCase());
        }).toList();

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12.0,
            mainAxisExtent: 200,
            crossAxisSpacing: 12.0,
            childAspectRatio: 0.8,
          ),
          itemCount: filteredData.length,
          itemBuilder: (context, index) {
            var snapshotData =
                filteredData[index].data() as Map<String, dynamic>;

            var selectedOption = snapshotData['selectedOption'] ?? "No Option";
            var imageUrl = snapshotData['imageUrl'] ?? null;
            var productName = snapshotData['productName'] ?? "No Name";
            var productPrice = snapshotData['productPrice'] ?? "No Price";
            var productDescription =
                snapshotData['productDescription'] ?? "No Description";

            return GestureDetector(
                onTap: () {
                  _showProductDetailsDialog(
                      imageUrl, productName, productDescription);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      children: [
                        imageUrl != null
                            ? Image.network(
                                imageUrl,
                                width: 150,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : CircleAvatar(radius: 50),
                        ListTile(
                          title: Center(
                            child: Text(
                              productName,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              SizedBox(width: 15),
                              Text(
                                productPrice,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 35),
                              IconButton(
                                icon: Icon(Icons.shopping_cart),
                                onPressed: () {
                                  _addItemToFirestore(
                                      imageUrl, productName, productPrice);
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          },
        );
      },
    );
  }
}
