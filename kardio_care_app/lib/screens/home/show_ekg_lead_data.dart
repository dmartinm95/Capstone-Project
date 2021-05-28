import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/screens/home/build_ekg_plot.dart';
import 'package:kardio_care_app/util/device_scanner.dart';
import 'package:kardio_care_app/widgets/block_radio_button.dart';
import 'package:provider/provider.dart';

class ShowEKGLeadData extends StatelessWidget {
  const ShowEKGLeadData({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
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
                builder: (context, value, child) {
                  return BuildEKGPlot(
                    dataValue: value.leadDataList,
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
}
