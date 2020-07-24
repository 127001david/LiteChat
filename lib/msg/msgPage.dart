import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lite_chat/msg/event_bus.dart';
import 'package:lite_chat/msg/model/msgTxt.dart';

import '../constant.dart';
import 'model/baseMsg.dart';

class MsgPageRoute extends StatefulWidget {
  MsgPageRoute({Key key, this.username}) : super(key: key);

  final String username;

  @override
  State<StatefulWidget> createState() {
    return MsgPageState(username);
  }
}

class MsgPageState extends State<MsgPageRoute> {
  static const channelCallNative =
      const MethodChannel(Constant.channel_send_msg);
  static const platformNativeCall =
      const MethodChannel(Constant.channel_receive_msg);

  MsgPageState(this.username);

  final String username;
  final List<MsgContainer> msgList = [];

  TextEditingController _msgTextFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();

    bus.on(username, (e) {
      final msg = e as Map;
      if('type_txt' == msg['type']) {
        print('收到一条新消息：from ${msg['from']}, txt ${msg['txt']}');
        MsgContainer baseMsg = MsgContainer(msg_type.txt, msgTxtFromMap(msg));
        msgList.insert(0, baseMsg);
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    bus.off(username);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(username), actions: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 12),
          child: Icon(Icons.more_horiz),
        )
      ]),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: <Widget>[
            Expanded(
              child: DecoratedBox(
                child: ListView.builder(
                    reverse: true,
                    itemCount: msgList.length,
                    itemBuilder: (context, index) {
                      if (msg_type.txt == msgList[index].msgType) {
                        MsgTxt msgTxt = msgList[index].msg as MsgTxt;
                        if (username == msgTxt.from) {
                          return Row(
                            children: <Widget>[
                              Container(
                                width: 39,
                                height: 39,
                                margin: EdgeInsets.only(left: 10, bottom: 11),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        color: Colors.orangeAccent),
                                    child: Icon(
                                      Icons.perm_contact_calendar,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5, bottom: 11),
                                padding: EdgeInsets.only(
                                    left: 16, top: 9, right: 12, bottom: 9),
                                constraints: BoxConstraints(
                                    minWidth: 43.0,
                                    maxWidth: 240.0,
                                    minHeight: 37),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        centerSlice:
                                            Rect.fromLTWH(5, 25, 28, 7),
                                        image: AssetImage(
                                            'assets/white_bubble.png'))),
                                child: Text(
                                  (msgList[index].msg as MsgTxt).txt,
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Row(
                            textDirection: TextDirection.rtl,
                            children: <Widget>[
                              Container(
                                width: 39,
                                height: 39,
                                margin: EdgeInsets.only(right: 10, bottom: 11),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: DecoratedBox(
                                    decoration:
                                        BoxDecoration(color: Colors.grey),
                                    child: Icon(
                                      Icons.perm_contact_calendar,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 5, bottom: 11),
                                padding: EdgeInsets.only(
                                    left: 12, top: 9, right: 16, bottom: 9),
                                constraints: BoxConstraints(
                                    minWidth: 43.0,
                                    maxWidth: 240.0,
                                    minHeight: 39),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        centerSlice:
                                            Rect.fromLTWH(5, 25, 28, 7),
                                        image: AssetImage(
                                            'assets/yellow_bubble.png'))),
                                child: Text((msgList[index].msg as MsgTxt).txt,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 14.0)),
                              ),
                            ],
                          );
                        }
                      }

                      return ListTile();
                    }),
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 237, 237, 237)),
              ),
            ),
            Container(
              height: 0.5,
              color: Color.fromARGB(255, 213, 213, 213),
            ),
            Container(
              constraints: BoxConstraints(minHeight: 52),
              color: Color.fromARGB(255, 247, 247, 247),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 24,
                    height: 24,
                    margin: EdgeInsets.only(left: 10, right: 9),
                    child: GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        'assets/laba.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.symmetric(vertical: 7),
                    padding: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: TextField(
                      autofocus: false,
                      minLines: 1,
                      maxLines: 4,
                      cursorColor: Color.fromARGB(255, 7, 193, 96),
                      cursorWidth: 2,
                      controller: _msgTextFieldController,
                      textInputAction: TextInputAction.send,
                      onEditingComplete: () {
                        String txt = _msgTextFieldController.text;
                        if (null != txt && '' != txt.trim()) {
                          _sendTxt(txt);
                          _msgTextFieldController.clear();
                        }
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          isDense: true,
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                    ),
                  )),
                  Container(
                    width: 24,
                    height: 24,
                    margin: EdgeInsets.only(left: 10, right: 12),
                    child: GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        'assets/emoji.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    margin: EdgeInsets.only(right: 9),
                    child: GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        'assets/more_panel.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _sendTxt(String msg) async {
    try {
      await channelCallNative
          .invokeMethod('sendTxt', {'txt': msg, 'username': username});

      MsgTxt msgTxt = MsgTxt(to: username, txt: msg);

      MsgContainer baseMsg = MsgContainer(msg_type.txt, msgTxt);

      msgList.insert(0, baseMsg);

      print(msg);

      setState(() {});
    } on PlatformException catch (e) {}
  }
}
