import 'package:dashboard/ViewModel/GetX/QuestionGetX.dart';
import 'package:dashboard/view/pages/HomeScreen.dart';
import 'package:dashboard/view/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'ViewModel/GetX/CategoryGetX.dart';
import 'ViewModel/GetX/QuizGetx.dart';
import 'ViewModel/GetX/SignInGetX.dart';
import 'ViewModel/local.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();

  await Firebase.initializeApp().then((value) {
    Get.put(AuthController());
    Get.put(CategoryController());
    Get.put(QustionGetX());
    Get.put(QuizGetX());

  });
  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return  GetMaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'DashBoard',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home:
    CacheHelper.get( key: 'user')==null?  LoginPage():const HomeScreen(),
    );
  }
}
