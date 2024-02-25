import 'package:get/get.dart';
import '../../constant.dart';

class UsersGetx extends GetxController {
  var requestDocs= firestore.collection('requests').snapshots();
  var users= firestore.collection('users').snapshots();

  Future removeRequest(String documentPath)async{
   await firestore.collection('requests').doc(documentPath).delete();
 }
  Future removeUser(String documentPath)async{
    await firestore.collection('Users').doc(documentPath).delete();
  }

}
