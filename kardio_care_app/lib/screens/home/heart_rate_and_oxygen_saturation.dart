import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/util/data_storage.dart';
import 'package:kardio_care_app/util/pan_tompkins.dart';
import 'package:kardio_care_app/widgets/recordings_today_tile.dart';
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
  Box<RecordingData> _box;

  @override
  void initState() {
    super.initState();

    Hive.openBox<RecordingData>('recordingDataBox');
    _box = Hive.box<RecordingData>('recordingDataBox');

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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HeartRateTile(
                currHR: panTompkinsProvider.currentHeartRate == 0
                    ? null
                    : panTompkinsProvider.currentHeartRate,
              ),
              const VerticalDivider(
                width: 5,
                thickness: 1,
                indent: 20,
                endIndent: 45,
                color: KardioCareAppTheme.dividerPurple,
              ),
              RecordingsTile(
                recordingData: _box,
              )
            ],
          ),
        ),
      ),
    );
  }
}
