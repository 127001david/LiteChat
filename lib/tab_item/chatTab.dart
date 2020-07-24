import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lite_chat/msg/event_bus.dart';
import 'package:lite_chat/msg/model/conversation.dart';
import 'package:lite_chat/msg/msgPage.dart';
import 'package:lite_chat/tab_item/baseTab.dart';
import 'package:lite_chat/user/friendOptions.dart';

import '../constant.dart';

class ChatTabWidget extends BaseTabWidget<ChatTabState> {
  @override
  State<StatefulWidget> createState() {
    return ChatTabState();
  }
}

class ChatTabState extends BaseTabWidgetState<ChatTabWidget> {
  static const channelCallNative =
      const MethodChannel(Constant.channel_conversation);
  List<Map> _conversations = [];

  @override
  void initState() {
    super.initState();
    title = '轻聊';

    _getConversations();

    bus.on(null, (e) {
      final msg = e as Map;
      if ('type_txt' == msg['type']) {
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget divider = Container(
      height: 0.2,
      color: Colors.grey[400],
      margin: EdgeInsets.only(left: 67),
    );

    return Center(
      child: ListView.separated(
        itemCount: _conversations.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return MsgPageRoute(
                    username: _conversations[index]['username']);
              }));
            },
            child: Row(
              children: <Widget>[
                Container(
                  width: 43,
                  height: 43,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.grey),
                      child: Icon(
                        Icons.perm_contact_calendar,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Text(_conversations[index]['username'])
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return divider;
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future _getConversations() async {
    try {
      List<dynamic> conversations =
          await channelCallNative.invokeMethod('getConversations');

      conversations.forEach((element) {
        _conversations.add(element);
      });

      print(conversations);

      setState(() {});
    } on PlatformException catch (e) {}
  }
}
