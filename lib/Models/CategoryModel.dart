import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String name;
  String imageUrl;
  String id;

  Category({
    required this.name,
    required this.imageUrl,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'imageUrl': imageUrl,
    'id': id,
  };

  static Category fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Category(
      name: snapshot['name'],
      imageUrl: snapshot['imageUrl'],
      id: snapshot['id'],
    );
  }
}