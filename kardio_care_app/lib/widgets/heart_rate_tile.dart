import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'dart:math' as math;

class HeartRateTile extends StatefulWidget {
  HeartRateTile({Key key}) : super(key: key);

  @override
  _HeartRateTileState createState() => _HeartRateTileState();
}

class _HeartRateTileState extends State<HeartRateTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Heart Rate',
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '100',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 40),
                ),
              ),
              Text(
                'Bpm',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 24,
                ),
              )
            ],
          ),
          Transform.rotate(
            angle: 45 * math.pi / 180,
            child: Icon(
              Icons.arrow_upward_sharp,
              color: KardioCareAppTheme.detailRed,
              size: 40,
            ),
          )
        ],
      ),
    );
  }
}
