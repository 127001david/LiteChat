import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lite_chat/msg/model/msg.dart';
import 'package:lite_chat/widget/msgUserIcon.dart';
import 'dart:math' as math;

import 'imagesAnim.dart';

class OtherTxt extends StatelessWidget {
  OtherTxt(this.msgTxt);

  final Msg msgTxt;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        OtherIcon(),
        Container(
          margin: EdgeInsets.only(left: 5),
          padding: EdgeInsets.only(left: 16, top: 9, right: 12, bottom: 9),
          constraints:
              BoxConstraints(minWidth: 43.0, maxWidth: 240.0, minHeight: 37),
          decoration: BoxDecoration(
              image: DecorationImage(
                  centerSlice: Rect.fromLTWH(5, 25, 28, 7),
                  image: AssetImage('assets/white_bubble.png'))),
          child: Text(
            msgTxt.txt,
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      ],
    );
  }
}

class MyTxt extends StatelessWidget {
  MyTxt(this.msgTxt);

  final Msg msgTxt;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: <Widget>[
        MyIcon(),
        Container(
          margin: EdgeInsets.only(right: 5),
          padding: EdgeInsets.only(left: 12, top: 9, right: 16, bottom: 9),
          constraints:
              BoxConstraints(minWidth: 43.0, maxWidth: 240.0, minHeight: 39),
          decoration: BoxDecoration(
              image: DecorationImage(
                  centerSlice: Rect.fromLTWH(5, 25, 28, 7),
                  image: AssetImage('assets/yellow_bubble.png'))),
          child: Text(msgTxt.txt,
              textAlign: TextAlign.left, style: TextStyle(fontSize: 14.0)),
        ),
      ],
    );
  }
}

class SharePlayingWidget extends InheritedWidget {
  SharePlayingWidget(this.playing, {@required Widget child})
      : super(child: child);

  final bool playing;

  static SharePlayingWidget of(BuildContext context) {
    return context
        .getElementForInheritedWidgetOfExactType<SharePlayingWidget>()
        .widget;
  }

  @override
  bool updateShouldNotify(SharePlayingWidget oldWidget) {
    return oldWidget.playing != playing;
  }
}

class OtherVoice extends StatelessWidget {
  OtherVoice(this.length, this.onTap);

  final int length;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        OtherIcon(),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: (40 + length * 20).toDouble(),
            margin: EdgeInsets.only(left: 5),
            padding: EdgeInsets.only(left: 16, top: 12, right: 12, bottom: 6),
            constraints:
                BoxConstraints(minWidth: 43.0, maxWidth: 140.0, minHeight: 39),
            decoration: BoxDecoration(
                image: DecorationImage(
                    centerSlice: Rect.fromLTWH(5, 25, 28, 7),
                    image: AssetImage('assets/white_bubble.png'))),
            child: Text.rich(
              TextSpan(children: [
                WidgetSpan(
                    child: SharePlayingWidget.of(context).playing
                        ? ImagesAnim([
                            Transform.rotate(
                              angle: math.pi,
                              child: Image.asset(
                                'assets/voice_my_3.png',
                              ),
                            ),
                            Transform.rotate(
                              angle: math.pi,
                              child: Image.asset(
                                'assets/voice_my_4.png',
                              ),
                            ),
                            Transform.rotate(
                              angle: math.pi,
                              child: Image.asset(
                                'assets/voice_my_1.png',
                              ),
                            ),
                            Transform.rotate(
                              angle: math.pi,
                              child: Image.asset(
                                'assets/voice_my_2.png',
                              ),
                            ),
                            Transform.rotate(
                              angle: math.pi,
                              child: Image.asset(
                                'assets/voice_my.png',
                              ),
                            ),
                          ], 10, 15, Colors.transparent)
                        : Image.asset(
                            'assets/voice_other.png',
                            width: 10,
                            height: 15,
                          )),
                TextSpan(text: ' $length″')
              ]),
              style: TextStyle(fontSize: 14.0),
            ),
          ),
        ),
      ],
    );
  }
}

class MyVoice extends StatefulWidget {
  MyVoice(this.length, this.onTap);

