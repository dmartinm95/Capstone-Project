import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'dart:io' show Platform;

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);
  final BluetoothState state;

  final double fontSize = 14;
  final double iconSize = 125;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bluetooth Disabled",
          style: KardioCareAppTheme.screenTitleText,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: KardioCareAppTheme.background,
      body: Platform.isIOS
          ? IosInstructions(
              state: state,
              fontSize: fontSize,
              iconSize: iconSize,
            )
          : AndroidInstructions(
              state: state,
              fontSize: fontSize,
              iconSize: iconSize,
            ),
    );
  }
}

class AndroidInstructions extends StatelessWidget {
  const AndroidInstructions({
    Key key,
    @required this.iconSize,
    @required this.state,
    @required this.fontSize,
  }) : super(key: key);

  final double iconSize;
  final BluetoothState state;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            Icons.bluetooth_disabled,
            size: iconSize,
            color: KardioCareAppTheme.actionBlue,
          ),
          Text(
            "Bluetooth Adapter is ${state.toString().substring(15)}",
            style:
                TextStyle(color: KardioCareAppTheme.detailGray, fontSize: 19),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: RichText(
              text: TextSpan(
                text:
                    "In order to activate Kompression, and to connect them to your Android device, Bluetooth must be turned ",
                style: TextStyle(
                  color: KardioCareAppTheme.detailGray,
                  fontSize: fontSize,
                  height: 1.25,
                ),
                children: [
                  TextSpan(
                    text: "On",
                    style: TextStyle(
                      color: KardioCareAppTheme.detailGray,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            child: RichText(
              text: TextSpan(
                text: "1. Tap on ",
                style: TextStyle(
                  color: KardioCareAppTheme.detailGray,
                  fontSize: fontSize,
                  height: 2,
                ),
                children: [
                  TextSpan(
                    text: "Settings",
                    style: TextStyle(
                        color: KardioCareAppTheme.detailGray,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: " on your Android device.\n",
                    style: TextStyle(
                        color: KardioCareAppTheme.detailGray,
                        fontSize: fontSize),
                  ),
                  TextSpan(
                    text: "2. Look for ",
                    style: TextStyle(
                      color: KardioCareAppTheme.detailGray,
                      fontSize: fontSize,
                    ),
                  ),
                  TextSpan(
                    text: "Bluetooth",
                    style: TextStyle(
                      color: KardioCareAppTheme.detailGray,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        " or the Bluetooth symbol in your settings and tap it.\n",
                    style: TextStyle(
                      color: KardioCareAppTheme.detailGray,
                      fontSize: fontSize,
                    ),
                  ),
                  TextSpan(
                    text:
                        "3. There should be an option to enable. Please tap or swipe on it so that is in the ",
                    style: TextStyle(
                      color: KardioCareAppTheme.detailGray,
                      fontSize: fontSize,
                    ),
                  ),
                  TextSpan(
                    text: "on",
                    style: TextStyle(
                      color: KardioCareAppTheme.detailGray,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " position.\n",
                    style: TextStyle(
                      color: KardioCareAppTheme.detailGray,
                      fontSize: fontSize,
                    ),
                  ),
                  TextSpan(
                    text: "4. Close out of Settings and you're done!",
                    style: TextStyle(
                      color: KardioCareAppTheme.detailGray,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IosInstructions extends StatelessWidget {
  const IosInstructions({
    Key key,
    @required this.state,
    @required this.fontSize,
    this.iconSize,
  }) : super(key: key);

  final BluetoothState state;
  final double fontSize;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            Icons.bluetooth_disabled,
            size: iconSize,
            color: KardioCareAppTheme.actionBlue,
          ),
          Text(
            "Bluetooth Adapter is ${state.toString().substring(15)}",
            style:
                TextStyle(color: KardioCareAppTheme.detailGray, fontSize: 19),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: RichText(
              text: TextSpan(
                text:
                    "In order to activate Kompression and connect them to your iOS device, set the ",
                style: TextStyle(
                  color: KardioCareAppTheme.detailGray,
                  fontSize: fontSize,
                  height: 1.25,
                ),
                children: [
                  TextSpan(
                    text: "OS level permissions",
                    style: TextStyle(
                        color: KardioCareAppTheme.detailGray,
                        fontSize: fontSize,
                        decoration: TextDecoration.underline),
                  ),
                  TextSpan(
                    text: " for Bluetooth to ",
                    style: TextStyle(
                        color: KardioCareAppTheme.detailGray,
                        fontSize: fontSize),
                  ),
                  TextSpan(
                    text: "On",
                    style: TextStyle(
                      color: KardioCareAppTheme.detailGray,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            child: RichText(
              text: TextSpan(
                text: "1. Tap on ",
                style: TextStyle(
                  color: KardioCareAppTheme.detailGray,
                  fontSize: fontSize,
                  height: 2,
                ),
                children: [
                  TextSpan(
                    text: "Settings",
                    style: TextStyle(
                        color: KardioCareAppTheme.detailGray,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: " on your iPhone\n",
                    style: TextStyle(
                        color: KardioCareAppTheme.detailGray,
                        fontSize: fontSize),
                  ),
                  TextSpan(
                    text: "2. Select ",
                    style: TextStyle(
                      color: KardioCareAppTheme.detailGray,
                      fontSize: fontSize,
                    ),
                  ),
                  TextSpan(
                    text: "General\n",
                    style: TextStyle(
                      color: KardioCareAppTheme.detailGray,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "3. Tap on ",
                    style: TextStyle(
                      color: KardioCareAppTheme.detailGray,
                      fontSize: fontSize,
                    ),
                  ),
                  TextSpan(
                    text: "Bluetooth\n",
                    style: TextStyle(
                      color: KardioCareAppTheme.detailGray,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "4. Toggle Bluetooth to ",
                    style: TextStyle(
                      color: KardioCareAppTheme.detailGray,
                      fontSize: fontSize,
                    ),
                  ),
                  TextSpan(
                    text: "On",
                    style: TextStyle(
                      color: KardioCareAppTheme.detailGray,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
