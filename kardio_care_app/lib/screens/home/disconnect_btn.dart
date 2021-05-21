import 'package:flutter/material.dart';
import 'package:kardio_care_app/util/device_scanner.dart';

class AppBarDisconnectBtn extends StatelessWidget {
  const AppBarDisconnectBtn({
    Key key,
    @required this.deviceScannerProvider,
  }) : super(key: key);

  final DeviceScanner deviceScannerProvider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: () {
          print("Tapping action button");
          deviceScannerProvider.disconnectFromModule();
        },
        child: Icon(
          Icons.bluetooth_connected,
          size: 26.0,
          color: Colors.black,
        ),
      ),
    );
  }
}
