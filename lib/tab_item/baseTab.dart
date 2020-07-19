import 'package:flutter/cupertino.dart';

abstract class BaseTabWidget<T extends State> extends StatefulWidget {
  BaseTabWidget({Key key}) : super(key: key);

  T of(BuildContext context) => context.findAncestorStateOfType<T>();
}

abstract class BaseTabWidgetState<T extends BaseTabWidget> extends State<T> {
  String title;
}
