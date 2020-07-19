import 'package:flutter/cupertino.dart';

import 'baseTab.dart';

class NewWorldTabWidget extends BaseTabWidget {

  @override
  State<StatefulWidget> createState() {
    return NewWorldTabState();
  }
}

class NewWorldTabState extends BaseTabWidgetState<NewWorldTabWidget> {

  @override
  void initState() {
    super.initState();
    title = '发现';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('发现'),
    );
  }
}
