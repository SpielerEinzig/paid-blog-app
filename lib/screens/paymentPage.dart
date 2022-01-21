import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack_client/flutter_paystack_client.dart';
import 'package:subscription_app/screens/home.dart';
import 'package:subscription_app/screens/user/userHome.dart';
import 'package:subscription_app/services/authentication.dart';

class PaymentPage extends StatefulWidget {
  static const String id = 'paymentPage';
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance.collection('users');
  late User? loggedInUser;
  String _message = '';

  getUserCredentials() async {
    try {
      final result = await _auth.currentUser;
      if (result != null) {
        loggedInUser = result;
        print(loggedInUser!.email);
        print(loggedInUser!.uid);
        final DocumentSnapshot doc =
            await _database.doc(loggedInUser!.uid).get();
        print(doc.data());
        if (doc.exists) {
          setState(() {
            Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
            // You can then retrieve the value from the Map like this:
            var value = data?['paymentStatus'];
            print(value);
            if (value == true) {
              print('the payment status is $value');
              Navigator.pushNamed(context, UserHome.id);
            }
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Authenticate().signOut();
            Navigator.popAndPushNamed(context, HomeScreen.id);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SizedBox(
        child: Column(
          children: [
            Text('Click pay to subscribe for premium blog content'),
            ElevatedButton(
                onPressed: () async {
                  DateTime paymentDate = DateTime.now();
                  DateTime paymentDueDate =
                      paymentDate.add(Duration(minutes: 1));
                  Duration difference = paymentDueDate.difference(paymentDate);

                  final charge = Charge()
                    ..email = loggedInUser!.email
                    ..amount = 5000 * 100
                    ..reference =
                        'ref_${DateTime.now().millisecondsSinceEpoch}';
                  final res =
                      await PaystackClient.checkout(context, charge: charge);

                  if (res.message == 'Approved') {
                    _message = 'Charge was successful. Ref: ${res.reference}';
                    print(_message);
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(loggedInUser!.uid)
                        .set({"paymentDueDate": paymentDueDate},
                            SetOptions(merge: true)).then((value) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(loggedInUser!.uid)
                          .update({"paymentStatus": true});
                      Navigator.pushNamed(context, UserHome.id);
                    });
                  } else {
                    _message = 'Failed: ${res.message}';
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Get premium content'),
                )),
            getFreeBlogStream(),
          ],
        ),
      ),
    );
  }
}

getFreeBlogStream() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('freeBlog')
        .orderBy('date')
        .snapshots(),
    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      if (snapshot.hasData) {
        List<Widget> blogList = [];
        final blogSnapShot = snapshot.data!.docs.reversed;

        for (var blog in blogSnapShot) {
          Map<String, dynamic>? blogPosts =
              blog.data() as Map<String, dynamic>?;
          final mainText = blogPosts?['mainText'];
          final copyText = blogPosts?['copyText'];
          final timeStamp = blogPosts?['date'];

          final newBlog = singleBlogPost(
            mainText: mainText,
            copyText: copyText,
            date: timeStamp.toDate(),
          );
          blogList.add(newBlog);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: blogList,
          ),
        );
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

Widget singleBlogPost(
    {required String mainText,
    required String copyText,
    required DateTime date}) {
  return Card(
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
    child: Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Posted on: " + date.toString()),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              mainText,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(copyText),
              IconButton(
                icon: Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: copyText));
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
