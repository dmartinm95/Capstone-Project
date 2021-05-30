import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/screens/home/bluetooth_off_screen.dart';
import 'package:kardio_care_app/screens/home/home.dart';
import 'package:kardio_care_app/main_dashboard.dart';
import 'package:kardio_care_app/screens/ekg_recording/ekg_results.dart';
import 'package:kardio_care_app/screens/ekg_recording/ekg_recording.dart';
import 'package:kardio_care_app/screens/ekg_recording/start_recording.dart';
import 'package:kardio_care_app/screens/rhythm_analysis/view_rhythm_event.dart';
import 'package:kardio_care_app/util/pan_tompkins.dart';
import 'package:provider/provider.dart';
import 'package:kardio_care_app/util/device_scanner.dart';
import 'package:kardio_care_app/screens/rhythm_analysis/all_recordings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DeviceScanner>(
            create: (context) => DeviceScanner()),
        ChangeNotifierProvider<PanTomkpins>(create: (context) => PanTomkpins()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // initialRoute: '/main_dashboard',
        routes: {
          '/main_dashboard': (context) => MainDashboard(),
          '/start_recording': (context) => StartRecording(),
          '/ekg_recording': (context) => EKGRecording(),
          '/ekg_results': (context) => EKGResults(),
          '/all_recordings': (context) => AllRecordings(),
          '/view_rhythm_event': (context) => ViewRhythmEvent(),
        },
        theme: ThemeData(
          scaffoldBackgroundColor: KardioCareAppTheme.background,
          primarySwatch: Colors.blue,
          // scaffoldBackgroundColor: kBackgroundColor,
          //   primaryColor: kPrimaryColor,
          //   textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
          //   visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.off) {
              return BluetoothOffScreen(state: state);
            }
            return MainDashboard();
          },
        ),
      ),
    );
  }
}
