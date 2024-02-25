import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/Models/CategoryModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant.dart';

class CategoryController extends GetxController {

 var docs=firestore
      .collection('category')
      .snapshots();
  String? name;
  String? imageUrl;





 Future  postCategory() async {
    String id ="";

    try {
        await firestore
            .collection('category')
            .doc()
            .set(
          Category(name: name!, imageUrl: imageUrl!, id: id).toJson(),
        );
        Get.snackbar(
          'Successfully PostData',
         'success'


        );

    } catch (e) {
     print(e);
    }
  }

}