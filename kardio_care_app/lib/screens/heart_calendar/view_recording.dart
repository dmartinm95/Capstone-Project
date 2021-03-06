import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/screens/ekg_recording/recording_charts.dart';
import 'package:kardio_care_app/widgets/recording_stats.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class ViewRecording extends StatefulWidget {
  ViewRecording({
    Key key,
  }) : super(key: key);

  @override
  _ViewRecordingState createState() => _ViewRecordingState();
}

class _ViewRecordingState extends State<ViewRecording> {
  var selectedRecordingData;

  @override
  Widget build(BuildContext context) {
    selectedRecordingData = ModalRoute.of(context).settings.arguments;
    Map<DateTime, double> heartRateData =
        selectedRecordingData['heartRateData'];
    Map<DateTime, double> heartRateVarData =
        selectedRecordingData['heartRateVarData'];
    DateTime timeTaken = selectedRecordingData['dateTimeOfRecording'];
    String screenTitle =
        "Started on ${DateFormat.yMd().format(timeTaken)} at ${DateFormat.jm().format(timeTaken)}";

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Recording",
          style: KardioCareAppTheme.screenTitleText,
        ),
        centerTitle: true,
        actions: [
          CircleAvatar(
            backgroundColor: KardioCareAppTheme.actionBlue,
            radius: 15,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.close),
              color: KardioCareAppTheme.background,
              onPressed: () {
                Navigator.maybePop(context);
              },
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.05,
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 20, 19, 0),
              child: Text(
                screenTitle,
                style: KardioCareAppTheme.subTitle,
              ),
            ),
            const Divider(
              color: KardioCareAppTheme.dividerPurple,
              height: 20,
              thickness: 1,
              indent: 19,
              endIndent: 19,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 10, 19, 0),
              child: RecordingCharts(
                heartRateData: heartRateData,
                heartRateVarData: heartRateVarData,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 20, 19, 10),
              child: RecordingStats(
                avgHRV:
                    (heartRateVarData.values.toList().reduce((a, b) => a + b) ~/
                            heartRateVarData.values.length)
                        .toInt(),
                avgHR: (heartRateData.values.toList().reduce((a, b) => a + b) ~/
                    heartRateData.values.length),
                minHR: heartRateData.values.reduce(min).toInt(),
                maxHR: heartRateData.values.reduce(max).toInt(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
