import 'package:dashboard/constant.dart';
import 'package:get/get.dart';

class CodeGetX extends GetxController {
  Future postCode(String code, String typeCoins, double price) async {
    firestore.collection('codes').doc().set({
      "price": price,
      'code': code,
      'typeCoins': typeCoins,
      "isApplied": false,
    });
  }
}
