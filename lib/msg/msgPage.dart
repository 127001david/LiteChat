import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lite_chat/msg/event_bus.dart';
import 'package:lite_chat/msg/model/msg.dart';
import 'package:lite_chat/record/recordVoice.dart';
import 'package:lite_chat/user/userInfo.dart';
import 'package:lite_chat/widget/animatedText.dart';
import 'package:lite_chat/widget/morePanel.dart';
import 'package:lite_chat/widget/msgItem.dart';
import 'package:path_provider/path_provider.dart';

import '../constant.dart';
import 'model/baseMsg.dart';

/// 聊天页
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
  final List<Msg> _msgList = [];

  EventCallback _receiveMsg;

  TextEditingController _msgTextFieldController = TextEditingController();
  FocusNode _msgTextFieldFocusNode = FocusNode();

  bool _hasTxt = false;

  String baseVoiceDir;

  Animation<double> _sendButtonAnimation;
  AnimationController _sendButtonAnimController;

  bool _showMorePanel = false;

  bool _resizeToAvoidBottomInset = true;

  bool _voice = false;
  AudioPlayer _audioPlayer = AudioPlayer();

  bool _dispose = false;

  @override
  void initState() {
    super.initState();

    _sendButtonAnimController =
        AnimationController(duration: Duration(milliseconds: 100), vsync: this);
    _sendButtonAnimation =
        Tween(begin: 0.5, end: 1.0).animate(_sendButtonAnimController);

    _getMsgList();

    _initRecordPath();

    _receiveMsg = (e) {
      final msg = e as Msg;
      _msgList.insert(0, msg);

      setState(() {});
    };

    bus.on(username, _receiveMsg);

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
    _dispose = true;
    bus.off(username, _receiveMsg);
    _sendButtonAnimController?.dispose();
    _audioPlayer?.release();
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
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  child: DecoratedBox(
                    child: ListView.separated(
                      reverse: true,
                      itemCount: _msgList.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        Msg msg = _msgList[index];
                        if (type_txt == msg.type) {
                          if (username == msg.from) {
                            return OtherTxt(msg);
                          } else {
                            return MyTxt(msg);
                          }
                        } else if (type_img == msg.type) {
                          if (username == msg.from) {
                            return OtherImg(msg);
                          } else {
                            return MyImg(msg);
                          }
                        } else if (type_voice == msg.type) {
                          if (username == msg.from) {
                            SharePlayingWidget shareDataWidget =
                                SharePlayingWidget(
                              msg.playing,
                              child: OtherVoice(msg.length, () {
                                _playVoice(msg);
                              }),
                            );

                            return shareDataWidget;
                          } else {
                            SharePlayingWidget shareDataWidget =
                                SharePlayingWidget(
                              msg.playing,
                              child: MyVoice(msg.length, () {
                                _playVoice(msg);
                              }),
                            );

                            return shareDataWidget;
                          }
                        }

                        return ListTile(
                          title: Text(msg.type),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return spaceDivider;
                      },
                    ),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 237, 237, 237)),
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
                            ? RecordVoice(
                                key: GlobalKey(),
                                recordPath:
                                    '$baseVoiceDir/${DateTime.now().millisecondsSinceEpoch}.wav',
                                startRecord: () async {},
                                stopRecord: (path, length) async {
                                  print('_recordPath:$path     length:$length');
                                  _sendVoice(path, length);
                                },
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
          ],
        ),
      ),
    );
  }

  Future _initRecordPath() async {
    Directory baseDir = await getApplicationDocumentsDirectory();

    baseVoiceDir = '${baseDir.path}/voice';
  }

  Future _getMsgList() async {
    try {
      List<dynamic> msgList = await channelConversation
          .invokeMethod('getMsgList', {'username': username});

      msgList.forEach((element) {
        Msg msg = msgFromMap(element);
        _msgList.insert(0, msg);
      });

      setState(() {});
    } on PlatformException catch (e) {}
  }

  Future _sendTxt(String txt) async {
    try {
      await channelCallNative
          .invokeMethod('sendTxt', {'txt': txt, 'username': username});

      Msg msg = Msg(
          type: type_txt,
          username: username,
          from: loginUser,
          to: username,
          time: new DateTime.now().millisecondsSinceEpoch,
          txt: txt);

      addMsgToList(msg);

      print('文字已发送:$txt');
    } on PlatformException catch (e) {}
  }

  Future _sendImg(String path) async {
    try {
      Map map = await channelCallNative
          .invokeMethod('sendImg', {'imgPath': path, 'username': username});

      Msg msg = msgFromMap(map);
      print('图片已发送：$msg');

      addMsgToList(msg);
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

      addMsgToList(msg);
    } on PlatformException catch (e) {}
  }

  void addMsgToList(Msg msg) {
    _msgList.insert(0, msg);

    bus.off(username, _receiveMsg);
    bus.emit(username, msg);
    bus.on(username, _receiveMsg);

    setState(() {});
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

  void _playVoice(Msg msg) {
    print(msg.voiceUri);
    if (AudioPlayerState.PLAYING == _audioPlayer.state) {
      _audioPlayer.stop();
      setState(() {
        msg.playing = false;
      });

      return;
    }
    _audioPlayer.play(msg.voiceUri);
    setState(() {
      msg.playing = true;
    });

    _audioPlayer.onPlayerStateChanged.listen((event) {
      if (AudioPlayerState.COMPLETED == _audioPlayer.state ||
          AudioPlayerState.STOPPED == _audioPlayer.state) {
        if (!_dispose) {
          setState(() {
            msg.playing = false;
          });
        }
      }
    });
  }
}
