import 'package:flutter/material.dart';
import 'package:kardio_care_app/constants/app_constants.dart';

class HeartRateCard extends StatefulWidget {
  final double dataValue;

  const HeartRateCard({
    Key key,
    this.dataValue,
  }) : super(key: key);

  @override
  _HeartRateCardState createState() => _HeartRateCardState();
}

class _HeartRateCardState extends State<HeartRateCard> {
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
                Text("70 bpm"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
