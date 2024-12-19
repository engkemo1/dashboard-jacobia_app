import 'package:dashboard/constant.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Models/options.dart';
class QustionGetX extends GetxController {
  List<String> options =[];

  Rx<List<String>> selectedOptionList = Rx<List<String>>([]);
  var selectedOption = ''.obs;
  String? imageUrl;
  int type=0;
  String question = "",category="";
  String option1 = "", option2 = "", option3 = "", option4 = "", option5 = "";
  int? answer;
  int? answertf;
  bool isLoading = false;
  List<Options>? optionsModel ;

var  QuestionsDocs =firestore.collection('question').snapshots();

Future createOption() async{
  options.clear();
  QuerySnapshot<Map<String, dynamic>> snapshot =
  await firestore.collection("category").get();


  optionsModel=snapshot.docs.map((e) => Options.fromDocumentSnapshot(e)).toList();
  update();

  snapshot.docs.forEach((element) {
        options.add(element['name']);
        update();
      });

  }

  postQOptions() {
    firestore.collection('question').add({
      'selected':category,
      'question': question,
      'type': type==0?'options':'True/False',
      'option1': option1,
      'option2': option2,
      'option3': option3,
      'option4': option4,
      'option5': option5,
      "answer": answer
    }).then((value) => Get.snackbar('Questions', 'Added Successfully'));
    update();
  }
  updateQOptions(String doc) {
    firestore.collection('question').doc(doc).update({
      'selected':category,
      'question': question,
      'type': type==0?'options':'True/False',
      'option1': option1,
      'option2': option2,
      'option3': option3,
      'option4': option4,
      'option5': option5,
      "answer": answer
    }).then((value) => Get.snackbar('Questions', 'Added Successfully'));
    update();
  }
  postQTF() {
    firestore.collection('question').add({
      'selected':category,
      'question': question,
      'type': type,
      'answer': answertf,
    }).then((value) => Get.snackbar('Questions', 'Added Successfully'));
    update();
  }

  updateQTF(String doc) {
    firestore.collection('question').doc( doc).update({
      'selected': category,
      'question': question,
      'type': type,
      'answer': answertf,
    }).then((value) => Get.snackbar('Questions', 'Added Successfully'));
    update();
  }

  @override
  void onInit() {
    createOption();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
