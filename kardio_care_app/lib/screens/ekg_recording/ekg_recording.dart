import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:kardio_care_app/util/device_scanner.dart';
import 'dart:async';
import 'dart:math';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:kardio_care_app/widgets/blood_oxygen_tile.dart';
import 'package:kardio_care_app/widgets/heart_rate_tile.dart';
import 'package:provider/provider.dart';
import 'package:kardio_care_app/constants/app_constants.dart';

class EKGRecording extends StatefulWidget {
  EKGRecording({Key key}) : super(key: key);

  @override
  _EKGRecordingState createState() => _EKGRecordingState();
}

class _EKGRecordingState extends State<EKGRecording> {
  DateTime startTime;
  Map<DateTime, double> bloodOxData;
  Map<DateTime, double> heartRateData;
  Map<DateTime, double> heartRateVarData;
  List<List<List<double>>> ekgData = <List<List<double>>>[];

  int _currSeconds = 0;
  int _currMinutes = 0;

  int _totalMinutes;

  bool recording = false;

  Timer _countdownTimer;
  Timer fakeDataTimer;

  var f = NumberFormat("00");

  int random(int min, int max) {
    var rn = Random();
    return (min + rn.nextInt(max - min));
  }

  void generateFakeData() {
    setState(() {
      bloodOxData[DateTime.now()] = random(10, 80).toDouble();
      heartRateData[DateTime.now()] = random(40, 100).toDouble();
      heartRateVarData[DateTime.now()] = random(40, 90).toDouble();
    });
  }

  void _stopTimer() {
    if (_countdownTimer != null) {
      _countdownTimer.cancel();
      fakeDataTimer.cancel();
      _currSeconds = 0;
      _currMinutes = 0;
    }
  }

  void _startTimer(DeviceScanner deviceScanner) async {
    bloodOxData = {};
    heartRateData = {};
    heartRateVarData = {};

    if (_countdownTimer != null) {
      _stopTimer();
    }

    startTime = DateTime.now();
    deviceScanner.ekgDataBatchIndex = 0;
    deviceScanner.ekgDataToStoreIndex = 0;
    await deviceScanner.connectToAllLeads(_totalMinutes);

    generateFakeData();
    fakeDataTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      generateFakeData();
    });

    _currMinutes = _totalMinutes;

    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_currSeconds > 0) {
          _currSeconds--;
        } else {
          if (_currMinutes > 0) {
            _currSeconds = 59;
            _currMinutes--;
          } else {
            _countdownTimer.cancel();
            fakeDataTimer.cancel();
            print("Timer Complete");

            print("EKG DATA COLLECTED");
            List<List<List<double>>> ekgDataCollected =
                List.from(deviceScanner.ekgDataToStore);

            Navigator.pushReplacementNamed(context, '/ekg_results', arguments: {
              'bloodOxData': bloodOxData,
              'heartRateData': heartRateData,
              'heartRateVarData': heartRateVarData,
              'ekgData': ekgDataCollected,
              'startTime': startTime,
              'selectedMinutes': ModalRoute.of(context).settings.arguments
            }).then((value) {
              print("Going home from ekg_recording.dart");
              deviceScanner.switchToMainLead();
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _totalMinutes = ModalRoute.of(context).settings.arguments;

    final deviceScannerProvider =
        Provider.of<DeviceScanner>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "EKG Recording",
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
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.05,
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: CircularPercentIndicator(
              radius: 200.0,
              lineWidth: 17.0,
              animation: true,
              restartAnimation: false,
              animateFromLastPercent: true,
              animationDuration: 800,
              percent:
                  (_currMinutes.toDouble() * 60 + _currSeconds.toDouble()) /
                      (_totalMinutes.toDouble() * 60),
              center: recording
                  ? Text(
                      "${f.format(_currMinutes)} : ${f.format(_currSeconds)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
                    )
                  : ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(width: 160, height: 160),
                      child: ElevatedButton(
                        child: Text(
                          'START',
                          style: TextStyle(
                            fontSize: 24,
                            color: KardioCareAppTheme.detailGray,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            recording = true;
                          });
                          _startTimer(deviceScannerProvider);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          primary: KardioCareAppTheme.background,
                        ),
                      ),
                    ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: KardioCareAppTheme.detailGreen,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: recording
                  ? FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        'Recording EKG stay calm and stationary.',
                        style: TextStyle(
                            color: KardioCareAppTheme.detailGray, fontSize: 19),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        'When you are ready press start.',
                        style: TextStyle(
                            color: KardioCareAppTheme.detailGray, fontSize: 19),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    child: HeartRateTile(
                      currHR: heartRateData?.values?.last?.toInt(),
                    ),
                  ),
                  const VerticalDivider(
                    width: 25,
                    thickness: 1,
                    indent: 20,
                    endIndent: 45,
                    color: KardioCareAppTheme.dividerPurple,
                  ),
                  Expanded(
                    child: BloodOxygenTile(
                      bloodOx: bloodOxData?.values?.last?.toInt(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _stopTimer();
  }
}

class EKGDataStorage {}
