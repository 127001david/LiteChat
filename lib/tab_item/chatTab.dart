import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:lite_chat/msg/event_bus.dart';
import 'package:lite_chat/msg/model/baseMsg.dart';
import 'package:lite_chat/msg/model/conversation.dart';
import 'package:lite_chat/msg/model/msg.dart';
import 'package:lite_chat/msg/msgPage.dart';
import 'package:lite_chat/msg/video_call/videoCall.dart';
import 'package:lite_chat/tab_item/baseTab.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constant.dart';

/// 会话列表，首页"轻聊"tab，会话列表以每个会话的最新一条消息为 item
class ChatTabWidget extends BaseTabWidget<ChatTabState> {
  @override
  State<StatefulWidget> createState() {
    return ChatTabState();
  }
}

class ChatTabState extends BaseTabWidgetState<ChatTabWidget> {
  static const platformNativeCall =
      const MethodChannel(Constant.channel_receive_msg);
  static const channelCallNative =
      const MethodChannel(Constant.channel_conversation);

  /// 用于页面展示
  List<Conversation> _conversationList = [];

  /// 用于更新会话内容
  Map<String, Conversation> _conversationMap = {};
  EventCallback _eventCallback;

  @override
  void initState() {
    super.initState();
    username = '轻聊';

    _getConversations();

    // 消息由 ChatTabState 页接收然后通过 EventBus 分发给监听者
    platformNativeCall.setMethodCallHandler((call) async {
      if ('receiveMsg' == call.method) {
        final arguments = call.arguments;
        final msg = msgFromMap(arguments);
        bus.emit('msg_from_${msg.from}', msg);

        _updateConversation(msg.username, msg);
        _updateTotalUnreadMsgCount();
        setState(() {});
      } else if ('receiveCmd' == call.method) {
        await [Permission.camera, Permission.microphone, Permission.storage]
            .request();

        await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          final arguments = call.arguments;
          final channel = arguments['channel'];
          print('channel : $channel');
          return CallPage(
            channelName: channel,
          );
        }));
      }

      return Future.value(666);
    });

    // 监听所有消息，替换列表中的会话
    _eventCallback = (e) {
      final msg = e as Msg;

      _updateConversation(msg.username, msg, unreadMsg: 0);

      setState(() {});
    };

    bus.on('conversations', _eventCallback);
  }

  @override
  void deactivate() {
    super.deactivate();
    print('chatTab deactivated');
  }

  @override
  void dispose() {
    super.dispose();
    bus.off('conversations', _eventCallback);
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
        itemCount: _conversationList.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          Conversation conversation = _conversationList[index];
          Msg msg = conversation.msg;
          String unreadMsg;
          String msgDsc;

          if (0 >= conversation.unreadMsgCount) {
            unreadMsg = '';
          } else if (10 > conversation.unreadMsgCount) {
            unreadMsg = conversation.unreadMsgCount.toString();
          } else {
            unreadMsg = '...';
          }

          switch (msg.type) {
            case type_txt:
              msgDsc = msg.txt;
              break;
            case type_img:
              msgDsc = "一张图片";
              break;
            case type_voice:
              msgDsc = "一段语音";
              break;
            case type_video:
              msgDsc = "一段视频";
              break;
            case type_file:
              msgDsc = "一个文件";
              break;
            default:
              msgDsc = "：）";
          }

          return InkWell(
            onTap: () {
              _clearConversationUnreadMsg(msg.username);

              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return MsgPageRoute(username: msg.username);
              }));
            },
            child: Row(
              children: <Widget>[
                Badge(
                  badgeColor: Color.fromARGB(255, 250, 82, 81),
                  shape: BadgeShape.circle,
                  showBadge: '' != unreadMsg,
                  borderRadius: 100,
                  padding: EdgeInsets.all(4),
                  position: BadgePosition.topRight(top: 2, right: 8),
                  animationType: BadgeAnimationType.fade,
                  badgeContent: Text(unreadMsg,
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  child: Container(
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
                                          msg.time)),
                                  style: TextStyle(
                                      fontSize: 11,
                                      color:
                                          Color.fromARGB(255, 178, 178, 178))),
                            ),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  msg.username,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 25, 25, 25)),
                                )),
                          ],
                        ),
                        if (type_txt == msg.type)
                          Text(msgDsc,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Color.fromARGB(255, 178, 178, 178)))
                        else
                          Text('[$msgDsc]',
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

  bool get wantKeepAlive => true;

  Future _getConversations() async {
    try {
      List<dynamic> conversations =
          await channelCallNative.invokeMethod('getConversations');

      conversations.forEach((element) {
        int unreadMsg = element['unreadMsg'];
        var msg = msgFromMap(element);
        var conversation =
            Conversation(msg.username, msg, unreadMsgCount: unreadMsg);
        _conversationList.add(conversation);
        _conversationMap[msg.username] = conversation;
      });

      print(conversations);

      setState(() {});
    } on PlatformException catch (e) {
      print(e);
    }

    _updateTotalUnreadMsgCount();
  }

  /// 根据[username]更新对应的会话数据，[unreadMsg]为 null 时表示接收到一条新消息，会话中的未读消息数自增 1
  void _updateConversation(String username, Msg msg, {int unreadMsg}) {
    var conversation = _conversationMap[username];
    if (null == conversation) {
      conversation = Conversation(username, msg, unreadMsgCount: 0);
      _conversationMap[username] = conversation;
      _conversationList.insert(0, conversation);
    } else {
      conversation.msg = msg;
      if (null == unreadMsg) {
        conversation.unreadMsgCount = conversation.unreadMsgCount + 1;
      } else {
        conversation.unreadMsgCount = unreadMsg;
      }

      _conversationList.remove(conversation);
      _conversationList.insert(0, conversation);
    }
  }

  /// 清除[username]对应的会话的未读消息数
  void _clearConversationUnreadMsg(String username) {
    var conversation = _conversationMap[username];
    if (null != conversation) {
      conversation.unreadMsgCount = 0;
    }
    _updateTotalUnreadMsgCount();

    setState(() {});
  }

  /// 更新总未读消息数
  Future _updateTotalUnreadMsgCount() async {
    var totalUnreadMsgCount = 0;
    _conversationList.forEach((element) {
      totalUnreadMsgCount += element.unreadMsgCount;
    });
    bus.emit('totalUnreadMsgCount', totalUnreadMsgCount);
  }
}
