import 'package:flutter/material.dart';

class AnimatedText extends AnimatedWidget {
  AnimatedText({Key key, Animation<double> animation, this.onTap})
      : super(key: key, listenable: animation);

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        return GestureDetector(
          child: Container(
            width: 54 * animation.value,
            height: 29,
            margin: EdgeInsets.only(right: 7),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 7, 193, 96),
                borderRadius: BorderRadius.circular(3)),
            child: child,
          ),
          onTap: onTap,
        );
      },
      child: Text(
        '发送',
        textDirection: TextDirection.ltr,
        style: TextStyle(
            color:
                Color.fromARGB((255 * animation.value).toInt(), 255, 255, 255),
            fontSize: 15 * animation.value),
      ),
    );
  }
}
