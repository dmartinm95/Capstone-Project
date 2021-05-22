import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/screens/heart_calendar/daily_stats.dart';
import 'package:kardio_care_app/screens/heart_calendar/recording_card.dart';
import 'package:kardio_care_app/widgets/block_radio_button.dart';

class RecordingCharts extends StatefulWidget {
  RecordingCharts({Key key}) : super(key: key);

  @override
  _RecordingChartsState createState() => _RecordingChartsState();
}

class _RecordingChartsState extends State<RecordingCharts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: Column(
          children: [
            Container(
              height: 300,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: BlockRadioButton(
                buttonLabels: ['HRV', 'HR'],
                circleBorder: false,
                backgroundColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
