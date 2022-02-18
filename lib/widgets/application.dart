import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './adaptive_scaffold.dart';
import './lock_overlay.dart';
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
          home: LockOverlay(
            mainScreen: AdaptiveScaffold(
              destinations: destinations,
            ),
          ),
        ),
      );
}
