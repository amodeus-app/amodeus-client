import 'package:shared_preferences/shared_preferences.dart';

// region _helpers
void _setData(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  final success = await prefs.setString(key, value);
  if (!success) {
    throw AssertionError("Cannot save $key");
  }
}

void _setFlag(String key, bool value) async {
  final prefs = await SharedPreferences.getInstance();
  final success = await prefs.setBool(key, value);
  if (!success) {
    throw AssertionError("Cannot save $key");
  }
}

Future<String?> _readData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<bool?> _readFlag(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(key);
}

Future<bool> _deleteData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.remove(key);
}
// endregion

// region darkTheme
Future<bool?> isPreferredDarkMode() async {
  return await _readFlag("darkTheme");
}

void setPreferredDarkMode(bool? value) async {
  if (value == null) {
    _deleteData("darkTheme");
    return;
  }
  _setFlag("darkTheme", value);
}
// endregion

// region auth
Future<bool> isAuthEnabled() async {
  return (await _readFlag("auth")) == true;
}

void setAuthEnabled(bool value) async {
  _setFlag("auth", value);
}
// endregion

// region dayView
Future<bool> isWeekView() async {
  return (await _readFlag("weekView")) == true;
}

void setWeekView(bool value) async {
  _setFlag("weekView", value);
}
// endregion

// region d_baseUrl
Future<String?> getBaseUrl() async {
  final v = await _readData("d_baseUrl");
  if (v == "") {
    return null;
  }
  return v;
}

void setBaseUrl(String value) async {
  _setData("d_baseUrl", value);
}
// endregion

// region d_personUuid
Future<String?> getPersonUUID() async {
  final v = await _readData("personUuid");
  if (v == "") {
    return null;
  }
  return v;
}

void setPersonUUID(String value) async {
  _setData("personUuid", value);
}
// endregion
