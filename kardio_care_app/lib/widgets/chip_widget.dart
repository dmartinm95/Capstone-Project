import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';

class ChipWidget extends StatefulWidget {
  final String chipName;

  ChipWidget({Key key, this.chipName}) : super(key: key);

  @override
  _ChipWidgetState createState() => _ChipWidgetState();
}

class _ChipWidgetState extends State<ChipWidget> {
  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(widget.chipName),
      labelStyle: TextStyle(
          color: KardioCareAppTheme.white,
          fontSize: 16.0,
          fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: KardioCareAppTheme.detailPurple,
    );
  }
}

