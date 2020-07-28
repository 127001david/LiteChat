const String type_txt = 'type_txt';
const String type_img = 'type_img';
const String type_voice = 'type_voice';
const String type_video = 'type_video';
const String type_file = 'type_file';

class MsgContainer<T extends BaseMsg> {
  MsgContainer(this.msgType, this.msg);

  String msgType;
  T msg;
}

// 类型限定
abstract class BaseMsg {}
