import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:kardio_care_app/constants/app_constants.dart';

import 'connect_disconnect_btns.dart';
import 'data_card.dart';
import 'device_status_text.dart';

class Body extends StatelessWidget {
  const Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          ConnectDisconnectBtns(),
          DeviceStatusText(deviceName: "DSD Tech", isConnected: true),
          DataCard(dataValue: 5.12345),
        ],
      ),
    );
  }
}
