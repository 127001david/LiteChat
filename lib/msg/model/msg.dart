import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:lite_chat/msg/model/baseMsg.dart';

/// 聊天消息实体类
Msg msgFromMap(Map map) {
  Msg msg;

  switch (map['type']) {
    case 'type_txt':
      msg = Msg(
          type: map['type'],
          username: map['username'],
          from: map['from'],
          to: map['to'],
          time: map['time'],
          txt: map['txt']);
      break;
    case 'type_img':
      msg = Msg(
          type: map['type'],
          username: map['username'],
          from: map['from'],
          to: map['to'],
          time: map['time'],
          original: map['original'],
          imgUrl: map['imgUrl'],
          thumbUrl: map['thumbUrl'],
          width: map['width'],
          height: map['height']);
      break;
    case 'type_voice':
      msg = Msg(
          type: map['type'],
          username: map['username'],
          from: map['from'],
          to: map['to'],
          time: map['time'],
          voiceUri: map['voiceUri'],
          length: map['length']);
      break;
    case 'type_video_call':
      msg = Msg(
          type: map['type'],
          username: map['username'],
          from: map['from'],
          to: map['to'],
          time: map['time'],
          channel: map['channel']);
      break;
    case 'type_video_call_cancel':
      msg = Msg(
          type: map['type'],
          username: map['username'],
          from: map['from'],
          to: map['to'],
          time: map['time'],
          channel: map['channel']);
      break;
    case 'type_video_call_refuse':
      msg = Msg(
          type: map['type'],
          username: map['username'],
          from: map['from'],
          to: map['to'],
          time: map['time'],
          channel: map['channel']);
      break;
    default:
      msg = Msg(from: map['from'], to: map['to'], time: map['time']);
  }

  return msg;
}

Map msgToMap(Msg data) {
  Map msg = Map();

  msg['type'] = data.type;
  msg['username'] = data.username;
  msg['from'] = data.from;
  msg['to'] = data.to;

  if (null != data.time) {
    msg['time'] = data.time;
  }

  if (null != data.txt) {
    msg['txt'] = data.txt;
  }

  if (null != data.original) {
    msg['original'] = data.original;
  }

  if (null != data.imgUrl) {
    msg['imgUrl'] = data.imgUrl;
  }

  if (null != data.voiceUri) {
    msg['voiceUri'] = data.voiceUri;
  }

  if (null != data.length) {
    msg['length'] = data.length;
  }

  if (null != data.thumbUrl) {
    msg['thumbUrl'] = data.thumbUrl;
  }

  if (null != data.width) {
    msg['width'] = data.width;
  }

  if (null != data.height) {
    msg['height'] = data.height;
  }

  if (null != data.videoUri) {
    msg['videoUri'] = data.videoUri;
  }

  if (null != data.fileUri) {
    msg['fileUri'] = data.fileUri;
  }

  if (null != data.channel) {
    msg['channel'] = data.channel;
  }

  return msg;
}

class Msg implements BaseMsg {
  Msg(
      {this.type,
      this.username,
      this.from,
      this.to,
      this.time,
      this.txt,
      this.original,
      this.imgUrl,
      this.voiceUri,
      this.length,
      this.thumbUrl,
      this.width,
      this.height,
      this.videoUri,
      this.fileUri,
      this.channel});

  String type;
  String username;
  String from;
  String to;
  int time;
  String txt;
  bool original;
  String imgUrl;
  String voiceUri;
  bool playing = false;
  int length;
  String thumbUrl;
  int width;
  int height;
  String videoUri;
  String fileUri;
  String channel;

  @override
  String toString() {
    return 'msg type:$type, from:$from, to:$to, time:$time, txt:$txt, imgUrl:$imgUrl, thumbUrl:$thumbUrl, width:$width, height:$height, voiceUri:$voiceUri, length:$length, videoUri:$videoUri, fileUri:$fileUri, channel:$channel';
  }
}
