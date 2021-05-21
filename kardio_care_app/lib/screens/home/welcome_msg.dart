import 'package:flutter/material.dart';

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
        color: Colors.blue,
        child: Center(
          child: Text("Welcome to KardioCare"),
        ),
        constraints: BoxConstraints.expand(
          width: size.width,
          height: 50,
        ),
      ),
    );
  }
}
