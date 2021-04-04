import 'package:flutter/material.dart';
import 'package:kardio_care_app/constants/app_constants.dart';

class DeviceStatusText extends StatelessWidget {
  const DeviceStatusText({
    Key key,
    this.deviceName,
    this.message,
    this.isLoading,
  }) : super(key: key);

  final String message;
  final String deviceName;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        bottom: kDefaultPadding,
        top: kDefaultPadding / 3,
        left: kDefaultPadding * 0.5,
        right: kDefaultPadding * 0.5,
      ),
      child: Stack(
        children: [
          Container(
            // width: size.width * 0.85,
            padding: EdgeInsets.only(
              left: kDefaultPadding * 1.5,
              right: kDefaultPadding * 1.5,
            ),
            height: size.height * 0.05,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(36),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: (message == null || message.isEmpty)
                      ? (deviceName != "")
                          ? Text(
                              '$deviceName ready to connect !',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            )
                          : Text(
                              'Check if module is turned on',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            )
                      : Text(
                          '$message',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                ),
                (isLoading == null)
                    ? Container()
                    : (isLoading == true)
                        ? Container(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              value: null,
                              backgroundColor: kPrimaryColor.withOpacity(0.5),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white38),
                            ),
                          )
                        : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
