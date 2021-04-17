import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:kardio_care_app/constants/app_constants.dart';
import 'package:kardio_care_app/util/pan_tompkins.dart';
import 'package:scidart/numdart.dart';
import 'package:scidart/scidart.dart';

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

////////////////////////////////////
  double plottingData;
  double cleanData;
  double ewmaData;
  Array plottingDataList = Array([for (int i = 0; i < 1000; i += 1) 0.0]);

  Array buffer0 = Array([for (int i = 0; i < 2200; i += 1) 0.0]);
  Array buffer1 = Array([for (int i = 0; i < 2200; i += 1) 0.0]);
  Array filteredBuffer = Array([for (int i = 0; i < 2200; i += 1) 0.0]);
  Array filteredBuffer2 = Array([for (int i = 0; i < 2200; i += 1) 0.0]);
  Array ewmaBuffer = Array([for (int i = 0; i < 2200; i += 1) 0.0]);

  int buffer0Index = 0;
  int buffer1Index = 0;

  int plotIndex = 0;

  bool isBuffer0Full = false;
  bool isBuffer1Full = true;

////////////////////////////////////

  String displayData;
  BluetoothDevice bleDevice;

  // From the samples10.csv file, they pass in an array of 5000 elements
  // we could maybe try 2500 first
  PanTomkpins panTomkpins;
  int dataListSize = 500;
  // Array used for filtered data
  Array incomingDataList = Array([for (int i = 0; i < 500; i += 1) 0.0]);

  bool isFull = false;
  int index = 0;
  final int averageLength = 4;
  List<double> rRIntervalList;
  int heartRateValue;
  double filteredData;
  double averageValue = 0;
  double diffData;

  // Added Real Time filtering
  Ewma ewmaFilter = Ewma(0.2);

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
      displayData = String.fromCharCodes(data);
      try {
        incomingData = int.parse(String.fromCharCodes(data)).toDouble();
        buffer0[buffer0Index] = incomingData;

        buffer0Index++;
      } catch (e) {
        print('Incorrect data format received');
      }

      if (buffer0Index >= buffer0.length) {
        print("Buffer 0 full, sending data to Buffer 1....");
        isBuffer0Full = true;
        buffer0Index = 0;

        buffer1 = buffer0;
        double maxValue = arrayMax(buffer1);
        print("Max VALUE inside Buffer 1 = $maxValue");

        buffer1 = arrayDivisionToScalar(buffer1, maxValue);

        // This should filter out baseline wander at 0.67 Hz
        print("Performing lfilter on Buffer 1 data....");
        filteredBuffer = lfilter(
            Array([0.968979151360103, -1.93768355538075, 0.968979151360103]),
            Array([1, -1.93768355538075, 0.937958302720205]),
            buffer1);

        // This should filter out 60 Hz powerline noise
        print("Performing lfilter on filteredBuffer data....");
        filteredBuffer2 = lfilter(
            Array([0.110036498530389, -0.0138184978198193, 0.110036498530389]),
            Array([1, -0.0138184978198193, -0.779927002939223]),
            filteredBuffer);

        // panTomkpins = new PanTomkpins(filteredBuffer2, 250);

        // var pk = panTomkpins.performPanTompkins(filteredBuffer2);

        // print("PRINTING PEAKS FOUND: ");
        // print(pk);

      }

      plottingData = filteredBuffer[buffer0Index];
      cleanData = filteredBuffer2[buffer0Index];
      ewmaData = ewmaFilter.filter(cleanData);

      setState(() {});

      // plottingDataList[plottingDataIndex] = incomingData;
      // plottingDataIndex++;

      // if (plottingDataIndex >= 1000) {
      //   isPlottingDataFull = true;
      //   plottingDataIndex = 0;
      // }

      // if (isPlottingDataFull) {
      //   plottingData = plottingDataList[]
      // }

      // filteredData = ewmaFilter.filter(incomingData);

      // addDataToList(filteredData);

      // diffData = incomingData - filteredData;

      // setState(() {});
      // print('Filtered DATA: $filteredData');

      // incomingData = filteredData;
      // print("IS FULL: $isFull");

      // TODO: Uncomment line below when pan_tompkins.dart is fully integrated
      // addDataToList(incomingData);
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

  void averageForPlot() {}

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
      incomingDataList[index] = data;
      index++;

      if (index != 0 && index % averageLength == 0) {
        setState(() {
          averageValue = mean(
              incomingDataList.getRangeArray(index - averageLength, index));
        });
      }
      if (index == dataListSize) {
        setState(() {
          isFull = true;
        });
        print("Reached desired list size of 500 elements");

        print("Sending data to pan-tompkins class for calculations");

        // PanTomkpins panTompkinsObject =
        //     PanTomkpins(incomingDataList, );

        // performPanTompkins(panTompkinsObject);

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

    // rRIntervalList = await pan.calculateRRInterval();

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
          // EKGChart(dataValue: averageValue),
          EKGChart(
            dataValue: incomingData,
            minValue: 0.0,
            maxValue: 1024.0,
          ),
          EKGChart(
            dataValue: plottingData,
            minValue: 0.0,
            maxValue: 1.0,
          ),
          EKGChart(
            dataValue: cleanData,
            minValue: 0.0,
            maxValue: 1.0,
          ),
          EKGChart(
            dataValue: ewmaData,
            minValue: 0.0,
            maxValue: 1.0,
          ),
          HeartRateCard(dataValue: heartRateValue),
        ],
      ),
    );
  }
}

// class PanTomkpins {
//   List<double> dataList;
//   int dataListSize;

//   PanTomkpins(List<double> dataList, int dataListSize) {
//     this.dataList = dataList;
//     this.dataListSize = dataListSize;
//   }

//   Future<List<double>> calculateRRInterval() async {
//     List<double> result = [1, 2, 1.4, 1.3, 2.1, 4.1];
//     // Perfom Pan-Tompkins algorithm and return R-R interval based on the peaks found
//     await Future.delayed(const Duration(seconds: 3), () {});
//     return result;
//   }
// }

class Ewma {
  double alpha;
  double output;
  bool hasInitial = false;

  Ewma(double alpha) {
    this.alpha = alpha;
  }

  double filter(double input) {
    if (hasInitial) {
      output = alpha * (input - output) + output;
    } else {
      output = input;
      hasInitial = true;
    }
    return output;
  }
}
