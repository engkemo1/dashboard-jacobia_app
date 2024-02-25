import 'package:dashboard/ViewModel/GetX/QuizGetx.dart';
import 'package:dashboard/constant.dart';
import 'package:dashboard/view/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widget/Widget_CreateQuiz.dart';

class ResultQuiz extends StatefulWidget {
  final data;

  const ResultQuiz({super.key, required this.data});

  @override
  State<ResultQuiz> createState() => _ResultQuizState();
}

class _ResultQuizState extends State<ResultQuiz> {
  var ranks = {};
  var total;
  var quizGetX = Get.put(QuizGetX());

  var prizeController = TextEditingController();

  @override
  void initState() {
    quizGetX.getRanks(widget.data['name']).then((value) {
      setState(() {
        ranks.addAll(value);
      });
    }).then((value) {
      quizGetX.getTotal(widget.data.id).then((value) => total = value);
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appBarColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.data['name'], style: TextStyle(color: Colors.white),),
          actions: [
            IconButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  // user must tap button!
                  builder: (BuildContext context) {
                    return const CreateQuiz();
                  },
                );
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                          title: const Center(
                            child: Text("Confirm Deletion"),
                          ),
                          content: Container(
                            height: 130,
                            child: Column(
                              children: [
                                Text(
                                  "Are you sure want to delete '${widget
                                      .data['name']}'?",
                                  style: TextStyle(color: Colors.black),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                        icon: const Icon(
                                          Icons.cancel,
                                          size: 14,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.red),
                                        onPressed: () {
                                          Get.back();
                                        },
                                        label: Text("cancel")),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    ElevatedButton.icon(
                                        icon: const Icon(
                                          Icons.delete,
                                          size: 14,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.red),
                                        onPressed: () {
                                          firestore
                                              .collection('quiz')
                                              .doc(widget.data.id)
                                              .delete().then((value) {
                                                firestore.collection(widget.data['name']).doc().delete();
                                          });
                                          Get.back();

                                          Get.back();

                                        },
                                        label: const Text("Delete"))
                                  ],
                                )
                              ],
                            ),
                          ));
                    });
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
          backgroundColor: appBarColor,
        ),
        body: ListView.separated(
          reverse: true,
          itemBuilder: (context, index) {
            return StreamBuilder(
                stream: firestore
                    .collection('users')
                    .where('uid', isEqualTo: ranks[index][0])
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  return snapshot.connectionState == ConnectionState.waiting
                      ? Center(
                    child: CircularProgressIndicator.adaptive(),
                  ):snapshot.data==null?const EmptyWidget()
                      : ListTile(
                    focusColor: Colors.white,
                    textColor: Colors.white,
                    leading: Text(
                      'Rank ${index == 0 ? 10 : index == 1 ? 9 : index == 2
                          ? 8
                          : index == 3 ? 7 : index == 4 ? 6 : index == 5
                          ? 5
                          : index == 6 ? 4 : index == 7 ? 3 : index == 8
                          ? 2
                          : index == 9 ? 1 : 0}',
                      style: TextStyle(fontSize: 14),
                    ),
                    subtitle: Row(
                      children: [
                        Text('phone: ${snapshot.data.docs[0]['phone']}'),
                      ],
                    ),
                    title: Text(snapshot.data.docs[0]['name']),
                    trailing: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                  title: const Center(
                                    child: Text("Send Prize"),
                                  ),
                                  content: Container(
                                    height: 230,
                                    child: Column(
                                      children: [
                                        Text(
                                            'CorrectAnswer:${ranks[index][1]}'),
                                        Text('Total prize:${total}'),
                                        Text(
                                            'Type Coins: ${widget
                                                .data['typeCoins']}'),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        TextField(
                                          decoration: InputDecoration(
                                              label: Text('Prize')),
                                          controller: prizeController
                                            ..text = (widget.data[
                                            'Rank${index == 9 ? 1 : index == 8
                                                ? 2
                                                : index == 7 ? 3 : index == 6
                                                ? 4
                                                : index == 5 ? 5 : index == 4
                                                ? 6
                                                : index == 3 ? 7 : index == 2
                                                ? 8
                                                : index == 1 ? 9 : index == 0
                                                ? 10
                                                : 0}'] *
                                                total /
                                                100)
                                                .toString(),
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton.icon(
                                                icon: const Icon(
                                                  Icons.cancel,
                                                  size: 14,
                                                ),
                                                style: ElevatedButton
                                                    .styleFrom(
                                                    primary:
                                                    Colors.red),
                                                onPressed: () {
                                                  // firestore
                                                  //     .collection(widget
                                                  //         .data['name'])
                                                  //     .doc(
                                                  //         ranks[index][0])
                                                  //     .delete()
                                                  //     .then((value) =>
                                                  //         Get.back());
                                                  // setState(() {
                                                  //
                                                  // });
                                                  Get.back();
                                                },
                                                label: Text("cancel")),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            ElevatedButton.icon(
                                                icon: const Icon(
                                                  Icons.send,
                                                  size: 14,
                                                ),
                                                style: ElevatedButton
                                                    .styleFrom(
                                                    primary: Colors
                                                        .greenAccent),
                                                onPressed: () {
                                                  var coin = widget
                                                      .data['typeCoins'];

                                                  var data = ((snapshot
                                                      .data
                                                      .docs[0]
                                                  [coin]) +
                                                      (widget.data[
                                                      'Rank${index == 9
                                                          ? 1
                                                          : index == 8
                                                          ? 2
                                                          : index == 7
                                                          ? 3
                                                          : index == 6
                                                          ? 4
                                                          : index == 5
                                                          ? 5
                                                          : index == 4
                                                          ? 6
                                                          : index == 3
                                                          ? 7
                                                          : index == 2
                                                          ? 8
                                                          : index == 1
                                                          ? 9
                                                          : index == 0
                                                          ? 10
                                                          : 0}'] *
                                                          total /
                                                          100));
                                                  print(data);
                                                  firestore
                                                      .collection('users')
                                                      .doc(
                                                      ranks[index][0])
                                                      .update({
                                                    coin: data
                                                  }).then((value) =>
                                                      Get.back());
                                                },
                                                label: const Text("send"))
                                          ],
                                        )
                                      ],
                                    ),
                                  ));
                            });
                      },
                    ),
                  );
                });
          },
          itemCount: ranks.length,
          separatorBuilder: (context, index) {
            return Divider();
          },
        ));
  }
}
