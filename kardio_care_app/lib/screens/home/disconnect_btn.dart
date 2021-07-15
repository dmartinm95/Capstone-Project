import 'package:flutter/material.dart';
import 'package:kardio_care_app/util/blurry_dialog_alert.dart';
import 'package:kardio_care_app/util/device_scanner.dart';
import 'package:kardio_care_app/app_theme.dart';

class AppBarDisconnectBtn extends StatelessWidget {
  const AppBarDisconnectBtn({
    Key key,
    @required this.deviceScannerProvider,
  }) : super(key: key);

  final DeviceScanner deviceScannerProvider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: CircleAvatar(
        backgroundColor: KardioCareAppTheme.actionBlue,
        radius: 15,
        child: GestureDetector(
          onTap: () {
            showAlertDialog(context, deviceScannerProvider);
          },
          child: Icon(
            Icons.bluetooth_disabled_rounded,
            color: KardioCareAppTheme.white,
          ),
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context, DeviceScanner deviceScanner) {
  VoidCallback continueCallBack = () => {
        Navigator.of(context).pop(),
        // Code on continue comes here
        deviceScanner.disconnectFromModule(),
      };
  BlurryDialog alert = BlurryDialog(
    "Disconnect Device",
    "Are you sure you want to disconnect Kompression?",
    continueCallBack,
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
