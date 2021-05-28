import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 0,
      child: Container(
        color: KardioCareAppTheme.detailPurple,
        child: Center(
          child: Text(
            "Welcome to KardioCare",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w400, fontSize: 20),
          ),
        ),
        constraints: BoxConstraints.expand(
          width: size.width,
          height: 50,
        ),
      ),
    );
  }
}
