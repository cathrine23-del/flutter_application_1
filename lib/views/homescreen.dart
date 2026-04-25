import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Ensure GetX is imported
import 'package:flutter_application_1/views/dashboard.dart';
import 'package:flutter_application_1/views/profile.dart';
import 'package:flutter_application_1/views/list.dart';
import 'package:flutter_application_1/views/category.dart';
import 'package:flutter_application_1/views/cart.dart';
import 'package:flutter_application_1/controller/cart controller.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int currentIndex = 0;

  // 1. START THE CONTROLLER
  // This makes the cart list live and accessible to the whole app
  final CartController cartController = Get.put(CartController());

  // 2. UPDATED PAGE BUILDER
  Widget getActivePage(int index) {
    switch (index) {
      case 0:
        return Dashboard();
      case 1:
        // Now using the controller method internally
        return const listpage();
      case 2:
        return const Category();
      case 3:
        return const Profile();
      case 4:
        // The Cart page will now pull from cartController.cartItems
        return const Cart();
      default:
        return Dashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body updates whenever currentIndex changes
      body: getActivePage(currentIndex),
      bottomNavigationBar: CurvedNavigationBar(
        index: currentIndex,
        backgroundColor: Colors.transparent,
        color: Colors.deepOrange,
        buttonBackgroundColor: Colors.deepOrange,
        height: 60,
        items: const <Widget>[
          Icon(Icons.dashboard, size: 30, color: Colors.white),
          Icon(Icons.list, size: 30, color: Colors.white),
          Icon(Icons.category, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
          Icon(Icons.shopping_cart, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
