import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack_client/flutter_paystack_client.dart';
import 'package:subscription_app/screens/admin/adminPage.dart';
import 'package:subscription_app/screens/home.dart';
import 'package:subscription_app/screens/logIn.dart';
import 'package:subscription_app/screens/paymentPage.dart';
import 'package:subscription_app/screens/register.dart';
import 'package:subscription_app/screens/user/userHome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyD7_-jMdkjvxffgdGpVSrcc-JBPZ1g7ctw",
          authDomain: "subscription-appdemo.firebaseapp.com",
          projectId: "subscription-appdemo",
          storageBucket: "subscription-appdemo.appspot.com",
          messagingSenderId: "477411027893",
          appId: "1:477411027893:web:036244247c25be086507fc"));
  await PaystackClient.initialize(
      'pk_test_8cc3cb26890264ab857ff4bf11a5c41fd53010be');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        LogIn.id: (context) => LogIn(),
        Register.id: (context) => Register(),
        AdminPage.id: (context) => AdminPage(),
        PaymentPage.id: (context) => PaymentPage(),
        UserHome.id: (context) => UserHome(),
      },
    );
  }
}
