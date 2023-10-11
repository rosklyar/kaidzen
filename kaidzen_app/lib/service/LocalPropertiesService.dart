import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalPropertiesService extends ChangeNotifier {
  final Map<PropertyKey, Object?> _properties = {};

  Future<void> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    for (PropertyKey key in PropertyKey.values) {
      _properties[key] = prefs.get(key.name) ?? key.defaultValue;
    }
    notifyListeners();
  }

  String? getString(PropertyKey key) => _properties[key] as String?;
  bool? getBool(PropertyKey key) => _properties[key] as bool?;
  int? getInt(PropertyKey key) => _properties[key] as int?;
  double? getDouble(PropertyKey key) => _properties[key] as double?;
  List<String>? getStringList(PropertyKey key) => _properties[key] as List<String>?;

  Future<void> setString(PropertyKey key, String value) => _setProperty(key, value);
  Future<void> setBool(PropertyKey key, bool value) => _setProperty(key, value);
  Future<void> setInt(PropertyKey key, int value) => _setProperty(key, value);
  Future<void> setDouble(PropertyKey key, double value) => _setProperty(key, value);
  Future<void> setStringList(PropertyKey key, List<String> value) =>
      _setProperty(key, value);

  Future<void> _setProperty(PropertyKey key, Object value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key.name, value);
    } else if (value is int) {
      await prefs.setInt(key.name, value);
    } else if (value is double) {
      await prefs.setDouble(key.name, value);
    } else if (value is String) {
      await prefs.setString(key.name, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key.name, value);
    }
    _properties[key] = value;
    notifyListeners();
  }
}

enum PropertyKey {
  HABITS_EXPANDED('habitsExpanded', true);

  const PropertyKey(this.name, this.defaultValue);

  final String name;
  final Object defaultValue;
}
