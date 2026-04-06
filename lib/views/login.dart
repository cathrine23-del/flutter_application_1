import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = false;

  Future<void> loginUser() async {
    if (emailController.text.isEmpty) {
      Get.snackbar("Error", "Please enter your email");
      return;
    }
    if (passwordController.text.isEmpty) {
      Get.snackbar("Error", "Please enter your password");
      return;
    }

    try {
      var response = await http.post(
        Uri.parse(
            "http://localhost/flutter_api/login.php?email=${emailController.text}&password=${passwordController.text}"), // ⚠️ CHANGE THIS IP
        body: {
          "email": emailController.text,
          "password": passwordController.text,
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['code'] == 1) {
          Get.snackbar("Success", "Login successful");

          // ✅ GO TO HOME SCREEN
          Get.offAllNamed("/homescreen");
        } else {
          Get.snackbar("Error", data['message']);
        }
      } else {
        Get.snackbar("Error", "Server error");
      }
    } catch (e) {
      Get.snackbar("Error", "Connection failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/cutlery.png', height: 100, width: 150),

              SizedBox(height: 20),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: "Enter email",
                  prefixIcon: Icon(Icons.person),
                ),
              ),

              SizedBox(height: 30),

              TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: "Enter password",
                  prefixIcon: Icon(Icons.password),
                  suffixIcon: IconButton(
                    icon: Icon(isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),

              SizedBox(height: 30),

              // ✅ SINGLE BUTTON (FIXED)
              GestureDetector(
                onTap: loginUser,
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),

              SizedBox(height: 20),

              Row(
                children: [
                  Text("Don't have an account?"),
                  SizedBox(width: 5),
                  GestureDetector(
                    child: Text(
                      "Sign up",
                      style: TextStyle(color: Colors.pinkAccent),
                    ),
                    onTap: () {
                      Get.toNamed("/signup");
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
