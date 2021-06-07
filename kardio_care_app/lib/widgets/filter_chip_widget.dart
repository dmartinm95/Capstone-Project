import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';


class FilterChipWidget extends StatefulWidget {
  final String chipName;

  FilterChipWidget({Key key, this.chipName}) : super(key: key);

  @override
  _FilterChipWidgetState createState() => _FilterChipWidgetState();
}

class _FilterChipWidgetState extends State<FilterChipWidget> {
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipName),
      labelStyle: TextStyle(
          color: KardioCareAppTheme.white,
          fontSize: 16.0,
          fontWeight: FontWeight.w500),
      selected: _isSelected,
      checkmarkColor: KardioCareAppTheme.detailGray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: KardioCareAppTheme.actionBlue,
      onSelected: (isSelected) {
        setState(() {
          _isSelected = isSelected;
        });
      },
      selectedColor: KardioCareAppTheme.detailRed,
    );
  }
}
