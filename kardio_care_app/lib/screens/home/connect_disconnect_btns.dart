import 'package:flutter/material.dart';
import 'package:kardio_care_app/constants/app_constants.dart';

class ConnectDisconnectBtns extends StatelessWidget {
  const ConnectDisconnectBtns({
    Key key,
    this.pressConnectBtn,
    this.pressDisconnectBtn,
  }) : super(key: key);

  final Function pressConnectBtn;
  final Function pressDisconnectBtn;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Row(
        children: [
          SizedBox(
            width: size.width / 2,
            height: 50,
            child: TextButton(
              onPressed: pressConnectBtn,
              style: TextButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                  ),
                ),
              ),
              child: Text(
                "Connect",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 50,
              child: TextButton(
                onPressed: pressDisconnectBtn,
                style: TextButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                ),
                child: Text(
                  "Disconnect",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
