import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmVisible = false;
  bool isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> handleSignup() async {
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    setState(() => isLoading = true);

    try {
      var url = Uri.parse("http://localhost/flutter_api/signup.php");

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "name": usernameController.text.trim(),
          "email": emailController.text.trim(),
          "phone": phoneController.text.trim(),
          "password": passwordController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data["code"] == 1) {
          Get.snackbar("Success", "Account created successfully");
          Get.offAllNamed("/");
        } else {
          Get.snackbar("Error", data["message"]);
        }
      } else {
        Get.snackbar("Error", "Server error: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Connection failed");
    }

    setState(() => isLoading = false);
  }

  // Helper function to keep code clean
  InputDecoration customInputDecoration(String hint, IconData icon,
      {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.restaurant_menu,
                    size: 80, color: Colors.deepOrange),
                const SizedBox(height: 20),
                const Text(
                  "Create Account",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: usernameController,
                  decoration: customInputDecoration("Username", Icons.person),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: emailController,
                  decoration: customInputDecoration("Email", Icons.email),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: phoneController,
                  decoration: customInputDecoration("Phone", Icons.phone),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  decoration: customInputDecoration(
                    "Password",
                    Icons.lock,
                    suffix: IconButton(
                      icon: Icon(isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () => setState(
                          () => isPasswordVisible = !isPasswordVisible),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: !isConfirmVisible,
                  decoration: customInputDecoration(
                    "Confirm Password",
                    Icons.lock_outline,
                    suffix: IconButton(
                      icon: Icon(isConfirmVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () =>
                          setState(() => isConfirmVisible = !isConfirmVisible),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: isLoading ? null : handleSignup,
                  child: Container(
                    height: 55,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("Log in",
                          style: TextStyle(color: Colors.pinkAccent)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
