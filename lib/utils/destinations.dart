import 'package:amodeus_client/widgets/destination_wrapper.dart';
import 'package:flutter/material.dart';

import './navigator_destination.dart';
import '../screens/calendar.dart';
import '../screens/counter.dart';
import '../screens/login.dart';
import '../screens/settings.dart';
import '../widgets/adaptive_scaffold.dart';

final allDestinations = <NavigatorDestination>[
  NavigatorDestination(
    destination: AdaptiveScaffoldDestination(
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
    path: "/timetable",
    replace: true,
    key: GlobalKey<DestinationWrapperState>(),
  ),
  NavigatorDestination(
    destination: AdaptiveScaffoldDestination(
      body: Builder(builder: (context) => const CounterScreen()),
      title: "Оценки",
      icon: Icons.bookmark,
    ),
    path: "/marks",
    replace: true,
    key: GlobalKey<DestinationWrapperState>(),
  ),
  NavigatorDestination(
    destination: AdaptiveScaffoldDestination(
      body: Builder(builder: (context) => const SettingsScreen()),
      title: "Настройки",
      icon: Icons.settings,
    ),
    path: "/settings",
    key: GlobalKey<DestinationWrapperState>(),
  ),
];

final customDestinations = <String, WidgetBuilder>{
  "/login": (context) => const LoginScreen(),
};

final homeDestination = allDestinations[0];
