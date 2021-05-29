import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/widgets/blood_oxygen_tile.dart';
import 'package:kardio_care_app/widgets/heart_rate_tile.dart';

class HeartRateAndOxygenSaturation extends StatelessWidget {
  const HeartRateAndOxygenSaturation({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        color: KardioCareAppTheme.background, // Red
        child: Container(
          child: Row(
            children: [
              Expanded(
                  child: HeartRateTile(
                currHR: 86,
                lastHR: 83,
              )),
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
