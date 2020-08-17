import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lite_chat/friends/friendOptions.dart';

import '../constant.dart';
import 'baseTab.dart';

class FriendsTabWidget extends BaseTabWidget<FriendsTabState> {
  FriendsTabWidget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FriendsTabState();
  }
}

class FriendsTabState extends BaseTabWidgetState<FriendsTabWidget>
    with AutomaticKeepAliveClientMixin {
  static const channelCallNative = const MethodChannel(Constant.channel_friend);
  List<String> _friends = [];

  @override
  void initState() {
    super.initState();
    username = '通讯录';

    _friends.add('新的朋友');
    _friends.add('群聊');

    _getFriends();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Widget divider1 = Container(
      height: 0.2,
      color: Colors.grey[400],
      margin: EdgeInsets.only(left: 64),
    );

    Widget divider2 = Container(
      height: 30,
      color: Color.fromARGB(255, 232, 232, 232),
    );

    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: _friends.length,
      itemBuilder: (BuildContext context, int index) {
        if (0 == index) {
          return Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: ClipRRect(
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.orange),
                    child: Icon(
                      Icons.person_add,
                      color: Colors.white,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Text(
                _friends[index],
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              )
            ],
          );
        } else if (1 == index) {
          return Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: ClipRRect(
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.green),
                    child: Icon(
                      Icons.group,
                      color: Colors.white,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Text(
                _friends[index],
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              )
            ],
          );
        } else {
          return InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return FriendOptionsRoute(username: _friends[index]);
              }));
            },
            child: Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                Text(_friends[index])
              ],
            ),
          );
        }
      },
      separatorBuilder: (BuildContext context, int index) {
        return 1 == index ? divider2 : divider1;
      },
    );
  }

  Future _getFriends() async {
    try {
      List<dynamic> friends =
          await channelCallNative.invokeMethod('getFriends');

      print(friends);

      setState(() {
        friends.forEach((element) {
          _friends.add(element as String);
        });
        print(_friends);
      });
    } on PlatformException catch (e) {}
  }

  @override
  bool get wantKeepAlive => true;
}
