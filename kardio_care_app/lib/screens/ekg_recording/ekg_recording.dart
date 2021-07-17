import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:kardio_care_app/util/device_scanner.dart';
import 'dart:async';
import 'dart:math';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:kardio_care_app/widgets/heart_rate_tile.dart';

class EKGRecording extends StatefulWidget {
  EKGRecording({Key key, this.deviceScannerProvider, this.totalMinutes})
      : super(key: key);

  final DeviceScanner deviceScannerProvider;
  final int totalMinutes;

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

  int _totalMinutes = 0;

  bool recording = false;

  Timer _countdownTimer;
  Timer fakeDataTimer;

  var f = NumberFormat("00");

  @override
  void initState() {
    _totalMinutes = widget.totalMinutes;
    print("INIT state");
    print("Device name: ${widget.deviceScannerProvider.bleDevice.name}");
    print("Total time selected: $_totalMinutes minutes");
    super.initState();
  }

  @override
  void dispose() {
    _stopTimer();
    print("Disposing ekg_recording.dart screen");
    widget.deviceScannerProvider.turnOffNotifyAllLeads();
    widget.deviceScannerProvider.switchToActiveLead();
    super.dispose();
  }

  int random(int min, int max) {
    var rn = Random();
    return (min + rn.nextInt(max - min));
  }

  void generateFakeData() {
    setState(() {
      bloodOxData[DateTime.now()] = random(95, 100).toDouble();
      // heartRateData[DateTime.now()] = random(50, 100).toDouble();
      // heartRateVarData[DateTime.now()] = random(40, 90).toDouble();
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

  void _startTimer(DeviceScanner deviceScanner) {
    bloodOxData = {};
    heartRateData = {};
    heartRateVarData = {};

    if (_countdownTimer != null) {
      _stopTimer();
    }

    startTime = DateTime.now();

    widget.deviceScannerProvider.connectToAllLeads(_totalMinutes);

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
                List.from(widget.deviceScannerProvider.ekgDataToStore);
            widget.deviceScannerProvider.doneRecording = true;
            widget.deviceScannerProvider.turnOffNotifyAllLeads();

            print("Heart Rate Data Collected");
            List<double> heartRateDataCollected =
                widget.deviceScannerProvider.recordedHeartRateData;
            print(heartRateDataCollected);

            print("Hear Rate Var Data Collected");
            List<double> heartRateVarDataCollected =
                widget.deviceScannerProvider.recordedHeartRateVarData;
            print(heartRateVarDataCollected);

            // heartRateData[DateTime.now()] = mean(Array(heartRateDataCollected));
            heartRateData =
                Map.from(widget.deviceScannerProvider.recordedHeartRateMap);

            heartRateVarData =
                Map.from(widget.deviceScannerProvider.recordedHeartRateVarMap);

            print("Going to ekg_results screen");
            Navigator.pushReplacementNamed(context, '/ekg_results', arguments: {
              'bloodOxData': bloodOxData,
              'heartRateData': heartRateData,
              'heartRateVarData': heartRateVarData,
              'ekgData': ekgDataCollected,
              'startTime': startTime,
              'selectedMinutes': _totalMinutes,
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // _totalMinutes = ModalRoute.of(context).settings.arguments;

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
            radius: 15,
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
              animationDuration: 1000,
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
                          _startTimer(null);
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
                        'Recording EKG. Stay calm and stationary.',
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
                        currHR: widget.deviceScannerProvider.currentHeartRate ==
                                0
                            ? null
                            : widget.deviceScannerProvider.currentHeartRate),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
