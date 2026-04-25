import 'package:flutter_application_1/views/category.dart';
import 'package:flutter_application_1/views/dashboard.dart';
import 'package:flutter_application_1/views/homescreen.dart';
import 'package:flutter_application_1/views/list.dart';
import 'package:flutter_application_1/views/login.dart';
import 'package:flutter_application_1/views/profile.dart';
import 'package:flutter_application_1/views/signup.dart';
import 'package:flutter_application_1/views/cart.dart';
import 'package:flutter_application_1/views/checkout.dart';
import 'package:get/get.dart';

var routes = [
  GetPage(name: "/", page: () => const LoginScreen()),
  GetPage(name: "/signup", page: () => const SignupScreen()),
  GetPage(name: "/homescreen", page: () => const Homescreen()),
  GetPage(name: "/dashboard", page: () => Dashboard()),
  GetPage(name: "/listpage", page: () => const listpage()),
  GetPage(name: "/profile", page: () => const Profile()),
  GetPage(name: "/category", page: () => const Category()),
  GetPage(name: "/cart", page: () => const Cart()),
  GetPage(name: "/checkout", page: () => const CheckoutScreen()),
];
