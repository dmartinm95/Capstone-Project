import 'package:flutter/material.dart';
import 'package:kardio_care_app/constants/app_constants.dart';

class DataCard extends StatelessWidget {
  const DataCard({
    Key key,
    this.dataValue,
  }) : super(key: key);

  final double dataValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding / 2),
      height: 60,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 7,
            spreadRadius: 5,
            color: kPrimaryColor.withOpacity(0.22),
          ),
        ],
      ),
      child: (dataValue == null) ? Text('Data:\n') : Text('Data:\n$dataValue'),
    );
  }
}
