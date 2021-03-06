import 'package:flutter/material.dart';
import 'package:kardio_care_app/screens/heart_calendar/heart_rate_chart.dart';
import 'package:kardio_care_app/screens/heart_calendar/hrv_chart.dart';
import 'package:kardio_care_app/widgets/block_radio_button.dart';

class RecordingCharts extends StatefulWidget {
  RecordingCharts({
    Key key,
    this.heartRateData,
    this.heartRateVarData,
  }) : super(key: key);

  final Map<DateTime, double> heartRateData;
  final Map<DateTime, double> heartRateVarData;

  @override
  _RecordingChartsState createState() => _RecordingChartsState();
}

class _RecordingChartsState extends State<RecordingCharts> {
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
                              'Heart Rate Variability',
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
                              fromResultsScreen: true,
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
                                'Heart Rate',
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
                              fromResultsScreen: true,
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
