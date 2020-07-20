enum msg_type { txt, img, voice }

class MsgContainer<T extends BaseMsg> {
  MsgContainer(this.msgType, this.msg);

  msg_type msgType;
  T msg;
}

// 类型限定
abstract class BaseMsg {}
