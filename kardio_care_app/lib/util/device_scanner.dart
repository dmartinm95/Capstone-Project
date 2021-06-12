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
  static const String LEAD_THREE_CHAR_UUID =
      "44ab8765-80b6-442f-8953-f18e3375549c";
  static const String LEAD_V1_CHAR_UUID =
      "f34748fb-c879-49f6-9719-aea577d5d182";
  static const String ALL_LEADS_CHAR_UUID =
      "a0855912-29ea-4b12-a704-c813bdeb351b";

  static const String DEVICE_NAME = "Kompression";
  static const int SAMPLES_LENGTH = 10;
  static const int BYTES_TO_RECEIVE = 20;

  ValueNotifier<BluetoothDevice> bleConnectionNotifier =
      ValueNotifier<BluetoothDevice>(null);

  // BLE module details
  BluetoothDevice bleDevice;
  List<BluetoothService> bleServices;
  List<BluetoothCharacteristic> bleCharacteristics;
  BluetoothService bleCustomService;
  BluetoothCharacteristic bleLeadOneCharacteristic;
  BluetoothCharacteristic bleLeadTwoCharacteristic;
  BluetoothCharacteristic bleLeadThreeCharacteristic;
  BluetoothCharacteristic bleLeadV1Characteristic;
  BluetoothCharacteristic bleAllLeadsCharacteristic;

  List<BluetoothCharacteristic> bleLeadCharacteristics = List.filled(4, null);
  int activeLeadIndex = 0;

  // Store real-time incoming data
  int leadOneData = 0;
  List<int> leadDataList = List.filled(SAMPLES_LENGTH, 0);
  List<int> allLeadDataList = List.filled(4, 0);

  List<List<List<double>>> ekgDataToStore;
  int ekgDataToStoreIndex = 0;
  int ekgDataBatchIndex = 0;
  int batches = 0;

  DeviceScanner() {
    activeLeadIndex = 0;
    bleConnectionNotifier.value = null;
  }

  void dispose() {
    super.dispose();
  }

  // Start searching for bluetooth devices nearby
  Future<void> startScan() async {
    try {
      await FlutterBlue.instance.startScan(timeout: Duration(seconds: 5));
    } catch (e) {
      print("Error while startin scan: ${e.toString()}");
    }
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
      bleConnectionNotifier.value = bleDevice;

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

    bleLeadThreeCharacteristic = bleCharacteristics.firstWhere(
        (characteristic) =>
            characteristic.uuid.toString() == LEAD_THREE_CHAR_UUID);

    bleLeadV1Characteristic = bleCharacteristics.firstWhere((characteristic) =>
        characteristic.uuid.toString() == LEAD_V1_CHAR_UUID);

    bleAllLeadsCharacteristic = bleCharacteristics.firstWhere(
        (characteristic) =>
            characteristic.uuid.toString() == ALL_LEADS_CHAR_UUID);

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
    if (bleLeadThreeCharacteristic != null) {
      bleLeadCharacteristics[2] = bleLeadThreeCharacteristic;
      print(
          "Found Characteristic! - uuid: ${bleLeadThreeCharacteristic.uuid.toString()}");
    }
    if (bleLeadV1Characteristic != null) {
      bleLeadCharacteristics[3] = bleLeadV1Characteristic;
      print(
          "Found Characteristic! - uuid: ${bleLeadV1Characteristic.uuid.toString()}");
    }
    if (bleAllLeadsCharacteristic != null) {
      print(
          "Found Characteristic! - uuid: ${bleAllLeadsCharacteristic.uuid.toString()}");
    }
  }

  // Start listing to stream data from module
  void listenToStream(int leadIndex) async {
    if (bleLeadCharacteristics[leadIndex] == null) {
      print(
          "Characteristic with UUID: ${bleCharacteristics[leadIndex].uuid.toString()} is NULL");
      return;
    }
    activeLeadIndex = leadIndex;

    if (leadIndex == 0) {
      bleLeadCharacteristics[leadIndex].value.listen((data) {
        _decodeData(data);
      });
    } else if (leadIndex == 1) {
      bleLeadCharacteristics[leadIndex].value.listen((data) {
        _decodeData(data);
      });
    } else if (leadIndex == 2) {
      bleLeadCharacteristics[leadIndex].value.listen((data) {
        _decodeData(data);
      });
    } else if (leadIndex == 3) {
      bleLeadCharacteristics[leadIndex].value.listen((data) {
        _decodeData(data);
      });
    }
  }

  void listenToAllLeadsData() async {
    if (bleAllLeadsCharacteristic == null) {
      print(
          "Characteristic with UUID: ${bleAllLeadsCharacteristic.uuid.toString()} is NULL");
      return;
    }

    bleAllLeadsCharacteristic.value.listen((data) {
      decodeAllLeadsData(data);
    });
  }

  void decodeAllLeadsData(List<int> data) {
    if (ekgDataBatchIndex >= batches) {
      return;
    }
    if (ekgDataToStoreIndex >= ekgDataToStore[0].length) {
      ekgDataBatchIndex++;
      ekgDataToStoreIndex = 0;
      print("Batch #$ekgDataBatchIndex");
    }
    try {
      int leadOne = data[0] + 256 * data[1];
      int leadTwo = data[2] + 256 * data[3];
      int leadThree = data[4] + 256 * data[5];
      int leadFour = data[6] + 256 * data[7];

      ekgDataToStore[ekgDataBatchIndex][ekgDataToStoreIndex][0] =
          leadOne.toDouble();

      ekgDataToStore[ekgDataBatchIndex][ekgDataToStoreIndex][1] =
          leadTwo.toDouble();

      ekgDataToStore[ekgDataBatchIndex][ekgDataToStoreIndex][2] =
          leadThree.toDouble();

      ekgDataToStore[ekgDataBatchIndex][ekgDataToStoreIndex][3] =
          leadFour.toDouble();

      ekgDataToStoreIndex++;
    } catch (error) {
      print("Error while decoding all lead data: ${error.toString()}");
    }
  }

  Future switchToMainLead() async {
    try {
      await turnOffNotifyAllLeads();
      await turnOnMainLead();
      await Future.delayed(Duration(seconds: 1));
      listenToStream(0);
    } catch (e) {
      print("Error while switching to main lead: ${e.toString()}");
    }
  }

  void switchToStreamIndex(int leadIndex) async {
    // if (bleAllLeadsCharacteristic.isNotifying) {
    //   await turnOffNotifyAllLeads();
    // }

    if (activeLeadIndex == leadIndex) {
      // if (!bleLeadCharacteristics[activeLeadIndex].isNotifying) {
      //   await bleLeadCharacteristics[activeLeadIndex].setNotifyValue(true);
      //   return;
      // }
      return;
    }

    try {
      if (bleLeadCharacteristics[activeLeadIndex].isNotifying) {
        await bleLeadCharacteristics[activeLeadIndex].setNotifyValue(false);
      }
      await bleLeadCharacteristics[leadIndex].setNotifyValue(true);

      activeLeadIndex = leadIndex;
    } catch (e) {
      print("Error while stopping current stream: ${e.toString()}");
    }
  }

  // Helper method to parse the incoming data
  void _decodeData(List<int> data) {
    try {
      int j = 0;
      for (int i = 0; i < data.length; i += 2) {
        int dataToAdd = data[i] + 256 * data[i + 1];
        leadDataList[j] = dataToAdd;
        j++;
        notifyListeners();
      }
    } catch (error) {
      print(leadDataList.toString());
      print("Error: ${error.toString()}");
    }
  }

  // Disconnect from module
  void disconnectFromModule() {
    if (bleDevice == null) return;

    bleDevice.disconnect();

    bleConnectionNotifier.value = null;
    print("Disconnected");
  }

  Future connectToAllLeads(int numMinutes) async {
    batches = (numMinutes * 60 * 400 / 4096).ceil();

    print("Number of batches required: $batches");

    // List.filled(batches, List.filled(4096, List.filled(12, 0)));

    ekgDataToStore = List.generate(batches,
        (_) => List.generate(4096, (_) => List.generate(12, (_) => 0.0)));

    print(
        "Initial state: batchIndex = $ekgDataBatchIndex\t storeIndex = $ekgDataToStoreIndex");
    // ekgDataBatchIndex = 0;
    // ekgDataToStoreIndex = 0;

    await turnOffActiveLead();
    await turnOnNotifyAllLeads();
    listenToAllLeadsData();
  }

  Future turnOffActiveLead() async {
    print("Setting active lead: $activeLeadIndex to false");
    if (bleCharacteristics[activeLeadIndex].isNotifying) {
      await bleCharacteristics[activeLeadIndex].setNotifyValue(false);
    }
    print("Done turning off active lead");
  }

  Future turnOnNotifyAllLeads() async {
    print("Turning ON all leads");
    await bleAllLeadsCharacteristic.setNotifyValue(true);
    print("Done turning ON all leads");
  }

  Future turnOffNotifyAllLeads() async {
    await bleAllLeadsCharacteristic.setNotifyValue(false);
  }

  Future turnOnMainLead() async {
    await bleCharacteristics[0].setNotifyValue(true);
  }
}
