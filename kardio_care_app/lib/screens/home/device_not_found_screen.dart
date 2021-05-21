import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/util/device_scanner.dart';

class DeviceNotFoundScreen extends StatefulWidget {
  const DeviceNotFoundScreen({Key key, this.deviceScanner}) : super(key: key);

  final DeviceScanner deviceScanner;

  @override
  _DeviceNotFoundScreenState createState() => _DeviceNotFoundScreenState();
}

class _DeviceNotFoundScreenState extends State<DeviceNotFoundScreen> {
  bool buttonDisable = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: buttonDisable
            ? KardioCareAppTheme.actionBlue.withOpacity(0.5)
            : KardioCareAppTheme.actionBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
      ),
      child: Text(
        "Search for module",
        style: TextStyle(
          fontSize: 13,
          color: Colors.white,
        ),
      ),
      onPressed: buttonDisable ? () {} : searchAndConnect,
    );
    // return CircularProgressIndicator(
    //   value: null,
    //   semanticsLabel: 'Linear progress indicator',
    // );
  }

  void searchAndConnect() async {
    setState(() {
      buttonDisable = true;
    });

    print("Clicking search");
    await widget.deviceScanner.subscribeToScanEvents();
    print("Done search.");
    if (widget.deviceScanner.bleDevice != null) {
      print("Connecting...");
      await widget.deviceScanner.connectToModule();
      print("Done connecting.");
    }

    if (!mounted) return;

    setState(() {
      buttonDisable = false;
    });
  }
}
