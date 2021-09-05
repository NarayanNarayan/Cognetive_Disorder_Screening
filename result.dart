import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Result extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        color: Color(0xFFFFFFFF),
        onPressed: () {
          Navigator.popUntil(context, (route) => !route.hasActiveRouteBelow);
        },
        child: Text(
          "Thanks For Taking The Test",
          textScaleFactor: 2,
        ),
      ),
    );
  }
}
