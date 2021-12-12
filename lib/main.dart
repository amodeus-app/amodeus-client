import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './utils/theme.dart';
import './widgets/application.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => ThemeNotifier(),
    child: const Application(),
  ));
}
