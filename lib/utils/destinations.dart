import 'package:flutter/material.dart';

import '../screens/calendar.dart';
import '../screens/settings.dart';
import '../widgets/adaptive_scaffold.dart';

final destinations = <AdaptiveScaffoldDestination>[
  const AdaptiveScaffoldDestination(
    title: "Расписание",
    icon: Icons.calendar_today,
    body: CalendarScreen(),
  ),
  /*const AdaptiveScaffoldDestination(
    title: "Оценки",
    icon: Icons.bookmark,
    body: MarksScreen(), // TODO (2022-02-20): implement
  ),*/
  const AdaptiveScaffoldDestination(
    title: "Настройки",
    icon: Icons.settings,
    body: SettingsScreen(),
  ),
];
