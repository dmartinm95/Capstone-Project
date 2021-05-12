import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:kardio_care_app/constants/app_constants.dart';
import 'package:scidart/numdart.dart';
import 'package:scidart/scidart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'connect_disconnect_btns.dart';
import 'device_status_text.dart';

final data = ValueNotifier<double>(0.0);

class Body extends StatefulWidget {
  Body({Key key}) : super(key: key);

  final FlutterBlue flutterBlue = FlutterBlue.instance;

  final String deviceName =
      "Kompression"; // Might need to change depending on the name of the bluetooth module being used

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // Variables for BLE device
  bool isConnected = false;
  bool isLoading = false;
  String statusMessage = "";
  BluetoothCharacteristic notifyCharacteristic;
  BluetoothDevice bleDevice;

  // Variables for buffering incoming data
  Stream<List<int>> myStream;
  double incomingData;
  double downsampleData;
  bool isReady = false;
  Array incomingDatabuffer = Array([for (int i = 0; i < 3500; i += 1) 0.0]);
  int dataBufferIndex = 0;

  Array buffer0 = Array([for (int i = 0; i < 2500; i += 1) 0.0]);
  Array buffer1 = Array([for (int i = 0; i < 2500; i += 1) 0.0]);
  Array filteredBuffer = Array([for (int i = 0; i < 2500; i += 1) 0.0]);
  Array filteredBuffer2 = Array([for (int i = 0; i < 2500; i += 1) 0.0]);
  int buffer0Index = 0;
  int buffer1Index = 0;
  double cleanData = 0;

  // Variables for plotting
  int plotIndex = 0;
  double upCounter = 0;
  Timer timer;
  List<_ChartData> chartData = <_ChartData>[];
  int dataCount = 0;
  ChartSeriesController chartSeriesController;

