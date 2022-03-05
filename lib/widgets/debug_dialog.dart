import 'package:flutter/material.dart';

import '../utils/storage.dart' as storage;

class DebugDialog extends StatefulWidget {
  const DebugDialog({Key? key}) : super(key: key);

  @override
  State<DebugDialog> createState() => _DebugDialogState();
}

class _DebugDialogState extends State<DebugDialog> {
  bool? _darkTheme;
  bool _auth = false;
  bool? _weekView;
  final _baseUrl = TextEditingController();
  final _personUuid = TextEditingController();

  Widget _stringTile(String title, TextEditingController value, ValueChanged<String> onChanged) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: value,
          onSubmitted: onChanged,
          decoration: InputDecoration(label: Text(title)),
        ),
      );

  Widget _boolTile(String title, bool value, ValueChanged<bool> onChanged) =>
      SwitchListTile.adaptive(
        value: value,
        onChanged: onChanged,
        title: Text(title),
      );

  Widget _boolOrNullTile(String title, bool? value, ValueChanged<bool?> onChanged) =>
      CheckboxListTile(
        value: value,
        onChanged: onChanged,
        tristate: true,
        title: Text(title),
      );

  @override
  void initState() {
    super.initState();
    storage.darkTheme.get().then((value) => setState(() {
          _darkTheme = value;
        }));
    storage.authEnabled.getNotNull().then((value) => setState(() {
          _auth = value;
        }));
    storage.weekView.get().then((value) => setState(() {
          _weekView = value;
        }));
    storage.baseURL.get().then((value) => setState(() {
          _baseUrl.text = value ?? "";
        }));
    storage.personUUID.get().then((value) => setState(() {
          _personUuid.text = value ?? "";
        }));
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Меню отладки"),
      children: [
        _boolOrNullTile(
          "darkTheme",
          _darkTheme,
          (value) => setState(() {
            storage.darkTheme.set(value);
            _darkTheme = value;
          }),
        ),
        _boolTile(
          "auth",
          _auth,
          (value) => setState(() {
            storage.authEnabled.set(value);
            _auth = value;
          }),
        ),
        _boolOrNullTile(
          "weekView",
          _weekView,
          (value) => setState(() {
            storage.weekView.set(value);
            _weekView = value;
          }),
        ),
        _stringTile(
          "d_baseUrl",
          _baseUrl,
          (value) => setState(() {
            storage.baseURL.set(value);
            _baseUrl.text = value;
          }),
        ),
        _stringTile(
          "personUuid",
          _personUuid,
          (value) => setState(() {
            storage.personUUID.set(value);
            _personUuid.text = value;
          }),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _baseUrl.dispose();
    _personUuid.dispose();
    super.dispose();
  }
}
