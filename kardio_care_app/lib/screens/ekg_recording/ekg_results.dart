import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/screens/ekg_recording/recording_charts.dart';
import 'package:kardio_care_app/util/blurry_loading.dart';
import 'package:kardio_care_app/util/device_scanner.dart';
import 'package:kardio_care_app/widgets/recording_stats.dart';
import 'package:kardio_care_app/util/data_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math';
import 'package:kardio_care_app/widgets/filter_chip_widget.dart';
import 'package:provider/provider.dart';
import 'package:kardio_care_app/util/ekg_classifier.dart';
import 'dart:ui';
import 'dart:isolate';
import 'package:kardio_care_app/util/ekg_classifier.dart';
import 'package:kardio_care_app/util/ekg_isolate.dart';

class EKGResults extends StatefulWidget {
  EKGResults({Key key}) : super(key: key);

  @override
  _EKGResultsState createState() => _EKGResultsState();
}

class _EKGResultsState extends State<EKGResults> {
  bool showLoading = false;

  @override
  Widget build(BuildContext context) {
    final deviceScannerProvider =
        Provider.of<DeviceScanner>(context, listen: false);

    if (showLoading) {
      return Stack(children: <Widget>[
        ResultsWidgets(
          deviceScannerProvider: deviceScannerProvider,
          loadingCallback: loadingCallback,
          popScreenCallback: popScreenCallback,
        ),
        AbsorbPointer(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  strokeWidth: 10,
                  backgroundColor: Colors.transparent,
                  color: KardioCareAppTheme.detailGreen,
                ),
              ),
            ),
          ),
        )
      ]);
    } else {
      return ResultsWidgets(
        deviceScannerProvider: deviceScannerProvider,
        loadingCallback: loadingCallback,
        popScreenCallback: popScreenCallback,
      );
    }
  }

  void loadingCallback(bool loading) {
    setState(() {
      showLoading = loading;
    });
  }

  void popScreenCallback() {
    Navigator.of(context).pop();
  }
}

class ResultsWidgets extends StatefulWidget {
  ResultsWidgets({
    Key key,
    this.deviceScannerProvider,
    this.loadingCallback,
    this.popScreenCallback,
  }) : super(key: key);

  final DeviceScanner deviceScannerProvider;
  final Function(bool) loadingCallback;
  final Function() popScreenCallback;

  @override
  _ResultsWidgetsState createState() => _ResultsWidgetsState();
}

class _ResultsWidgetsState extends State<ResultsWidgets> {
  var unsavedRecordingData;
  final box = Hive.box<RecordingData>('recordingDataBox');

  EKGClassifier ekgClassifier;

  EKGIsolate ekgIsolate;

  @override
  void initState() {
    super.initState();

    initStateAsync();
  }

  void initStateAsync() async {

    // Spawn a new isolate
    ekgIsolate = EKGIsolate();
    await ekgIsolate.start();

    // Create an instance of classifier to load model
    ekgClassifier = EKGClassifier();
  }

  @override
  Widget build(BuildContext context) {
    unsavedRecordingData = ModalRoute.of(context).settings.arguments;
    RecordingData dataResults = RecordingData();
    dataResults.bloodOxData = unsavedRecordingData['bloodOxData'];
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
                    widget.deviceScannerProvider.doneRecording = false;
                    widget.deviceScannerProvider.switchToActiveLead();
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
                    avgO2: (dataResults.bloodOxData.values
                                .toList()
                                .reduce((a, b) => a + b) ~/
                            dataResults.bloodOxData.values.length)
                        .toInt(),
                    minHR: dataResults.heartRateData.values.reduce(min).toInt(),
                    maxHR: dataResults.heartRateData.values.reduce(max).toInt(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(19, 15, 19, 0),
                  child: Text(
                    "Tap Relevant Tags",
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
                  padding: const EdgeInsets.fromLTRB(19, 10, 19, 100),
                  child: Center(
                    child: Container(
                      height: 100,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 5.0,
                        runSpacing: 5.0,
                        children: <Widget>[
                          FilterChipWidget(chipName: 'Morning'),
                          FilterChipWidget(chipName: 'Afternoon'),
                          FilterChipWidget(chipName: 'Evening'),
                          FilterChipWidget(chipName: 'Running'),
                        ],
                      ),
                    ),
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
                            onPressed: () async {
                              widget.loadingCallback(true);

                              widget.deviceScannerProvider.doneRecording =
                                  false;
                              widget.deviceScannerProvider.switchToActiveLead();

                              dataResults.rhythms = [];

                              IsolateData isolateData = IsolateData(
                                ekgClassifier.interpreter.address,
                                dataResults.ekgData,
                              );

                              dataResults.rhythms =
                                  await classifyEKG(isolateData);

                              await box.put(
                                  dataResults.startTime.toIso8601String(),
                                  dataResults);

                              widget.popScreenCallback();
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

  /// Runs inference in another isolate
  Future<List<String>> classifyEKG(IsolateData isolateData) async {
    ReceivePort responsePort = ReceivePort();
    ekgIsolate.sendPort.send(isolateData..responsePort = responsePort.sendPort);
    List<String> results = await responsePort.first;
    return results;
  }
}
