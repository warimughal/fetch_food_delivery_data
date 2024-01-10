// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_in_if_null_operators, unused_local_variable, prefer_final_fields, unused_field

import 'package:fetch_food_delivery_data/Screens/cartScreen.dart';
import 'package:fetch_food_delivery_data/Tabs/friesTab.dart';
import 'package:fetch_food_delivery_data/Tabs/hotwingsTab.dart';
import 'package:fetch_food_delivery_data/Tabs/pizzaTab.dart';
import 'package:fetch_food_delivery_data/Tabs/shawarmaTab.dart';
import 'package:fetch_food_delivery_data/Tabs/zingerburgerTab.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int selectedTabIndex = 0;
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  List<String> categories = [
    'Pizza',
    'Zinger Burger',
    'Fries',
    'Hotwings',
    'Shawarma',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    _tabController!.addListener(() {
      setState(() {
        selectedTabIndex = _tabController!.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Categories",
            style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CartScreen(),
                  ),
                );
              },
              icon: Icon(Icons.shopping_cart),
              color: Colors.black,
            ),
          ],
        ),
        backgroundColor: Colors.yellow,
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Choose Category',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value.toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search by Burgers, Pizza, etc.',
                        hintStyle: TextStyle(fontSize: 12),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(categories.length, (index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedTabIndex = index;
                      });
                    },
                    child: Card(
                      elevation: 2,
                      color: selectedTabIndex == index
                          ? Colors.yellow
                          : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: Text(
                          categories[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: selectedTabIndex == index
                                ? Colors.black
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  if (selectedTabIndex == 0) PizzaTab(searchQuery: searchQuery),
                  if (selectedTabIndex == 1)
                    ZingerBurgerTab(searchQuery: searchQuery),
                  if (selectedTabIndex == 2) FriesTab(searchQuery: searchQuery),
                  if (selectedTabIndex == 3)
                    HotWingsTab(searchQuery: searchQuery),
                  if (selectedTabIndex == 4)
                    ShawarmaTab(searchQuery: searchQuery),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
