import 'package:flutter/material.dart';
import 'package:kardio_care_app/util/device_scanner.dart';

class SearchAndConnectBtn extends StatefulWidget {
  const SearchAndConnectBtn({
    Key key,
    @required this.size,
    this.deviceScannerProvider,
  }) : super(key: key);

  final Size size;
  final DeviceScanner deviceScannerProvider;

  @override
  _SearchAndConnectBtnState createState() => _SearchAndConnectBtnState();
}

class _SearchAndConnectBtnState extends State<SearchAndConnectBtn> {
  bool buttonEnabled = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 0,
      child: Container(
        constraints: BoxConstraints.expand(
          width: widget.size.width,
          height: 200,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xffeeee00),
          border: Border.all(color: Colors.yellow, width: 5),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: !isLoading
            ? SizedBox.expand(
                child: TextButton(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Kompression"),
                      Text("Click here to search and connect"),
                      Icon(
                        Icons.bluetooth_audio,
                        size: 100,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                  onPressed: pressBtn,
                ),
              )
            : CircularProgressIndicator(),
      ),
    );
  }

  void pressBtn() {
    setState(() {
      buttonEnabled = false;
      isLoading = true;
    });

    widget.deviceScannerProvider.connectToModule().then((value) {
      if (value) {
        print("Device connected successfully");
        setState(() {
          buttonEnabled = value;
          isLoading = false;
        });
      }
    });
  }
}