  final int length;
  final GestureTapCallback onTap;

  @override
  State<StatefulWidget> createState() {
    return MyVoiceState();
  }
}

class MyVoiceState extends State<MyVoice> {
  MyVoiceState();

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: <Widget>[
        MyIcon(),
        GestureDetector(
          onTap: () {
            widget.onTap();
          },
          child: Container(
            width: (40 + widget.length * 20).toDouble(),
            margin: EdgeInsets.only(right: 5),
            padding: EdgeInsets.only(left: 12, top: 12, right: 16, bottom: 6),
            constraints:
                BoxConstraints(minWidth: 43.0, maxWidth: 140.0, minHeight: 39),
            decoration: BoxDecoration(
                image: DecorationImage(
                    centerSlice: Rect.fromLTWH(5, 25, 28, 7),
                    image: AssetImage('assets/yellow_bubble.png'))),
            child: Text.rich(
                TextSpan(children: [
                  TextSpan(
                      text: '${widget.length}″ ',
                      style: TextStyle(fontSize: 14.0)),
                  WidgetSpan(
                      child: SharePlayingWidget.of(context).playing
                          ? ImagesAnim([
                              Image.asset(
                                'assets/voice_my_3.png',
                              ),
                              Image.asset(
                                'assets/voice_my_4.png',
                              ),
                              Image.asset(
                                'assets/voice_my_1.png',
                              ),
                              Image.asset(
                                'assets/voice_my_2.png',
                              ),
                              Image.asset(
                                'assets/voice_my.png',
                              ),
                            ], 10, 15, Colors.transparent)
                          : Image.asset(
                              'assets/voice_my.png',
                              width: 10,
                              height: 15,
                            ))
                ]),
                textAlign: TextAlign.right),
          ),
        ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class OtherImg extends StatelessWidget {
  OtherImg(this.msgImg);

  final Msg msgImg;

  @override
  Widget build(BuildContext context) {
    double width = 0;
    double height = 0;
    if (msgImg.width > msgImg.height && msgImg.width > 150) {
      width = 150;
      height = (msgImg.height.toDouble() / msgImg.width.toDouble()) * 150;
    } else if (msgImg.height > msgImg.width && msgImg.height > 150) {
      height = 150;
      width = (msgImg.width.toDouble() / msgImg.height.toDouble()) * 150;
    } else {
      width = msgImg.width.toDouble();
      height = msgImg.height.toDouble();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        OtherIcon(),
        Container(
          margin: EdgeInsets.only(left: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: msgImg.thumbUrl.startsWith("http")
                ? FadeInImage.assetNetwork(
                    placeholder: 'assets/placeholder.png',
                    image: msgImg.thumbUrl,
                    fit: BoxFit.fill,
                    width: width,
                    height: height,
                  )
                : Image.file(
                    File(msgImg.thumbUrl),
                    fit: BoxFit.fill,
                    width: width,
                    height: height,
                  ),
          ),
        ),
      ],
    );
  }
}

class MyImg extends StatelessWidget {
  MyImg(this.msgImg);

  final Msg msgImg;

  @override
  Widget build(BuildContext context) {
    double width = 0;
    double height = 0;
    if (msgImg.width > msgImg.height && msgImg.width > 150) {
      width = 150;
      height = (msgImg.height.toDouble() / msgImg.width.toDouble()) * 150;
    } else if (msgImg.height > msgImg.width && msgImg.height > 150) {
      height = 150;
      width = (msgImg.width.toDouble() / msgImg.height.toDouble()) * 150;
    } else {
      width = msgImg.width.toDouble();
      height = msgImg.height.toDouble();
    }

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
                ? FadeInImage.assetNetwork(
                    placeholder: 'assets/placeholder.png',
                    image: msgImg.thumbUrl,
                    fit: BoxFit.fill,
                    width: width,
                    height: height,
                  )
                : Image.file(
                    File(msgImg.thumbUrl),
                    fit: BoxFit.fill,
                    width: width,
                    height: height,
                  ),
          ),
        ),
      ],
    );
  }
}
