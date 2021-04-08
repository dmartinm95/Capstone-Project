import 'package:flutter/material.dart';
import 'package:kardio_care_app/constants/app_constants.dart';

class ConnectDisconnectBtns extends StatelessWidget {
  const ConnectDisconnectBtns({
    Key key,
    this.pressConnectBtn,
    this.pressDisconnectBtn,
    this.isLoading,
  }) : super(key: key);

  final Function pressConnectBtn;
  final Function pressDisconnectBtn;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Row(
        children: [
          SizedBox(
            width: size.width / 2,
            height: 50,
            child: BtnWidget(
              isLoading: isLoading,
              pressDisconnectBtn: pressConnectBtn,
              name: "Connect",
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 50,
              child: BtnWidget(
                isLoading: isLoading,
                pressDisconnectBtn: pressDisconnectBtn,
                name: "Disconnect",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BtnWidget extends StatelessWidget {
  const BtnWidget({
    Key key,
    @required this.isLoading,
    @required this.pressDisconnectBtn,
    this.name,
  }) : super(key: key);

  final bool isLoading;
  final Function pressDisconnectBtn;
  final String name;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (isLoading == null || isLoading) ? null : pressDisconnectBtn,
      style: TextButton.styleFrom(
        backgroundColor: (isLoading == null || isLoading)
            ? kPrimaryColor.withOpacity(0.9)
            : kPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ),
      child: Text(
        name,
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
