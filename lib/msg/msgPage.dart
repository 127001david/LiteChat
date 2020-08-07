import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin_record/flutter_plugin_record.dart';
import 'package:flutter_plugin_record/play_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lite_chat/msg/event_bus.dart';
import 'package:lite_chat/msg/model/msg.dart';
import 'package:lite_chat/user/userInfo.dart';
import 'package:lite_chat/widget/animatedText.dart';
import 'package:lite_chat/widget/morePanel.dart';
import 'package:lite_chat/widget/msgItem.dart';
import 'package:path_provider/path_provider.dart';

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
  FocusNode _msgTextFieldFocusNode = FocusNode();

  bool _hasTxt = false;

  Animation<double> _sendButtonAnimation;
  AnimationController _sendButtonAnimController;

  bool _showMorePanel = false;

  bool _resizeToAvoidBottomInset = true;

  bool _voice = false;

  FlutterPluginRecord _recordPlugin = FlutterPluginRecord();
  String _recordPath;
  int _recordTime;

  @override
  void initState() {
    super.initState();

    _sendButtonAnimController =
        AnimationController(duration: Duration(milliseconds: 100), vsync: this);
    _sendButtonAnimation =
        Tween(begin: 0.5, end: 1.0).animate(_sendButtonAnimController);

    _recordPlugin.init();

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

    _msgTextFieldFocusNode.addListener(() {
      if (_msgTextFieldFocusNode.hasFocus) {
        setState(() {
          _showMorePanel = false;
        });
      }
    });

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
      resizeToAvoidBottomInset: _resizeToAvoidBottomInset,
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
          setState(() {
            _showMorePanel = false;
          });
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
                        return OtherTxt(msgTxt);
                      } else {
                        return MyTxt(msgTxt);
                      }
                    } else if (type_img == msgContainer.msgType) {
                      Msg msgImg = msgContainer.msg as Msg;

                      if (username == msgImg.from) {
                        return OtherImg(msgImg);
                      } else {
                        return MyImg(msgImg);
                      }
                    } else if (type_voice == msgContainer.msgType) {
                      Msg msgVoice = msgContainer.msg as Msg;

                      if (username == msgVoice.from) {
                        return OtherVoice(msgVoice.length.toString());
                      } else {
                        return MyVoice(msgVoice.length.toString());
                      }
                    }

                    return ListTile(
                      title: Text(msgContainer.msgType),
                    );
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
                      onTap: () {
                        setState(() {
                          _voice = !_voice;
                        });
                      },
                      child: Image.asset(
                        _voice ? 'assets/keyboard.png' : 'assets/laba.png',
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
                    child: _voice
                        ? Center(
                            child: GestureDetector(
                              onTapDown: (detail) async {
                                print('detail:$detail');
                                Directory d =
                                    await getApplicationDocumentsDirectory();
                                _recordTime =
                                    DateTime.now().millisecondsSinceEpoch;
                                _recordPlugin.response.listen((event) {
                                  print('recordState:$event');
                                  if ('onStop' == event.msg) {
                                    _recordPath = event.path;
                                    _recordTime = event.audioTimeLength ~/ 1000;
                                    print(
                                        '_recordPath:$_recordPath     _recordTime:$_recordTime');
                                    _sendVoice(_recordPath, _recordTime);
                                  }
                                });
                                _recordPlugin.start();
                              },
                              onTapUp: (detail) {
                                _recordPlugin.stop();
                              },
                              onTapCancel: () {
                                print('record cancel');
                                _recordPlugin.stop();
                              },
                              child: Text(
                                '按住 说话',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 25, 25, 25)),
                              ),
                            ),
                          )
                        : TextField(
                            autofocus: false,
                            minLines: 1,
                            maxLines: 4,
                            cursorColor: Color.fromARGB(255, 7, 193, 96),
                            cursorWidth: 2,
                            focusNode: _msgTextFieldFocusNode,
                            controller: _msgTextFieldController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                isDense: true,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                disabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white))),
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
                          setState(() {
                            _showMorePanel = true;
                          });

                          _msgTextFieldFocusNode.unfocus();
                        },
                        child: Image.asset(
                          'assets/more_panel.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            _showMorePanel
                ? MorePanel(_selectPicture, _takePicture, null, null, null)
                : Container()
          ],
        ),
      ),
    );
  }

  Future _getMsgList() async {
    try {
      List<dynamic> msgList = await channelConversation
          .invokeMethod('getMsgList', {'username': username});

      msgList.forEach((element) {
        Msg msg = msgFromMap(element);
        print(msg);
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

  Future _sendVoice(String path, int length) async {
    try {
      Map map = await channelCallNative.invokeMethod('sendVoice', {
        'voicePath': path,
        'length': length.toString(),
        'username': username
      });

      Msg msg = msgFromMap(map);
      print('语音已发送：$msg');

      MsgContainer msgContainer = MsgContainer(type_voice, msg);

      _msgList.insert(0, msgContainer);

      bus.emit(username, map);

      setState(() {});
    } on PlatformException catch (e) {}
  }

  Future _takePicture() async {
    var image = await ImagePicker().getImage(source: ImageSource.camera);
    if (null != image) {
      print('图片路径${image.path}');
      _sendImg(image.path);
    }
    setState(() {
      _showMorePanel = false;
    });
  }

  Future _selectPicture() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    if (null != image) {
      print('图片路径${image.path}');
      _sendImg(image.path);
    }
    setState(() {
      _showMorePanel = false;
    });
  }
}
