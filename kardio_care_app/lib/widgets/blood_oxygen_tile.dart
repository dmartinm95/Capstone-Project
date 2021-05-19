import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';

class BloodOxygenTile extends StatefulWidget {
  BloodOxygenTile({Key key}) : super(key: key);

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
                  '87',
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
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: 10,
            ),
          )
        ],
      ),
    );
  }
}
