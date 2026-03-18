import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text("profile"),
          onTap: () {
            Get.offAllNamed("/profile");
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueGrey,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 160,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: GestureDetector(
                child: Text(
                  "username",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Get.toNamed("/profile");
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              "user@email.com",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
