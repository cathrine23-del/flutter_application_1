import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_application_1/controller/cart controller.dart';

class listpage extends StatefulWidget {
  final Function(Map<String, dynamic>)? onAddToCart;

  const listpage({super.key, this.onAddToCart});

  @override
  State<listpage> createState() => _listpageState();
}

class _listpageState extends State<listpage> {
  // Find the controller
  final CartController cartController = Get.find<CartController>();

  List myfoodItem = [];
  bool loaded = false;
  String errorMessage = "";
  String categoryName = "All Foods";

  @override
  void initState() {
    super.initState();

    // 1. Get the arguments safely
    dynamic args = Get.arguments;

    if (args != null) {
      if (args is Map) {
        // If it's a Map, look for the key. Use .toString() to be safe.
        categoryName =
            (args['category_name'] ?? args['name'] ?? "All Foods").toString();
      } else if (args is String) {
        // If it's already a String, just use it.
        categoryName = args;
      } else {
        // If it's something else, convert it to a string so it doesn't crash.
        categoryName = args.toString();
      }
    }

    // 2. Fetch the food using the cleaned-up name
    fetchFood();
  }

  Future<void> fetchFood() async {
    try {
      var response = await http.get(
        Uri.parse(
            "http://localhost/flutter_api/fetch.php?category=$categoryName"),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            myfoodItem = data['food'] ?? [];
            loaded = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            errorMessage = "Server Error: ${response.statusCode}";
            loaded = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = "Connection Failed: $e";
          loaded = true;
        });
      }
    }
  }

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

              // ADD TO CART BUTTON
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
                    // THE FIX: Convert the dynamic Map into a String-Keyed Map
                    Map<String, dynamic> cleanItem =
                        Map<String, dynamic>.from(item);

                    // 1. Logic for the Bottom Nav flow
                    if (widget.onAddToCart != null) {
                      widget.onAddToCart!(cleanItem);
                    }

                    // 2. Logic for the Category flow (Direct Controller Access)
                    cartController.addToCart(cleanItem);

                    Navigator.pop(context); // Close bottom sheet

                    Get.snackbar(
                      "Success",
                      "${item['foodname']} added to cart",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 1),
                    );
                  },
                  child: const Text("ADD TO CART",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),

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
                    Navigator.pop(context);
                    Get.toNamed("/cart");
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
        title: Text(categoryName.toUpperCase()),
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
                        onTap: () => showOrderOptions(context, food),
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
