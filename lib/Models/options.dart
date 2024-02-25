import 'package:cloud_firestore/cloud_firestore.dart';

class Options {
  String name;
  String imageUrl;

  Options({
    required this.name,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'imageUrl': imageUrl,
  };

  Options.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc):
        name = doc.data()!["name"],
  imageUrl=doc.data()!['imageUrl'];


}