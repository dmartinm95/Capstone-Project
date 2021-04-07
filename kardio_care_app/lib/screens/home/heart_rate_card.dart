import 'package:flutter/material.dart';
import 'package:kardio_care_app/constants/app_constants.dart';

class HeartRateCard extends StatelessWidget {
  const HeartRateCard({Key key, this.dataValue}) : super(key: key);
  final int dataValue;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 100,
            width: 75,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 20,
                    color: kPrimaryColor.withOpacity(0.2),
                  ),
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Heart Rate"),
                Text("$dataValue bpm"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
