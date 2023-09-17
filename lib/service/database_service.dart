import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // database reference
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("users");

  // group coll ref
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  // saving user data
  Future savingUserData(String fullName, String email) async {
    return await collectionReference.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid
    });
  }

  // getting user data
  Future getUserData(String email) async{
    QuerySnapshot querySnapshot = await collectionReference.where(
      "email",isEqualTo: email
    ).get();
    return querySnapshot;
  }
}
