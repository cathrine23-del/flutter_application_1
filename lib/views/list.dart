import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class listpage extends StatelessWidget {
  const listpage({super.key});

  Widget foodItem(String name, String price, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: ListTile(
        leading: Icon(icon, size: 35, color: Colors.orange),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(price),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text("List Page"),
          onTap: () {
            Get.offAllNamed("/list");
          },
        ),
      ),
      body: ListView(
        children: [
          foodItem("Pizza", "Ksh 900", Icons.local_pizza),
          foodItem("Burger", "Ksh 700", Icons.lunch_dining),
          foodItem("Fries", "Ksh 300", Icons.fastfood),
          foodItem("Chicken", "Ksh 850", Icons.set_meal),
          foodItem("Drink", "Ksh 200", Icons.local_drink),
          foodItem("Ice Cream", "Ksh 250", Icons.icecream),
        ],
      ),
    );
  }
}
