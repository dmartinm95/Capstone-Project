import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:rxdart/rxdart.dart';

class DeviceScanner with ChangeNotifier {
  // Arduino Nano 33 BLE details
  static const String SERVICE_UUID = "202d3e06-252d-40bd-8dc6-0b7bfe15b99f";
  static const String LEAD_ONE_CHAR_UUID =
      "4ccf588c-c839-4ec7-9954-94611cc77895";
  static const String LEAD_TWO_CHAR_UUID =
      "7c90374c-9246-4fa2-b396-299d83992ac6";
  static const String DEVICE_NAME = "Kompression";
  static const int SAMPLES_LENGTH = 10;
  static const int BYTES_TO_RECEIVE = 20;

  // Use BehaviourSubject from rxdart library, which stores the last value emitted
  // and sends it to any new subscriber, this helps remember the connection state
  // when switching between the different screens
  final _streamController = BehaviorSubject<BluetoothDevice>();

  // Stream controller for checking when a device is connected
  Stream<BluetoothDevice> get bluetoothDevice => _streamController.stream;

  // BLE module details
  BluetoothDevice bleDevice;
  List<BluetoothService> bleServices;
  List<BluetoothCharacteristic> bleCharacteristics;
  BluetoothService bleCustomService;
  BluetoothCharacteristic bleLeadOneCharacteristic;
  BluetoothCharacteristic bleLeadTwoCharacteristic;

  List<BluetoothCharacteristic> bleLeadCharacteristics = List.filled(4, null);
  int _prevLeadIndex = 0;
  int activeLeadIndex = 0;

  // Store real-time incoming data
  int leadOneData = 0;
  List<int> leadDataList = List.filled(SAMPLES_LENGTH, 0);

  DeviceScanner() {
    _prevLeadIndex = 0;
  }

  void dispose() {
    super.dispose();
    _streamController.close();
  }

  // Start searching for bluetooth devices nearby
  Future<void> startScan() async {
    await FlutterBlue.instance.startScan(timeout: Duration(seconds: 5));
  }

  // Go through scan results and find our device
  Future<BluetoothDevice> subscribeToScanEvents() async {
    // Check unpaired devices
    FlutterBlue.instance.scanResults.listen(
      (scanResults) {
        for (ScanResult scanResult in scanResults) {
          if (scanResult.device.name.toString() == DEVICE_NAME) {
            print("Device found from scan");
            FlutterBlue.instance.stopScan();
            bleDevice = scanResult.device;
            return bleDevice;
          }
        }
      },
    );

    // Check paired devices
    FlutterBlue.instance.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        if (device.name.toString() == DEVICE_NAME) {
          print("Device found from connected devices");
          FlutterBlue.instance.stopScan();
          bleDevice = device;
          return bleDevice;
        }
      }
    });

    return null;
  }

  // Steps to connect to our BLE module and get incoming data
  Future<bool> connectToModule() async {
    try {
      await startScan();
      await subscribeToScanEvents();
      print("Connecting");
      await bleDevice.connect();
      print("Getting services");
      await _getCustomService();
      print("Getting characteristics");
      await _getCustomCharacteristic();
      print("Setting notify to true");
      await bleLeadOneCharacteristic.setNotifyValue(true);
      print("Connected");
      _streamController.add(bleDevice);

      listenToStream(0);
      print("Listening to stream");
      return true;
    } catch (error) {
      print("Error observed while attempting to connect: ${error.toString()}");
      return false;
    }
  }

  // Find our custom service
  Future<void> _getCustomService() async {
    bleServices = await bleDevice.discoverServices();

    bleCustomService = bleServices
        .firstWhere((service) => service.uuid.toString() == SERVICE_UUID);

    print("Found Service! - uuid: ${bleCustomService.uuid.toString()}");
  }

  // Find our custom characteristics
  Future<void> _getCustomCharacteristic() async {
    bleCharacteristics = bleCustomService.characteristics;

    bleLeadOneCharacteristic = bleCharacteristics.firstWhere((characteristic) =>
        characteristic.uuid.toString() == LEAD_ONE_CHAR_UUID);

    bleLeadTwoCharacteristic = bleCharacteristics.firstWhere((characteristic) =>
        characteristic.uuid.toString() == LEAD_TWO_CHAR_UUID);

    if (bleLeadOneCharacteristic != null) {
      bleLeadCharacteristics[0] = bleLeadOneCharacteristic;
      print(
          "Found Characteristic! - uuid: ${bleLeadOneCharacteristic.uuid.toString()}");
    }
    if (bleLeadTwoCharacteristic != null) {
      bleLeadCharacteristics[1] = bleLeadTwoCharacteristic;
      print(
          "Found Characteristic! - uuid: ${bleLeadTwoCharacteristic.uuid.toString()}");
    }
  }

  // Start listing to stream data from module
  void listenToStream(int leadIndex) async {
    if (bleLeadCharacteristics[leadIndex] == null) {
      print(
          "Characteristic with UUID: ${bleCharacteristics[leadIndex].uuid.toString()} is NULL");
      return;
    }
    _prevLeadIndex = leadIndex;

    if (leadIndex == 0) {
      bleLeadCharacteristics[leadIndex].value.listen((data) {
        _decodeData(data);
      });
    } else if (leadIndex == 1) {
      bleLeadCharacteristics[leadIndex].value.listen((data) {
        _decodeData(data);
      });
    }

    // _currentStreamSubscription =
    //     bleLeadCharacteristics[leadIndex].value.listen((data) {
    //   print("Raw data: $data");
    //   _decodeData(data);
    // }, onError: (error) {
    //   print(error);
    // }, onDone: () {
    //   print("Stream closed!");
    // });
  }

  void stopCurrentStream(int leadIndex) async {
    if (leadIndex == _prevLeadIndex) {
      return;
    }

    await bleLeadCharacteristics[_prevLeadIndex].setNotifyValue(false);

    await bleLeadCharacteristics[leadIndex].setNotifyValue(true);

    activeLeadIndex = leadIndex;
  }

  // Helper method to parse the incoming data
  void _decodeData(List<int> data) {
    try {
      int j = 0;
      for (int i = 0; i < BYTES_TO_RECEIVE; i += 2) {
        leadDataList[j] = data[i] + 256 * data[i + 1];
        // print("Lead data: ${leadDataList[j]}");
        j++;
      }
      notifyListeners();
    } catch (error) {
      print(leadDataList.toString());
      print("Error: ${error.toString()}");
    }
  }

  // Disconnect from module
  void disconnectFromModule() {
    if (bleDevice == null) return;

    bleDevice.disconnect();

    _streamController.sink.add(null);
    print("Disconnected");
  }
}
