import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/screens/ekg_recording/recording_charts.dart';
import 'package:kardio_care_app/util/device_scanner.dart';
import 'package:kardio_care_app/widgets/recording_stats.dart';
import 'package:kardio_care_app/util/data_storage.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'dart:ui';

class EKGResults extends StatefulWidget {
  EKGResults({Key key}) : super(key: key);

  @override
  _EKGResultsState createState() => _EKGResultsState();
}

class _EKGResultsState extends State<EKGResults> {
  var unsavedRecordingData;

  @override
  Widget build(BuildContext context) {
    final deviceScannerProvider =
        Provider.of<DeviceScanner>(context, listen: false);

    unsavedRecordingData = ModalRoute.of(context).settings.arguments;
    RecordingData dataResults = RecordingData();
    dataResults.heartRateData = unsavedRecordingData['heartRateData'];
    dataResults.heartRateVarData = unsavedRecordingData['heartRateVarData'];
    dataResults.ekgData = unsavedRecordingData['ekgData'];
    dataResults.startTime = unsavedRecordingData['startTime'];
    dataResults.recordingLengthMin = unsavedRecordingData['selectedMinutes'];

    return Container(
      color: KardioCareAppTheme.background,
      child: SafeArea(
        top: false,
        right: false,
        left: false,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              "Results",
              style: KardioCareAppTheme.screenTitleText,
            ),
            centerTitle: true,
            actions: [
              CircleAvatar(
                backgroundColor: KardioCareAppTheme.actionBlue,
                radius: 16,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.close),
                  color: KardioCareAppTheme.background,
                  onPressed: () {
                    deviceScannerProvider.doneRecording = false;
                    deviceScannerProvider.switchToActiveLead();
                    print("Pressed X");
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
                  padding: const EdgeInsets.fromLTRB(19, 10, 19, 0),
                  child: RecordingCharts(
                    heartRateData: dataResults.heartRateData,
                    heartRateVarData: dataResults.heartRateVarData,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(19, 20, 19, 10),
                  child: RecordingStats(
                    avgHRV: (dataResults.heartRateVarData.values
                                .toList()
                                .reduce((a, b) => a + b) ~/
                            dataResults.heartRateVarData.values.length)
                        .toInt(),
                    avgHR: (dataResults.heartRateData.values
                            .toList()
                            .reduce((a, b) => a + b) ~/
                        dataResults.heartRateData.values.length),
                    minHR: dataResults.heartRateData.values.reduce(min).toInt(),
                    maxHR: dataResults.heartRateData.values.reduce(max).toInt(),
                  ),
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
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
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
                            child: Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                            // ),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/detect_rhythms',
                                  arguments: dataResults);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
