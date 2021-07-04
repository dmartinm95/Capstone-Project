import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';

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
              style: KardioCareAppTheme.subTitle,
            ),
          ),
          content: FittedBox(
            fit: BoxFit.fill,
            child: Text(
              content,
              style: TextStyle(
                color: KardioCareAppTheme.detailGray,
              ),
            ),
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                child: Text(
                  "OK",
                  style: TextStyle(
                    fontSize: 20,
                    color: KardioCareAppTheme.actionBlue,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ));
  }
}
