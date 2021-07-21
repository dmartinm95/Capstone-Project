import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/util/device_scanner.dart';
import 'package:kardio_care_app/util/data_storage.dart';
import 'package:hive/hive.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class DetectRhythms extends StatefulWidget {
  DetectRhythms({Key key}) : super(key: key);

  @override
  _DetectRhythmsState createState() => _DetectRhythmsState();
}

class _DetectRhythmsState extends State<DetectRhythms> {
  Interpreter _interpreter;
  bool loadedModel = false;
  List<double> threshold = [0.124, 0.07, 0.05, 0.278, 0.390, 0.174];
  List<String> rhythmClassifications = [
    '1st Degree AV block',
    'Bundle Branch Block', //'Right bundle branch block',
    'Bundle Branch Block', //'Left bundle branch block',
    'Sinus Bradycardia',
    'Atrial Fibrillation',
    'Sinus Tachycardia'
  ];

  final box = Hive.box<RecordingData>('recordingDataBox');
  int currentBatch = 0;
  DeviceScanner deviceScannerProvider;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  @override
  Widget build(BuildContext context) {
    RecordingData dataResults = ModalRoute.of(context).settings.arguments;
    if (currentBatch == 0) {
      classify(dataResults.ekgData, dataResults);
    }

    print(currentBatch);
    deviceScannerProvider = Provider.of<DeviceScanner>(context, listen: false);

    return Scaffold(
      backgroundColor: KardioCareAppTheme.background,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: Text(
                    "Analyzing Batch: ${currentBatch.toString()}",
                    style: TextStyle(color: KardioCareAppTheme.detailGray),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
              child: LinearPercentIndicator(
                lineHeight: 10,
                progressColor: KardioCareAppTheme.actionBlue,
                percent: currentBatch / dataResults.ekgData.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  classify(List<List<List<double>>> ekgData, RecordingData dataResults) async {
    List rhythms = [];
    while (currentBatch < ekgData.length) {
      if (loadedModel) {
        List<dynamic> output = List<double>.filled(6, 0).reshape([1, 6]);

        _interpreter.run([ekgData[currentBatch]], output);

        setState(() {
          currentBatch++;
        });
        await Future.delayed(Duration(milliseconds: 100));

        rhythms.add(convertToRhythms(output.cast())[0]);
      } else {
        setState(() {
          currentBatch = 0;
        });
        await Future.delayed(Duration(milliseconds: 100));
      }
    }

    dataResults.rhythms = rhythms.cast();

    await box.put(dataResults.startTime.toIso8601String(), dataResults);

    deviceScannerProvider.doneRecording = false;
    deviceScannerProvider.switchToActiveLead();

    Navigator.of(context).pop();
  }

  void loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'model.tflite',
        // options: InterpreterOptions()..threads = 4,
      );
      loadedModel = true;
    } catch (e) {
      print("Error while creating interpreter: $e");
    }

    print('Loaded tensorflow model');
  }

  List<String> convertToRhythms(List<List<double>> output) {
    List<String> rhythms = [];
    String currRhythm;

    for (List<double> batch in output) {
      currRhythm = 'No Abnormal Rhythm';
      for (int i = 0; i < 6; i++) {
        // print(batch[i]);
        if (threshold[i] < batch[i]) {
          currRhythm = rhythmClassifications[i];
        }
      }
      rhythms.add(currRhythm);
    }
    print('Found rhythms: ' + rhythms.toSet().toList().toString());

    return rhythms;
  }
}
