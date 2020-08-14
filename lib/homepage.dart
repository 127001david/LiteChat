import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lite_chat/friends/add.dart';
import 'package:lite_chat/msg/event_bus.dart';
import 'package:lite_chat/msg/model/msg.dart';

import 'constant.dart';
import 'tab_item/baseTab.dart';
import 'tab_item/chatTab.dart';
import 'tab_item/friendsTab.dart';
import 'tab_item/myTab.dart';
import 'tab_item/newWorldTab.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  static const platformNativeCall =
      const MethodChannel(Constant.channel_receive_msg);

  List<BaseTabWidget> _tabViews = [
    ChatTabWidget(),
    FriendsTabWidget(),
    NewWorldTabWidget(),
    MyTabWidget()
  ];
  List _titles = ['轻聊', '通讯录', '发现', '我'];
  int _selectedIndex = 0;
  bool _showAction = true;

  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    platformNativeCall.setMethodCallHandler((call) {
      final msg = call.arguments as Map;
      bus.emit(msg['from'], msgFromMap(msg));

      return Future.value(666);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: <Widget>[
          _showAction
              ? PopupMenuButton<String>(
                  icon: Icon(Icons.add),
                  onSelected: (value) {
                    switch (value) {
                      case '发起群聊':
                        break;
                      case '添加朋友':
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AddFriendRoute()));
                        break;
                      case '扫一扫　':
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        child: Text('发起群聊'),
                      ),
                      PopupMenuItem(
                        value: '添加朋友',
                        child: Text('添加朋友'),
                      ),
                      PopupMenuItem(
                        child: Text('扫一扫　'),
                      )
                    ];
                  },
                )
              : Container(
                  width: 0,
                  height: 0,
                ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 26, 183, 80),
        backgroundColor: Color.fromARGB(255, 245, 245, 245),
        unselectedItemColor: Color.fromARGB(255, 30, 30, 30),
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble), title: Text('轻聊')),
          BottomNavigationBarItem(icon: Icon(Icons.people), title: Text('通讯录')),
          BottomNavigationBarItem(icon: Icon(Icons.public), title: Text('发现')),
          BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('我')),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _tabViews,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _showAction = (0 == index || 1 == index);
      _selectedIndex = index;
    });

    _pageController.jumpToPage(_selectedIndex);
  }
}
