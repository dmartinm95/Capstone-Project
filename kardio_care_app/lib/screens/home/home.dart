import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/screens/home/build_ekg_plot.dart';
import 'package:kardio_care_app/screens/home/disconnect_btn.dart';
import 'package:kardio_care_app/screens/home/heart_rate_and_oxygen_saturation.dart';
import 'package:kardio_care_app/screens/home/search_connect_btn.dart';
import 'package:kardio_care_app/screens/home/show_ekg_lead_data.dart';
import 'package:kardio_care_app/screens/home/welcome_msg.dart';
import 'package:provider/provider.dart';
import 'package:kardio_care_app/util/device_scanner.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final deviceScannerProvider =
        Provider.of<DeviceScanner>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: KardioCareAppTheme.screenTitleText,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          StreamBuilder(
            stream: deviceScannerProvider.bluetoothDevice,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container();
              }
              return AppBarDisconnectBtn(
                deviceScannerProvider: deviceScannerProvider,
              );
            },
          ),
        ],
      ),
      body: SizedBox(
        height: size.height,
        child: Column(
          children: <Widget>[
            // WelcomeMessage(size: size),
            StreamBuilder(
              stream: deviceScannerProvider.bluetoothDevice,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return SearchAndConnectBtn(
                    size: size,
                    deviceScannerProvider: deviceScannerProvider,
                  );
                }
                return ShowEKGLeadData(
                  size: size,
                  deviceScannerProvider: deviceScannerProvider,
                );
              },
            ),
            HeartRateAndOxygenSaturation(),
            SizedBox(
              height: 60,
            )
          ],
        ),
      ),
    );
  }
}
