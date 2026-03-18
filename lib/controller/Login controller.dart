// ignore: file_names
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LoginController extends GetxController {
  var username;
  var password;
  var ispasswordvisible = false.obs;
  login(user, pass) {
    username = user;
    password = pass;
    if (username == "admin" && password == "123456") {
      return true;
    } else {
      return false;
    }
  }

  togglepasswordvisibility() {
    ispasswordvisible.value = !ispasswordvisible.value;
  }
}
