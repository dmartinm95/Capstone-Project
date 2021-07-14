import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'dart:math' as math;

class HeartRateTile extends StatefulWidget {
  HeartRateTile({Key key, this.currHR}) : super(key: key);

  final int currHR;

  @override
  _HeartRateTileState createState() => _HeartRateTileState();
}

class _HeartRateTileState extends State<HeartRateTile> {
  int _lastHR;
  int _currHR;

  @override
  Widget build(BuildContext context) {
    _lastHR = _currHR;
    _currHR = widget.currHR;

    bool nullHR = (_currHR ?? -1) < 0 || (_lastHR ?? -1) < 0;
    bool validDiff = nullHR ? false : (_currHR - _lastHR != 0);

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
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
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
                child: Text(
                  (_currHR ?? "--").toString(),
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
          !nullHR && validDiff
              ? Transform.rotate(
                  angle: (_lastHR - _currHR > 0)
                      ? 135 * math.pi / 180
                      : 45 * math.pi / 180,
                  child: Icon(
                    Icons.arrow_upward_sharp,
                    color: KardioCareAppTheme.actionBlue,
                    size: 35,
                  ),
                )
              : SizedBox(
                  height: 35,
                )
        ],
      ),
    );
  }
}
