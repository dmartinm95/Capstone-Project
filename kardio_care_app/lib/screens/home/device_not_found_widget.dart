import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/util/device_scanner.dart';

class DeviceNotFoundWidget extends StatefulWidget {
  const DeviceNotFoundWidget({Key key, this.deviceScannerProvider})
      : super(key: key);

  final DeviceScanner deviceScannerProvider;

  @override
  _DeviceNotFoundWidgetState createState() => _DeviceNotFoundWidgetState();
}

class _DeviceNotFoundWidgetState extends State<DeviceNotFoundWidget> {
  bool buttonEnabled = true;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: buttonEnabled
            ? KardioCareAppTheme.actionBlue
            : KardioCareAppTheme.actionBlue.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
      ),
      child: Text(
        "Search for module",
        style: TextStyle(
          fontSize: 13,
          color: Colors.white,
        ),
      ),
      onPressed: () {
        setState(() {
          buttonEnabled = false;
        });
        print("Tapping search and connect");
        widget.deviceScannerProvider.connectToModule().then((value) {
          print("The value is: $value");
          setState(() {
            buttonEnabled = value;
          });
        });
      },
    );
  }

  // void searchAndConnect() async {
  //   setState(() {
  //     buttonEnabled = false;
  //   });

  //   Future<bool> future = widget.deviceScannerProvider.connectToModule();

  //   print("Result is: ${widget.deviceScannerProvider.bleDevice}");
  //   if (!mounted) return;

  //   setState(() {
  //     buttonEnabled = true;
  //   });
  // }
}
