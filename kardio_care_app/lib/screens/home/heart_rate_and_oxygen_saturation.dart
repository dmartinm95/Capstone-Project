import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/util/device_scanner.dart';
import 'package:kardio_care_app/util/pan_tompkins.dart';
import 'package:kardio_care_app/widgets/blood_oxygen_tile.dart';
import 'package:kardio_care_app/widgets/heart_rate_tile.dart';
import 'package:provider/provider.dart';

class HeartRateAndOxygenSaturation extends StatefulWidget {
  const HeartRateAndOxygenSaturation({
    Key key,
  }) : super(key: key);

  @override
  _HeartRateAndOxygenSaturationState createState() =>
      _HeartRateAndOxygenSaturationState();
}

class _HeartRateAndOxygenSaturationState
    extends State<HeartRateAndOxygenSaturation> {
  Timer _everySecond;

  @override
  void initState() {
    super.initState();

    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _everySecond.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final panTompkinsProvider =
        Provider.of<PanTomkpins>(context, listen: false);

    return Expanded(
      flex: 1,
      child: Container(
        color: KardioCareAppTheme.background, // Red
        child: Container(
          child: Row(
            children: [
              Expanded(
                child: HeartRateTile(
                  currHR: panTompkinsProvider.currentHeartRate == 0
                      ? null
                      : panTompkinsProvider.currentHeartRate,
                ),
              ),
              const VerticalDivider(
                width: 25,
                thickness: 1,
                indent: 20,
                endIndent: 45,
                color: KardioCareAppTheme.dividerPurple,
              ),
              Expanded(child: BloodOxygenTile())
            ],
          ),
        ),
      ),
    );
  }
}
