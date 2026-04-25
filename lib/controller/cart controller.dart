import 'package:get/get.dart';

class CartController extends GetxController {
  // .obs makes this list "observable" - the UI will watch this for changes
  var cartItems = <Map<String, dynamic>>[].obs;

  void addToCart(Map<String, dynamic> item) {
    // We use 'foodname' because that's the key coming from your fetch.php
    int index = cartItems.indexWhere((i) => i['name'] == item['foodname']);

    if (index != -1) {
      // Item exists, increase quantity
      cartItems[index]['qty']++;
      cartItems.refresh(); // Crucial for GetX to trigger a UI update
    } else {
      // New item, add to the list
      cartItems.add({
        'name': item['foodname'],
        'price': double.parse(item['price'].toString()),
        'qty': 1,
        'image': item['image'],
      });
    }
  }

  // Function to remove or decrease item quantity (Useful for the Cart UI)
  void removeFromCart(int index) {
    if (cartItems[index]['qty'] > 1) {
      cartItems[index]['qty']--;
      cartItems.refresh();
    } else {
      cartItems.removeAt(index);
    }
  }

  // Automatically calculates the total price of everything in the cart
  double get totalAmount =>
      cartItems.fold(0, (sum, item) => sum + (item['price'] * item['qty']));

  // Helper to clear the cart after a successful order
  void clearCart() {
    cartItems.clear();
  }
}
