import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:kardio_care_app/constants/app_constants.dart';

class DeviceScanner with ChangeNotifier {
  // ignore: close_sinks
  StreamController<BluetoothDevice> _streamController = new StreamController();
  Stream<BluetoothDevice> get bluetoothDevice => _streamController.stream;

  BluetoothDevice bleDevice;
  bool isConnected = false;
  bool foundDevice = false;
  List<BluetoothService> bleServices;
  List<BluetoothCharacteristic> bleCharacteristics;
  BluetoothService bleCustomService;
  BluetoothCharacteristic bleLeadOneCharacteristic;

  int testData = 0;

  int leadOneData = 0;
  Timer _timer;

  DeviceScanner() {
    // subscribeToScanEvents();
    // _timer = new Timer.periodic(const Duration(seconds: 10), startScan);
  }

  void startScan(Timer timer) {
    FlutterBlue.instance.startScan(timeout: Duration(seconds: 2));
  }

  void dispose() {
    super.dispose();
    _timer.cancel();
    _streamController.close();
  }

  Future<void> subscribeToScanEvents() async {
    await FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
    FlutterBlue.instance.scanResults.listen(
      (scanResults) {
        for (ScanResult scanResult in scanResults) {
          if (scanResult.device.name.toString() == "Kompression") {
            bleDevice = scanResult.device;

            FlutterBlue.instance.stopScan();
          }
        }
      },
    );
    return;
  }

  Future<void> connectToModule() async {
    try {
      await bleDevice.connect();
      await _getCustomService();
      await _getCustomCharacteristic();
      await bleLeadOneCharacteristic.setNotifyValue(true);
      print("Connected");
      _streamController.add(bleDevice);
      isConnected = true;

      listenToStream();
    } catch (error) {
      print("Error observed while attempting to connect: ${error.toString()}");
    }
    return;
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
      print("Could not find lead one characteristic or is null");
      return;
    }

    bleLeadOneCharacteristic.value.listen((data) {
      notifyListeners();
      try {
        leadOneData = int.parse(String.fromCharCodes(data));
        print(leadOneData);
      } catch (error) {
        print("Error: ${error.toString()}");
      }
    }, onError: (error) {
      print(error);
    }, onDone: () {
      print("Stream closed!");
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

  void updateTestData() {
    testData++;
    notifyListeners();
  }
}
