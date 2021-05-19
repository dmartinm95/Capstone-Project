import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/constants/app_constants.dart';
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
    final deviceScanner = Provider.of<DeviceScanner>(context, listen: false);
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
        children: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: KardioCareAppTheme.actionBlue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(23)),
            ),
            // child: Padding(
            // padding: const EdgeInsets.all(8.0),
            child: Text(
              "Connect to Module",
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
            ),
            // ),
            onPressed: deviceScanner.connectToModule,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<DeviceScanner>(
              builder: (context, device, child) =>
                  Text('Data Value ${device.leadOneData}'),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 20,
              ),
              child: Consumer<DeviceScanner>(
                builder: (context, device, child) => LiveEKGChart(
                  dataValue: device.leadOneData,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: BlockRadioButton(
              buttonLabels: ['I', 'II', 'III', 'V1'],
              circleBorder: true,
              backgroundColor: KardioCareAppTheme.background,
            ),
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
