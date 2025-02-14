import 'package:dashboard/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '';
import '../../../ViewModel/GetX/users_getx.dart';
import '../../empty_widget.dart';

class UsersRequest extends StatelessWidget {
  UsersGetx userRequests = UsersGetx();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: userRequests.requestDocs,
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
                      padding: EdgeInsets.only(left: 10),
                      color: appBarColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Recent Users",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SingleChildScrollView(
                            child: SizedBox(
                              width: double.infinity,
                              child: DataTable(
                                horizontalMargin: 0,
                                columnSpacing: 20,
                                columns: const [
                                  DataColumn(
                                    label: Text(
                                      "Name",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "TypeCoins",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Coins",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "operation",
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
        });
  }
}

DataRow recentUserDataRow(
    int index, BuildContext context, AsyncSnapshot snapshot) {
  return DataRow(
    cells: [
      DataCell(
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            snapshot.data.docs[index]['name'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
      DataCell(GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                    title: Center(
                      child: Text(snapshot.data.docs[index]['typeCoins']),
                    ),
                    content: Container(
                      height: 140,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "    المبلغ الذي يريد سحبه :  ${snapshot.data.docs[index]['withdrawal']}",
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.phone),
                              Text(
                                  " رقم الموبيل :  ${snapshot.data.docs[index]['phone']}"),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                  icon: const Icon(
                                    Icons.call,
                                    size: 14,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  label: Text("call")),
                              const SizedBox(
                                width: 20,
                              ),
                              ElevatedButton.icon(
                                  icon: const Icon(
                                    Icons.phone,
                                    size: 14,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                  onPressed: () {},
                                  label: const Text("chat"))
                            ],
                          )
                        ],
                      ),
                    ));
              });
        },
        child: Text(
          snapshot.data.docs[index]['typeCoins'],
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      )),
      DataCell(Text(
        snapshot.data.docs[index]['withdrawal'].toString(),
        style: TextStyle(color: Colors.white, fontSize: 12),
      )), 
      DataCell(Row(
        children: [
          InkWell(
            onTap: () {

              String key = snapshot.data.docs[index]['typeCoins'];
              double currentCoins = snapshot.data.docs[index][key] ?? 0.0;
              double withdrawal = snapshot.data.docs[index]['withdrawal'] ?? 0.0;

              firestore
                  .collection("users")
                  .doc(snapshot.data.docs[index]['uid'])
                  .update({
                key: currentCoins - withdrawal,
              })
                  .then((value) {
                UsersGetx().removeRequest(snapshot.data.docs[index].id);
              })
                  .catchError((error) {
                print("Error updating user data: $error");
              });
            },
            child: const Text(
              'Accept',
              style: TextStyle(color: Colors.greenAccent, fontSize: 13),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              UsersGetx().removeRequest(snapshot.data.docs[index].id);
            },
            child: const Text(
              'Reject',
              style: TextStyle(color: Colors.red, fontSize: 13),
            ),
          )
        ],
      )),
    ],
  );
}
