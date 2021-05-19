import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/screens/heart_calendar/daily_stats.dart';
import 'package:kardio_care_app/screens/heart_calendar/recording_card.dart';
import 'package:kardio_care_app/widgets/block_radio_button.dart';

class DailyTrendCharts extends StatefulWidget {
  DailyTrendCharts({Key key}) : super(key: key);

  @override
  _DailyTrendChartsState createState() => _DailyTrendChartsState();
}

class _DailyTrendChartsState extends State<DailyTrendCharts> {
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
