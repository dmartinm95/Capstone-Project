import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/screens/home/build_ekg_plot.dart';
import 'package:kardio_care_app/util/device_scanner.dart';
import 'package:kardio_care_app/util/pan_tompkins.dart';
import 'package:kardio_care_app/widgets/block_radio_button.dart';
import 'package:provider/provider.dart';

class ShowEKGLeadData extends StatelessWidget {
  ShowEKGLeadData({
    Key key,
    @required this.size,
    this.deviceScannerProvider,
  }) : super(key: key);

  final Size size;
  final DeviceScanner deviceScannerProvider;

  @override
  Widget build(BuildContext context) {
    final panTompkinsProvider =
        Provider.of<PanTomkpins>(context, listen: false);

    return Expanded(
      flex: 0,
      child: Container(
        constraints: BoxConstraints.expand(
          width: size.width,
          height: size.height / 2 - 50,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: KardioCareAppTheme.background,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: Consumer<DeviceScanner>(
                builder: (context, device, child) {
                  panTompkinsProvider.addDataToBuffer(
                      device.leadDataList, true);
                  return BuildEKGPlot(
                    dataValue: device.leadDataList,
                    dataFilter: null,
                  );
                },
              ),
            ),
            Flexible(
              flex: 0,
              fit: FlexFit.tight,
              child: BlockRadioButton(
                buttonLabels: ['I', 'II', 'III'],
                circleBorder: true,
                backgroundColor: KardioCareAppTheme.background,
                callback: callback,
                currentSelection: deviceScannerProvider.activeLeadIndex,
              ),
            ),
          ],
        ),
      ),
    );
  }

  callback(int newIndex) {
    print("Switching stream to new index: $newIndex");

    deviceScannerProvider.switchToStreamIndex(newIndex);
  }
}
