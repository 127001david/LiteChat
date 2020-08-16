import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant.dart';

/// 添加好友
class AddFriendRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddFriendState();
  }
}

class AddFriendState extends State<AddFriendRoute> {
  static const channelCallNative = const MethodChannel(Constant.channel_friend);

  bool _showSearchIcon = false;
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('添加朋友'),
        actions: <Widget>[
          _showSearchIcon
              ? IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _focusNode.unfocus();
                    // todo test code
                    _addFriend(_controller.text, 'reason');
                  },
                )
              : Container(
                  width: 0,
                  height: 0,
                )
        ],
      ),
      body: Column(
        children: <Widget>[
          TextField(
            autofocus: true,
            maxLines: 1,
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
                hintText: '用户名',
                contentPadding: EdgeInsets.only(left: 12, top: 10),
                suffixIcon: _showSearchIcon
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          setState(() {
                            _showSearchIcon = false;
                          });
                        })
                    : Container(
                        width: 0,
                        height: 0,
                      )),
            onChanged: (text) {
              setState(() {
                _showSearchIcon = 0 < text.trim().length;
              });
            },
          ),
        ],
      ),
    );
  }

  Future _addFriend(String username, String reason) async {
    try {
      bool success = await channelCallNative
          .invokeMethod('addFriend', {'username': username, 'reason': reason});

      if (success) {
        print('add friend success');
      }

      setState(() {});
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
