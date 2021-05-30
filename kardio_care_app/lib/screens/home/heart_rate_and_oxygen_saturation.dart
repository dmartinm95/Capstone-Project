import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/util/device_scanner.dart';
import 'package:kardio_care_app/util/pan_tompkins.dart';
import 'package:kardio_care_app/widgets/blood_oxygen_tile.dart';
import 'package:kardio_care_app/widgets/heart_rate_tile.dart';
import 'package:provider/provider.dart';
import 'package:scidart/numdart.dart';

class HeartRateAndOxygenSaturation extends StatelessWidget {
  const HeartRateAndOxygenSaturation({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final panTompkinsProvider =
        Provider.of<PanTomkpins>(context, listen: false);

    return Expanded(
      flex: 1,
      child: Container(
        color: KardioCareAppTheme.background, // Red
        child: Container(
          child: Row(
            children: [
              Expanded(
                // child: ValueListenableBuilder(
                //   valueListenable: panTompkinsProvider.currentHeartRateNotifier,
                //   builder: (context, value, child) {
                //     print("panTompkinsProvider current heart rate: $value");
                //     return Container();
                //     // return HeartRateTile(currHR: value);
                //   },
                // ),
                child: HeartRateTile(),
                // child: Consumer<PanTomkpins>(
                //   builder: (context, value, child) => HeartRateTile(
                //     currHR: value.currentHeartRate,
                //   ),
                // ),
              ),
              const VerticalDivider(
                width: 25,
                thickness: 1,
                indent: 20,
                endIndent: 45,
                color: KardioCareAppTheme.dividerPurple,
              ),
              Expanded(child: BloodOxygenTile())
            ],
          ),
        ),
      ),
    );
  }
}
