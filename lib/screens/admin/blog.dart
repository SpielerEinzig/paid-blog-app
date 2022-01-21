import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Blog extends StatefulWidget {
  const Blog({Key? key}) : super(key: key);

  @override
  _BlogState createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          getBlogStream(),
        ],
      ),
    );
  }
}

getBlogStream() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('blog')
        .orderBy('date')
        .snapshots(),
    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      if (snapshot.hasData) {
        List<Widget> blogList = [];

        final blogSnapshot = snapshot.data!.docs.reversed;
        for (var blog in blogSnapshot) {
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
      return Center(child: CircularProgressIndicator());
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
