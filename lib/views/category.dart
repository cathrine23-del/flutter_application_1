import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Category extends StatelessWidget {
  const Category({super.key});

  Widget categoryCard(
      IconData icon, String title, String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(assetPath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Categories"),
        centerTitle: true,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [
            // UPDATED: Passing as a Map to match your listpage expectation
            categoryCard(
                Icons.local_pizza,
                "Pizza",
                "assets/pizza.jpg",
                () => Get.toNamed("/listpage",
                    arguments: {"category_name": "pizza"})),

            categoryCard(
                Icons.lunch_dining,
                "Burger",
                "assets/burger.jpg",
                () => Get.toNamed("/listpage",
                    arguments: {"category_name": "burger"})),

            categoryCard(
                Icons.fastfood,
                "Fries",
                "assets/fries.jpg",
                () => Get.toNamed("/listpage",
                    arguments: {"category_name": "fries"})),

            categoryCard(
                Icons.local_drink,
                "Drinks",
                "assets/juice.jpg",
                () => Get.toNamed("/listpage",
                    arguments: {"category_name": "drinks"})),

            categoryCard(
                Icons.icecream,
                "Desserts",
                "assets/desert.jpg",
                () => Get.toNamed("/listpage",
                    arguments: {"category_name": "dessert"})),

            categoryCard(
                Icons.ramen_dining,
                "Noodles",
                "assets/noodles.jpg",
                () => Get.toNamed("/listpage",
                    arguments: {"category_name": "noodles"})),
          ],
        ),
      ),
    );
  }
}
