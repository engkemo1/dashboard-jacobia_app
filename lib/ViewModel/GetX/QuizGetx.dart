import 'package:dashboard/Models/options.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constant.dart';

class QuizGetX extends GetxController {
  List<String> options = [];
  List<Options> optionsModelList = [];
  Rx<List<String>> selectedOptionList = Rx<List<String>>([]);
  var selectedOption = ''.obs;
  String? imageUrl = '';
  String desc = '';
  String name = "";
  String coin = "";

  String date = "", startTime = "", endTime = "",category="";
  int? rank1,
      rank2,
      rank3,
      rank4,
      rank5,
      rank6,
      rank7,
      rank8,
      rank9,
      rank10,
      min,
      max;
  double?  profit,
      price;


  Future getRanks(String collection) async {
    List<int> ranks = [];
    var obj = {};

    // Fetch documents from the collection
    var snapshot = await firestore.collection(collection).get();

    // Extract the correctAnswer values and add them to the ranks list
    snapshot.docs.forEach((element) {
      ranks.add(element.get('correctAnswer'));
    });

    // Check if there are any ranks
    if (ranks.isEmpty) {
      print('No ranks available');
      Get.snackbar("", "No ranks available", backgroundColor: Colors.white);
      return {};
    }

    // Sort ranks in descending order
    ranks.sort((a, b) => b.compareTo(a)); // Sorting in descending order

    // Determine the range based on the available ranks
    int rangeStart = ranks.length >= 10 ? ranks.length - 10 : 0; // Start from 0 if less than 10
    var rank = ranks.getRange(rangeStart, ranks.length).toList();
    print(rank);

    // Now retrieve the users with the corresponding ranks
    for (var i = 0; i < rank.length; i++) {
      print('Processing rank $i');

      var rankValue = rank[i];
      var rankUsers = await firestore
          .collection(collection)
          .where("correctAnswer", isEqualTo: rankValue)
          .get();

      rankUsers.docs.forEach((element) {
        obj[i] = [element.id, rankValue];
        print(obj);
      });
    }

    return obj;
  }
  Future getTotal(String doc)async{
    double total=0;
   await firestore.collection('total').doc(doc).get().then((value) =>
       total=value.get('total')

    );
   print(total);
   return total;
  }


  var getQuiz = firestore.collection('quiz').snapshots();

  Future createoption() async {
    options.clear();
    await firestore.collection('category').get().then((value) {
      optionsModelList =
          value.docs.map((e) => Options.fromDocumentSnapshot(e)).toList();
      value.docs.forEach((element) {
        print(element['name']);

        options.add(element['name']);

        update();
      });
    });
  }

  Future createQuiz(BuildContext context) async {
    print(price);
    await firestore.collection('quiz').add({
      'selected': FieldValue.arrayUnion(selectedOptionList.value),
      'name': name,
      "typeCoins":coin,
      'imageUrl': imageUrl,
      'min': min,
      'max': max,
      'date': date,
      'startTime': startTime,
      'EndTime': endTime,
      "Rank1": rank1,
      "Rank2": rank2,
      "Rank3": rank3,
      "Rank4": rank4,
      "Rank5": rank5,
      "Rank6": rank6,
      "Rank7": rank7,
      "Rank8": rank8,
      "Rank9": rank9,
      "Rank10": rank10,
      'profit': profit,
      'price': price,
      'desc': desc
    }).then((value) {
      Get.snackbar('Quiz', ' Successfully Added',backgroundColor: Colors.white);
      Navigator.pop(context);
    });
    update();
  }

  Future editQuiz(String path) async {
    await firestore.collection('quiz').doc(path).update({
      'selected': FieldValue.arrayUnion(selectedOptionList.value),
      'name': name,
      'imageUrl': imageUrl,
      'min': min,
      'max': max,
      'date': date,
      'startTime': startTime,
      'EndTime': endTime,
      "Rank1": rank1,
      "Rank2": rank2,
      "Rank3": rank3,
      "Rank4": rank4,
      "Rank5": rank5,
      "Rank6": rank6,
      "Rank7": rank7,
      "Rank8": rank8,
      "Rank9": rank9,
      "Rank10": rank10,
      'profit': profit,
      'price': price,
      'desc': desc
    }).then((value) {
      Get.snackbar('Quiz', ' Successfully Added');
      Get.back();
    });
    update();
  }

  postQTF() {
    firestore.collection('Quiz').add({
      'selected': FieldValue.arrayUnion(selectedOptionList.value),
      'question': name,
    });
    update();
  }

  @override
  void onInit() {
    createoption();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
