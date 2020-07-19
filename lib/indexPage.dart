import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lite_chat/constant.dart';
import 'package:lite_chat/homepage.dart';
import 'package:lite_chat/user/login.dart';
import 'package:lite_chat/user/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return IndexState();
  }
}

class IndexState extends State<IndexPage> {
  static const channelCallNative =
      const MethodChannel(Constant.channel_user_info);
  bool _needLogin = false;

  @override
  void initState() {
    super.initState();

    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: Stack(
        children: <Widget>[
          ConstrainedBox(
              constraints: BoxConstraints.expand(),
              child: Image.asset(
                'assets/LiteChatOpen.jpeg',
                fit: BoxFit.cover,
              )),
          _needLogin
              ? Positioned(
                  left: 28.0,
                  bottom: 20.0,
                  child: RaisedButton(
                    child: Text('登录'),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return LoginRoute();
                      }));
                    },
                  ),
                )
              : Spacer(),
          _needLogin
              ? Positioned(
                  right: 28.0,
                  bottom: 20.0,
                  child: RaisedButton(
                    child: Text('注册'),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return RegisterRoute();
                      }));
                    },
                  ),
                )
              : Spacer(),
        ],
      ),
    ));
  }

  Future<void> checkLogin() async {
    String username;

    try {
      username = await channelCallNative.invokeMethod('checkLogin');

      print('login success');
    } on PlatformException catch (e) {

    }

    if (null == username) {
      _needLogin = true;
      setState(() {});
    } else {
      Future.delayed(Duration(seconds: 2)).then((value) => {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => MyHomePage()))
          });
    }
  }
}