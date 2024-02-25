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
var obj={};
    await firestore.collection(collection).get().then((value) {
      value.docs.forEach((element) {
        ranks.add(element.get('correctAnswer'));
      });
      return ranks;
    }).then((value) async{

      value.sort();
  var rank=   value.getRange(value.length - 10, value.length).toList();

  print(rank);
      for(var i=0;i<=9;i++){
      print(i);

      await  firestore
          .collection(collection)
          .where("correctAnswer", isEqualTo: rank[i])
          .get()
          .then((value) => {

        value.docs.forEach((element) {

          obj[i]=[element.id,rank[i]];
          print(obj);

        })
      });
    }


    });


    return obj;
  }
  Future getTotal(String doc)async{
    int total=0;
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
