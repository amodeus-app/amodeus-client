import 'package:amodeus_client/utils/update_checker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
        LockScreen(onUnlocked: () async {
          setState(() {
            _i = 1;
          });
          final newerVersion = await getNewerVersion();
          if (newerVersion != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Доступно обновление для приложения"),
                action: SnackBarAction(
                  label: "СКАЧАТЬ",
                  onPressed: () async => await launch(
                    "https://github.com/evgfilim1/amodeus-client/releases/tag/$newerVersion",
                  ),
                ),
              ),
            );
          }
        }),
        widget.mainScreen,
      ],
    );
  }
}
