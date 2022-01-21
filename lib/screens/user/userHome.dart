import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:subscription_app/screens/admin/blog.dart';
import 'package:subscription_app/screens/home.dart';
import 'package:subscription_app/screens/messages.dart';
import 'package:subscription_app/screens/paymentPage.dart';
import 'package:subscription_app/services/authentication.dart';

class UserHome extends StatefulWidget {
  static const String id = 'userHome';
  const UserHome({Key? key}) : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  checkPaymentStatus() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(loggedInUser!.uid)
        .get()
        .then((DocumentSnapshot doc) {
      final paymentDue = doc['paymentDueDate'];
      print(paymentDue);
      DateTime finaPaymentDate = paymentDue.toDate();
      print(finaPaymentDate);
      print(DateTime.now());
      if (DateTime.now().isAfter(finaPaymentDate)) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(loggedInUser!.uid)
            .update(
          {"paymentStatus": false},
        ).then((value) {
          Navigator.pushNamed(context, PaymentPage.id);
        });
      } else {
        return;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPaymentStatus();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Authenticate().signOut();
                Navigator.popAndPushNamed(context, HomeScreen.id);
              },
              icon: Icon(Icons.arrow_back),
            ),
            title: Text('Welcome'),
            bottom: TabBar(tabs: [
              Text('Blog'),
              Text('Messages'),
            ]),
          ),
          body: TabBarView(children: [
            Blog(),
            Messages(),
          ]),
        ));
  }
}
