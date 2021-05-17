import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class EKGRecording extends StatefulWidget {
  EKGRecording({Key key}) : super(key: key);

  @override
  _EKGRecordingState createState() => _EKGRecordingState();
}

class _EKGRecordingState extends State<EKGRecording> {
  int _currSeconds = 10;
  int _currMinutes = 0;

  bool recording = false;

  Timer _timer;

  var f = NumberFormat("00");

  void _stopTimer() {
    if (_timer != null) {
      _timer.cancel();
      _currSeconds = 20;
      _currMinutes = 1;
    }
  }

  void _startTimer() {
    if (_timer != null) {
      _stopTimer();
    }

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
    return Scaffold(
      appBar: AppBar(
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
                      'recording',
                      style: TextStyle(color: Colors.black, fontSize: 19),
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      'When you are ready press start',
                      style: TextStyle(color: Colors.black, fontSize: 19),
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
          Container(
            child: recording
                ? CircleAvatar(
                    radius: 100,
                    child: Text(
                      "${f.format(_currMinutes)} : ${f.format(_currSeconds)}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 48,
                      ),
                    ),
                  )
                : ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(width: 200, height: 200),
                    child: ElevatedButton(
                      child: Text(
                        'Start',
                        style: TextStyle(fontSize: 24),
                      ),
                      onPressed: () {
                        setState(() {
                          recording = true;
                        });
                        _startTimer();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                      ),
                    ),
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
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(9.5, 0, 9.5, 50),
                      child: Container(
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    width: 25,
                    thickness: 1,
                    indent: 20,
                    endIndent: 70,
                    color: KardioCareAppTheme.detailGray,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(9.5, 0, 9.5, 50),
                      child: Container(
                        color: Colors.blue,
                      ),
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
