import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

var myfoodItem = [];
bool loaded = false;

class listpage extends StatefulWidget {
  const listpage({super.key});

  @override
  State<listpage> createState() => _listpageState();
}

class _listpageState extends State<listpage> {
  @override
  void initState() {
    super.initState();
    fetchFood();
  }

  fetchFood() async {
    var response = await http.get(
      Uri.parse("http://localhost/food/fetch.php"), // FIXED localhost
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var foodData = data['food']; // FIXED serverData

      for (var food in foodData) {
        myfoodItem.add({
          "name": food['name'],
          "price": food['price'],
          "image": food['image']
        });
      }

      setState(() {
        loaded = true;
      });

      print(foodData);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Server error")),
      );
    }
  }

  Widget foodItem(String name, String price, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: ListTile(
        leading: Icon(icon, size: 35, color: Colors.orange),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(price),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Page"),
      ),
      body: loaded
          ? ListView.builder(
              itemCount: myfoodItem.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Image.network(
                      "http://localhost/food/images/${myfoodItem[index]['image']}",
                      height: 100,
                      width: 150,
                    ),
                    Column(
                      children: [
                        Text(myfoodItem[index]['name']), // FIXED
                        Text(myfoodItem[index]['price']), // FIXED
                      ],
                    )
                  ],
                );
              })
          : Center(child: CircularProgressIndicator()),
    );
  }
}
