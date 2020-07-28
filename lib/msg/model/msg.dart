import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:lite_chat/msg/model/baseMsg.dart';

Msg msgFromMap(Map map) {
  Msg msg;

  switch (map['type']) {
    case 'type_txt':
      msg = Msg(
          from: map['from'], to: map['to'], time: map['time'], txt: map['txt']);
      break;
    case 'type_img':
      msg = Msg(
          from: map['from'],
          to: map['to'],
          time: map['time'],
          original: map['original'],
          thumbUri: map['thumbUri'],
          txt: map['imgUri']);
      break;
    case 'type_voice':
      msg = Msg(
          from: map['from'],
          to: map['to'],
          time: map['time'],
          txt: map['voiceUri'],
          length: map['length']);
      break;
    default:
      msg = Msg(from: map['from'], to: map['to'], time: map['time']);
  }

  return msg;
}

Map msgToMap(Msg data) {
  Map msg = Map();

  msg['username'] = data.username;
  msg['from'] = data.from;
  msg['to'] = data.to;

  if(null != data.time) {
    msg['time'] = data.time;
  }

  if(null != data.txt) {
    msg['txt'] = data.txt;
  }

  if(null != data.original) {
    msg['original'] = data.original;
  }

  if(null != data.imgUri) {
    msg['imgUri'] = data.imgUri;
  }

  if(null != data.voiceUri) {
    msg['voiceUri'] = data.voiceUri;
  }

  if(null != data.length) {
    msg['length'] = data.length;
  }

  if(null != data.thumbUri) {
    msg['thumbUri'] = data.thumbUri;
  }

  if(null != data.videoUri) {
    msg['videoUri'] = data.videoUri;
  }

  if(null != data.fileUri) {
    msg['fileUri'] = data.fileUri;
  }

  return msg;
}

class Msg implements BaseMsg {
  Msg(
      {this.username,
      this.from,
      this.to,
      this.time,
      this.txt,
      this.original,
      this.imgUri,
      this.voiceUri,
      this.length,
      this.thumbUri,
      this.videoUri,
      this.fileUri});

  String username;
  String from;
  String to;
  int time;
  String txt;
  bool original;
  String imgUri;
  String voiceUri;
  int length;
  String thumbUri;
  String videoUri;
  String fileUri;
}
