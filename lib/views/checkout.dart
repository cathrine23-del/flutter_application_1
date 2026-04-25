import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/controller/cart controller.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CartController cartController = Get.find<CartController>();
  final TextEditingController addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  double deliveryFee = 150.0;
  bool isLoading = false;

  // Get logged-in user data stored during login
  Map? get currentUser {
    try {
      return Get.find<Map>(tag: 'currentUser');
    } catch (_) {
      return null;
    }
  }

  Future<void> placeOrder() async {
    if (!_formKey.currentState!.validate()) return;
    if (cartController.cartItems.isEmpty) {
      Get.snackbar("Error", "Your cart is empty!",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    setState(() => isLoading = true);

    try {
      // Build a readable summary string of all items
      final foodItemsList = cartController.cartItems
          .map((item) => "${item['name']} x${item['qty']}")
          .join(", ");

      final totalWithDelivery =
          (cartController.totalAmount + deliveryFee).toStringAsFixed(0);

      var url = Uri.parse("http://localhost/flutter_api/place_order.php");
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "user_id": currentUser?['id']?.toString() ?? "0",
          "total_price": totalWithDelivery,
          "food_items": foodItemsList,
          "delivery_address": addressController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data["success"] == true) {
          cartController.clearCart();
          _showSuccessDialog(data["order_id"]?.toString() ?? "—");
        } else {
          Get.snackbar("Error", data["message"] ?? "Order failed",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar("Error", "Server error: ${response.statusCode}",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Connection failed: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }

    setState(() => isLoading = false);
  }

  void _showSuccessDialog(String orderId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(30),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle,
                  color: Colors.green, size: 60),
            ),
            const SizedBox(height: 20),
            const Text(
              "Order Placed! 🎉",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Your order #$orderId has been received.\nWe'll deliver it to you shortly!",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // close dialog
                  // Go back to home, clearing the stack
                  Get.offAllNamed("/homescreen");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Back to Home",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Delivery Address ──────────────────────────────────
              const Text("Delivery Address",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextFormField(
                controller: addressController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "e.g. 123 Main St, Nairobi",
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Icon(Icons.location_on, color: Colors.deepOrange),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.deepOrange),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your delivery address";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // ── Order Summary ─────────────────────────────────────
              const Text("Order Summary",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Obx(() => Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        ...cartController.cartItems.asMap().entries.map((e) {
                          final item = e.value;
                          return Column(
                            children: [
                              ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    "http://localhost/flutter_api/images/${item['image']}",
                                    width: 55,
                                    height: 55,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                        Icons.fastfood,
                                        color: Colors.orange,
                                        size: 40),
                                  ),
                                ),
                                title: Text(
                                  item['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                ),
                                subtitle: Text(
                                  "Qty: ${item['qty']}",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                trailing: Text(
                                  "Ksh ${(item['price'] * item['qty']).toStringAsFixed(0)}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                              if (e.key <
                                  cartController.cartItems.length - 1)
                                const Divider(height: 1, indent: 16),
                            ],
                          );
                        }),
                      ],
                    ),
                  )),
              const SizedBox(height: 20),

              // ── Price Breakdown ───────────────────────────────────
              Obx(() => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        _priceRow("Subtotal",
                            "Ksh ${cartController.totalAmount.toStringAsFixed(0)}"),
                        const SizedBox(height: 8),
                        _priceRow("Delivery Fee",
                            "Ksh ${deliveryFee.toStringAsFixed(0)}"),
                        const Divider(height: 24),
                        _priceRow(
                          "Total",
                          "Ksh ${(cartController.totalAmount + deliveryFee).toStringAsFixed(0)}",
                          isBold: true,
                          valueColor: Colors.deepOrange,
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 30),

              // ── Place Order Button ────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 4,
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Place Order",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priceRow(String label, String value,
      {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: isBold ? Colors.black : Colors.grey)),
        Text(value,
            style: TextStyle(
                fontSize: 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: valueColor ?? Colors.black)),
      ],
    );
  }
}
