import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/dashboard.dart';
import 'package:flutter_application_1/views/profile.dart';
import 'package:flutter_application_1/views/list.dart';
import 'package:flutter_application_1/views/category.dart';
import 'package:flutter_application_1/views/cart.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int currentIndex = 0;

  final List pages = [
    Dashboard(),
    listpage(),
    Category(),
    Profile(),
    Cart(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.deepOrange,
          items: <Widget>[
            Icon(Icons.dashboard, size: 30),
            Icon(Icons.list, size: 30),
            Icon(Icons.category, size: 30),
            Icon(Icons.person, size: 30),
            Icon(Icons.shopping_cart, size: 30),
          ],
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          }),
    );
  }
}
