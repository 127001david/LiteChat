import 'dart:convert';

import 'package:lite_chat/msg/model/baseMsg.dart';

MsgTxt msgTxtFromMap(Map msg) {
  MsgTxt msgTxt = MsgTxt(from: msg['from'], txt: msg['txt']);
  return msgTxt;
}

Map msgTxtToMap(MsgTxt data) {
  Map msg = Map();

  msg['from'] = data.from;
  msg['to'] = data.to;
  msg['txt'] = data.txt;

  return msg;
}

class MsgTxt implements BaseMsg {
  MsgTxt({
    this.from,
    this.to,
    this.txt,
  });

  String from;
  String to;
  String txt;
}
