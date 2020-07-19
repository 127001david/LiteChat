import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lite_chat/msg/msgPage.dart';

class FriendOptionsRoute extends StatefulWidget {
  FriendOptionsRoute({Key key, this.username}) : super(key: key);

  final String username;

  @override
  State<StatefulWidget> createState() {
    return FriendOptionsState(username);
  }
}

class FriendOptionsState extends State<FriendOptionsRoute> {
  FriendOptionsState(this.username);

  final String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 12),
            child: Icon(Icons.more_horiz),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 58,
                height: 58,
                margin: EdgeInsets.only(left: 14, right: 20, top: 12),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Text(
                      username,
                      style: TextStyle(
                          color: Color.fromARGB(255, 40, 40, 40),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 3),
                    child: Text(
                      '昵称：',
                      style: TextStyle(
                          color: Color.fromARGB(255, 111, 111, 111),
                          fontSize: 12,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 3),
                    child: Text(
                      '轻聊号：',
                      style: TextStyle(
                          color: Color.fromARGB(255, 111, 111, 111),
                          fontSize: 12,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 3),
                    child: Text(
                      '地区：',
                      style: TextStyle(
                          color: Color.fromARGB(255, 111, 111, 111),
                          fontSize: 12,
                          fontWeight: FontWeight.normal),
                    ),
                  )
                ],
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            height: 0.5,
            color: Color.fromARGB(255, 218, 218, 218),
          ),
          Container(
            height: 50,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 15,
                  top: 14,
                  child: Text(
                    '设置备注和标签',
                    style: TextStyle(
                        color: Color.fromARGB(255, 27, 27, 27),
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Positioned(
                  right: 4,
                  top: 14,
                  child: Icon(Icons.navigate_next,
                      color: Color.fromARGB(255, 169, 169, 169)),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 14),
            height: 0.5,
            color: Color.fromARGB(255, 218, 218, 218),
          ),
          Container(
            height: 50,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 15,
                  top: 14,
                  child: Text(
                    '朋友权限',
                    style: TextStyle(
                        color: Color.fromARGB(255, 27, 27, 27),
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Positioned(
                  right: 4,
                  top: 14,
                  child: Icon(Icons.navigate_next,
                      color: Color.fromARGB(255, 169, 169, 169)),
                )
              ],
            ),
          ),
          Container(
            height: 8,
            color: Color.fromARGB(255, 237, 237, 237),
          ),
          Container(
            height: 50,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 15,
                  top: 14,
                  child: Text(
                    '朋友圈',
                    style: TextStyle(
                        color: Color.fromARGB(255, 27, 27, 27),
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Positioned(
                  right: 4,
                  top: 14,
                  child: Icon(Icons.navigate_next,
                      color: Color.fromARGB(255, 169, 169, 169)),
                )
              ],
            ),
          ),
          Container(
            height: 8,
            color: Color.fromARGB(255, 237, 237, 237),
          ),
          Container(
              height: 50,
              child: FlatButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return MsgPageRoute(
                      username: username,
                    );
                  }));
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.chat_bubble,
                          color: Color.fromARGB(255, 92, 110, 156)),
                      Container(
                        margin: EdgeInsets.only(left: 9),
                        child: Text(
                          '发消息',
                          style: TextStyle(
                            color: Color.fromARGB(255, 92, 110, 156),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ]),
              )),
          Container(
            height: 0.5,
            color: Color.fromARGB(255, 218, 218, 218),
          ),
          Container(
            height: 50,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.video_call,
                      color: Color.fromARGB(255, 92, 110, 156)),
                  Container(
                    margin: EdgeInsets.only(left: 9),
                    child: Text(
                      '音视频通话',
                      style: TextStyle(
                        color: Color.fromARGB(255, 92, 110, 156),
                        fontSize: 14,
                      ),
                    ),
                  )
                ]),
          ),
          Expanded(
            child: Container(color: Color.fromARGB(255, 237, 237, 237)),
          )
        ],
      ),
    );
  }
}
