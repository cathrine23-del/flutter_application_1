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
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "email",
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  "phone",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          // TextField(
                          //   controller: phoneController,
                          //   keyboardType: TextInputType.phone,
                          //   decoration: InputDecoration(
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(20),
                          //     ),
                          //     hintText: "enter your phone",
                          //     prefixIcon: Icon(Icons.phone),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    // TextField(
                    //   controller: emailController,
                    //   decoration: InputDecoration(
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(20),
                    //     ),
                    //     hintText: "enter your email",
                    //     prefixIcon: Icon(Icons.email),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "username",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: "enter your username",
                  hintStyle: TextStyle(fontWeight: FontWeight.w100),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "email",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextField(
                controller: emailController,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "phone",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: "enter your phone",
                  hintStyle: TextStyle(fontWeight: FontWeight.w100),
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              SizedBox(height: 10),
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
                controller: passwordController,
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
                controller: confirmPasswordController,
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
              GestureDetector(
                onTap: () async {
                  if (emailController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    Get.snackbar("Error", "Please fill all fields");
                    return;
                  }

                  try {
                    final response = await http.post(
                      Uri.parse("http://localhost/flutter_api/login.php"),
                      headers: {"Content-Type": "application/json"},
                      body: jsonEncode({
                        "email": emailController.text,
                        "password": passwordController.text,
                      }),
                    );

                    print(response.body);

                    if (response.statusCode == 200) {
                      final serverData = jsonDecode(response.body);

                      if (serverData['code'] == 1) {
                        Get.snackbar("Success", "Login successful");
                        Get.offAndToNamed("/homescreen");
                      } else {
                        Get.snackbar("Error", serverData['message']);
                      }
                    } else {
                      Get.snackbar("Error", "Server error");
                    }
                  } catch (e) {
                    print(e);
                    Get.snackbar("Error", "Something went wrong");
                  }
                },
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
