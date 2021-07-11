import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/screens/heart_calendar/daily_stats.dart';
import 'package:kardio_care_app/screens/heart_calendar/recording_card.dart';
import 'package:kardio_care_app/widgets/block_radio_button.dart';
import 'package:kardio_care_app/screens/heart_calendar/heart_rate_chart.dart';
import 'package:kardio_care_app/screens/heart_calendar/hrv_chart.dart';

class DailyTrendCharts extends StatefulWidget {
  DailyTrendCharts({
    Key key,
    this.heartRateData,
    this.heartRateVarData,
  }) : super(key: key);

  final Map<DateTime, double> heartRateData;
  final Map<DateTime, double> heartRateVarData;

  @override
  _DailyTrendChartsState createState() => _DailyTrendChartsState();
}

class _DailyTrendChartsState extends State<DailyTrendCharts> {
  int radioButtonIndex = 0;

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
            radioButtonIndex == 0
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Text(
                              'Heart Rate Variability Today',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 12, 30, 5),
                            child: Text('Milliseconds'),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: HRVChart(
                              heartRateVarData: widget.heartRateVarData,
                              fromResultsScreen: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                'Heart Rate Today',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 12, 30, 5),
                            child: Text('Beats per minute'),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: HeartRateChart(
                              heartRateData: widget.heartRateData,
                              fromResultsScreen: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: BlockRadioButton(
                buttonLabels: ['HRV', 'HR'],
                circleBorder: false,
                backgroundColor: Colors.white,
                callback: callback,
              ),
            )
          ],
        ),
      ),
    );
  }

  callback(int newIndex) {
    setState(() {
      radioButtonIndex = newIndex;
    });
  }
}
