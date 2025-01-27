import 'package:dashboard/ViewModel/GetX/QuizGetx.dart';
import 'package:dashboard/constant.dart';
import 'package:dashboard/view/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widget/Widget_CreateQuiz.dart';

class ResultQuiz extends StatefulWidget {
  final  data;

  const ResultQuiz({super.key, required this.data});

  @override
  State<ResultQuiz> createState() => _ResultQuizState();
}

class _ResultQuizState extends State<ResultQuiz> {
  var ranks = {};
  double? total;
  final quizGetX = Get.put(QuizGetX());
  final prizeController = TextEditingController();

  @override
  void initState() {
    quizGetX.getRanks(widget.data['name']).then((value) {
      setState(() {
        ranks.addAll(value);
      });
    }).then((value) {
      quizGetX.getTotal(widget.data.id).then((value) => total = value);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBarColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.data['name'],
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          // Edit Button
          IconButton(
            onPressed: () {
              showDialog<void>(context: context, barrierDismissible: false, builder: (BuildContext context) {
                return const CreateQuiz();
              });
            },
            icon: const Icon(Icons.edit, color: Colors.white),
          ),
          // Delete Button
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: const Center(child: Text("Confirm Deletion")),
                    content: SizedBox(
                      height: 130,
                      child: Column(
                        children: [
                          Text("Are you sure you want to delete '${widget.data['name']}'?", style: const TextStyle(color: Colors.black)),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                icon: const Icon(Icons.cancel, size: 14),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                onPressed: () => Get.back(),
                                label: const Text("Cancel"),
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.delete, size: 14),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                onPressed: () {
                                  firestore.collection('quiz').doc(widget.data['id']).delete().then((_) {
                                    firestore.collection(widget.data['name']).get().then((snapshot) {
                                      for (var doc in snapshot.docs) {
                                        doc.reference.delete();
                                      }
                                    });
                                  });
                                  Get.back();
                                  Get.back();
                                },
                                label: const Text("Delete"),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
        backgroundColor: appBarColor,
      ),
      body: ranks.isEmpty
          ? const Center(child: Text("No ranks available.", style: TextStyle(color: Colors.white)))
          : ListView.separated(
        reverse: false,
        itemBuilder: (context, index) {
          return ranks[index] == null
              ? const EmptyWidget()
              : StreamBuilder(
            stream: firestore
                .collection('users')
                .where('uid', isEqualTo: ranks[index][0])
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator.adaptive());
              }

              if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                return const EmptyWidget();
              }

              final user = snapshot.data.docs[0];
              final rank = index + 1;

              return ListTile(
                textColor: Colors.white,
                leading: Text('Rank $rank', style: const TextStyle(fontSize: 14)),
                title: Text(user['name'] ?? 'Unknown'),
                subtitle: Text('Phone: ${user['phone'] ?? 'N/A'}'),
                trailing: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    _showSendPrizeDialog(context, rank, index, user);
                  },
                ),
              );
            },
          );
        },
        itemCount: ranks.length,
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }

  void _showSendPrizeDialog(BuildContext context, int rank, int index, dynamic user) {
    showDialog(
      context: context,
      builder: (_) {
        final prize = (widget.data['Rank$rank'] ?? 0) * (total ?? 0) / 100;

        return AlertDialog(
          title: const Center(child: Text("Send Prize")),
          content: SizedBox(
            height: 230,
            child: Column(
              children: [
                Text('Correct Answer: ${ranks[index][1]}'),
                Text('Total prize: $total'),
                Text('Type Coins: ${widget.data['typeCoins']}'),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(label: Text('Prize')),
                  controller: prizeController..text = prize.toString(),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.cancel, size: 14),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => Get.back(),
                      label: const Text("Cancel"),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.send, size: 14),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
                      onPressed: () {
                        final coin = widget.data['typeCoins'];
                        final updatedCoin = (user[coin] ?? 0) + prize;

                        // Update the user's coin
                        firestore
                            .collection('users')
                            .doc(ranks[index][0])
                            .update({coin: updatedCoin})
                            .then((_) {
                          // Remove the item from the ranks list
                          Get.back(); // Close the dialog


                          // Show success snackbar
                          Get.snackbar(
                            "Success",
                            "Prize sent successfully!",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        }).catchError((error) {
                          // Handle error (optional)
                          Get.snackbar(
                            "Error",
                            "Failed to send prize: $error",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        });
                      },
                      label: const Text("Send"),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
