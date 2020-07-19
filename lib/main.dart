import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lite_chat/homepage.dart';
import 'package:lite_chat/indexPage.dart';
import 'package:lite_chat/tab_item/ChatTab.dart';
import 'package:lite_chat/tab_item/baseTab.dart';
import 'package:lite_chat/tab_item/friendsTab.dart';
import 'package:lite_chat/tab_item/myTab.dart';
import 'package:lite_chat/tab_item/newWorldTab.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LiteChat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: IndexPage(),
    );
  }
}
