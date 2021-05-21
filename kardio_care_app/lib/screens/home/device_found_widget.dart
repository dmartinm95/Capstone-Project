import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/screens/home/live_chart.dart';
import 'package:kardio_care_app/util/device_scanner.dart';
import 'package:kardio_care_app/widgets/block_radio_button.dart';
import 'package:kardio_care_app/widgets/blood_oxygen_tile.dart';
import 'package:kardio_care_app/widgets/heart_rate_tile.dart';
import 'package:provider/provider.dart';

class DeviceFoundWidget extends StatefulWidget {
  DeviceFoundWidget({Key key}) : super(key: key);

  @override
  _DeviceFoundWidgetState createState() => _DeviceFoundWidgetState();
}

class _DeviceFoundWidgetState extends State<DeviceFoundWidget> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceScannerProvider =
        Provider.of<DeviceScanner>(context, listen: false);
    return Column(
      children: [
        Consumer<DeviceScanner>(
          builder: (context, value, child) {
            return LiveEKGChart(
              dataValue: value.leadOneData,
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: BlockRadioButton(
            buttonLabels: ['I', 'II', 'III', 'V1'],
            circleBorder: true,
            backgroundColor: KardioCareAppTheme.background,
          ),
        ),
      ],
    );
  }
}
