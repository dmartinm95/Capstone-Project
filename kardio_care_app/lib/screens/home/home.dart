import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/constants/app_constants.dart';
import 'package:kardio_care_app/screens/home/device_not_found_screen.dart';
import 'package:kardio_care_app/screens/home/home_new.dart';
import 'package:kardio_care_app/widgets/block_radio_button.dart';
import 'package:kardio_care_app/widgets/blood_oxygen_tile.dart';
import 'package:kardio_care_app/widgets/heart_rate_tile.dart';
import 'package:provider/provider.dart';
import 'package:kardio_care_app/util/device_scanner.dart';
import 'package:kardio_care_app/screens/home/live_chart.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DeviceScanner deviceScanner = new DeviceScanner();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: KardioCareAppTheme.screenTitleText,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: deviceScanner.bluetoothDevice,
              builder: (context, snapshot) {
                print(snapshot.connectionState.toString());
                if (snapshot.data == null) {
                  print("No device found yet");
                  return DeviceNotFoundScreen(
                    deviceScanner: deviceScanner,
                  );
                } else {
                  print("Device found");
                  return Consumer<DeviceScanner>(
                    builder: (context, value, child) {
                      return Text("Data incoming: ${value.leadOneData}");
                    },
                  );
                }
              },
            ),
          ),
          // Consumer<DeviceScanner>(
          //   builder: (context, value, child) {
          //     return Text("Data incoming: ${value.leadOneData}");
          //   },
          // ),
          const Divider(
            color: KardioCareAppTheme.detailGray,
            height: 35,
            thickness: 1,
            indent: 19,
            endIndent: 19,
          ),
          Expanded(
            child: Container(
              child: Row(
                children: [
                  Expanded(child: HeartRateTile()),
                  const VerticalDivider(
                    width: 25,
                    thickness: 1,
                    indent: 20,
                    endIndent: 45,
                    color: KardioCareAppTheme.detailGray,
                  ),
                  Expanded(child: BloodOxygenTile())
                ],
              ),
            ),
          ),
          Container(
            height: 70,
          ),
        ],
      ),
    );
  }
}
