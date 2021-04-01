import 'package:flutter/material.dart';
import 'package:kardio_care_app/constants/app_constants.dart';

class DeviceStatusText extends StatelessWidget {
  const DeviceStatusText({
    Key key,
    this.deviceName,
    this.isConnected,
  }) : super(key: key);

  final String deviceName;
  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin:
          EdgeInsets.only(bottom: kDefaultPadding, top: kDefaultPadding / 3),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: kDefaultPadding * 0.25,
              left: kDefaultPadding,
              right: kDefaultPadding,
            ),
            height: size.height * 0.05,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(36),
              ),
            ),
            child: (isConnected)
                ? Text(
                    '$deviceName connected',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )
                : Text(
                    'Not yet connected',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
