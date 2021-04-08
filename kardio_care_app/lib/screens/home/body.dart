import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:kardio_care_app/constants/app_constants.dart';

import 'connect_disconnect_btns.dart';
import 'data_card.dart';
import 'ekg_chart.dart';
import 'device_status_text.dart';
import 'heart_rate_card.dart';

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
  bool isLoading = false;
  String statusMessage = "";
  BluetoothCharacteristic notifyCharacteristic;
  double incomingData;
  String displayData;
  BluetoothDevice bleDevice;

  // From the samples10.csv file, they pass in an array of 5000 elements
  // we could maybe try 2500 first
  PanTomkpins panTomkpins;
  int dataListSize = 500;
  List<double> incomingDataList = [for (int i = 0; i < 500; i += 1) 0.0];
  bool isFull = false;
  int index = 0;
  List<double> rRIntervalList;
  int heartRateValue;

  @override
  void initState() {
    super.initState();
    // scanForDevice();
    startScan();
    setState(() {
      isFull = false;
      index = 0;
    });
  }

  void showLoadingIndicator() {
    print('is loading...');
    setState(() {
      isLoading = true;
    });
  }

  void startScan() async {
    showLoadingIndicator();

    await scanForDevice();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> scanForDevice() async {
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
    showLoadingIndicator();

    print('waiting for scan...');
    await scanForDevice();
    print('done waiting for scan...');

    if (bleDevice == null) {
      setState(() {
        statusMessage = "Cannot find module";
        isLoading = false;
      });
      print('device is null');
      return;
    } else {
      print('device found, now attempting to connect');
      connectToDevice();
    }

    // setState(() {
    //   isLoading = false;
    // });
  }

  void pressDisconnectBtn() {
    showLoadingIndicator();

    print("Disconnect");
    if (bleDevice == null || notifyCharacteristic == null) {
      setState(() {
        statusMessage = "Check if device is turned ON";
        isLoading = false;
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
        // TODO: Replace "Kompression" with bleDevice.name
        statusMessage = "Kompression" + " connected!";
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
      try {
        notifyCharacteristic.write(utf8.encode(0.toString()));
      } catch (e) {
        print("Error observed when trying to send data");
      }
      bleDevice.disconnect();
      statusMessage = "Disconnected successfully";
      isConnected = false;
      bleDevice = null;
      isLoading = false;
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
    Future.delayed(const Duration(milliseconds: 2000), () {});
    notifyCharacteristic.value.listen((data) {
      setState(() {
        displayData = String.fromCharCodes(data);
        try {
          incomingData = int.parse(String.fromCharCodes(data)).toDouble();
        } catch (e) {
          print('Incorrect data format received');
        }
        // print("IS FULL: $isFull");

        // TODO: Uncomment line below when pan_tompkins.dart is fully integrated
        // addDataToList(incomingData);
      });
      // print(displayData);
    });

    setState(() {
      // TODO: Replace "Kompression" with bleDevice.name later on
      statusMessage = "Kompression" + " connected!";
      isConnected = true;
      isLoading = false;
      print("Connected!");
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

  // Pan-Tompkins stuff starts here
  // TODO: Need to work on integrating pan_tompkins into this file
  void addDataToList(double data) {
    if (!isFull) {
      setState(() {
        incomingDataList[index] = data;
        index++;
      });

      if (index == dataListSize) {
        setState(() {
          isFull = true;
        });
        print("Reached desired list size of 500 elements");

        print("Sending data to pan-tompkins class for calculations");

        PanTomkpins panTompkinsObject =
            PanTomkpins(incomingDataList, dataListSize);

        performPanTompkins(panTompkinsObject);

        setState(() {
          print("Clearing isFull flag to collect incoming data");
          isFull = false;
          index = 0;
        });
      }
    } else {
      print("isFull == true, cannot store incoming data");
    }
  }

  void performPanTompkins(PanTomkpins pan) async {
    print("Waiting for results from pan-tompkins");

    rRIntervalList = await pan.calculateRRInterval();

    print("Results returned: ${rRIntervalList.toString()}");

    calculateHeartRate();
  }

  void calculateHeartRate() {
    print("Calculating heart rate using RRIntervalList");
    int randomNumber = Random().nextInt(100) + 50;

    setState(() {
      heartRateValue = randomNumber;
    });
  }

  // Pan-Tompkins stuff ends here

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          ConnectDisconnectBtns(
            isLoading: isLoading,
            pressConnectBtn: () {
              pressConnectBtn();
            },
            pressDisconnectBtn: () {
              pressDisconnectBtn();
            },
          ),
          // TODO: Remove hardcoded "Kompression" value, replace with bleDevice.name
          DeviceStatusText(
            message: statusMessage,
            deviceName: (bleDevice == null) ? "" : "Kompression",
            isLoading: isLoading,
          ),
          EKGChart(dataValue: incomingData),
          HeartRateCard(dataValue: heartRateValue),
        ],
      ),
    );
  }
}

class PanTomkpins {
  List<double> dataList;
  int dataListSize;

  PanTomkpins(List<double> dataList, int dataListSize) {
    this.dataList = dataList;
    this.dataListSize = dataListSize;
  }

  Future<List<double>> calculateRRInterval() async {
    List<double> result = [1, 2, 1.4, 1.3, 2.1, 4.1];
    // Perfom Pan-Tompkins algorithm and return R-R interval based on the peaks found
    await Future.delayed(const Duration(seconds: 3), () {});
    return result;
  }
}
