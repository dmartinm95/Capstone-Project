import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothFeature extends StatefulWidget {
  BluetoothFeature({Key key}) : super(key: key);

  // Get an instance of the Flutter Bluetooth plugin
  final FlutterBlue flutterBlue = FlutterBlue.instance;

  // Store the Bluetooth Devices
  final List<BluetoothDevice> devicesList = <BluetoothDevice>[];

  // Our target device's name
  final String deviceName = "DSD TECH";

  @override
  _BluetoothFeaureState createState() => _BluetoothFeaureState();
}

class _BluetoothFeaureState extends State<BluetoothFeature> {
  BluetoothDevice _targetDevice;
  List<BluetoothService> _services = <BluetoothService>[];
  bool _deviceConnected = false;
  double dataFromDevice;

  int writeLocation = 0;
  int currWriteBuffer = 0;

  List<double> buffer0 = [for (var i = 0; i < 750; i += 1) 0.0];
  List<double> buffer1 = [for (var i = 0; i < 750; i += 1) 0.0];

  @override
  void initState() {
    super.initState();
    scanForDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bluetooth Screen"),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Container(
                height: 50,
                width: double.infinity,
                color: Colors.greenAccent,
                child: Row(
                  children: [
                    Text('Ready to connect to: '),
                    (_targetDevice != null)
                        ? Text('${_targetDevice.name}')
                        : Text('Not found during scan'),
                  ],
                ),
              ),
              Container(
                height: 25,
                width: double.infinity,
                color: Colors.greenAccent,
                child: Row(
                  children: [
                    Text('Module state: '),
                    (_deviceConnected)
                        ? Text('Connected')
                        : Text('Disconnected'),
                  ],
                ),
              ),
            ],
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: Text('Connect'),
                  onPressed: () {
                    print('Connecting...');
                    connectToDevice();
                    print('Done connecting.');
                  },
                ),
                TextButton(
                  child: Text('Disconnect'),
                  onPressed: () {
                    print('Disconnecting...');
                    // TODO: Hard coded values for custom characteristic, change later
                    _services[2].characteristics[0].setNotifyValue(false);
                    disconnectFromDevice();
                    setState(() {
                      _deviceConnected = false;
                    });
                    print('Done disconnecting.');
                  },
                ),
              ],
            ),
          ),
          (_deviceConnected)
              ? Expanded(
                  child: Container(
                    color: Colors.lightGreenAccent,
                    child: _buildConnectDeviceView(),
                  ),
                )
              : Expanded(
                  child: Container(
                    color: Colors.lightGreenAccent,
                    width: double.infinity,
                    child: Text(
                      'Not yet connected',
                    ),
                  ),
                ),
          Expanded(
            child: Container(
              color: Colors.lightBlueAccent,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Real Time Data',
                  ),
                  Text(
                    dataFromDevice.toString(),
                  ),
                  Text('Buffer currently used for plotting data:'),
                  (currWriteBuffer == 0) ? Text('Buffer 0') : Text('Buffer 1'),
                  TextButton(
                    child: Text('Plot Data'),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => DetailsScreen(),
                      //   ),
                      // );
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListView _buildConnectDeviceView() {
    List<Container> containers = <Container>[];

    for (BluetoothService service in _services) {
      List<Widget> characteristicsWidget = <Widget>[];
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        print(characteristic.uuid.toString());
        characteristicsWidget.add(
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      characteristic.uuid.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    ..._buildReadWriteNotifyButton(characteristic),
                  ],
                ),
              ],
            ),
          ),
        );
      }

      containers.add(
        Container(
          child: ExpansionTile(
              title: Text(service.uuid.toString()),
              children: characteristicsWidget),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  List<ButtonTheme> _buildReadWriteNotifyButton(
      BluetoothCharacteristic characteristic) {
    List<ButtonTheme> buttons = <ButtonTheme>[];

    if (characteristic.properties.read) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ElevatedButton(
              child: Text('READ',
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onPressed: () {},
            ),
          ),
        ),
      );
    }

    if (characteristic.properties.write) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ElevatedButton(
              child: Text(
                'WRITE',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {},
            ),
          ),
        ),
      );
    }

    if (characteristic.properties.notify) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ElevatedButton(
              child: Text(
                'NOTIFY',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await characteristic
                    .setNotifyValue(!characteristic.isNotifying);

                characteristic.value.listen((value) {
                  print(new String.fromCharCodes(value));
                  setState(() {
                    dataFromDevice = (5 / 1024) *
                        int.parse(String.fromCharCodes(value)).toDouble();
                    if (currWriteBuffer == 0) {
                      buffer0[writeLocation] = dataFromDevice;
                    } else {
                      buffer1[writeLocation] = dataFromDevice;
                    }
                    writeLocation++;

                    if (writeLocation == buffer0.length) {
                      if (currWriteBuffer == 0) {
                        // We have data ready to plot, switch to the second buffer
                        currWriteBuffer = 1;
                        writeLocation = 0;
                        print('Drawing from buffer0...');
                      } else {
                        // Second buffer is now full,
                        currWriteBuffer = 0;
                        writeLocation = 0;
                        print('Drawing from buffer1...');
                      }
                    }
                  });
                });
              },
            ),
          ),
        ),
      );
    }

    return buttons;
  }

  void addDeviceToList(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }

  void scanForDevices() {
    if (_targetDevice != null) return;

    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        print('Connected Devices - ${device.name} found!');
        if (device.name == widget.deviceName) {
          print('Connected Devices - FOUND');
          _targetDevice = device;
        }
        addDeviceToList(device);
      }
    });

    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        print(
            'Scan Results - ${result.device.name} found! rssi: ${result.rssi}');
        if (result.device.name == widget.deviceName) {
          print('Scan Results - FOUND');
          _targetDevice = result.device;
        }
        addDeviceToList(result.device);
      }
    });
    widget.flutterBlue.startScan();
  }

  void connectToDevice() async {
    try {
      await _targetDevice.connect();
    } catch (e) {
      if (e.code != 'already_connected') {
        throw e;
      }
    } finally {
      _services = await _targetDevice.discoverServices();
    }
    setState(() {
      _deviceConnected = true;
      widget.flutterBlue.stopScan();
    });
  }

  void disconnectFromDevice() {
    setState(() {
      _targetDevice.disconnect();
    });
  }
}
