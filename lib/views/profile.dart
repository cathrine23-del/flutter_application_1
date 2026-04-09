import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    Map? userData;

    // ✅ SAFE RETRIEVAL
    try {
      userData = Get.find<Map>(tag: 'currentUser');
    } catch (e) {
      userData = null;
    }

    // ✅ RED SCREEN PREVENTER
    if (userData == null) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.orange),
              SizedBox(height: 10),
              Text("Loading profile..."),
            ],
          ),
        ),
      );
    }

    const Color themeOrange = Color(0xFFF0813D);
    const Color themeGray = Colors.black87;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: themeOrange, width: 3),
                ),
                child: const CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('assets/profile_placeholder.jpg'),
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              userData['name'] ?? "User Name",
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: themeGray),
            ),
            Text(
              userData['email'] ?? "email@example.com",
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              "Your profile is 80% completed.",
              style: TextStyle(
                  color: themeOrange,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            AccountOptionItem(
              icon: Icons.home,
              title: "Manage Address",
              subtitle: userData['location'] ?? "No address set",
              iconColor: themeOrange,
              textColor: themeGray,
              onTap: () {},
            ),
            const Divider(),
            AccountOptionItem(
              icon: Icons.favorite_border,
              title: "Favorites",
              iconColor: themeOrange,
              textColor: themeGray,
              onTap: () {},
            ),
            const Divider(),
            AccountOptionItem(
              icon: Icons.settings,
              title: "Settings",
              iconColor: themeOrange,
              textColor: themeGray,
              onTap: () {},
            ),
            const Divider(),
            const SizedBox(height: 40),
            OutlinedButton(
              onPressed: () => Get.offAllNamed("/"),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey, width: 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.power_settings_new, color: themeOrange, size: 20),
                  SizedBox(width: 8),
                  Text("LOG OUT",
                      style: TextStyle(
                          color: themeOrange,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountOptionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color iconColor;
  final Color textColor;
  final VoidCallback onTap;

  const AccountOptionItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.iconColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFFDE8DA),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title,
          style: TextStyle(
              color: textColor, fontSize: 17, fontWeight: FontWeight.w600)),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing:
          const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16),
    );
  }
}
