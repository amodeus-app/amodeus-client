import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

import './adaptive_scaffold.dart';
import './lock_overlay.dart';
import '../utils/destinations.dart';
import '../utils/theme.dart';

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
          title: 'AModeus',
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            SfGlobalLocalizations.delegate,
          ],
          supportedLocales: const <Locale>[
            Locale('ru'),
          ],
          themeMode: theme.themeMode,
          theme: ThemeNotifier.lightTheme,
          darkTheme: ThemeNotifier.darkTheme,
          debugShowCheckedModeBanner: false,
          home: LockOverlay(
            mainScreen: AdaptiveScaffold(
              destinations: destinations,
            ),
          ),
        ),
      );
}
