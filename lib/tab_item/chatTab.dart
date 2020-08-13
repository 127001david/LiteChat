import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
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

      for (int i = 0; i < _conversations.length; i++) {
        if (_conversations[i]['username'] == msg['username']) {
          _conversations.removeAt(i);

          _conversations.insert(0, msg);

          setState(() {});
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget divider = Container(
      height: 0.7,
      color: Color.fromARGB(255, 229, 229, 229),
      margin: EdgeInsets.only(left: 67),
    );

    var format = intl.DateFormat('HH:mm');

    return Center(
      child: ListView.separated(
        itemCount: _conversations.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          Map msg = _conversations[index];

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
                Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 14),
                              child: Text(
                                  format.format(
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          _conversations[index]['time'])),
                                  style: TextStyle(
                                      fontSize: 11,
                                      color:
                                          Color.fromARGB(255, 178, 178, 178))),
                            ),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  _conversations[index]['username'],
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 25, 25, 25)),
                                )),
                          ],
                        ),
                        if ('type_txt' == msg['type'])
                          Text(_conversations[index]['txt'],
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Color.fromARGB(255, 178, 178, 178)))
                        else
                          Text('[${msg['type']}]',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Color.fromARGB(255, 178, 178, 178)))
                      ],
                    ))
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
