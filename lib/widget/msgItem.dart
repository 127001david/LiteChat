import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:lite_chat/msg/model/msg.dart';
import 'package:lite_chat/widget/msgUserIcon.dart';

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
