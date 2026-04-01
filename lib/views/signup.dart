import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/login.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;

TextEditingController usernameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.blue,
      //   title: Text(
      //     "Sign up",
      //     style: TextStyle(fontSize: 30, color: Colors.black),
      //   ),
      //   centerTitle: true,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/cutlery.png', height: 100, width: 100),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "username",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: "enter your email",
                  hintStyle: TextStyle(fontWeight: FontWeight.w100),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "password",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: "enter password",
                  hintStyle: TextStyle(fontWeight: FontWeight.w100),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.visibility),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "confirm password",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: "confirm password",
                  hintStyle: TextStyle(fontWeight: FontWeight.w100),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.visibility),
                ),
              ),
              MaterialButton(
                onPressed: () async {
                  if (usernameController.text.isEmpty) {
                    Get.snackbar("Error", "Please enter your name");
                  } else if (emailController.text.isEmpty) {
                    Get.snackbar("Error", "Please enter your email");
                  } else if (phoneController.text.isEmpty) {
                    Get.snackbar("Error", "Please enter your phone");
                  } else if (passwordController.text.isEmpty ||
                      confirmPasswordController.text.isEmpty ||
                      passwordController.text.toString().compareTo(
                              confirmPasswordController.text.toString()) !=
                          0) {
                    Get.snackbar("Error", "Please enter your password");
                  } else if (confirmPasswordController.text.isEmpty) {
                    Get.snackbar("Error",
                        "password and confirm password should be non empty and matching");
                  }
                  final response = await http.get(Uri.parse(
                      "http://10.0.2.2/flutter_api/signup.php?name={name.text}&email={email.text}&phone={phone.text}&password={password.text}"));
                  print(response.body);
                  if (response.statusCode == 200) {
                    final serverData = jsonDecode(response.body);
                    if (serverData['status'] == "1") {
                      Get.snackbar("sign up", "sign up success");
                      Get.offAndToNamed("/");
                    } else {
                      Get.snackbar("sign up", "sign up failed");
                    }
                  } else {
                    Get.snackbar("sign up", "sign up failed");
                  }
                },
                textColor: Colors.blue,
                child: Text("sign up", style: TextStyle(color: Colors.black)),
              ),
              Container(
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "sign up",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: Row(
                  children: [
                    Text("already have an account?"),
                    SizedBox(width: 5),
                    GestureDetector(
                      child: Text(
                        "Log in",
                        style: TextStyle(color: Colors.red, fontSize: 10),
                      ),
                      onTap: () {
                        Get.toNamed("/");
                      },
                    ),
                    //  Spacer(),
                    //   Text("forgot password?"),
                    //   SizedBox(width: 5),
                    //   Text(
                    //     "reset password",
                    //     style: TextStyle(color: Colors.red, fontSize: 10),
                    //   ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
