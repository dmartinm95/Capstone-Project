import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/constants/app_constants.dart';
import 'package:kardio_care_app/screens/ekg_recording/ekg_recording.dart';
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
          // Padding(
          //   padding: const EdgeInsets.all(20.0),
          //   child: Container(
          //     height: MediaQuery.of(context).size.height * 0.12,
          //     color: Colors.transparent,
          //     child: Container(
          //         decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.all(Radius.circular(10.0))),
          //         child: Center(
          //           child: Text(
          //             "Select a length of time to record",
          //             style: TextStyle(
          //                 color: KardioCareAppTheme.detailGray, fontSize: 19),
          //             textAlign: TextAlign.center,
          //           ),
          //         )),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.fromLTRB(19, 30, 19, 0),
            child: Text(
              "Select a length of time to record",
              style: KardioCareAppTheme.subTitle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: const Divider(
              color: KardioCareAppTheme.dividerPurple,
              height: 20,
              thickness: 1,
              indent: 19,
              endIndent: 19,
            ),
          ),
          FullRectangleTextButton(
            backgroundColor: Color(0xFF3f37c9),
            label: 'Long',
            subLabel: '$ekgLongLengthMin Min',
            lengthMinutes: ekgLongLengthMin,
          ),
          FullRectangleTextButton(
            backgroundColor: Color(0xFF4361ee),
            label: 'Medium',
            subLabel: '$ekgMediumLengthMin Min',
            lengthMinutes: ekgMediumLengthMin,
          ),
          FullRectangleTextButton(
            backgroundColor: Color(0xFF4895ef),
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
          //   padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
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
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.3,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          // ),
          onPressed: () {
            deviceScannerProvider.turnOffActiveLead();
            deviceScannerProvider.currentHeartRate = 0;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                settings: const RouteSettings(name: "\ekg_recording"),
                builder: (context) => EKGRecording(
                  deviceScannerProvider: deviceScannerProvider,
                  totalMinutes: lengthMinutes,
                ),
              ),
            );
            // ).then((value) {
            //   print("Going home from start_recording.dart");
            //   deviceScannerProvider.turnOffNotifyAllLeads();
            //   deviceScannerProvider.switchToActiveLead();
            // });
          },
        ),
      ),
    );
  }
}
