import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/login%20controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:http/http.dart' as http;

LoginController loginController = Get.put(LoginController());
TextEditingController usernameController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      /*appBar: AppBar(
          backgroundColor: Colors.pinkAccent,
          title: Text(
            "Login Screen",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          centerTitle: true,
        ),*/
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/cutlery.png', height: 100, width: 150),
              /*
                Text(
                  "Login Screen",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                ),
                */
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Row(
                  children: [
                    Text(
                      "Enter username",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ), //makes the edges softer
                  hintText: "Use email or phone number",
                  prefixIcon: Icon(Icons.person), //desplays the icins
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  10,
                  0,
                  0,
                  0,
                ), //applies padding to all sides
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Enter Password",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Obx(() => TextField(
                    controller: passwordController,
                    obscureText: !loginController.ispasswordvisible.value,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: "Enter password here",
                      prefixIcon: Icon(Icons.password),
                      suffixIcon: GestureDetector(
                        child: Icon(loginController.ispasswordvisible.value
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onTap: () {
                          loginController.togglepasswordvisibility();
                        },
                      ),
                    ),
                  )),
              SizedBox(height: 30),

              MaterialButton(
                onPressed: () async {
                  if (usernameController.text.isEmpty) {
                    Get.snackbar("Error", "Please enter your username");
                  } else if (passwordController.text.isEmpty) {
                    Get.snackbar("Error", "Please enter your password");
                  } else {
                    try {
                      final response = await http.get(
                        Uri.parse(
                            "http://10.0.2.2/flutter_api/login.php?phone=${usernameController.text}&password=${passwordController.text}"),
                      );

                      print(response.body);

                      if (response.statusCode == 200) {
                        final serverData = jsonDecode(response.body);

                        if (serverData['code'] == '1') {
                          String phone = serverData["user details"][0]["phone"];

                          Get.toNamed("/homescreen");
                        } else {
                          Get.snackbar(
                              "Wrong credentials", serverData['message']);
                        }
                      } else {
                        Get.snackbar(
                            "Server Error", "Error occurred while logging in");
                      }
                    } catch (e) {
                      Get.snackbar("Error", "Something went wrong");
                    }
                  }
                },
                color: Colors.brown,
                textColor: Colors.white,
                child: const Text("Login"),
              ), // we must specify what this butoon does when it is pressed. () for no name
              GestureDetector(
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                onTap: () {
                  bool success = loginController.login(
                      usernameController.text, passwordController.text);
                  if (success) {
                    Get.offAndToNamed("/homescreen");
                  } else {
                    Get.snackbar(
                        snackPosition: SnackPosition.BOTTOM,
                        "Error",
                        "Invalid username or password");
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: Row(
                  children: [
                    Text("Don't have an account?"),
                    SizedBox(width: 5),
                    GestureDetector(
                      child: Text(
                        "sign in",
                        style: TextStyle(color: Colors.pinkAccent),
                      ),
                      onTap: () {
                        Get.toNamed("/signup");
                      },
                    ),
                    Spacer(),
                    Text("Forgot password?"),
                    SizedBox(width: 5),
                    Text("Reset", style: TextStyle(color: Colors.pinkAccent)),
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
