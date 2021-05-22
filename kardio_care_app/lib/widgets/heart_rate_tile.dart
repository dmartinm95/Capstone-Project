import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'dart:math' as math;

class HeartRateTile extends StatefulWidget {
  HeartRateTile({Key key, this.currHR, this.lastHR}) : super(key: key);

  final int currHR;
  final int lastHR;

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
                  (widget.currHR ?? "--").toString(),
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
          if ((widget.currHR ?? -1) > 0 && (widget.lastHR ?? -1) > 0)
            Transform.rotate(
              angle: (widget.lastHR - widget.currHR > 0)
                  ? 135 * math.pi / 180
                  : 45 * math.pi / 180,
              child: Icon(
                Icons.arrow_upward_sharp,
                color: KardioCareAppTheme.detailRed,
                size: 40,
              ),
            ),
        ],
      ),
    );
  }
}
