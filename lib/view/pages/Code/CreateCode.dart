import 'package:dashboard/ViewModel/GetX/codeGetx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant.dart';
import '../../widget/DropDownWidget.dart';
import 'codes.dart';

class CreateCode extends StatefulWidget {
  const CreateCode({Key? key}) : super(key: key);

  @override
  State<CreateCode> createState() => _CreateCodeState();
}

class _CreateCodeState extends State<CreateCode> {
  final TextEditingController _coinsController = TextEditingController();
  String coins = 'redCoins';
  List<String> coinsList = [
    'redCoins',
    'greenCoins',
    'yellowCoins',
  ];

  var codeController = TextEditingController();
  var priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appBarColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.to(Codes());
                  },
                  child: Text(' View all codes'),
                  style: ElevatedButton.styleFrom(primary: appBarColor),
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: Colors.white,
                      size: 20,
                    ))
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Center(
                child: Container(
              width: 300,
              height: 420,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: appBarColor,
                  boxShadow: const [
                    BoxShadow(blurRadius: 100, color: Colors.white38),
                  ]),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    InputField(
                      controller: _coinsController,
                      isEnabled: false,
                      hint: '${coins.toString()}',
                      label: 'Select Coins',
                      iconOrdrop: 'drop',
                      widget: DropdownButton(
                        items: coinsList
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
                            coins = newValue!;
                            _coinsController.text = coins;
                          });
                        },
                      ),
                      texth: 15,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InputField(
                        label: 'Code',
                        controller: codeController,
                        hint: '###########',
                        iconOrdrop: 'icon',
                        isEnabled: true,
                        texth: 15),
                    SizedBox(
                      height: 20,
                    ),
                    InputField(
                        label: 'Price',
                        controller: priceController,
                        hint: '\$',
                        iconOrdrop: 'icon',
                        isEnabled: true,
                        texth: 15),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (priceController.text.isEmpty ||
                            codeController.text.isEmpty) {
                          Get.snackbar(
                              'Something error', 'please fill all fields',
                              backgroundColor: Colors.white);
                        } else {
                          if (codeController.text.length == 15) {
                            CodeGetX()
                                .postCode(codeController.text, coins,
                                    double.parse(priceController.text))
                                .then((value) {
                              Get.snackbar('Jacobia', 'Successfully added',
                                  backgroundColor: Colors.white);
                              priceController.clear();
                               codeController.clear();
                            });
                          } else {
                            Get.snackbar(
                                'Jacobia', 'code must be 15 text length',
                                colorText: Colors.red,
                                backgroundColor: Colors.white);
                          }
                        }
                      },
                      child: Text('Save'),
                      style: ElevatedButton.styleFrom(primary: appBarColor),
                    )
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
