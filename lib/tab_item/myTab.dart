import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lite_chat/indexPage.dart';

import '../constant.dart';
import 'baseTab.dart';

class MyTabWidget extends BaseTabWidget {
  @override
  State<StatefulWidget> createState() {
    return MyTabState();
  }
}

class MyTabState extends BaseTabWidgetState<MyTabWidget> {
  static const channelCallNative =
      const MethodChannel(Constant.channel_user_info);

  String _username = '';

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Color.fromARGB(255, 237, 237, 237)),
      child: Column(
        children: [
          Container(
            height: 181,
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  margin: EdgeInsets.only(left: 20, top: 81, right: 14),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.orangeAccent),
                      child: Icon(
                        Icons.perm_contact_calendar,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(top: 81),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _username,
                        style: TextStyle(
                            color: Color.fromARGB(255, 25, 25, 25),
                            fontSize: 20),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        child: Text(
                          '轻号：nice_body',
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          softWrap: false,
                          style: TextStyle(
                              color: Color.fromARGB(255, 127, 127, 127),
                              fontSize: 13),
                        ),
                      )
                    ],
                  ),
                )),
                Container(
                  margin: EdgeInsets.only(left: 17, top: 126, right: 17),
                  child: Image.asset(
                    'assets/qr_code_tiny.png',
                    width: 12,
                    height: 12,
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 0.7,
            color: Color.fromARGB(255, 229, 229, 229),
            margin: EdgeInsets.only(left: 0),
          ),
          Container(
            height: 0.7,
            color: Color.fromARGB(255, 229, 229, 229),
            margin: EdgeInsets.only(left: 0, top: 7),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('退出当前账号'),
                      actions: [
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              '取消',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 127, 127, 127)),
                            )),
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _logout();
                            },
                            child: Text('确定')),
                      ],
                    );
                  });
            },
            child: Container(
              height: 50,
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    width: 19,
                    height: 19,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Image.asset('assets/setting.png'),
                  ),
                  Expanded(
                      child: Text(
                    '退出登录',
                    style: TextStyle(
                        color: Color.fromARGB(255, 25, 25, 25), fontSize: 15),
                  )),
                  Icon(Icons.navigate_next,
                      color: Color.fromARGB(255, 169, 169, 169)),
                ],
              ),
            ),
          ),
          Container(
            height: 0.7,
            color: Color.fromARGB(255, 229, 229, 229),
            margin: EdgeInsets.only(left: 0),
          )
        ],
      ),
    );
  }

  bool get wantKeepAlive => true;

  Future _getUserInfo() async {
    try {
      String username = await channelCallNative.invokeMethod('checkLogin');

      setState(() {
        _username = username;
      });
    } on PlatformException catch (e) {}
  }

  /// 退出登录
  Future<void> _logout() async {
    try {
      await channelCallNative.invokeMethod('logout');

      print('login success');
    } on PlatformException catch (e) {
      print(e);
    }

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => IndexPage()));
  }
}
