import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../constant.dart';
import 'baseTab.dart';

class MyTabWidget extends BaseTabWidget {
  @override
  State<StatefulWidget> createState() {
    return MyTabState();
  }
}

class MyTabState extends BaseTabWidgetState<MyTabWidget> {
  static const channelCallNative =
      const MethodChannel(Constant.channel_user_info);

  String _username = '';

  @override
  void initState() {
    super.initState();
    title = '我';
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(_username),
    );
  }

  Future _getUserInfo() async {
    try {
      String username = await channelCallNative.invokeMethod('checkLogin');

      setState(() {
        _username = username;
      });
    } on PlatformException catch (e) {}
  }
}
