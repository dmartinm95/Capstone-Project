import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:kardio_care_app/constants/app_constants.dart';

import 'connect_disconnect_btns.dart';
import 'data_card.dart';
import 'device_status_text.dart';

class Body extends StatefulWidget {
  Body({Key key}) : super(key: key);

  final FlutterBlue flutterBlue = FlutterBlue.instance;

  final String deviceName = "DSD TECH";

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isConnected = false;
  bool isFound = false;
  String statusMessage = "";
  BluetoothCharacteristic notifyCharacteristic;
  double incomingData;
  String displayData;
  BluetoothDevice bleDevice;

  @override
  void initState() {
    super.initState();
    scanForDevice();
  }

  Future<void> scanForDevice() async {
    // TODO: Need to handle case when two scans happen at the same time, use try catch
    await widget.flutterBlue.startScan(timeout: Duration(seconds: 4));
    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        if (device.name == widget.deviceName) {
          setState(() {
            bleDevice = device;
          });
        }
      }
    });

    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        if (result.device.name == widget.deviceName) {
          setState(() {
            bleDevice = result.device;
          });
        }
      }
    });
  }

  void pressConnectBtn() async {
    print('waiting for scan...');
    await scanForDevice();
    print('done waiting for scan...');
    if (bleDevice == null) {
      setState(() {
        statusMessage = "Cannot find module";
      });
      print('device is null');
      return;
    } else {
      print('device found, now attempting to connect');
      connectToDevice();
    }
  }

  void pressDisconnectBtn() {
    print("Disconnect");
    if (bleDevice == null) {
      setState(() {
        statusMessage = "Check if device is turned ON";
      });
    } else {
      setState(() {
        statusMessage = "Disconnecting...";
      });
      disconnectFromDevice();
    }
  }

  void connectToDevice() async {
    try {
      await bleDevice.connect();
    } catch (e) {
      if (e.code != 'already_connected') {
        setState(() {
          statusMessage = "Already connected";
        });
        throw e;
      }
    } finally {
      setState(() {
        statusMessage = bleDevice.name + " connected!";
        isConnected = true;
      });
      print("Connected!");
    }

    if (bleDevice != null) {
      List<BluetoothService> services = await bleDevice.discoverServices();

      await findCustomCharacteristic(services);

      if (notifyCharacteristic != null) {
        print('found char');
      } else {
        print('not found char');
      }
    }

    getIncomingData();
  }

  void disconnectFromDevice() {
    setState(() {
      notifyCharacteristic.write(utf8.encode(0.toString()));
      bleDevice.disconnect();
      statusMessage = "Disconnected successfully";
      isConnected = false;
      bleDevice = null;
    });
    print("Disconnected!");
  }

  Future<void> findCustomCharacteristic(List<BluetoothService> services) async {
    services.forEach((service) {
      List<BluetoothCharacteristic> characteristics = service.characteristics;
      for (BluetoothCharacteristic characteristic in characteristics) {
        if (characteristic.properties.notify == true) {
          print("Found characteristic");
          setState(() {
            notifyCharacteristic = characteristic;
          });
        }
      }
    });
  }

  void getIncomingData() {
    turnOnNotify();
    notifyCharacteristic.value.listen((data) {
      setState(() {
        displayData = String.fromCharCodes(data);
        incomingData = int.parse(String.fromCharCodes(data)).toDouble();
      });
      // print(displayData);
    });
  }

  void turnOnNotify() async {
    if (notifyCharacteristic != null) {
      await notifyCharacteristic.setNotifyValue(true);
      notifyCharacteristic.write(utf8.encode(1.toString()));
    } else {
      print("NotifyCharacteristic is NULL");
    }
  }

  void turnOffNotify() async {
    if (notifyCharacteristic != null) {
      await notifyCharacteristic.setNotifyValue(false);
    } else {
      print("NotifyCharacteristic is NULL");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          ConnectDisconnectBtns(
            pressConnectBtn: () {
              pressConnectBtn();
            },
            pressDisconnectBtn: () {
              pressDisconnectBtn();
            },
          ),
          DeviceStatusText(
            message: statusMessage,
            deviceName: (bleDevice == null) ? "" : bleDevice.name,
          ),
          DataCard(dataValue: incomingData),
        ],
      ),
    );
  }
}
