import 'package:shared_preferences/shared_preferences.dart';

// region Helpers
void _removeKey(String key) async {
  final prefs = await SharedPreferences.getInstance();
  final res = await prefs.remove(key);
  assert(res);
}

abstract class _DataHelper<T> {
  const _DataHelper();

  Future<T?> get();
  void set(T? value);
}

class _StringDataHelper implements _DataHelper<String> {
  final String key;

  const _StringDataHelper({required this.key});

  @override
  Future<String?> get() async {
    final prefs = await SharedPreferences.getInstance();
    final res = prefs.getString(key);
    if (res == "") {
      return null;
    }
    return res;
  }

  @override
  void set(String? value) async {
    if (value == null || value == "") {
      _removeKey(key);
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final success = await prefs.setString(key, value);
    if (!success) {
      throw AssertionError("Cannot save $key");
    }
  }
}

class _FlagDataHelper implements _DataHelper<bool> {
  final String key;

  const _FlagDataHelper({required this.key});

  @override
  Future<bool?> get() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  Future<bool> getNotNull() async {
    return (await get() == true);
  }

  @override
  void set(bool? value) async {
    if (value == null) {
      _removeKey(key);
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final success = await prefs.setBool(key, value);
    if (!success) {
      throw AssertionError("Cannot save $key");
    }
  }
}
// endregion

const darkTheme = _FlagDataHelper(key: "darkTheme");
const authEnabled = _FlagDataHelper(key: "auth");
const weekView = _FlagDataHelper(key: "weekView");
const baseURL = _StringDataHelper(key: "d_baseUrl");
const personUUID = _StringDataHelper(key: "personUuid");

// region Deprecated methods
// region darkTheme
@Deprecated("Use [darkTheme.get] instead")
Future<bool?> isPreferredDarkMode() {
  return darkTheme.get();
}

@Deprecated("Use [darkTheme.set] instead")
void setPreferredDarkMode(bool? value) {
  return darkTheme.set(value);
}
// endregion

// region auth
@Deprecated("Use [authEnabled.getNotNull] instead")
Future<bool> isAuthEnabled() {
  return authEnabled.getNotNull();
}

@Deprecated("Use [authEnabled.set] instead")
void setAuthEnabled(bool value) {
  return authEnabled.set(value);
}
// endregion

// region weekView
@Deprecated("Use [weekView.getNotNull] instead")
Future<bool> isWeekView() {
  return weekView.getNotNull();
}

@Deprecated("Use [weekView.set] instead")
void setWeekView(bool value) {
  return weekView.set(value);
}
// endregion

// region d_baseUrl
@Deprecated("Use [baseURL.get] instead")
Future<String?> getBaseUrl() {
  return baseURL.get();
}

@Deprecated("Use [baseURL.set] instead")
void setBaseUrl(String value) {
  return baseURL.set(value);
}
// endregion

// region personUuid
@Deprecated("Use [personUUID.get] instead")
Future<String?> getPersonUUID() {
  return personUUID.get();
}

@Deprecated("Use [personUUID.set] instead")
void setPersonUUID(String value) {
  return personUUID.set(value);
}
// endregion
// endregion
