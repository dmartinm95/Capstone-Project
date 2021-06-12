import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/constants/app_constants.dart';
import 'package:kardio_care_app/util/device_scanner.dart';
import 'package:provider/provider.dart';

class StartRecording extends StatelessWidget {
  const StartRecording({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.12,
              color: Colors.transparent,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Center(
                    child: Text(
                      "Select a length of time to record",
                      style: TextStyle(
                          color: KardioCareAppTheme.detailGray, fontSize: 19),
                      textAlign: TextAlign.center,
                    ),
                  )),
            ),
          ),
          FullRectangleTextButton(
            backgroundColor: Colors.blue,
            label: 'Long',
            subLabel: '$ekgLongLengthMin Min',
            lengthMinutes: ekgLongLengthMin,
          ),
          FullRectangleTextButton(
            backgroundColor: Colors.green,
            label: 'Medium',
            subLabel: '$ekgMediumLengthMin Min',
            lengthMinutes: ekgMediumLengthMin,
          ),
          FullRectangleTextButton(
            backgroundColor: Colors.deepPurple,
            label: 'Short',
            subLabel: '$ekgShortLengthMin Min',
            lengthMinutes: ekgShortLengthMin,
          ),
        ],
      ),
    );
  }
}

class FullRectangleTextButton extends StatelessWidget {
  const FullRectangleTextButton(
      {Key key,
      this.label,
      this.subLabel,
      this.backgroundColor,
      this.lengthMinutes})
      : super(key: key);

  final Color backgroundColor;
  final String label;
  final String subLabel;
  final int lengthMinutes;

  @override
  Widget build(BuildContext context) {
    final deviceScannerProvider =
        Provider.of<DeviceScanner>(context, listen: false);

    return Container(
      child: Expanded(
        child: TextButton(
          style: TextButton.styleFrom(
            minimumSize: Size.fromWidth(MediaQuery.of(context).size.width),
            backgroundColor: backgroundColor,
            shape: BeveledRectangleBorder(),
          ),
          // child: Padding(
          // padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                subLabel,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          // ),
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              '/ekg_recording',
              arguments: lengthMinutes,
            ).then((value) {
              print("Going home from start_recording.dart");
              // deviceScannerProvider.switchToStreamIndex(0);
              deviceScannerProvider.switchToMainLead();
            });
          },
        ),
      ),
    );
  }
}
