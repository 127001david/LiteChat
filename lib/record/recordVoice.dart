import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lite_chat/record/flutterPluginRecord.dart';
import 'package:path_provider/path_provider.dart';

typedef StartRecord = Future Function();
typedef StopRecord = Future Function(String path, int length);

class RecordVoice extends StatefulWidget {
  final StartRecord startRecord;
  final StopRecord stopRecord;
  final String recordPath;

  /// startRecord 开始录制回调  stopRecord回调
  const RecordVoice(
      {Key key, this.recordPath, this.startRecord, this.stopRecord})
      : super(key: key);

  @override
  _VoiceWidgetState createState() => _VoiceWidgetState();
}

class _VoiceWidgetState extends State<RecordVoice> {
  double starty = 0.0;
  double offset = 0.0;
  bool isUp = false;
  String textShow = "按住说话";
  String toastShow = "手指上滑,取消发送";
  String voiceIco = "images/voice_volume_1.png";
  int _recordTime;

  ///默认隐藏状态
  bool voiceState = true;
  OverlayEntry overlayEntry;
  FlutterPluginRecord recordPlugin;

  @override
  void initState() {
    super.initState();
    recordPlugin = FlutterPluginRecord();

    _initRecordPath();

    recordPlugin.responseFromInit.listen((data) {
      if (data) {
        print("初始化成功");
      } else {
        print("初始化失败");
      }
    });

    _init();

    recordPlugin.response.listen((data) {
      if (data.msg == "onStop" && !isUp) {
        ///结束录制时会返回录制文件的地址方便上传服务器
        print("onStop  " + data.path);
        _recordTime =
            (DateTime.now().millisecondsSinceEpoch - _recordTime) ~/ 1000;
        widget.stopRecord(data.path, _recordTime);
      } else if (data.msg == "onStart") {
        print("onStart --");
        _recordTime = DateTime.now().millisecondsSinceEpoch;
        widget.startRecord();
      }
    });

    ///录制过程监听录制的声音的大小 方便做语音动画显示图片的样式
    recordPlugin.responseFromAmplitude.listen((data) {
      var voiceData = double.parse(data.msg);
      setState(() {
        if (voiceData > 0 && voiceData < 0.1) {
          voiceIco = "images/voice_volume_2.png";
        } else if (voiceData > 0.2 && voiceData < 0.3) {
          voiceIco = "images/voice_volume_3.png";
        } else if (voiceData > 0.3 && voiceData < 0.4) {
          voiceIco = "images/voice_volume_4.png";
        } else if (voiceData > 0.4 && voiceData < 0.5) {
          voiceIco = "images/voice_volume_5.png";
        } else if (voiceData > 0.5 && voiceData < 0.6) {
          voiceIco = "images/voice_volume_6.png";
        } else if (voiceData > 0.6 && voiceData < 0.7) {
          voiceIco = "images/voice_volume_7.png";
        } else if (voiceData > 0.7 && voiceData < 1) {
          voiceIco = "images/voice_volume_7.png";
        } else {
          voiceIco = "images/voice_volume_1.png";
        }
        if (overlayEntry != null) {
          overlayEntry.markNeedsBuild();
        }
      });
    });
  }

  ///显示录音悬浮布局
  buildOverLayView(BuildContext context) {
    if (overlayEntry == null) {
      overlayEntry = new OverlayEntry(builder: (content) {
        return Positioned(
          top: MediaQuery.of(context).size.height * 0.5 - 80,
          left: MediaQuery.of(context).size.width * 0.5 - 80,
          child: Material(
            type: MaterialType.transparency,
            child: Center(
              child: Opacity(
                opacity: 0.8,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Color(0xff77797A),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: new Image.asset(
                          voiceIco,
                          width: 100,
                          height: 100,
                          package: 'flutter_plugin_record',
                        ),
                      ),
                      Container(
//                      padding: EdgeInsets.only(right: 20, left: 20, top: 0),
                        child: Text(
                          toastShow,
                          style: TextStyle(
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
      Overlay.of(context).insert(overlayEntry);
    }
  }

  showVoiceView() {
    setState(() {
      textShow = "松开结束";
      voiceState = false;
    });
    start();
    buildOverLayView(context);
  }

  hideVoiceView() {
    setState(() {
      textShow = "按住说话";
      voiceState = true;
    });

    stop();
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }

    if (isUp) {
      print("取消发送");
    } else {
      print("进行发送");
    }
  }

  moveVoiceView() {
    // print(offset - start);
    setState(() {
      isUp = starty - offset > 100 ? true : false;
      if (isUp) {
        textShow = "松开手指,取消发送";
        toastShow = textShow;
      } else {
        textShow = "松开结束";
        toastShow = "手指上滑,取消发送";
      }
    });
  }

  Future _initRecordPath() async {
    Directory baseDir = await getApplicationDocumentsDirectory();

    Directory baseVoiceDir = Directory('${baseDir.path}/voice/');

    if (!baseVoiceDir.existsSync()) {
      baseVoiceDir.createSync(recursive: true);
    }
  }

  ///初始化语音录制的方法
  Future _init() async {
    await recordPlugin.init();
  }

  ///开始语音录制的方法
  Future start() async {
    await recordPlugin.startByWavPath(widget.recordPath);
  }

  ///停止语音录制的方法
  Future stop() async {
    await recordPlugin.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {},
        onLongPressStart: (details) {
          print("start------onLongPressStart");
          starty = details.globalPosition.dy;
          showVoiceView();
        },
        onLongPressEnd: (details) {
          print("end------onLongPressEnd");
          hideVoiceView();
        },
        onLongPressMoveUpdate: (details) {
          offset = details.globalPosition.dy;
          moveVoiceView();
        },
        child: Container(
          child: Center(
            child: Text(
              textShow,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (recordPlugin != null) {
      recordPlugin.dispose();
    }
    super.dispose();
  }
}
