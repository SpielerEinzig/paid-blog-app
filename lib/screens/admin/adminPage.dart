import 'package:flutter/material.dart';
import 'package:subscription_app/screens/admin/blog.dart';
import 'package:subscription_app/screens/admin/dashboard.dart';
import 'package:subscription_app/screens/home.dart';
import 'package:subscription_app/screens/messages.dart';
import 'package:subscription_app/services/authentication.dart';

class AdminPage extends StatefulWidget {
  static const String id = 'adminPage';

  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Authenticate().signOut();
              Navigator.popAndPushNamed(context, HomeScreen.id);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text('Welcome, Admin'),
          bottom: TabBar(
            tabs: [
              Text('DashBoard'),
              Text('Blog'),
              Text('Messages'),
            ],
          ),
        ),
        body: TabBarView(children: [
          AdminDashboard(),
          Blog(),
          Messages(),
        ]),
      ),
    );
  }
}
