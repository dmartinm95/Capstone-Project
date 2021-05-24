import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';

class BlockRadioButton extends StatefulWidget {
  const BlockRadioButton(
      {Key key,
      this.buttonLabels,
      this.circleBorder,
      this.backgroundColor,
      this.callback})
      : super(key: key);

  final Function(int) callback;

  final List<String> buttonLabels; //= ['HRV', 'HR'];
  final bool circleBorder;
  final Color backgroundColor;

  @override
  _BlockRadioButtonState createState() => _BlockRadioButtonState();
}

class _BlockRadioButtonState extends State<BlockRadioButton> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            for (int i in Iterable<int>.generate(widget.buttonLabels.length))
              customRadio(widget.buttonLabels[i], i)
          ],
        ),
      ),
    );
  }

  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.callback(index);
  }

  Widget customRadio(String buttonText, int index) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: selectedIndex == index
            ? KardioCareAppTheme.detailGray
            : widget.backgroundColor,
        shape: widget.circleBorder
            ? CircleBorder()
            : RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      // child: Padding(
      // padding: const EdgeInsets.all(8.0),
      child: Text(
        buttonText,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: selectedIndex == index
              ? Colors.white
              : KardioCareAppTheme.detailGray,
        ),
      ),
      // ),
      onPressed: () => changeIndex(index),
    );
  }
}
