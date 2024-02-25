import 'package:dashboard/ViewModel/GetX/QuestionGetX.dart';
import 'package:dashboard/view/empty_widget.dart';
import 'package:dashboard/view/pages/Questions/create_question.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import '../../../Models/options.dart';
import '../../../ViewModel/GetX/CategoryGetX.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../ViewModel/GetX/QuizGetx.dart';
import '../../../ViewModel/file_handeler.dart';
import '../../../constant.dart';
import '../../widget/DropDownWidget.dart';
import '../pdf_view.dart';

class Category extends StatefulWidget {
  final String name;

  const Category({super.key, required this.name});

  @override
  State<Category> createState() => _CategoryState();
}

List<String> options = [];

class _CategoryState extends State<Category> {
  String? dropdownValue;
  final TextEditingController _question = TextEditingController();
  final TextEditingController _imageUrLController = TextEditingController();
  final TextEditingController _option1 = TextEditingController();
  final TextEditingController _option2 = TextEditingController();
  final TextEditingController _option3 = TextEditingController();
  final TextEditingController _option4 = TextEditingController();
  final TextEditingController _option5 = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  List<String> options = [];
  List<String> categoryList = [];

  @override
  void initState() {
    var fire =
    FirebaseFirestore.instance.collection('category').get().then((value) {
      value.docs.forEach((element) {
        categoryList.add(element["name"]);
      });
      setState(() {});
    });

    super.initState();
  }

  int value = 0;
  List<String> optionList = [];
  String? corAns;
  String? category;

  bool truefalse = false;
  var controller = Get.put(QustionGetX());
  var quizGetx = Get.put(QuizGetX());
  List<Options> optionsList = [];

