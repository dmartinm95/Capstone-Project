import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/constants/app_constants.dart';
import 'package:kardio_care_app/screens/home/device_not_found_widget.dart';
import 'package:kardio_care_app/screens/home/device_found_widget.dart';
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
  @override
  Widget build(BuildContext context) {
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
          deviceScannerProvider.bleDevice != null
              ? AppBarActionButton(deviceScannerProvider: deviceScannerProvider)
              : Container(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: deviceScannerProvider.bluetoothDevice,
                builder: (context, snapshot) {
                  print("Snapshot data: ${snapshot.data}");
                  if (snapshot.data == null) {
                    print("No device found yet");
                    return DeviceNotFoundWidget(
                        deviceScannerProvider: deviceScannerProvider);
                  } else {
                    print("Device found");
                    // return DeviceFoundWidget();
                    return Consumer<DeviceScanner>(
                      builder: (context, value, child) {
                        return LiveEKGChart(
                          dataValue: value.leadOneData,
                        );
                      },
                    );
                  }
                }),
          ),
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

class AppBarActionButton extends StatelessWidget {
  const AppBarActionButton({
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
