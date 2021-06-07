import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/screens/heart_calendar/heart_calendar.dart';
import 'package:kardio_care_app/screens/profile/profile.dart';
import 'package:kardio_care_app/screens/rhythm_analysis/rhythm_analysis.dart';
import 'package:kardio_care_app/screens/home/home.dart';
import 'package:kardio_care_app/util/blurry_message_alert.dart';
import 'package:kardio_care_app/util/device_scanner.dart';
import 'package:provider/provider.dart';

class MainDashboard extends StatefulWidget {
  @override
  _MainDashboardState createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  // to track currently selected screen
  int currentScreenIndex = 0;

  final List<Widget> screens = [
    Home(),
    HeartCalendar(),
    RhythmAnalysis(),
    Profile(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Home();

  @override
  Widget build(BuildContext context) {
    final deviceScannerProvider =
        Provider.of<DeviceScanner>(context, listen: false);
    return Scaffold(
      extendBody: true,
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: KardioCareAppTheme.actionBlue,
        child: Icon(
          Icons.add,
          size: 40,
        ),
        onPressed: () {
          if (deviceScannerProvider.bleDevice == null) {
            showAlertDialog(context);
          } else {
            Navigator.pushNamed(context, '/start_recording');
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 7,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                iconSize: 35,
                icon: Icon(
                  Icons.home,
                  color: currentScreenIndex == 0 ? Colors.black : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    currentScreen = Home();
                    currentScreenIndex = 0;
                  });
                },
                splashRadius: 1,
              ),
              IconButton(
                iconSize: 30,
                icon: Icon(
                  Icons.calendar_today,
                  color: currentScreenIndex == 1 ? Colors.black : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    currentScreen = HeartCalendar();
                    currentScreenIndex = 1;
                  });
                },
                splashRadius: 1,
              ),
              Container(
                // convert to sizedBox ??
                width: MediaQuery.of(context).size.width * 0.20,
              ),
              IconButton(
                iconSize: 35,
                icon: Icon(
                  Icons.favorite,
                  color: currentScreenIndex == 2 ? Colors.black : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    currentScreen = RhythmAnalysis();
                    currentScreenIndex = 2;
                  });
                },
                splashRadius: 1,
              ),
              IconButton(
                iconSize: 35,
                icon: Icon(
                  Icons.person,
                  color: currentScreenIndex == 3 ? Colors.black : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    currentScreen = Profile();
                    currentScreenIndex = 3;
                  });
                },
                splashRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  BlurryMessageDialog message = BlurryMessageDialog(
    "Device not connected",
    "Please connect device\nbefore starting a recording.",
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return message;
    },
  );
}
