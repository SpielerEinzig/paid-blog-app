import 'package:firebase_auth/firebase_auth.dart';
import 'package:subscription_app/services/database.dart';

class Authenticate {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late bool paymentStatus;

  //register with email and password
  register({required String email, required String password}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      //create new document as user signs up
      await DatabaseService().setDefaultData(
        uid: user!.uid,
        email: email,
        password: password,
        role: 'user',
        paymentStatus: false,
      );
    } catch (e) {
      print(e);
    }
  }

  //sign in with email and password
  signIn({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  //sign out
  signOut() async {
    await _auth.signOut();
  }

  //reset password
  resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
