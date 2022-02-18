import 'package:flutter/material.dart';

import '../screens/lockscreen.dart';

class LockOverlay extends StatefulWidget {
  final Widget mainScreen;

  const LockOverlay({
    Key? key,
    required this.mainScreen,
  }) : super(key: key);

  @override
  _LockOverlayState createState() => _LockOverlayState();
}

class _LockOverlayState extends State<LockOverlay> {
  var _i = 0;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _i,
      children: [
        LockScreen(onUnlocked: () {
          setState(() {
            _i = 1;
          });
        }),
        widget.mainScreen,
      ],
    );
  }
}
