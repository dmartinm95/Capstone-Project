import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:kardio_care_app/util/pan_tompkins.dart';
import 'package:scidart/numdart.dart';

// TODO: Loading animation while saving data

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
  bool doneRecording = false;
  bool isEkgDataFull = false;

  List<double> recordedHeartRateData = List.empty(growable: true);
  List<double> recordedHeartRateVarData = List.empty(growable: true);
  Map<DateTime, double> recordedHeartRateMap = {};
  Map<DateTime, double> recordedHeartRateVarMap = {};

  int currentHeartRate = 0;
  PanTomkpins panTompkinsInstance;

  StreamSubscription<List<int>> subscription;
  StreamSubscription<List<int>> currentLeadSubscription;

  DeviceScanner() {
    activeLeadIndex = 0;
    bleConnectionNotifier.value = null;
  }

  void dispose() {
    print("Disposing device scanner");
    subscription.cancel();
    currentLeadSubscription.cancel();
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
      activeLeadIndex = 0;
      await bleLeadCharacteristics[activeLeadIndex].setNotifyValue(true);
      bleConnectionNotifier.value = bleDevice;
      print("Connected");
      listenToStream(activeLeadIndex);
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
      subscription = bleAllLeadsCharacteristic.value.listen((event) {});
    }
  }

  // Start listing to stream data from module
  void listenToStream(int leadIndex) async {
    if (bleLeadCharacteristics[leadIndex] == null) {
      print(
          "Characteristic with UUID: ${bleCharacteristics[leadIndex].uuid.toString()} is NULL");
      return;
    }

    if (leadIndex == 0) {
      currentLeadSubscription =
          bleLeadCharacteristics[leadIndex].value.listen((data) {
        _decodeData(data);
      });
    } else if (leadIndex == 1) {
      currentLeadSubscription =
          bleLeadCharacteristics[leadIndex].value.listen((data) {
        _decodeData(data);
      });
    } else if (leadIndex == 2) {
      currentLeadSubscription =
          bleLeadCharacteristics[leadIndex].value.listen((data) {
        _decodeData(data);
      });
    } else if (leadIndex == 3) {
      currentLeadSubscription =
          bleLeadCharacteristics[leadIndex].value.listen((data) {
        _decodeData(data);
      });
    }
  }

  // Switch between all four leads in the Home screen
  void switchToStreamIndex(int leadIndex) async {
    if (activeLeadIndex == leadIndex) {
      print("Same index as before, do nothing");
      return;
    }

    try {
      if (bleLeadCharacteristics[activeLeadIndex].isNotifying) {
        await bleLeadCharacteristics[activeLeadIndex].setNotifyValue(false);
      }

      await bleLeadCharacteristics[leadIndex].setNotifyValue(true);

      activeLeadIndex = leadIndex;

      if (currentLeadSubscription != null) {
        currentLeadSubscription.cancel();
      }

      listenToStream(activeLeadIndex);
    } catch (e) {
      print(
          "Error while switching to stream at index $leadIndex: ${e.toString()}");

      // In case of error set notify to True on lead 0
      print("Reseting active lead index to 0");
      activeLeadIndex = 0;
      for (int i = 1; i < bleLeadCharacteristics.length; i++) {
        if (bleLeadCharacteristics[i].isNotifying) {
          await bleLeadCharacteristics[i].setNotifyValue(false);
        }
      }

      if (!bleLeadCharacteristics[activeLeadIndex].isNotifying) {
        await bleLeadCharacteristics[activeLeadIndex].setNotifyValue(true);
      }
    }
  }

  void listenToAllLeadsData() {
    if (bleAllLeadsCharacteristic == null) {
      print(
          "Characteristic with UUID: ${bleAllLeadsCharacteristic.uuid.toString()} is NULL");
      return;
    }

    subscription = bleAllLeadsCharacteristic.value.listen((data) {
      decodeAllLeadsData(data);
    });
  }

  void decodeAllLeadsData(List<int> data) {
    if (ekgDataBatchIndex >= batches) {
      print("At batch number $batches, already. Max reached");
      return;
    }

    if (ekgDataToStoreIndex >= ekgDataToStore[0].length) {
      print("Store Index: $ekgDataToStoreIndex");
      ekgDataBatchIndex++;
      ekgDataToStoreIndex = 0;

      print("Now filling Batch #$ekgDataBatchIndex");
    } else {
      try {
        int currLead = 0;

        for (int currByte = 0; currByte < 8; currByte += 2) {
          double value = (data[currByte] + 256 * data[currByte + 1]).toDouble();
          ekgDataToStore[ekgDataBatchIndex][ekgDataToStoreIndex][currLead] =
              value;

          if (currLead == 0) {
            int result = panTompkinsInstance.addRecordedData(value);
            if (result != 0) {
              currentHeartRate = result;
              recordedHeartRateData.add(result.toDouble());
              recordedHeartRateMap[DateTime.now()] = result.toDouble();

              recordedHeartRateVarData
                  .add(panTompkinsInstance.currentHeartRateVar);
              recordedHeartRateVarMap[DateTime.now()] =
                  panTompkinsInstance.currentHeartRateVar;
            }
          }

          currLead++;
        }

        ekgDataToStoreIndex++;
        currLead = 0;

        for (int currByte = 8; currByte < 16; currByte += 2) {
          double value = (data[currByte] + 256 * data[currByte + 1]).toDouble();
          ekgDataToStore[ekgDataBatchIndex][ekgDataToStoreIndex][currLead] =
              value;

          if (currLead == 0) {
            int result = panTompkinsInstance.addRecordedData(value);
            if (result != 0) {
              currentHeartRate = result;
              recordedHeartRateData.add(result.toDouble());
              recordedHeartRateMap[DateTime.now()] = result.toDouble();

              recordedHeartRateVarData
                  .add(panTompkinsInstance.currentHeartRateVar * 1000);
              recordedHeartRateVarMap[DateTime.now()] =
                  panTompkinsInstance.currentHeartRateVar * 1000;
            }
          }

          currLead++;
        }

        ekgDataToStoreIndex++;
      } catch (error) {
        print("Error while decoding all lead data: ${error.toString()}");
      }
    }
  }

  void switchToActiveLead() async {
    if (doneRecording) {
      return;
    }

    print("Waiting for 250 ms before switching");
    await Future.delayed(Duration(milliseconds: 250));

    try {
      await bleCharacteristics[activeLeadIndex].setNotifyValue(true);

      if (currentLeadSubscription != null) {
        currentLeadSubscription.cancel();
      }

      listenToStream(activeLeadIndex);

      print("Finished switch");
    } catch (e) {
      print("Error while switching to main lead: ${e.toString()}");

      // In case of error set notify to True on lead 0
      print("Reseting active lead index to 0");
      activeLeadIndex = 0;
      for (int i = 1; i < bleLeadCharacteristics.length; i++) {
        if (bleLeadCharacteristics[i].isNotifying) {
          await bleLeadCharacteristics[i].setNotifyValue(false);
        }
      }

      if (!bleLeadCharacteristics[activeLeadIndex].isNotifying) {
        await bleLeadCharacteristics[activeLeadIndex].setNotifyValue(true);
      }
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

    bleConnectionNotifier.value = null;
    print("Disconnected");
  }

  void connectToAllLeads(int numMinutes) async {
    if (subscription != null) {
      print("Subscription exists already!");
      subscription.cancel();
    }

    batches = (numMinutes * 60 * 400 / 4096).ceil();

    print("Number of batches required: $batches");

    ekgDataToStore = List.generate(batches,
        (_) => List.generate(4096, (_) => List.generate(12, (_) => 0.0)));

    ekgDataBatchIndex = 0;
    ekgDataToStoreIndex = 0;

    panTompkinsInstance = new PanTomkpins();

    // Clear maps and list for both HR and HRV values for each recording instance
    recordedHeartRateData = List.empty(growable: true);
    recordedHeartRateVarData = List.empty(growable: true);

    if (recordedHeartRateMap.isNotEmpty) {
      recordedHeartRateMap.clear();
    }

    if (recordedHeartRateVarData.isNotEmpty) {
      recordedHeartRateVarData.clear();
    }

    print(
        "Initial state: batchIndex = $ekgDataBatchIndex\t storeIndex = $ekgDataToStoreIndex");

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
    if (!bleAllLeadsCharacteristic.isNotifying) {
      await bleAllLeadsCharacteristic.setNotifyValue(true);
    }
    print("Done turning ON all leads");
  }

  Future turnOffNotifyAllLeads() async {
    if (bleAllLeadsCharacteristic.isNotifying) {
      await bleAllLeadsCharacteristic.setNotifyValue(false);
      print("Waiting for 250 ms");
      await Future.delayed(Duration(milliseconds: 250));
    }
  }

  Future turnOnActiveLead() async {
    await bleCharacteristics[activeLeadIndex].setNotifyValue(true);
  }
}
