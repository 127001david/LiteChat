import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lite_chat/constant.dart';
import 'package:lite_chat/msg/event_bus.dart';
import 'package:lite_chat/msg/model/msg.dart';
import 'package:lite_chat/settings.dart';

class VideoCallSinglePage extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String channelName;

  final String username;

  /// 当前用户是通话发起者
  final bool isCaller;

  /// Creates a call page with given channel name.
  const VideoCallSinglePage(
      {Key key, this.channelName, this.username, this.isCaller})
      : super(key: key);

  @override
  _VideoCallSingleState createState() => _VideoCallSingleState();
}

class _VideoCallSingleState extends State<VideoCallSinglePage> {
  static const channelCallNative =
      const MethodChannel(Constant.channel_send_msg);

  int _user = -1;
  final _infoStrings = <String>[];
  bool muted = false;

  bool _calling = true;

  EventCallback _receiveMsg;

  @override
  void dispose() {
    bus.off('cmd_from_${widget.username}', _receiveMsg);
    // clear users
    _user = -1;
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _receiveMsg = (e) {
      final msg = e as Msg;
      print('type_video_call_cancel = ${msg.type}');
      if ('type_video_call_cancel' == msg.type) {
        Navigator.pop(context);
      } else if ('type_video_call_refuse' == msg.type) {
        Navigator.pop(context);
      }
    };

    bus.on('cmd_from_${widget.username}', _receiveMsg);

    // initialize agora sdk
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            _viewRows(),
            Offstage(
              offstage: !_calling || widget.isCaller,
              child: Container(color: Colors.black54),
            ),
            _calling ? _userInfo() : Container(),
            (widget.isCaller || !_calling) ? _toolbar() : _toolbarCalling(),
          ],
        ),
      ),
    );
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await AgoraRtcEngine.create(APP_ID);
    await AgoraRtcEngine.enableVideo();
    await AgoraRtcEngine.setChannelProfile(ChannelProfile.Communication);
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = Size(1920, 1080);
    await AgoraRtcEngine.setVideoEncoderConfiguration(configuration);
  }

  Future _joinChannel() async {
    await AgoraRtcEngine.joinChannel(null, widget.channelName, null, 0);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _user = -1;
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _user = uid;
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _user = -1;
      });

      _onCallEnd(context);
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame = (
      int uid,
      int width,
      int height,
      int elapsed,
    ) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    };
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final remoteView = -1 != _user ? AgoraRenderWidget(_user) : null;

    final localView = AgoraRenderWidget(0, local: true, preview: true);

    return Stack(
      fit: StackFit.expand,
      children: [
        -1 != _user ? remoteView : localView,
        Positioned(
          top: 20.0,
          right: 18.0,
          width: 90,
          height: 180,
          child: -1 != _user ? localView : Container(),
        )
      ],
    );
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Image.asset(
              'assets/call_end.png',
              width: 35,
              height: 35,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Color.fromARGB(255, 218, 74, 74),
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  /// Toolbar layout in calling state
  Widget _toolbarCalling() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned(
            left: 39,
            bottom: 41,
            child: RawMaterialButton(
              onPressed: () => _onCallCancel(context),
              child: Image.asset(
                'assets/call_end.png',
                width: 35,
                height: 35,
              ),
              shape: CircleBorder(),
              elevation: 2.0,
              fillColor: Color.fromARGB(255, 218, 74, 74),
              padding: const EdgeInsets.all(15.0),
            )),
        Positioned(
            right: 39,
            bottom: 41,
            child: RawMaterialButton(
              onPressed: () {
                _joinChannel();
                setState(() {
                  _calling = false;
                });
              },
              child: Image.asset(
                'assets/accept_call.png',
                width: 35,
                height: 35,
              ),
              shape: CircleBorder(),
              elevation: 2.0,
              fillColor: Color.fromARGB(255, 13, 178, 8),
              padding: const EdgeInsets.all(15.0),
            )),
      ],
    );
  }

  Widget _userInfo() {
    return Container(
      alignment: Alignment.topRight,
      padding: EdgeInsets.only(top: 44, right: 16),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 39,
            height: 39,
            margin: EdgeInsets.only(left: 14),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.orangeAccent),
                child: Icon(
                  Icons.perm_contact_calendar,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.username,
                style: TextStyle(color: Colors.white, fontSize: 27),
              ),
              Container(
                child: Text(
                  widget.isCaller ? '正在等待对方接受邀请' : '邀请你进行视频通话',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onCallEnd(BuildContext context) async {
    try {
      await channelCallNative.invokeMethod(
          widget.isCaller && _calling ? 'videoCallCancel' : 'videoCallEnd',
          {'channel': widget.channelName, 'username': widget.username});
    } on PlatformException catch (e) {}

    Navigator.pop(context);
  }

  void _onCallCancel(BuildContext context) async {
    try {
      await channelCallNative.invokeMethod('videoCallRefuse',
          {'channel': widget.channelName, 'username': widget.username});
    } on PlatformException catch (e) {}

    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }
}
