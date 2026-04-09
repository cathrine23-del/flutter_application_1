import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  // Mock data for the cart
  List<Map<String, dynamic>> cartItems = [
    {"name": "Margherita Pizza", "price": 900, "qty": 1, "image": "pizza.jpg"},
    {"name": "Tropical Juice", "price": 200, "qty": 2, "image": "juice.jpg"},
  ];

  double get subtotal =>
      cartItems.fold(0, (sum, item) => sum + (item['price'] * item['qty']));
  double deliveryFee = 150.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Your Cart"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 1. LIST OF CART ITEMS
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Item Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          "http://localhost/flutter_api/images/${item['image']}",
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.fastfood, size: 50),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Name and Price
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Ksh ${item['price']}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      // Quantity Controls
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (item['qty'] > 1) item['qty']--;
                              });
                            },
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text("${item['qty']}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                item['qty']++;
                              });
                            },
                            icon: const Icon(Icons.add_circle_outline,
                                color: Colors.orange),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // 2. SUMMARY SECTION
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Subtotal",
                        style: TextStyle(color: Colors.grey, fontSize: 16)),
                    Text("Ksh $subtotal", style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Delivery Fee",
                        style: TextStyle(color: Colors.grey, fontSize: 16)),
                    Text("Ksh $deliveryFee",
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const Divider(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    Text("Ksh ${subtotal + deliveryFee}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.orange)),
                  ],
                ),
                const SizedBox(height: 20),
                // CHECKOUT BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to Payment or Success page
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Go to Checkout",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
