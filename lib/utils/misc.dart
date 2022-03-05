import 'package:flutter/material.dart';

bool isMediumScreen(BuildContext context) => MediaQuery.of(context).size.width >= 760.0;

bool isLargeScreen(BuildContext context) => MediaQuery.of(context).size.width >= 1240.0;