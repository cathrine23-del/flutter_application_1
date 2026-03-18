import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class Category extends StatelessWidget {
  const Category({super.key});

  @override
  Widget categoryCard(IconData icon, String title) {
    return Container(
      width: 150,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: const Text("Categories"),
          onTap: () {
            Get.offAllNamed("/category");
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [
            categoryCard(Icons.local_pizza, "Pizza"),
            categoryCard(Icons.lunch_dining, "Burger"),
            categoryCard(Icons.fastfood, "Fries"),
            categoryCard(Icons.local_drink, "Drinks"),
            categoryCard(Icons.icecream, "Desserts"),
            categoryCard(Icons.ramen_dining, "Noodles"),
          ],
        ),
      ),
    );
  }
}
