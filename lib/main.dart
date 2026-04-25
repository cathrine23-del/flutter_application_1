import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/configs/routes.dart';
import 'package:flutter_application_1/views/login.dart';
import 'package:flutter_application_1/controller/cart%20controller.dart'; // Ensure path is correct

void main() {
  // Ensures Flutter is fully initialized before we inject GetX services
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inject the CartController PERMANENTLY
  // This stops the "CartController not found" red screen by keeping it in memory
  Get.put(CartController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Food Delivery App',
      debugShowCheckedModeBanner: false,

      // 2. Routing Configuration
      // Using initialRoute is safer since you already have a routes.dart file
      initialRoute: "/",
      getPages: routes,

      // 3. Theme Data (Optional but recommended for consistency)
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
    );
  }
}
