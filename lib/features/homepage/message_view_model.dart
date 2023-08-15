import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ogretmentalepleri/features/homepage/message_model.dart';
import 'package:ogretmentalepleri/product/widgets/my_toast_message_widget.dart';

class MessageViewModel {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> sendMessage(
      String userID, String message, String nameSurname, List<String>? messageTitle) async {
    try {
      firebaseFirestore.collection('message').doc(firebaseAuth.currentUser!.uid).set(MessageModel(
        userID: firebaseAuth.currentUser!.uid,
        message: '$nameSurname, $message',
          messageTitle: messageTitle,
        dateTime: DateTime.now()
      ).toMap());
    } on FirebaseAuthException catch (e) {
      await MyToastMessageWidget().toast(
          msg: 'Bir sorunla karşılaşıldı. Lütfen daha sonra tekrar deneyiniz!');
    }
  }

  Future<void> signAnonymmously() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      print("Signed in with temporary account.");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
    }
  }
}
