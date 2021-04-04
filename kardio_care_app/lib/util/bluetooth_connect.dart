import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothConnect extends StatefulWidget {
  BluetoothConnect({Key key}) : super(key: key);

  final FlutterBlue flutterBlue = FlutterBlue.instance;
  @override
  _BluetoothConnectState createState() => _BluetoothConnectState();
}

class _BluetoothConnectState extends State<BluetoothConnect> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void initState() {
    super.initState();
  }
}
