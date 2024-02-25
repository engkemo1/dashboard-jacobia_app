import 'package:dashboard/view/pages/quiz/result_quiz.dart';
import 'package:dashboard/view/widget/Widget_CreateQuiz.dart';
import 'package:flutter/material.dart';
import '../../../../constant.dart';
import '../../../Models/options.dart';
import '../../../ViewModel/GetX/QuizGetx.dart';
import 'package:get/get.dart';

class Quiz extends StatefulWidget {
  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  var controller = Get.put(QuizGetX());
  List<Options> optionsList = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
      
          actions: [
            Container(
              height: 35,
              width: 150,
              margin: EdgeInsets.only(right: 5),
              child: ElevatedButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: true,
                    // user must tap button!
                    builder: (BuildContext context) {
                      return CreateQuiz();
                    },
                  );
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(appBarColor)),
                child: const Text(
                  'Add Quiz',
                  style: TextStyle(color: Colors.greenAccent),
                ),
              ),
            )
          ],
          title: const Text('Quiz',style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.greenAccent,
          elevation: 0,
        ),
        backgroundColor: appBarColor,
        body: StreamBuilder(
            stream: controller.getQuiz,
            builder: (context, AsyncSnapshot snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(
                        backgroundColor: Colors.greenAccent,
                      ),
                    )
                  : ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListTile(
                                isThreeLine: true,
                                style: ListTileStyle.drawer,
                                leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      snapshot.data.docs[index]['imageUrl'],
                                      fit: BoxFit.fill,
                                    )),
                                title: Text(
                                  snapshot.data.docs[index]['name'],
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                                subtitle: Text(
                                  snapshot.data.docs[index]['selected']
                                      .toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
      Get.to(ResultQuiz(data: snapshot.data.docs[index],));
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: Colors.greenAccent,
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.white,
                              )
                            ],
                          ),
                        );
                      },
                    );
            }),
      ),
    );
  }
}
