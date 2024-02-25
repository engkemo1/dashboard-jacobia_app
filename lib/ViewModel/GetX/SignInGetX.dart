import 'dart:io';
import 'package:dashboard/view/pages/HomeScreen.dart';
import 'package:dashboard/view/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../local.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  late Rx<File?> _pickedImage;

  File? get profilePhoto => _pickedImage.value;
  User get user => _user.value!;




  void loginUser(String email, String password) async {

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        if(email =='jacobia@gmail.com'&&password=='jacobia123456'){
          CacheHelper.put(key:'user',value: 'exist');
          Get.to(HomeScreen());
          update();
        }else
          {
            Get.snackbar(
              'Error Logging in',
              'email or password is incorrect',
            );
          }

      } else {
        Get.snackbar(
          'Error Logging in',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Loggin gin',
        e.toString(),
      );
    }
  }

  void signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    CacheHelper.removeData(key: 'user');
    Get.to(LoginPage());

  }
}