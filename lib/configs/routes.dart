import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/category.dart';
import 'package:flutter_application_1/views/dashboard.dart';
import 'package:flutter_application_1/views/homescreen.dart';
import 'package:flutter_application_1/views/list.dart';
import 'package:flutter_application_1/views/login.dart';
import 'package:flutter_application_1/views/profile.dart';
import 'package:flutter_application_1/views/signup.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

var routes = [
  GetPage(
    name: "/",
    page: () => LoginScreen(),
  ),
  GetPage(
    name: "/signup",
    page: () => SignupScreen(),
  ),
  GetPage(
    name: "/homescreen",
    page: () => Homescreen(),
  ),
  GetPage(name: "/dashboard", page: () => Dashboard()),
  GetPage(name: "/list", page: () => listpage()),
  GetPage(name: "/profile", page: () => Profile()),

 GetPage(name: "/category", page: () => Category()),
];
