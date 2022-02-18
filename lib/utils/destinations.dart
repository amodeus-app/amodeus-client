import 'package:flutter/material.dart';

import '../screens/calendar.dart';
import '../screens/counter.dart';
import '../screens/settings.dart';
import '../widgets/adaptive_scaffold.dart';

final destinations = <AdaptiveScaffoldDestination>[
  AdaptiveScaffoldDestination(
    title: "Расписание",
    icon: Icons.calendar_today,
    body: Builder(builder: (context) => const CalendarScreen()),
    actions: <Widget>[
      const IconButton(
        onPressed: null,
        icon: Icon(Icons.search),
        tooltip: "Поиск",
      ),
    ],
  ),
  AdaptiveScaffoldDestination(
    body: Builder(builder: (context) => const CounterScreen()),
    title: "Оценки",
    icon: Icons.bookmark,
  ),
  AdaptiveScaffoldDestination(
    body: Builder(builder: (context) => const SettingsScreen()),
    title: "Настройки",
    icon: Icons.settings,
  ),
];
