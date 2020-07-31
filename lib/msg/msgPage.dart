import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lite_chat/msg/event_bus.dart';
import 'package:lite_chat/msg/model/msg.dart';
import 'package:lite_chat/user/userInfo.dart';
import 'package:lite_chat/widget/animatedText.dart';

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

class MsgPageState extends State<MsgPageRoute>
    with SingleTickerProviderStateMixin {
  static const channelCallNative =
      const MethodChannel(Constant.channel_send_msg);
  static const platformNativeCall =
      const MethodChannel(Constant.channel_receive_msg);
  static const channelConversation =
      const MethodChannel(Constant.channel_conversation);

  MsgPageState(this.username);

  final String username;
  final List<MsgContainer> _msgList = [];

  TextEditingController _msgTextFieldController = TextEditingController();

  bool _hasTxt = false;

  Animation<double> _sendButtonAnimation;
  AnimationController _sendButtonAnimController;

  @override
  void initState() {
    super.initState();

    _sendButtonAnimController =
        AnimationController(duration: Duration(milliseconds: 100), vsync: this);
    _sendButtonAnimation =
        Tween(begin: 0.5, end: 1.0).animate(_sendButtonAnimController);

    _getMsgList();

    bus.on(username, (e) {
      final msg = e as Map;
      if ('type_txt' == msg['type']) {
        print('收到一条新消息：from ${msg['from']}, txt ${msg['txt']}');
        MsgContainer baseMsg = MsgContainer(type_txt, msgFromMap(msg));
        _msgList.insert(0, baseMsg);
      }

      setState(() {});
    });

    AnimationStatusListener listener = (status) {
      print(status);
      if (status == AnimationStatus.dismissed) {
        setState(() {});
      }
    };

    _msgTextFieldController.addListener(() {
      _hasTxt = _msgTextFieldController.text != null &&
          _msgTextFieldController.text.trim() != '';

      if (_hasTxt) {
        setState(() {});
        _sendButtonAnimController.removeStatusListener(listener);
        _sendButtonAnimController.forward();
      } else {
        _sendButtonAnimController.addStatusListener(listener);
        _sendButtonAnimController.reverse();
      }
    });
  }

  @override
  void dispose() {
    bus.off(username);
    _sendButtonAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Container spaceDivider = Container(
      height: 11,
    );

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
                child: ListView.separated(
                  reverse: true,
                  itemCount: _msgList.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    MsgContainer msgContainer = _msgList[index];
                    if (type_txt == msgContainer.msgType) {
                      Msg msgTxt = msgContainer.msg as Msg;
                      if (username == msgTxt.from) {
                        return Row(
                          children: <Widget>[
                            OtherIcon(),
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              padding: EdgeInsets.only(
                                  left: 16, top: 9, right: 12, bottom: 9),
                              constraints: BoxConstraints(
                                  minWidth: 43.0,
                                  maxWidth: 240.0,
                                  minHeight: 37),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      centerSlice: Rect.fromLTWH(5, 25, 28, 7),
                                      image: AssetImage(
                                          'assets/white_bubble.png'))),
                              child: Text(
                                (msgContainer.msg as Msg).txt,
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Row(
                          textDirection: TextDirection.rtl,
                          children: <Widget>[
                            MyIcon(),
                            Container(
                              margin: EdgeInsets.only(right: 5),
                              padding: EdgeInsets.only(
                                  left: 12, top: 9, right: 16, bottom: 9),
                              constraints: BoxConstraints(
                                  minWidth: 43.0,
                                  maxWidth: 240.0,
                                  minHeight: 39),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      centerSlice: Rect.fromLTWH(5, 25, 28, 7),
                                      image: AssetImage(
                                          'assets/yellow_bubble.png'))),
                              child: Text((msgContainer.msg as Msg).txt,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 14.0)),
                            ),
                          ],
                        );
                      }
                    } else if (type_img == msgContainer.msgType) {
                      Msg msgImg = msgContainer.msg as Msg;

                      if (username == msgImg.from) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            OtherIcon(),
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  msgImg.thumbUrl,
                                  height: 150,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Row(
                          textDirection: TextDirection.rtl,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            MyIcon(),
                            Container(
                              margin: EdgeInsets.only(right: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: msgImg.thumbUrl.startsWith("http")
                                    ? Image.network(
                                        msgImg.thumbUrl,
                                        width: msgImg.width > msgImg.height &&
                                                msgImg.width > 150
                                            ? 150
                                            : null,
                                        height: msgImg.height > msgImg.width &&
                                                msgImg.height > 150
                                            ? 150
                                            : null,
                                      )
                                    : Image.file(
                                        File(msgImg.thumbUrl),
                                        width: msgImg.width > msgImg.height &&
                                                msgImg.width > 150
                                            ? 150
                                            : null,
                                        height: msgImg.height > msgImg.width &&
                                                msgImg.height > 150
                                            ? 150
                                            : null,
                                      ),
                              ),
                            ),
                          ],
                        );
                      }
                    }

                    return ListTile();
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return spaceDivider;
                  },
                ),
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
                  if (_hasTxt)
                    AnimatedText(
                      animation: _sendButtonAnimation,
                      onTap: () {
                        _sendTxt(_msgTextFieldController.text.trim());
                        _msgTextFieldController.clear();
                      },
                    )
                  else
                    Container(
                      width: 24,
                      height: 24,
                      margin: EdgeInsets.only(right: 9),
                      child: GestureDetector(
                        onTap: () {
                          _showGetPictureDialog();
                        },
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

  Future _getMsgList() async {
    try {
      List<dynamic> msgList = await channelConversation
          .invokeMethod('getMsgList', {'username': username});

      print('与${username}的聊天记录：${msgList}');

      msgList.forEach((element) {
        Msg msg = msgFromMap(element);
        MsgContainer msgContainer = MsgContainer(element['type'], msg);
        _msgList.insert(0, msgContainer);
      });

      setState(() {});
    } on PlatformException catch (e) {}
  }

  Future _sendTxt(String msg) async {
    try {
      await channelCallNative
          .invokeMethod('sendTxt', {'txt': msg, 'username': username});

      Msg msgTxt = Msg(
          username: username,
          from: loginUser,
          to: username,
          time: new DateTime.now().millisecondsSinceEpoch,
          txt: msg);

      MsgContainer msgContainer = MsgContainer(type_txt, msgTxt);

      _msgList.insert(0, msgContainer);

      bus.emit(username, msgToMap(msgTxt));

      print(msg);

      setState(() {});
    } on PlatformException catch (e) {}
  }

  Future _sendImg(String path) async {
    try {
      Map map = await channelCallNative
          .invokeMethod('sendImg', {'imgPath': path, 'username': username});

      Msg msg = msgFromMap(map);
      print('图片已发送：$msg');

      MsgContainer msgContainer = MsgContainer(type_img, msg);

      _msgList.insert(0, msgContainer);

      bus.emit(username, map);

      setState(() {});
    } on PlatformException catch (e) {}
  }

  void _showGetPictureDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('选择照片'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('相册'),
                onPressed: () {
                  _selectPicture();
                  Navigator.pop(context);
                },
              ),
              SimpleDialogOption(
                child: Text('拍照'),
                onPressed: () {
                  _takePicture();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future _takePicture() async {
    var image = await ImagePicker().getImage(source: ImageSource.camera);
    if (null != image) {
      print('图片路径${image.path}');
      _sendImg(image.path);
    }
  }

  Future _selectPicture() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    if (null != image) {
      print('图片路径${image.path}');
      _sendImg(image.path);
    }
  }
}

class OtherIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 39,
      height: 39,
      margin: EdgeInsets.only(left: 10),
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
    );
  }
}

class MyIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 39,
      height: 39,
      margin: EdgeInsets.only(right: 10),
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
    );
  }
}
