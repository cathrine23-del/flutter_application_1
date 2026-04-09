import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

class listpage extends StatefulWidget {
  const listpage({super.key});

  @override
  State<listpage> createState() => _listpageState();
}

class _listpageState extends State<listpage> {
  List myfoodItem = [];
  bool loaded = false;
  String errorMessage = "";

  // Get the category name sent from the Category Page
  String categoryName = Get.arguments ?? "All Foods";

  @override
  void initState() {
    super.initState();
    fetchFood();
  }

  Future<void> fetchFood() async {
    try {
      // We pass the category as a query parameter to your PHP
      var response = await http.get(
        Uri.parse(
            "http://localhost/flutter_api/fetch.php?category=$categoryName"),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          myfoodItem = data['food'];
          loaded = true;
        });
      } else {
        setState(() {
          errorMessage = "Server Error: ${response.statusCode}";
          loaded = true;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Connection Failed: $e";
        loaded = true;
      });
    }
  }

  // --- THE SELECTION LOGIC (BOTTOM SHEET) ---
  void showOrderOptions(BuildContext context, Map item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Order ${item['foodname']}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text("Ksh ${item['price']}",
                  style: const TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 25),

              // Add to Cart Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    Get.back();
                    Get.snackbar(
                      "Success",
                      "${item['foodname']} added to cart",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  },
                  child: const Text("ADD TO CART",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),

              // Place Order Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.orange, width: 2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    Get.back();
                    Get.toNamed("/cart"); // Navigates to your Cart page
                  },
                  child: const Text("PLACE ORDER NOW",
                      style: TextStyle(
                          color: Colors.orange, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
            categoryName.toUpperCase()), // Shows which category you clicked
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: !loaded
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(errorMessage,
                      style: const TextStyle(color: Colors.red)))
              : ListView.builder(
                  itemCount: myfoodItem.length,
                  itemBuilder: (context, index) {
                    final food = myfoodItem[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        onTap: () => showOrderOptions(
                            context, food), // Selection logic trigger
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            "http://localhost/flutter_api/images/${food['image']}",
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.fastfood,
                                    size: 40, color: Colors.orange),
                          ),
                        ),
                        title: Text(
                          food['foodname'].toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Text(
                          "Ksh ${food['price']}",
                          style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w600),
                        ),
                        trailing:
                            const Icon(Icons.add_circle, color: Colors.orange),
                      ),
                    );
                  },
                ),
    );
  }
}
