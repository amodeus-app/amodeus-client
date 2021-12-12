import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './destination_wrapper.dart';
import '../screens/lockscreen.dart';
import '../utils/destinations.dart';
import '../utils/theme.dart';

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
          title: 'amodeus_client',
          themeMode: theme.themeMode,
          theme: ThemeNotifier.lightTheme,
          darkTheme: ThemeNotifier.darkTheme,
          // FIXME if possible: state of widgets is not saved between routes
          routes: {
            for (var e in allDestinations)
              e.path: (context) => DestinationWrapper(
                    key: e.key,
                    initialIndex: allDestinations.indexOf(e),
                  ),
            ...customDestinations,
            "/": (context) => const LockScreen(),
          },
        ),
      );
}
