import 'package:flutter/material.dart';

/// 帧动画，以 300毫秒（有必要的时候可传入参数 duration）为间隔轮播传入的 Widget 数组
class ImagesAnim extends StatefulWidget {
  final List<Widget> imageCaches;
  final double width;
  final double height;
  final Color backColor;
  final duration;

  ImagesAnim(this.imageCaches, this.width, this.height, this.backColor,
      {Key key, this.duration})
      : assert(imageCaches != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _WOActionImageState();
  }
}

class _WOActionImageState extends State<ImagesAnim> {
  bool _disposed = false;
  Duration _duration;

  int _imageIndex = 0;

  @override
  void initState() {
    super.initState();

    if (null == widget.duration) {
      _duration = Duration(milliseconds: 300);
    } else {
      _duration = widget.duration;
    }

    _updateImage();
  }

  void _updateImage() {
    if (_disposed || widget.imageCaches.isEmpty) {
      return;
    }

    Future.delayed(_duration, () {
      if (_disposed || widget.imageCaches.isEmpty) {
        return;
      }

      setState(() {});
      _imageIndex++;
      _updateImage();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _disposed = true;
    widget.imageCaches.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.backColor,
      child: widget.imageCaches[_imageIndex % widget.imageCaches.length],
    );
  }
}
