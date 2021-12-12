import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import './adaptive_scaffold.dart';
import '../utils/destinations.dart';

class _NavigatorHelper {
  bool _needsPush = true;
  final String route;
  final RoutePredicate _wrapped;

  _NavigatorHelper(this.route) : _wrapped = ModalRoute.withName(route);

  bool get needsPush => _needsPush;

  bool call(Route route) {
    final r = _wrapped(route);
    if (r) {
      _needsPush = false;
    }
    return r;
  }
}

class DestinationWrapper extends StatefulWidget {
  final int initialIndex;

  const DestinationWrapper({
    Key? key,
    required this.initialIndex,
  }) : super(key: key);

  @override
  DestinationWrapperState createState() => DestinationWrapperState();
}

class DestinationWrapperState extends State<DestinationWrapper> {
  int _currentIndex = 0;

  void _navigateToIndex(int i) {
    setState(() {
      _currentIndex = i;
    });
    final destination = allDestinations[i];
    if (destination.replace) {
      final h = _NavigatorHelper(destination.path);
      Navigator.popUntil(context, h);
      if (h.needsPush) {
        // We emptied entire route stack, it's time to push our route back here.
        Navigator.pushNamed(context, destination.path);
      }
    } else {
      Navigator.pushNamed(context, destination.path);
    }
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      currentIndex: _currentIndex,
      destinations: allDestinations
          .where((e) => e.destination.icon != null)
          .map((e) => e.destination)
          .toList(growable: false),
      onNavigationIndexChange: _navigateToIndex,
      actions: const <Widget>[],
    );
  }
}
