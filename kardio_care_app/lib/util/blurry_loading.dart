import 'dart:ui';

import 'package:flutter/material.dart';

class BlurryLoading extends StatelessWidget {
  BlurryLoading();
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
              strokeWidth: 10,
              backgroundColor: Colors.transparent,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 100,
          ),
          // Text(
          //   'Saving...',
          //   style: TextStyle(
          //     color: Colors.white,
          //   ),
          // )
        ],
      ),
    );
  }
}
