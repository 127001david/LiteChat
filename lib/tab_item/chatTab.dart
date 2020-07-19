import 'package:flutter/cupertino.dart';
import 'package:lite_chat/tab_item/baseTab.dart';

class ChatTabWidget extends BaseTabWidget<ChatTabState> {
  @override
  State<StatefulWidget> createState() {
    return ChatTabState();
  }
}

class ChatTabState extends BaseTabWidgetState<ChatTabWidget> {
  @override
  void initState() {
    super.initState();
    title = '轻聊';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: TextStyle(fontSize: 80),
      ),
    );
  }
}