  var getXController = QustionGetX();
  var cat = CategoryController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firestore
            .collection("question")
            .where("selected", isEqualTo: widget.name)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {


        return Scaffold(
          backgroundColor: appBarColor,
          appBar: AppBar(
            actions:[ IconButton(icon: Icon(Icons.print,color: Colors.greenAccent,),onPressed: ()async{
              final pdfFile =
              await PdfInvoiceApi.generate2(snapshot.data.docs, null,widget.name);

              // opening the pdf file
              FileHandleApi.openFile(pdfFile);
            },),],
            title: Text(widget.name,style: TextStyle(color: Colors.white),),
            backgroundColor: appBarColor,
            elevation: 100,
          ),
          body: snapshot.connectionState == ConnectionState.waiting
                    ? const Center(
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.greenAccent,
                  ),
                )
                    : snapshot.data.docs.length == 0
                    ? EmptyWidget()
                    : Column(
                      children:[                        Container(
                padding: EdgeInsets.all(10),
                height: 50,width: double.infinity,color: Colors.greenAccent.withOpacity(0.5),child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text("${snapshot.data.docs.length}",style: TextStyle(color: Colors.white,fontSize: 18),),

                Text(":عدد الاسألة",style: TextStyle(color: Colors.white,fontSize: 18),),

                ],
                ),),


                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              category = snapshot.data.docs[index]["selected"];
                              truefalse = snapshot.data.docs[index]
                              ['answer'] ==
                                  0
                                  ? true
                                  : false;
                              return Directionality(
                                textDirection: TextDirection.rtl,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      subtitle: Text(
                                        " الجواب:  ${snapshot.data.docs[index]['type'] ==
                                            'options' ? snapshot.data
                                            .docs[index]['answer'] == "A" ? snapshot.data
                                            .docs[index]['option1'] : snapshot.data
                                            .docs[index]['answer'] == "B" ? snapshot.data
                                            .docs[index]['option2'] : snapshot.data
                                            .docs[index]['answer'] == "C" ? snapshot.data
                                            .docs[index]['option3'] : snapshot.data
                                            .docs[index]['answer'] == "D" ? snapshot.data
                                            .docs[index]['option4'] : snapshot.data
                                            .docs[index]['option5'] :  snapshot.data.docs[index]['answer']}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(
                                          Icons.update,
                                          color: Colors.greenAccent,
                                        ),
                                        onPressed: () {
                                          print(snapshot.data.docs[index]['answer'].toString());



                                          print(snapshot.data.docs[index]
                                          ['selected']);

                                          showDialog(
                                              context: context,
                                              builder: (_) {
                          if(snapshot.data.docs[index]
                          ['type'] ==
                              "options") {
                            corAns = snapshot.data.docs[index]
                                                ['answer']
                                                ;
                          }
                                                return AlertDialog(
                                                    backgroundColor: appBarColor,
                                                    content: SingleChildScrollView(
                                                      child: Form(
                                                        key: _formKey,
                                                        child: Column(
                                                          children: [
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            InputField(
                                                                label: 'Question ',
                                                                hint:
                                                                'Enter Question',
                                                                controller: _question
                                                                  ..text = snapshot
                                                                      .data
                                                                      .docs[
                                                                  index]
                                                                  ['question'],
                                                                iconOrdrop: 'icon',
                                                                isEnabled: true,
                                                                texth: 15),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            DropdownButtonFormField(
                                                              elevation: 0,
                                                              iconEnabledColor:
                                                              Colors.white,
                                                              style: TextStyle(
                                                                  color:
                                                                  Colors.white),
                                                              decoration:
                                                              const InputDecoration(
                                                                hintText:
                                                                'Please Select Category',
                                                                hintStyle: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                                enabledBorder:
                                                                OutlineInputBorder(
                                                                  //<-- SEE HERE
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                focusedBorder:
                                                                OutlineInputBorder(
                                                                  //<-- SEE HERE
                                                                  borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                      width: 1),
                                                                ),
                                                                filled: true,
                                                                fillColor:
                                                                appBarColor,
                                                              ),
                                                              iconDisabledColor:
                                                              Colors.white,
                                                              dropdownColor:
                                                              Colors.black,
                                                              value: category,
                                                              onChanged: (String?
                                                              newValue) {
                                                                category =
                                                                newValue!;
                                                              },
                                                              items: categoryList.map<
                                                                  DropdownMenuItem<
                                                                      String>>((String
                                                              value) {
                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value: value,
                                                                  child: Text(
                                                                    value,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        20),
                                                                  ),
                                                                );
                                                              }).toList(),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            snapshot.data.docs[
                                                            index]
                                                            ['type'] ==
                                                                "options"
                                                                ? Column(
                                                              children: [
                                                                InputField(
                                                                    controller: _option1
                                                                      ..text = snapshot.data
                                                                          .docs[index]
                                                                      [
                                                                      "option1"],
                                                                    label:
                                                                    'A',
                                                                    hint:
                                                                    'Option',
                                                                    iconOrdrop:
                                                                    'icon',
                                                                    isEnabled:
                                                                    true,
                                                                    texth:
                                                                    15),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                InputField(
                                                                    controller: _option2
                                                                      ..text = snapshot.data
                                                                          .docs[index]
                                                                      [
                                                                      "option2"],
                                                                    label:
                                                                    'B',
                                                                    hint:
                                                                    'Option',
                                                                    iconOrdrop:
                                                                    'icon',
                                                                    isEnabled:
                                                                    true,
                                                                    texth:
                                                                    15),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                InputField(
                                                                    controller: _option3
                                                                      ..text = snapshot.data
                                                                          .docs[index]
                                                                      [
                                                                      "option3"],
                                                                    label:
                                                                    'C',
                                                                    hint:
                                                                    'Option',
                                                                    iconOrdrop:
                                                                    'icon',
                                                                    isEnabled:
                                                                    true,
                                                                    texth:
                                                                    15),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                InputField(
                                                                    controller: _option4
                                                                      ..text = snapshot.data
                                                                          .docs[index]
                                                                      [
                                                                      "option4"],
                                                                    label:
                                                                    'D',
                                                                    hint:
                                                                    'Option',
                                                                    iconOrdrop:
                                                                    'icon',
                                                                    isEnabled:
                                                                    true,
                                                                    texth:
                                                                    15),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                InputField(
                                                                    controller: _option5
                                                                      ..text = snapshot.data
                                                                          .docs[index]
                                                                      [
                                                                      "option5"],
                                                                    label:
                                                                    'E',
                                                                    hint:
                                                                    'Option',
                                                                    iconOrdrop:
                                                                    'icon',
                                                                    isEnabled:
                                                                    true,
                                                                    texth:
                                                                    15),
                                                                SizedBox(
                                                                  height: 30,
                                                                ),
                                                                DropdownButtonFormField(
                                                                  elevation:
                                                                  0,
                                                                  iconEnabledColor:
                                                                  Colors
                                                                      .white,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                  decoration:
                                                                  const InputDecoration(
                                                                    hintText:
                                                                    'Please Select Correct Answer',
                                                                    hintStyle:
                                                                    TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                    enabledBorder:
                                                                    OutlineInputBorder(
                                                                      //<-- SEE HERE
                                                                      borderSide:
                                                                      BorderSide(
                                                                          color: Colors
                                                                              .white),
                                                                    ),
                                                                    focusedBorder:
                                                                    OutlineInputBorder(
                                                                      //<-- SEE HERE
                                                                      borderSide: BorderSide(
                                                                          color:
                                                                          Colors.white,
                                                                          width: 1),
                                                                    ),
                                                                    filled:
                                                                    true,
                                                                    fillColor:
                                                                    appBarColor,
                                                                  ),
                                                                  iconDisabledColor:
                                                                  Colors
                                                                      .white,
                                                                  dropdownColor:
                                                                  Colors
                                                                      .black,
                                                                  value:
                                                                  corAns,
                                                                  onChanged:
                                                                      (String?
                                                                  newValue) {
                                                                    corAns =
                                                                    newValue!;
                                                                  },
                                                                  items: [
                                                                    'A',
                                                                    'B',
                                                                    'C',
                                                                    'D',
                                                                    'E'
                                                                  ].map<
                                                                      DropdownMenuItem<
                                                                          String>>((String
                                                                  value) {
                                                                    return DropdownMenuItem<
                                                                        String>(
                                                                      value:
                                                                      value,
                                                                      child:
                                                                      Text(
                                                                        value,
                                                                        style:
                                                                        TextStyle(
                                                                            fontSize: 20),
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                                ),
                                                              ],
                                                            )
                                                                : StatefulBuilder(
                                                              builder: (BuildContext
                                                              context,
                                                                  void Function(
                                                                      void
                                                                      Function())
                                                                  setState) {
                                                                return Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                      Theme(
                                                                        data:
                                                                        Theme.of(context)
                                                                            .copyWith(
                                                                          unselectedWidgetColor:
                                                                          Colors
                                                                              .greenAccent,
                                                                        ),
                                                                        child:
                                                                        RadioListTile(
                                                                          title:
                                                                          const Text(
                                                                            'True',
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .white,
                                                                                fontSize: 13),
                                                                          ),
                                                                          value:
                                                                          true,
                                                                          selectedTileColor:
                                                                          Colors.white,
                                                                          activeColor:
                                                                          Colors
                                                                              .greenAccent,
                                                                          groupValue:
                                                                          truefalse,
                                                                          onChanged:
                                                                              (
                                                                              bool? value) {
                                                                            setState(() {
                                                                              truefalse =
                                                                              value!;
                                                                            });
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                      Theme(
                                                                        data:
                                                                        Theme.of(context)
                                                                            .copyWith(
                                                                            unselectedWidgetColor: Colors
                                                                                .greenAccent),
                                                                        child:
                                                                        RadioListTile(
                                                                          activeColor:
                                                                          Colors
                                                                              .greenAccent,
                                                                          title:
                                                                          const Text(
                                                                              'False',
                                                                              style: TextStyle(
                                                                                  color: Colors
                                                                                      .white,
                                                                                  fontSize: 13)),
                                                                          value:
                                                                          false,
                                                                          groupValue:
                                                                          truefalse,
                                                                          onChanged:
                                                                              (
                                                                              bool? value) {
                                                                            setState(() {
                                                                              truefalse =
                                                                              value!;
                                                                            });
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            ),
                                                            SizedBox(
                                                              height: 30,
                                                            ),
                                                            SizedBox(
                                                              width: 150,
                                                              child: ElevatedButton(
                                                                onPressed: () {
                                                                  print(truefalse);
                                                                  if (_formKey
                                                                      .currentState!
                                                                      .validate()) {
                                                                    controller
                                                                        .answer =
                                                                        corAns;
                                                                    controller
                                                                        .category =
                                                                    category!;
                                                                    controller
                                                                        .answertf =
                                                                        truefalse;

                                                                    controller
                                                                        .option1 =
                                                                        _option1
                                                                            .text;
                                                                    controller
                                                                        .option2 =
                                                                        _option2
                                                                            .text;
                                                                    controller
                                                                        .option3 =
                                                                        _option3
                                                                            .text;
                                                                    controller
                                                                        .option4 =
                                                                        _option4
                                                                            .text;
                                                                    controller
                                                                        .option5 =
                                                                        _option5
                                                                            .text;
                                                                    controller
                                                                        .type =
                                                                    snapshot.data
                                                                        .docs[index]

                                                                    [ "type"] ==
                                                                        "options" ? 0 : 1
                                                                    ;
                                                                    controller
                                                                        .question =
                                                                        _question
                                                                            .text;

                                                                    if (snapshot.data
                                                                        .docs[index]
                                                                    [
                                                                    "type"] ==
                                                                        "options") {
                                                                      controller.updateQOptions(
                                                                          snapshot
                                                                              .data
                                                                              .docs[
                                                                          index]
                                                                              .id);
                                                                    } else {
                                                                      controller.updateQTF(
                                                                          snapshot
                                                                              .data
                                                                              .docs[
                                                                          index]
                                                                              .id);
                                                                    }

                                                                    Navigator
                                                                        .
                                                                    pop
                                                                      (
                                                                        context
                                                                    );
                                                                  }
                                                                },
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                    MaterialStateProperty
                                                                        .all(Colors
                                                                        .greenAccent)),
                                                                child: const Text(
                                                                  'Save',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 30,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ));
                                              });
                                        },
                                      ),
                                      title: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "السؤال: ${snapshot.data
                                                  .docs[index]['question']}",
                                              style:
                                              TextStyle(color: Colors.white)),
                                          Divider(
                                            color: Colors.grey.withOpacity(0.2),
                                          )
                                        ],
                                      ),
                                      leading: IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (_) {
                                                return AlertDialog(
                                                    title: const Center(
                                                      child:
                                                      Text("Confirm Deletion"),
                                                    ),
                                                    content: Container(
                                                      height: 100,
                                                      child: Column(
                                                        children: [
                                                          const Text(
                                                            "Are you sure want to delete'?",
                                                            style: TextStyle(
                                                                color:
                                                                Colors.black),
                                                          ),
                                                          SizedBox(
                                                            height: 30,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children: [
                                                              ElevatedButton.icon(
                                                                  icon: const Icon(
                                                                    Icons.cancel,
                                                                    size: 14,
                                                                  ),
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                      primary:
                                                                      Colors
                                                                          .red),
                                                                  onPressed: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  label: Text(
                                                                      "cancel")),
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                              ElevatedButton.icon(
                                                                  icon: const Icon(
                                                                    Icons.delete,
                                                                    size: 14,
                                                                  ),
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                      primary:
                                                                      Colors
                                                                          .red),
                                                                  onPressed: () {
                                                                    firestore
                                                                        .collection(
                                                                        'question')
                                                                        .doc(snapshot
                                                                        .data
                                                                        .docs[
                                                                    index]
                                                                        .id)
                                                                        .delete()
                                                                        .then((value) =>
                                                                        Navigator.pop(
                                                                            context));
                                                                  },
                                                                  label: const Text(
                                                                      "Delete"))
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ));
                                              });
                                        },
                                      ),
                                      isThreeLine: true,
                                    ),
                                    Divider(
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              );
                            }),
                        )] ,
                    )

        );
      }
    );
  }
}
