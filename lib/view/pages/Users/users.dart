import 'package:dashboard/constant.dart';
import 'package:flutter/material.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:get/get.dart';
import '../../../Models/UsersModel.dart';
import '../../../ViewModel/GetX/users_getx.dart';
import '../../empty_widget.dart';

class Users extends StatelessWidget {
  UsersGetx users = UsersGetx();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Users',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder(
          stream: users.users,
          builder: (context, AsyncSnapshot snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.greenAccent,
                    ),
                  )
                : snapshot.data.docs.length == 0
                    ? EmptyWidget()
                    : Container(
                        padding: EdgeInsets.all(20),
                        color: appBarColor,
                        child: ListView(
                          children: [
                            const Text(
                              "Recent Users",
                              style: TextStyle(color: Colors.white),
                            ),
                            SingleChildScrollView(
                              child: SizedBox(
                                width: double.infinity,
                                child: DataTable(
                                  horizontalMargin: 1,
                                  columnSpacing: 1,
                                  columns: const [
                                    DataColumn(
                                      label: Text(
                                        "Name",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "Phone",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "Details",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                  rows: List.generate(
                                    snapshot.data.docs.length,
                                    (index) => recentUserDataRow(
                                        index, context, snapshot),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
          }),
    );
  }
}

DataRow recentUserDataRow(
    int index, BuildContext context, AsyncSnapshot snapshot) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Icon(
              Icons.person_2_outlined,
              color: Colors.greenAccent,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                snapshot.data.docs[index]['name'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
      DataCell(Text(
        snapshot.data.docs[index]['phone'],
        style: TextStyle(color: Colors.white, fontSize: 12),
      )),
      DataCell(IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: const Center(
                    child: Text("Details"),
                  ),
                  content: ListView(
                    children: [
                      Divider(),
                      ListTile(
                          leading: const Text('Email'),
                          trailing: SizedBox(
                            width: 150,
                            child: Center(
                              child: Text(

                                snapshot.data.docs[index]['email'] ?? '',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          )),
                      Divider(),
                      ListTile(
                          leading: const Text('Created At'),
                          trailing: Text(
                            snapshot.data.docs[index]['createdAt'] ?? '',
                            style: TextStyle(fontSize: 12),
                          )),
                      Divider(),
                      ListTile(
                          leading: const Text('Password'),
                          trailing: Text(
                            snapshot.data.docs[index]['password'] ?? '',
                            style: const TextStyle(fontSize: 12),
                          )),
                      const Divider(),
                      ListTile(
                          leading: const Text('Address'),
                          trailing: Text(
                            snapshot.data.docs[index]['address'] ?? '',
                          )),
                      Divider(),
                      ListTile(
                          leading: const Text('Nationality'),
                          trailing: Text(
                            snapshot.data.docs[index]['nationality'] ?? '',
                          )),
                      Divider(),
                      SizedBox(
                        child: ListTile(
                            leading: const Text('Red Coins'),
                            trailing: Text(
                              snapshot.data.docs[index]['redCoins']
                                      .toString() ??
                                  '',
                            )),
                      ),
                      Divider(),
                      ListTile(
                          leading: const Text('Green Coins'),
                          trailing: Text(
                            snapshot.data.docs[index]['greenCoins']
                                    .toString() ??
                                '',
                          )),
                      Divider(),
                      ListTile(
                          leading: const Text('Yellow Coins'),
                          trailing: Text(
                            snapshot.data.docs[index]['yellowCoins']
                                    .toString() ??
                                '',
                          )),
                      Divider(),
                      ListTile(
                        leading: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                        title: const Center(
                                          child: Text("Confirm Deletion"),
                                        ),
                                        content: Container(
                                          height: 120,
                                          child: Column(
                                            children: [
                                              Text(
                                                "Are you sure want to delete '${snapshot.data.docs[index]['name']}'?",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
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
                                                              backgroundColor:
                                                                  Colors.red),
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
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Colors.red),
                                                      onPressed: () async {
                                                        print(snapshot
                                                            .data
                                                            .docs[index]
                                                            .id); // Debugging: Check ID
                                                        await firestore
                                                            .collection('users')
                                                            .doc(snapshot.data
                                                                .docs[index].id)
                                                            .delete()
                                                            .then((v) {
                                                          Get.back();
                                                          Get.back();
                                                        });
                                                      },
                                                      label:
                                                          const Text("Delete"))
                                                ],
                                              )
                                            ],
                                          ),
                                        ));
                                  });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                        trailing: InkWell(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            Get.back();
                          },
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
        icon: Icon(
          Icons.arrow_circle_right_outlined,
          color: Colors.greenAccent,
        ),
      )),
    ],
  );
}
