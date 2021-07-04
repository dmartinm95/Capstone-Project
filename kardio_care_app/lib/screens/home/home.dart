import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/screens/home/disconnect_btn.dart';
import 'package:kardio_care_app/screens/home/heart_rate_and_oxygen_saturation.dart';
import 'package:kardio_care_app/screens/home/search_connect_btn.dart';
import 'package:kardio_care_app/screens/home/show_ekg_lead_data.dart';
import 'package:kardio_care_app/screens/home/welcome_msg.dart';
import 'package:kardio_care_app/util/pan_tompkins.dart';
import 'package:provider/provider.dart';
import 'package:kardio_care_app/util/device_scanner.dart';

class Home extends StatefulWidget {
  Home({Key key, this.deviceScannerProvider}) : super(key: key);

  final DeviceScanner deviceScannerProvider;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    print("Home screen init");

    if (widget.deviceScannerProvider.bleConnectionNotifier.value != null) {
      print("Turning ON notify from active lead");
      if (!widget
          .deviceScannerProvider
          .bleLeadCharacteristics[widget.deviceScannerProvider.activeLeadIndex]
          .isNotifying) {
        widget.deviceScannerProvider.turnOnActiveLead();
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    print("Home screen disposed");

    if (widget.deviceScannerProvider.bleConnectionNotifier.value != null) {
      print("Turning OFF notify from active lead");
      if (widget
          .deviceScannerProvider
          .bleLeadCharacteristics[widget.deviceScannerProvider.activeLeadIndex]
          .isNotifying) {
        widget.deviceScannerProvider.turnOffActiveLead();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final panTompkinsProvider =
        Provider.of<PanTomkpins>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: KardioCareAppTheme.screenTitleText,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          ValueListenableBuilder(
            valueListenable: widget.deviceScannerProvider.bleConnectionNotifier,
            builder: (context, value, child) {
              if (value == null) {
                panTompkinsProvider.resetCurrentHeartRate();
                return Container();
              }
              return AppBarDisconnectBtn(
                  deviceScannerProvider: widget.deviceScannerProvider);
            },
          ),
        ],
      ),
      body: SizedBox(
        height: size.height,
        child: Column(
          children: <Widget>[
            // WelcomeMessage(size: size),
            ValueListenableBuilder(
              valueListenable:
                  widget.deviceScannerProvider.bleConnectionNotifier,
              builder: (context, value, child) {
                if (value == null) {
                  return SearchAndConnectBtn(
                    size: size,
                    deviceScannerProvider: widget.deviceScannerProvider,
                  );
                }
                return ShowEKGLeadData(
                  size: size,
                  deviceScannerProvider: widget.deviceScannerProvider,
                );
              },
            ),
            HeartRateAndOxygenSaturation(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.10,
            )
          ],
        ),
      ),
    );
  }
}
