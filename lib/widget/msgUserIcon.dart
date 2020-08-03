
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OtherIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 39,
      height: 39,
      margin: EdgeInsets.only(left: 10),
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
    );
  }
}

class MyIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 39,
      height: 39,
      margin: EdgeInsets.only(right: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: DecoratedBox(
          decoration: BoxDecoration(color: Colors.grey),
          child: Icon(
            Icons.perm_contact_calendar,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}