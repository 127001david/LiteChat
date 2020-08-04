import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MorePanel extends StatelessWidget {
  MorePanel(this.onAlbumTap, this.onTakePhotoTap, this.onVideoCallTap,
      this.onLocationTap, this.onRedPacketTap);

  final GestureTapCallback onAlbumTap;
  final GestureTapCallback onTakePhotoTap;
  final GestureTapCallback onVideoCallTap;
  final GestureTapCallback onLocationTap;
  final GestureTapCallback onRedPacketTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 247, 247, 247),
      height: 200,
      child: Row(
        children: <Widget>[
          Expanded(
              child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: GestureDetector(
                        onTap: onAlbumTap,
                        child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/album.png',
                            width: 27,
                            height: 27,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 2),
                      child: Text(
                        '相册',
                        style: TextStyle(
                            fontSize: 10,
                            color: Color.fromARGB(255, 123, 123, 123)),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: GestureDetector(
                        onTap: onRedPacketTap,
                        child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/redpacket.png',
                            width: 27,
                            height: 27,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 2),
                      child: Text(
                        '红包',
                        style: TextStyle(
                            fontSize: 10,
                            color: Color.fromARGB(255, 123, 123, 123)),
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
          Expanded(
              child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: GestureDetector(
                        onTap: onTakePhotoTap,
                        child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/takephoto.png',
                            width: 27,
                            height: 27,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 2),
                      child: Text(
                        '拍摄',
                        style: TextStyle(
                            fontSize: 10,
                            color: Color.fromARGB(255, 123, 123, 123)),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(),
              ),
            ],
          )),
          Expanded(
              child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: GestureDetector(
                        onTap: onVideoCallTap,
                        child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/videocall.png',
                            width: 27,
                            height: 27,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 2),
                      child: Text(
                        '视频通话',
                        style: TextStyle(
                            fontSize: 10,
                            color: Color.fromARGB(255, 123, 123, 123)),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(),
              ),
            ],
          )),
          Expanded(
              child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: GestureDetector(
                        onTap: onLocationTap,
                        child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/location.png',
                            width: 27,
                            height: 27,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 2),
                      child: Text(
                        '位置',
                        style: TextStyle(
                            fontSize: 10,
                            color: Color.fromARGB(255, 123, 123, 123)),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
