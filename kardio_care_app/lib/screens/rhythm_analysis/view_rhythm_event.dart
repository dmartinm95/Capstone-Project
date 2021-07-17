import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/screens/rhythm_analysis/rhythm_event_chart.dart';
import 'package:kardio_care_app/util/data_storage.dart';
import 'package:kardio_care_app/widgets/recording_stats.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'dart:typed_data';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:ui' as dart_ui;
import 'package:flutter/services.dart';

class ViewRhythmEvent extends StatefulWidget {
  const ViewRhythmEvent({Key key}) : super(key: key);

  @override
  _ViewRhythmEventState createState() => _ViewRhythmEventState();
}

class _ViewRhythmEventState extends State<ViewRhythmEvent> {
  int selectedLead = 0;
  bool allRhythms = true;
  int currBatch = 0;

  @override
  Widget build(BuildContext context) {
    final RecordingData recordingData =
        ModalRoute.of(context).settings.arguments;

    int avgHRV = (recordingData.heartRateVarData.values
                .toList()
                .reduce((a, b) => a + b) ~/
            recordingData.heartRateVarData.values.length)
        .toInt();
    int avgHR =
        (recordingData.heartRateData.values.toList().reduce((a, b) => a + b) ~/
            recordingData.heartRateData.values.length);

    int minHR = recordingData.heartRateData.values.reduce(min).toInt();
    int maxHR = recordingData.heartRateData.values.reduce(max).toInt();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Recording Rhythms",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 20, 19, 0),
              child: FittedBox(
                child: Text(
                  'Recording on ' +
                      DateFormat.yMMMd().format(recordingData.startTime) +
                      ' at ' +
                      DateFormat.jm().format(recordingData.startTime),
                  style: KardioCareAppTheme.subTitle,
                ),
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
              padding: const EdgeInsets.fromLTRB(19, 0, 19, 0),
              child: Row(
                children: [
                  DropdownButton(
                    hint: const Text(
                      'Lead I',
                      style: TextStyle(
                        color: KardioCareAppTheme.detailGray,
                      ),
                    ),
                    value: selectedLead,
                    items: [
                      DropdownMenuItem(
                        child: Text(
                          "Lead I",
                          style: TextStyle(
                            color: KardioCareAppTheme.detailGray,
                          ),
                        ),
                        value: 0,
                      ),
                      DropdownMenuItem(
                        child: Text(
                          "Lead II",
                          style: TextStyle(
                            color: KardioCareAppTheme.detailGray,
                          ),
                        ),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text(
                          "Lead III",
                          style: TextStyle(
                            color: KardioCareAppTheme.detailGray,
                          ),
                        ),
                        value: 2,
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedLead = value;
                      });
                    },
                  ),
                  Expanded(child: SizedBox()),
                  if (recordingData.rhythms.toSet().toList().length != 1)
                    DropdownButton(
                      // hint: Text(
                      //   'Rhythms',
                      //   style: TextStyle(
                      //     color: KardioCareAppTheme.detailGray,
                      //   ),
                      // ),
                      value: allRhythms,
                      items: [
                        DropdownMenuItem(
                          child: Text(
                            "All Rhythms",
                            style: TextStyle(
                              color: KardioCareAppTheme.detailGray,
                            ),
                          ),
                          value: true,
                        ),
                        DropdownMenuItem(
                          child: Text(
                            "Abnormal Rhythms",
                            style: TextStyle(
                              color: KardioCareAppTheme.detailGray,
                            ),
                          ),
                          value: false,
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          allRhythms = value;
                        });
                      },
                    ),
                ],
              ),
            ),
            RhythmEventChart(
              lengthRecordingMin: recordingData.recordingLengthMin,
              ekgData: recordingData.ekgData,
              selectedLead: selectedLead,
              numBatches:
                  (recordingData.recordingLengthMin * 60 * 400 / 4096).ceil(),
              allRhythms: allRhythms,
              rhythms: recordingData.rhythms,
              changeBatchCallback: changeBatchCallback,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 20, 19, 0),
              child: RecordingStats(
                avgHRV: avgHRV,
                avgHR: avgHR,
                avgO2: 0,
                minHR: minHR,
                maxHR: maxHR,
              ),
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: KardioCareAppTheme.background,
        height: 70.0,
        child: Column(
          children: [
            const Divider(
              color: KardioCareAppTheme.dividerPurple,
              height: 1,
              thickness: 1,
              indent: 0,
              endIndent: 0,
            ),
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: KardioCareAppTheme.actionBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                  ),
                  // child: Padding(
                  // padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Generate Report",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Icon(
                        Icons.file_download,
                        color: Colors.white,
                        size: 30,
                      ),
                    ],
                  ),
                  // ),
                  onPressed: () async {
                    Navigator.pushNamed(context, '/preview_pdf', arguments: {
                      'recordingData': recordingData,
                      'currBatch': currBatch,
                      'avgHRV': avgHRV,
                      'avgHR': avgHR,
                      'minHR': minHR,
                      'maxHR': maxHR,
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changeBatchCallback(int index) {
    currBatch = index;
  }
}
