import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/login.dart';
import '../utils/storage.dart' as storage;
import '../utils/theme.dart';
import '../widgets/debug_dialog.dart';
import '../widgets/settings_tiles.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool? _authAvailable;
  bool _authEnabled = false;
  bool _weekView = false;
  PackageInfo? _info;

  final _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _localAuth.isDeviceSupported().then((value) async {
      final isAuthEnabled = await storage.authEnabled.getNotNull();
      setState(() {
        _authAvailable = value;
        _authEnabled = isAuthEnabled;
      });
    }).onError<MissingPluginException>((error, stackTrace) {
      setState(() {
        _authAvailable = false;
      });
    });
    storage.weekView.getNotNull().then((value) => setState(() {
          _weekView = value;
        }));
    PackageInfo.fromPlatform().then((value) => setState(() {
          _info = value;
        }));
  }

  void _onThemeItemTap(bool? setDark) {
    final theme = Provider.of<ThemeNotifier>(context, listen: false);
    setDark == null
        ? theme.setSystemTheme()
        : (setDark ? theme.setDarkMode() : theme.setLightMode());
    Navigator.pop(context);
  }

  void _toggleAuth(bool setOn, {bool noPin = false}) async {
    if (!setOn) {
      storage.authEnabled.set(false);
    } else {
      final authenticated = await _localAuth.authenticate(
        localizedReason: "Защита приложения",
        stickyAuth: true,
        biometricOnly: noPin,
        androidAuthStrings: const AndroidAuthMessages(
          biometricHint: "",
        ),
      );
      if (!authenticated) {
        return;
      }
      storage.authEnabled.set(true);
    }
    setState(() {
      _authEnabled = setOn;
    });
  }

  void _toggleWeekView(bool setOn) async {
    storage.weekView.set(setOn);
    setState(() {
      _weekView = setOn;
    });
  }

  GestureRecognizer _launchUrlOnTap(String url) => TapGestureRecognizer()
    ..onTap = () async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Не могу открыть ссылку")));
      }
    };

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);
    const debugSuffix = kDebugMode ? " DEBUG" : "";
    String appName = "", appVersion = "", aboutSubtitle = "", appFullVersion = "";
    if (_info != null) {
      appName = _info!.appName;
      appVersion = "${_info!.version}$debugSuffix";
      aboutSubtitle = "$appName $appVersion";
      appFullVersion = "$appVersion build ${_info!.buildNumber}";
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Настройки"),
      ),
      body: ListView(
        children: <SettingsTile>[
          SettingsTile(
            icon: Icons.account_circle,
            title: "Аккаунт",
            subtitle: "Вход не выполнен",
            enabled: kDebugMode,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            ),
          ),
          SettingsSwitchTile(
            title: "При запуске показывать",
            subtitle: _weekView ? "Расписание на неделю" : "Расписание на сегодня",
            value: _weekView,
            onTap: _toggleWeekView,
          ),
          SettingsDialogTile(
            context: context,
            icon: Icons.color_lens,
            title: "Тема",
            subtitle: theme.isSystem ? "Системная" : (theme.isDark ? "Тёмная" : "Светлая"),
            options: <SettingsDialogOption>[
              SettingsDialogOption(text: "Системная", onTap: () => _onThemeItemTap(null)),
              SettingsDialogOption(text: "Светлая", onTap: () => _onThemeItemTap(false)),
              SettingsDialogOption(text: "Тёмная", onTap: () => _onThemeItemTap(true)),
            ],
          ),
          SettingsSwitchTile(
            icon: Icons.security,
            title: "Защита приложения",
            subtitle: _authAvailable == false
                ? "Недоступно на вашем устройстве"
                : "С помощью отпечатка или пароля",
            value: _authEnabled,
            onTap: _toggleAuth,
            enabled: _authAvailable ?? false,
          ),
          SettingsAboutTile(
            context: context,
            icon: Icons.info,
            title: "О программе",
            subtitle: aboutSubtitle,
            appName: appName,
            appVersion: appFullVersion,
            appIcon: const Icon(Icons.accessible_forward, size: 48.0),
            children: <Widget>[
              Text.rich(
                TextSpan(
                  text: "Альтернативный клиент MODEUS для студентов ТюмГУ. Made with 💔 by ",
                  children: [
                    TextSpan(
                      text: "@evgfilim1",
                      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      recognizer: _launchUrlOnTap("https://evgfilim1.me/"),
                    ),
                  ],
                ),
              ),
            ],
            onLongPress: () =>
                showDialog(context: context, builder: (context) => const DebugDialog()),
          ),
        ],
      ),
    );
  }
}
