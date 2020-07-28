import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lite_chat/homepage.dart';
import 'package:lite_chat/user/userInfo.dart';

import '../constant.dart';

class RegisterRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterState();
  }
}

class RegisterState extends State<RegisterRoute> {
  var channelCallNative = MethodChannel(Constant.channel_user_info);

  FocusNode _f1 = FocusNode();
  FocusNode _f2 = FocusNode();
  FocusNode _f3 = FocusNode();

  TextEditingController _unameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _checkPwdController = TextEditingController();

  GlobalKey _formUsernameKey = GlobalKey<FormState>();
  GlobalKey _formPwdKey = GlobalKey<FormState>();
  GlobalKey _formCheckPwdKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('注册'),
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
                    labelText: '密码',
                    hintText: '不少于6位',
                    prefixIcon: Icon(Icons.lock)),
                textInputAction: TextInputAction.next,
                onEditingComplete: () {
                  if ((_formPwdKey.currentState as FormState).validate()) {
                    FocusScope.of(context).requestFocus(_f3);
                  }
                },
                validator: (pwd) {
                  return pwd.trim().length > 5 ? null : '密码不能少于6位';
                },
                onChanged: (text) {
                  (_formPwdKey.currentState as FormState).validate();
                },
              ),
            ),
            Form(
              key: _formCheckPwdKey,
              autovalidate: false,
              child: TextFormField(
                controller: _checkPwdController,
                autofocus: false,
                focusNode: _f3,
                maxLines: 1,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: '确认密码', prefixIcon: Icon(Icons.check)),
                textInputAction: TextInputAction.done,
                onEditingComplete: () async {
                  if ((_formUsernameKey.currentState as FormState).validate() &&
                      (_formPwdKey.currentState as FormState).validate() &&
                      (_formCheckPwdKey.currentState as FormState).validate()) {
                    try {
                      await channelCallNative.invokeMethod('register', {
                        'username': _unameController.text.trim(),
                        'pwd': _pwdController.text.trim()
                      });

                      print('register success');

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
                  return pwd.trim() == _pwdController.text.trim()
                      ? null
                      : '请与密码保持一致';
                },
                onChanged: (text) {
                  (_formCheckPwdKey.currentState as FormState).validate();
                },
              ),
            )
          ],
        ));
  }
}
