import 'msg.dart';

class Conversation {
  Conversation(this.username, this.msg, {this.unreadMsgCount});

  String username;
  Msg msg;
  int unreadMsgCount;
}
