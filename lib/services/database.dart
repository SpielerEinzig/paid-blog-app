import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  FirebaseFirestore database = FirebaseFirestore.instance;

  //set data on registration
  setDefaultData(
      {required String uid,
      required String email,
      required String password,
      required bool paymentStatus,
      required String role}) async {
    return await database.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'password': password,
      'paymentStatus': paymentStatus,
      'role': role,
    });
  }
}
