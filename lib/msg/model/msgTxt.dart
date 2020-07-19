// To parse this JSON data, do
//
//     final msgTxt = msgTxtFromJson(jsonString);

import 'dart:convert';

MsgTxt msgTxtFromJson(String str) => MsgTxt.fromJson(json.decode(str));

String msgTxtToJson(MsgTxt data) => json.encode(data.toJson());

class MsgTxt {
  MsgTxt({
    this.form,
    this.to,
    this.txt,
  });

  String form;
  String to;
  String txt;

  factory MsgTxt.fromJson(Map<String, dynamic> json) => MsgTxt(
        form: json["form"],
        to: json["to"],
        txt: json["txt"],
      );

  Map<String, dynamic> toJson() => {
        "form": form,
        "to": to,
        "txt": txt,
      };
}
