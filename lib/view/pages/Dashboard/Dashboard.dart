import 'package:flutter/material.dart';
import '../../../constant.dart';
import '../../widget/total_widget.dart';
import '../Categories/TotalCategories.dart';
import '../quiz/Quiz.dart';
import '../Users/users.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: appBarColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder(
                stream: firestore.collection('quiz').snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  return snapshot.connectionState == ConnectionState.waiting
                      ? const CircularProgressIndicator(
                    backgroundColor: Colors.greenAccent,
                  )
                      :  TotalWidget(
                    total: snapshot.data.docs.length.toString(),
                    title: 'Quiz',
                    widget: Quiz(),
                  );
                }),
            StreamBuilder(
                stream: firestore.collection('category').snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  return snapshot.connectionState == ConnectionState.waiting
                      ? const CircularProgressIndicator(
                          backgroundColor: Colors.greenAccent,
                        )
                      : TotalWidget(
                          total: snapshot.data.docs.length.toString(),
                          title: 'Categories',
                          widget: TotalCategories(),
                        );
                }),
            StreamBuilder(
                stream: firestore.collection('users').snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  return snapshot.connectionState == ConnectionState.waiting
                      ? const CircularProgressIndicator(
                    backgroundColor: Colors.greenAccent,
                  )
                      :  TotalWidget(
                    total: snapshot.data.docs.length.toString(),
                    title: 'Users',
                    widget: Users(),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
