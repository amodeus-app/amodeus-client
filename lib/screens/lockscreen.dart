import 'package:flutter/material.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

import '../utils/destinations.dart';
import '../utils/storage.dart' as storage;

class LockScreen extends StatefulWidget {
  const LockScreen({Key? key}) : super(key: key);

  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  bool? _authRequired;

  void _continue() {
    setState(() {
      _authRequired = false;
    });
    Navigator.popAndPushNamed(context, homeDestination.path);
  }

  @override
  void initState() {
    super.initState();
    storage.isAuthEnabled().then((value) {
      if (!value) {
        _continue();
      }
      setState(() {
        _authRequired = value;
      });
    });
  }

  void _doAuth() async {
    final authenticated = await LocalAuthentication().authenticate(
      localizedReason: "Вход в приложение",
      stickyAuth: true,
      // biometricOnly: noPin,
      androidAuthStrings: const AndroidAuthMessages(
        biometricHint: "",
      ),
    );
    if (!authenticated) {
      return;
    }
    _continue();
  }

  @override
  Widget build(BuildContext context) {
    if (_authRequired == true) {
      _doAuth();
      return Center(
        child: TextButton.icon(
          icon: const Icon(Icons.lock),
          label: const Text(
            "Разблокировать",
            style: TextStyle(fontSize: 20),
          ),
          onPressed: _doAuth,
        ),
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
