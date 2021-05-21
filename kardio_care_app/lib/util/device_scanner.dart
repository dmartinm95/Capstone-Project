import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DeviceScanner with ChangeNotifier {
  // Arduino Nano 33 BLE details
  static const String SERVICE_UUID = "202d3e06-252d-40bd-8dc6-0b7bfe15b99f";
  static const String LEAD_ONE_CHAR_UUID =
      "4ccf588c-c839-4ec7-9954-94611cc77895";
  static const String DEVICE_NAME = "Kompression";

  // Stream controller for checking when a device is connected
  StreamController<BluetoothDevice> _streamController = new StreamController();
  Stream<BluetoothDevice> get bluetoothDevice => _streamController.stream;

  // BLE module details
  BluetoothDevice bleDevice;
  List<BluetoothService> bleServices;
  List<BluetoothCharacteristic> bleCharacteristics;
  BluetoothService bleCustomService;
  BluetoothCharacteristic bleLeadOneCharacteristic;

  // Store real-time incoming data
  int leadOneData = 0;

  DeviceScanner();

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

      listenToStream();
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

  // Find our custom characteristic
  Future<void> _getCustomCharacteristic() async {
    bleCharacteristics = bleCustomService.characteristics;

    bleLeadOneCharacteristic = bleCharacteristics.firstWhere((characteristic) =>
        characteristic.uuid.toString() == LEAD_ONE_CHAR_UUID);

    print(
        "Found Characteristic! - uuid: ${bleLeadOneCharacteristic.uuid.toString()}");
  }

  // Start listing to stream data from module
  void listenToStream() {
    if (bleLeadOneCharacteristic == null) {
      print("Could not find lead one characteristic or is null");
      return;
    }
    _streamController.sink.add(bleDevice);

    bleLeadOneCharacteristic.value.listen((data) {
      _decodeData(data);
    }, onError: (error) {
      print(error);
    }, onDone: () {
      print("Stream closed!");
    });
  }

  // Helper method to parse the incoming data
  void _decodeData(List<int> data) {
    try {
      leadOneData = int.parse(String.fromCharCodes(data));
      notifyListeners();
    } catch (error) {
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