  @override
  void initState() {
    super.initState();
    startScan();
    timer = Timer.periodic(const Duration(milliseconds: 5), updateDataSource);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void showLoadingIndicator() {
    print('Is loading...');
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
        print(device.name);
        if (device.name == widget.deviceName) {
          setState(() {
            bleDevice = device;
          });
        }
      }
    });

    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        print(result.device.name);
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
        isLoading = false;
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
      turnOnNotify();
    }

    dataBufferIndex = 0;
    dataCount = 0;

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
      isReady = false;
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
            myStream = notifyCharacteristic.value;
          });
        }
      }
    });
  }

  double parseIncomingData(List<int> toDecode) {
    double result = 0.0;
    try {
      result = int.parse(String.fromCharCodes(toDecode)).toDouble();
      // print(result);
    } catch (e) {
      print("Error observed while parsing data: ${e.toString()}");
    }
    return result;
  }

  void getIncomingData() {
    // Future.delayed(const Duration(milliseconds: 2000), () {});

    List<int> decode = [];
    setState(() {
      statusMessage = "Filling buffer";
    });
    showLoadingIndicator();

    myStream.listen((data) {
      // print(data.first);
      for (int element in data) {
        if (element != 204) {
          decode.add(element);
        } else {
          incomingData = parseIncomingData(decode);

          if (dataBufferIndex < incomingDatabuffer.length) {
            incomingDatabuffer[dataBufferIndex] = incomingData;
            dataBufferIndex++;
          } else {
            dataBufferIndex = 0;
          }

          if (dataBufferIndex > incomingDatabuffer.length - 100) {
            if (!isReady) {
              isReady = true;
              setState(() {
                isLoading = false;
                statusMessage = "Kompression" + " connected!";
              });
            }
          }

          // buffer0[buffer0Index] = incomingData;
          // buffer0Index++;

          // if (buffer0Index >= buffer0.length) {
          //   print("Buffer0 is now full, filtering data");
          //   if (!isReady) {
          //     isReady = true;
          //     setState(() {
          //       isLoading = false;
          //       statusMessage = "Kompression" + " connected!";
          //     });
          //   }
          //   buffer0Index = 0;
          //   buffer1 = buffer0;

          //   double maxValue = arrayMax(buffer1);
          //   buffer1 = arrayDivisionToScalar(buffer1, maxValue);

          //   filteredBuffer = lfilter(
          //       Array(
          //           [0.968979151360103, -1.93768355538075, 0.968979151360103]),
          //       Array([1, -1.93768355538075, 0.937958302720205]),
          //       buffer1);

          //   filteredBuffer2 = lfilter(
          //       Array([
          //         0.110036498530389,
          //         -0.0138184978198193,
          //         0.110036498530389
          //       ]),
          //       Array([1, -0.0138184978198193, -0.779927002939223]),
          //       buffer1);
          //   isReady = true;
          // }

          // setState(() {});
          decode.clear();
        }
      }
    }, onDone: () {
      print("Task Done");
    }, onError: (error) {
      print("Some error");
    });
  }

  void turnOnNotify() async {
    if (notifyCharacteristic != null) {
      await notifyCharacteristic.setNotifyValue(true);
      // notifyCharacteristic.write(utf8.encode(1.toString()));
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
          buildLiveLineChart(0, 1024.0),
          // EKGChart(
          //   dataValue: data.value,
          //   minValue: 0.0,
          //   maxValue: 1000.0,
          // ),
        ],
      ),
    );
  }

  Widget buildLiveLineChart(double min, double max) {
    return AspectRatio(
      aspectRatio: 1.25,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: kBackgroundColor,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding * 0.25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Center(
                    child: Text(
                      'Lead I Data',
                      style: TextStyle(
                          color:
                              Colors.green.shade600, //const Color(0xff0f4a3c),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: kDefaultPadding),
                      child: SfCartesianChart(
                          enableAxisAnimation: false,
                          plotAreaBorderWidth: 0,
                          primaryXAxis: NumericAxis(isVisible: false),
                          primaryYAxis: NumericAxis(
                              isVisible: true,
                              isInversed: false,
                              axisLine: AxisLine(width: 0),
                              majorTickLines: MajorTickLines(size: 0),
                              minimum: min,
                              maximum: max),
                          series: <LineSeries<_ChartData, int>>[
                            LineSeries<_ChartData, int>(
                              onRendererCreated:
                                  (ChartSeriesController controller) {
                                chartSeriesController = controller;
                              },
                              dataSource: chartData,
                              width: 1.5,
                              color:
                                  kEKGLineColor, // color: const Color.fromRGBO(192, 108, 132, 1),
                              xValueMapper: (_ChartData sales, _) =>
                                  sales.index,
                              yValueMapper: (_ChartData sales, _) =>
                                  sales.value,
                              animationDuration: 0,
                            )
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateDataSource(Timer timer) {
    if (isReady) {
      chartData.add(_ChartData(dataCount, updateCounter()));
      if (chartData.length == 500) {
        chartData.removeAt(0);
        chartSeriesController?.updateDataSource(
          addedDataIndexes: <int>[chartData.length - 1],
          removedDataIndexes: <int>[0],
        );
      } else {
        chartSeriesController?.updateDataSource(
          addedDataIndexes: <int>[chartData.length - 1],
        );
      }
      dataCount++;
    }
  }

  double updateCounter() {
    if (plotIndex < incomingDatabuffer.length) {
      upCounter = incomingDatabuffer[plotIndex];
      // print(
      //     "Plot Index: $plotIndex \t Data buffer: ${incomingDatabuffer[plotIndex]} \t Filtered buffer: ${filteredBuffer[plotIndex]}");
      plotIndex++;
    } else {
      plotIndex = 0;
    }
    return upCounter;
  }
}

/// Private class for storing the chart series data points.
class _ChartData {
  _ChartData(this.index, this.value);
  final int index;
  final double value;
}

class Ewma {
  Ewma(this.alpha, this.output);

  double alpha;
  double output;
  bool hasInitial = false;

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
