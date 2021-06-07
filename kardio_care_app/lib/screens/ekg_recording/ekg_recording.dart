import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:kardio_care_app/util/device_scanner.dart';
import 'dart:async';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:kardio_care_app/widgets/blood_oxygen_tile.dart';
import 'package:kardio_care_app/widgets/heart_rate_tile.dart';
import 'package:provider/provider.dart';

class EKGRecording extends StatefulWidget {
  EKGRecording({Key key}) : super(key: key);

  @override
  _EKGRecordingState createState() => _EKGRecordingState();
}

class _EKGRecordingState extends State<EKGRecording> {
  int _currSeconds = 0;
  int _currMinutes = 0;

  int _totalMinutes;

  bool recording = false;

  Timer _timer;

  var f = NumberFormat("00");

  void _stopTimer() {
    if (_timer != null) {
      _timer.cancel();
      _currSeconds = 0;
      _currMinutes = 0;
    }
  }

  void _startTimer() {
    if (_timer != null) {
      _stopTimer();
    }

    _currMinutes = _totalMinutes;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_currSeconds > 0) {
          _currSeconds--;
        } else {
          if (_currMinutes > 0) {
            _currSeconds = 59;
            _currMinutes--;
          } else {
            _timer.cancel();
            print("Timer Complete");
            Navigator.pushReplacementNamed(context, '/ekg_results');
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _totalMinutes = ModalRoute.of(context).settings.arguments;
    print(_totalMinutes);
    // _currMinutes = _totalMinutes;

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: recording
                  ? Text(
                      'Recording EKG stay calm and stationary.',
                      style: TextStyle(
                          color: KardioCareAppTheme.detailGray, fontSize: 19),
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      'When you are ready press start:',
                      style: TextStyle(
                          color: KardioCareAppTheme.detailGray, fontSize: 19),
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
          Container(
            child: CircularPercentIndicator(
              radius: 200.0,
              lineWidth: 17.0,
              animation: true,
              restartAnimation: false,
              animateFromLastPercent: true,
              animationDuration: 900,
              percent:
                  (_currMinutes.toDouble() * 60 + _currSeconds.toDouble()) /
                      (_totalMinutes.toDouble() * 60),
              center: recording
                  ? Text(
                      "${f.format(_currMinutes)} : ${f.format(_currSeconds)}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 30.0),
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
                          _startTimer();
                          deviceScannerProvider.turnOffAllNotify();
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.red,
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    child: HeartRateTile(
                        // lastHR: 96,
                        // currHR: 80,
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
                        // bloodOx: 45,
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
