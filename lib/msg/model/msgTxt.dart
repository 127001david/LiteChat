// To parse this JSON data, do
//
//     final msgTxt = msgTxtFromJson(jsonString);

import 'dart:convert';

import 'package:lite_chat/msg/model/baseMsg.dart';

MsgTxt msgTxtFromJson(String str) => MsgTxt.fromJson(json.decode(str));

String msgTxtToJson(MsgTxt data) => json.encode(data.toJson());

class MsgTxt implements BaseMsg {
  MsgTxt({
    this.from,
    this.to,
    this.txt,
  });

  String from;
  String to;
  String txt;

  factory MsgTxt.fromJson(Map<String, dynamic> json) => MsgTxt(
        from: json["from"],
        to: json["to"],
        txt: json["txt"],
      );

  Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
        "txt": txt,
      };
}
