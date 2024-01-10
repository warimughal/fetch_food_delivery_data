// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'dart:async';

import 'package:fetch_food_delivery_data/Screens/homeScreen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.black,
                child: Text(
                  "FD",
                  style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 20,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
            SizedBox(width: 4),
            Text(
              "Online Food Delivery",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
