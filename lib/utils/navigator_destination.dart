import 'package:flutter/widgets.dart';

import '../widgets/adaptive_scaffold.dart';

@immutable
class NavigatorDestination {
  final AdaptiveScaffoldDestination destination;
  final String path;
  final bool replace;
  final Key? key;

  const NavigatorDestination({
    required this.destination,
    required this.path,
    this.replace = false,
    this.key,
  });
}
