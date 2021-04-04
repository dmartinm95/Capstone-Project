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
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(kDefaultPadding / 2),
      height: size.height * 0.35,
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 5,
            color: kPrimaryColor.withOpacity(0.2),
          ),
        ],
      ),
      child: (dataValue == null) ? Text('Data:\n') : Text('Data:\n$dataValue'),
    );
  }
}
