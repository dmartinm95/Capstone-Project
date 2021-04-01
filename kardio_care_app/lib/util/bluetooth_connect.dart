import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothConnect extends StatefulWidget {
  BluetoothConnect({Key key}) : super(key: key);

  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final String deviceName = "DSD Tech";

  @override
  _BluetoothConnectState createState() => _BluetoothConnectState();
}

class _BluetoothConnectState extends State<BluetoothConnect> {
  bool isConnected = false;
  BluetoothDevice connectedDevice;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Row(
      children: [
        SizedBox(
          width: size.width / 2,
          height: 50,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
            child: Text(
              "Connect",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        )
      ],
    );
  }
}
