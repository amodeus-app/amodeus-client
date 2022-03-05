import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/misc.dart';
import '../utils/theme.dart';

class AdaptiveScaffoldDestination {
  final String title;
  final IconData icon;
  final Widget body;

  const AdaptiveScaffoldDestination({
    required this.title,
    required this.icon,
    required this.body,
  });
}

/// A widget that adapts to the current display size, displaying a [Drawer],
/// or [BottomNavigationBar]. Navigation destinations are defined in the [destinations] parameter.
class AdaptiveScaffold extends StatefulWidget {
  final List<Widget> actions;
  final int currentIndex;
  final List<AdaptiveScaffoldDestination> destinations;
  final FloatingActionButton? floatingActionButton;

  const AdaptiveScaffold({
    Key? key,
    this.actions = const [],
    this.currentIndex = 0,
    required this.destinations,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  _AdaptiveScaffoldState createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends State<AdaptiveScaffold> {
  final _stackKey = UniqueKey();
  var _i = 0;

  @override
  void initState() {
    _i = widget.currentIndex;
    super.initState();
  }

  IndexedStack _getStack() => IndexedStack(
        key: _stackKey,
        index: _i,
        children: widget.destinations.map((e) => e.body).toList(),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);

    // Show a Drawer
    if (isLargeScreen(context)) {
      return SafeArea(
        child: Row(
          children: [
            Drawer(
              child: Column(
                children: [
                  DrawerHeader(
                    child: Center(
                      child: Container(),
                    ),
                  ),
                  for (var d in widget.destinations)
                    ListTile(
                      leading: Icon(d.icon),
                      title: Text(d.title),
                      selected: widget.destinations.indexOf(d) == _i,
                      onTap: () => _destinationTapped(d),
                    ),
                ],
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: theme.isEffectivelyDark ? Colors.grey[800] : Colors.grey[300],
            ),
            Expanded(
              child: Scaffold(
                body: _getStack(),
              ),
            ),
          ],
        ),
      );
    }

    // Show a bottom app bar
    return SafeArea(
      child: Scaffold(
        body: _getStack(),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            ...widget.destinations.map(
              (d) => BottomNavigationBarItem(
                icon: Icon(d.icon),
                label: d.title,
              ),
            ),
          ],
          currentIndex: _i,
          onTap: (i) {
            if (i != _i) {
              _changeScreen(i);
            }
          },
          landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
        ),
      ),
    );
  }

  void _destinationTapped(AdaptiveScaffoldDestination destination) {
    var idx = widget.destinations.indexOf(destination);
    if (idx != _i) {
      _changeScreen(idx);
    }
  }

  void _changeScreen(int i) {
    setState(() {
      _i = i;
    });
  }
}
