import 'package:dashboard/Models/options.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import '../../ViewModel/GetX/QuizGetx.dart';
import '../../constant.dart';
import 'DropDownWidget.dart';
import 'package:get/get.dart';

class CreateQuiz extends StatefulWidget {
  const CreateQuiz({Key? key}) : super(key: key);

  @override
  State<CreateQuiz> createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  String? dropdownValue;
  TextEditingController rank1Controller = TextEditingController();
  TextEditingController rank2Controller = TextEditingController();
  TextEditingController rank3Controller = TextEditingController();
  TextEditingController rank4Controller = TextEditingController();
  TextEditingController rank5Controller = TextEditingController();
  TextEditingController rank6Controller = TextEditingController();
  TextEditingController rank7Controller = TextEditingController();
  TextEditingController rank8Controller = TextEditingController();
  TextEditingController rank9Controller = TextEditingController();
  TextEditingController rank10Controller = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController profitController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController minController = TextEditingController();
  TextEditingController maxController = TextEditingController();
  TextEditingController descController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String _selectedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String time = '5';
  String _startDate = DateFormat('hh:mm:ss').format(DateTime.now());
  String coin = 'RedCoins';

  String _endDate =
      DateFormat('HH:mm:ss').format(DateTime.now().add(Duration(minutes: 15)));
  var timelist = [
    '10 Minutes',
    '15 Minutes',
    '20 Minutes',
    '25 Minutes',
    '30 Minutes'
  ];
  var typeCoin = [
    'redCoins',
    'greenCoins',
    'yellowCoins',
  ];
  var controller = Get.put(QuizGetX());
  List<Options> optionsList = [];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuizGetX>(builder: (c) {
      return AlertDialog(
        backgroundColor: appBarColor.withOpacity(0.9),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: ListBody(
              children: <Widget>[
                const Text(
                  'Category',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 5,
                ),
                MultiSelectDialogField(
                  title: const Text(
                    'Categories',
                    style: TextStyle(color: Colors.black),
                  ),
                  buttonText: const Text(
                    'Category',
                    style: TextStyle(color: Colors.white54),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white)),
                  items: controller.optionsModelList
                      .map((a) => MultiSelectItem<Options>(a, a.name))
                      .toList(),
                  listType: MultiSelectListType.CHIP,
                  onConfirm: (List<Options> values) {
                    optionsList = values;
                    controller.selectedOptionList.value.clear();
                    values.forEach((element) {
                      controller.selectedOptionList.value.add(element.name);
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                InputField(
                    controller: nameController,
                    label: 'Quiz name',
                    hint: 'Enter Quiz Name',
                    iconOrdrop: 'icon',
                    isEnabled: true,
                    texth: 15),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: InputField(
                          controller: maxController,
                          label: 'Max User',
                          hint: "Enter Max User",
                          isEnabled: true,
                          iconOrdrop: 'icon',
                          texth: 15,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        flex: 1,
                        child: InputField(
                          controller: minController,
                          label: 'Min User',
                          hint: "Enter Min User",
                          isEnabled: true,
                          iconOrdrop: 'icon',
                          texth: 15,
                        )),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                InputField(
                    controller: imageUrlController,
                    label: 'Image Url',
                    hint: 'Enter Image UrL',
                    iconOrdrop: 'icon',
                    isEnabled: true,
                    texth: 15),
                SizedBox(
                  height: 10,
                ),
                InputField(
                  texth: 15,
                  controller: _dateController,
                  isValidate: false,

                  isEnabled: false,
                  hint: '${_selectedDate.toString()}',
                  label: 'Date',
                  iconOrdrop: 'button',
                  widget: IconButton(
                    icon: Icon(
                      Icons.date_range,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _selectDate(context);
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: InputField(
                        texth: 15,
                        isEnabled: false,
                        isValidate: false,
                        controller: _startTimeController,
                        label: 'Start Time',
                        iconOrdrop: 'button',
                        hint: _startDate.toString(),
                        widget: IconButton(
                          icon: const Icon(
                            Icons.access_time,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _selectStartTime(context);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: InputField(
                      texth: 15,
                      controller: _endTimeController,
                      isEnabled: false,
                          isValidate: false,

                          iconOrdrop: 'button',
                      label: 'End Time',
                      hint: _endDate.toString(),
                      widget: IconButton(
                        icon: const Icon(
                          Icons.access_time,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _selectEndTime(context);
                        },
                      ),
                    ))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                InputField(
                  controller: _timeController,
                  isEnabled: false,
                  isValidate: false,

                  hint: '${time.toString()}',
                  label: 'Quiz Time',
                  iconOrdrop: 'drop',
                  widget: DropdownButton(
                    items: timelist
                        .map<DropdownMenuItem<String>>(
                            (value) => DropdownMenuItem<String>(
                                value: value.toString(),
                                child: Text(
                                  '$value',
                                  style: TextStyle(color: Colors.black),
                                )))
                        .toList(),
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                    iconSize: 20,
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        time = newValue!;
                        _timeController.text = time;
                      });
                    },
                  ),
                  texth: 15,
                ),
                SizedBox(
                  height: 10,
                ),
                InputField(
                  isEnabled: false,
                  hint: coin,
                  isValidate: false,

                  label: 'typeCoins',
                  iconOrdrop: 'drop',
                  widget: DropdownButton(
                    items: typeCoin
                        .map<DropdownMenuItem<String>>(
                            (value) => DropdownMenuItem<String>(
                                value: value.toString(),
                                child: Text(
                                  '$value',
                                  style: TextStyle(color: Colors.black),
                                )))
                        .toList(),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                    iconSize: 20,
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        coin = newValue!;
                      });
                    },
                  ),
                  texth: 15,
                ),
                const SizedBox(
                  height: 10,
                ),
                ExpansionTile(
                  iconColor: Colors.white,
                  collapsedIconColor: Colors.white,
                  title: const Text(
                    'Ranks',
                    style: TextStyle(color: Colors.white),
                  ),
                  children: [
                    Column(
                      children: [
                        InputField(
                          controller: rank1Controller,
                          label: 'Rank1',
                          hint: '%',
                          iconOrdrop: 'icon',
                          isEnabled: true,
                          texth: 12,
                          widget: const Icon(
                            Icons.percent,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        InputField(
                            controller: rank2Controller,
                            label: 'Rank2',
                            hint: '%',
                            iconOrdrop: 'icon',
                            isEnabled: true,
                            texth: 12),
                        const SizedBox(
                          height: 5,
                        ),
                        InputField(
                            label: 'Rank3',
                            hint: '%',
                            iconOrdrop: 'icon',
                            isEnabled: true,
                            controller: rank3Controller,
                            texth: 12),
                        const SizedBox(
                          height: 5,
                        ),
                        InputField(
                            label: 'Rank4',
                            hint: '%',
                            controller: rank4Controller,
                            iconOrdrop: 'icon',
                            isEnabled: true,
                            texth: 12),
                        SizedBox(
                          height: 5,
                        ),
                        InputField(
                            label: 'Rank5',
                            hint: '%',
                            controller: rank5Controller,
                            iconOrdrop: 'icon',
                            isEnabled: true,
                            texth: 12),
                        SizedBox(
                          height: 5,
                        ),
                        InputField(
                            label: 'Rank6',
                            hint: '%',
                            controller: rank6Controller,
                            iconOrdrop: 'icon',
                            isEnabled: true,
                            texth: 12),
                        SizedBox(
                          height: 5,
                        ),
                        InputField(
                            controller: rank7Controller,
                            label: 'Rank7',
                            hint: '%',
                            iconOrdrop: 'icon',
                            isEnabled: true,
                            texth: 12),
                        SizedBox(
                          height: 5,
                        ),
                        InputField(
                            controller: rank8Controller,
                            label: 'Rank8',
                            hint: '%',
                            iconOrdrop: 'icon',
                            isEnabled: true,
                            texth: 12),
                        SizedBox(
                          height: 5,
                        ),
                        InputField(
                            controller: rank9Controller,
                            label: 'Rank9',
                            hint: '%',
                            iconOrdrop: 'icon',
                            isEnabled: true,
                            texth: 12),
                        SizedBox(
                          height: 5,
                        ),
                        InputField(
                            controller: rank10Controller,
                            label: 'Rank10',
                            hint: '%',
                            iconOrdrop: 'icon',
                            isEnabled: true,
                            texth: 12),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                InputField(
                    label: 'Your Profit',
                    controller: profitController,
                    hint: '%',
                    iconOrdrop: 'icon',
                    isEnabled: true,
                    texth: 15),
                const SizedBox(
                  height: 10,
                ),
                InputField(
                    controller: priceController,
                    label: 'Price',
                    hint: '\$',
                    iconOrdrop: 'icon',
                    isEnabled: true,
                    texth: 15),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  minLines: 4,
                  maxLines: 5,
                  controller: descController,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return 'Please Enter Description';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.normal),
                      hintStyle: const TextStyle(color: Colors.grey),
                      hintText: 'Description',
                      fillColor: Colors.white,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20)),
                      ),
                      border: new UnderlineInputBorder(
                          borderSide: new BorderSide(color: Colors.white))),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {

                    controller.price = double.tryParse(priceController.text);
                    controller.profit = double.tryParse(profitController.text);
                    controller.imageUrl = imageUrlController.text;
                    controller.name = nameController.text;
                    controller.max = int.tryParse(maxController.text);
                    controller.min = int.tryParse(minController.text);
                    controller.desc = descController.text;
                    controller.date = _selectedDate.toString();
                    controller.startTime = _startDate.toString();
                    controller.endTime = _endDate.toString();
                    controller.coin = coin;
                    controller.rank1 = int.tryParse(rank1Controller.text);
                    controller.rank2 = int.tryParse(rank2Controller.text);
                    controller.rank3 = int.tryParse(rank3Controller.text);
                    controller.rank4 = int.tryParse(rank4Controller.text);
                    controller.rank5 = int.tryParse(rank5Controller.text);
                    controller.rank6 = int.tryParse(rank6Controller.text);
                    controller.rank7 = int.tryParse(rank7Controller.text);
                    controller.rank8 = int.tryParse(rank8Controller.text);
                    controller.rank9 = int. tryParse(rank9Controller.text);
                    controller.rank10 = int.tryParse(rank10Controller.text);
                    if(_formKey.currentState!.validate()){
                      if(optionsList.isEmpty){
Get.snackbar("Error"," Please select category");
                      }else{
                        controller.createQuiz(context);

                      }

                    }

                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.greenAccent)),
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'cancel',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      );
    });
  }

  _selectStartTime(BuildContext context) async {
    final TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    var date = join(DateTime.parse(_selectedDate), selected!);
    print(date);
    var formattedTime = DateFormat("HH:mm:ss").format(date);
    print(formattedTime);

    setState(() {
      _startDate = formattedTime;
    });
  }

  _selectEndTime(BuildContext context) async {
    final TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    var date = join(DateTime.parse(_selectedDate), selected!);
    print(date);
    var formattedTime = DateFormat("HH:mm:ss").format(date);
    print(formattedTime);
    // Conversion logic starts here
    setState(() {
      _endDate = formattedTime;
      print(formattedTime);
    });
  }

  DateTime join(DateTime date, TimeOfDay time) {
    print(time.hour);
    return new DateTime(
        date.year, date.month, date.day, time.hour, time.minute);
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      currentDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    setState(() {
      if (selected != null) {
        _selectedDate = DateFormat('yyyy-MM-dd').format(selected).toString();
        print(_selectedDate);
      } else {
        _selectedDate =
            DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
      }
    });
  }
}
