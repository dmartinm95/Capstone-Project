import 'package:flutter/material.dart';
import 'package:kardio_care_app/constants/app_constants.dart';

class DeviceStatusText extends StatelessWidget {
  const DeviceStatusText({
    Key key,
    this.deviceName,
    this.message,
  }) : super(key: key);

  final String message;
  final String deviceName;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin:
          EdgeInsets.only(bottom: kDefaultPadding, top: kDefaultPadding / 3),
      child: Stack(
        children: [
          Container(
            // width: size.width * 0.85,
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
            child: (message == null || message.isEmpty)
                ? (deviceName != "")
                    ? Text(
                        '$deviceName ready to connect !',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )
                    : Text(
                        'Check if module is turned on',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )
                : Text(
                    '$message',
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
