import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant.dart';

class MsgPageRoute extends StatefulWidget {
  MsgPageRoute({Key key, this.username}) : super(key: key);

  final String username;

  @override
  State<StatefulWidget> createState() {
    return MsgPageState(username);
  }
}

class MsgPageState extends State<MsgPageRoute> {
  static const channelCallNative = const MethodChannel(Constant.channel_msg);
  static const platformNativeCall =
      const MethodChannel(Constant.channel_receive_msg);

  MsgPageState(this.username);

  final String username;

  TextEditingController _msgTextFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    platformNativeCall.setMethodCallHandler((call) {
      print('收到一条新消息：${call.toString()}');
      return Future.value(666);
    });
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
      body: Column(
        children: <Widget>[
          Expanded(
            child: DecoratedBox(
              child: ListView(),
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 237, 237, 237)),
            ),
          ),
          Container(
            height: 0.5,
            color: Color.fromARGB(255, 213, 213, 213),
          ),
          Container(
            height: 52,
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
                    child: GestureDetector(
                        child: Container(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.white,
                  ),
                  child: TextField(
                    autofocus: false,
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
                        labelText: '',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white))),
                  ),
                ))),
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
    );
  }

  Future _sendTxt(String msg) async {
    try {
      await channelCallNative
          .invokeMethod('sendTxt', {'txt': msg, 'username': username});

      print(msg);

      setState(() {});
    } on PlatformException catch (e) {}
  }
}