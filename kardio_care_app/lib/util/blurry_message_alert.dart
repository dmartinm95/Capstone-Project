import 'dart:ui';

import 'package:flutter/material.dart';

class BlurryMessageDialog extends StatelessWidget {
  final String title;
  final String content;

  BlurryMessageDialog(this.title, this.content);

  final TextStyle textStyle = TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          title: FittedBox(
            child: Text(
              title,
              style: textStyle,
            ),
          ),
          content: FittedBox(
            fit: BoxFit.fill,
            child: Text(
              content,
              style: textStyle,
            ),
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ));
  }
}
