import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  // collecting data from the database
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("user");

  //saving user data
  Future saveUserData(String email, String username) async {
    return await userCollection.doc(uid).set({
      "email": email,
      "username": username,
      "uid": uid,
    });
  }

  //getting user data from firebase
  Future getUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }
}
