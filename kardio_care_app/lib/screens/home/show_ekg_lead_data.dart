import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/screens/home/build_ekg_plot.dart';
import 'package:kardio_care_app/util/data_filter.dart';
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
  final dataFilterInstance = new DataFilter();

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
                  // panTompkinsProvider.addDataToBuffer(value.leadDataList);
                  // if (deviceScannerProvider.activeLeadIndex == -1) {
                  //   ekgDataManager.fillInput(value.allLeadDataList);
                  // } else {
                  //   panTompkinsProvider.addDataToBuffer(value.leadDataList);
                  // }
                  return BuildEKGPlot(
                    dataValue: device.leadDataList,
                    dataFilter: dataFilterInstance,
                  );
                },
              ),
            ),
            Flexible(
              flex: 0,
              fit: FlexFit.tight,
              child: BlockRadioButton(
                buttonLabels: ['I', 'II', 'III', 'V1'],
                circleBorder: true,
                backgroundColor: KardioCareAppTheme.background,
                callback: callback,
                currentSelection: deviceScannerProvider.activeLeadIndex,
              ),
            ),
            const Divider(
              color: KardioCareAppTheme.dividerPurple,
              height: 20,
              thickness: 1,
              indent: 19,
              endIndent: 19,
            ),
          ],
        ),
      ),
    );
  }

  callback(int newIndex) {
    print("Switching stream index to: index $newIndex");

    deviceScannerProvider.switchToStreamIndex(newIndex);

    deviceScannerProvider.listenToStream(newIndex);

    dataFilterInstance.resetBuffer();
  }
}
