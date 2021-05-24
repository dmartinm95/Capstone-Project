import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class BloodOxygenTile extends StatefulWidget {
  BloodOxygenTile({Key key, this.bloodOx}) : super(key: key);

  final int bloodOx;

  @override
  _BloodOxygenTileState createState() => _BloodOxygenTileState();
}

class _BloodOxygenTileState extends State<BloodOxygenTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Blood Oxygen',
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
                  (widget.bloodOx ?? "--").toString(),
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 40),
                ),
              ),
              Text(
                '%',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 24,
                ),
              )
            ],
          ),
          LinearPercentIndicator(
            alignment: MainAxisAlignment.center,
            width: 120.0,
            lineHeight: 17.0,
            percent: (widget.bloodOx ?? 0.0).toDouble() / 100.0,
            progressColor: KardioCareAppTheme.detailPurple,
          )
        ],
      ),
    );
  }
}
