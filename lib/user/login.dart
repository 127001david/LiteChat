import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lite_chat/homepage.dart';
import 'package:lite_chat/user/userInfo.dart';

import '../constant.dart';

class LoginRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginRoute> {
  var channelCallNative = MethodChannel(Constant.channel_user_info);

  FocusNode _f1 = FocusNode();
  FocusNode _f2 = FocusNode();

  TextEditingController _unameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();

  GlobalKey _formUsernameKey = GlobalKey<FormState>();
  GlobalKey _formPwdKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('登录'),
        ),
        body: Column(
          children: <Widget>[
            Form(
              key: _formUsernameKey,
              autovalidate: false,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _unameController,
                    autofocus: true,
                    focusNode: _f1,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: '用户名', prefixIcon: Icon(Icons.person)),
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {
                      if ((_formUsernameKey.currentState as FormState)
                          .validate()) {
                        FocusScope.of(context).requestFocus(_f2);
                      }
                    },
                    validator: (username) {
                      return username.trim().length > 0 ? null : '用户名不能为空';
                    },
                    onChanged: (text) {
                      (_formUsernameKey.currentState as FormState).validate();
                    },
                  ),
                ],
              ),
            ),
            Form(
              key: _formPwdKey,
              autovalidate: false,
              child: TextFormField(
                controller: _pwdController,
                autofocus: false,
                focusNode: _f2,
                maxLines: 1,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: '密码', prefixIcon: Icon(Icons.lock)),
                textInputAction: TextInputAction.done,
                onEditingComplete: () async {
                  if ((_formUsernameKey.currentState as FormState).validate() &&
                      (_formPwdKey.currentState as FormState).validate()) {
                    try {
                      await channelCallNative.invokeMethod('login', {
                        'username': _unameController.text.trim(),
                        'pwd': _pwdController.text.trim()
                      });

                      print('login success');

                      loginUser = _unameController.text.trim();

                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return MyHomePage();
                      }), (route) => false);
                    } on PlatformException catch (e) {
                      Scaffold.of(_formPwdKey.currentContext)
                          ?.showSnackBar(SnackBar(
                        content: Text(e.message),
                      ));
                    }
                  }
                },
                validator: (pwd) {
                  return pwd.trim().length > 5 ? null : '密码不能少于6位';
                },
                onChanged: (text) {
                  (_formPwdKey.currentState as FormState).validate();
                },
              ),
            )
          ],
        ));
  }
}
