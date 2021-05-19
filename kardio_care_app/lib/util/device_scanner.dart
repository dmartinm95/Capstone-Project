import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:kardio_care_app/constants/app_constants.dart';

class DeviceScanner with ChangeNotifier {
  BluetoothDevice bleDevice;
  bool isConnected = false;
  List<BluetoothService> bleServices;
  List<BluetoothCharacteristic> bleCharacteristics;
  BluetoothService bleCustomService;
  BluetoothCharacteristic bleLeadOneCharacteristic;

  int leadOneData;

  DeviceScanner() {
    _subscribeToScanEvents();
    FlutterBlue.instance.startScan(timeout: Duration(seconds: 10));
  }

  void startScan(Timer timer) {
    FlutterBlue.instance.startScan(timeout: Duration(seconds: 2));
  }

  void dispose() {
    super.dispose();
  }

  void _subscribeToScanEvents() {
    FlutterBlue.instance.scanResults.listen((scanResults) {
      for (ScanResult scanResult in scanResults) {
        if (scanResult.device.name.toString() == "Kompression") {
          bleDevice = scanResult.device;
          FlutterBlue.instance.stopScan();
        }
        print(scanResult.device.name);
      }
    });
  }

  Future<void> connectToModule() async {
    try {
      await bleDevice.connect();
      await _getCustomService();
      await _getCustomCharacteristic();
      await bleLeadOneCharacteristic.setNotifyValue(true);
      print("Connected");
      isConnected = true;

      listenToStream();
    } catch (error) {
      print("Error observed while attempting to connect: ${error.toString()}");
    } finally {}
  }

  Future<void> _getCustomService() async {
    bleServices = await bleDevice.discoverServices();

    bleCustomService = bleServices
        .firstWhere((service) => service.uuid.toString() == kServiceUUID);

    print("Found Service! - uuid: ${bleCustomService.uuid.toString()}");
  }

  Future<void> _getCustomCharacteristic() async {
    bleCharacteristics = bleCustomService.characteristics;

    bleLeadOneCharacteristic = bleCharacteristics.firstWhere(
        (characteristic) => characteristic.uuid.toString() == kLeadOneCharUUID);

    print(
        "Found Characteristic! - uuid: ${bleLeadOneCharacteristic.uuid.toString()}");
  }

  void listenToStream() {
    if (bleLeadOneCharacteristic == null) {
      return;
    }

    bleLeadOneCharacteristic.value.listen((data) {
      decodeData(data);
    })
      ..onDone(() {
        print("Disconnected BLE Module.");
      })
      ..onError((error) {
        print("Error: ${error.toString()}");
      });
  }

  void decodeData(List<int> data) {
    try {
      leadOneData = int.parse(String.fromCharCodes(data));
      print(leadOneData);
      notifyListeners();
    } catch (error) {
      print("Error: ${error.toString()}");
    }
  }

  void disconnectFromModule() {
    bleDevice.disconnect();
    isConnected = false;
    print("Disconnected");
  }
}
