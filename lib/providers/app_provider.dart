import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/unit_models.dart';

class AppProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _isOfflineMode = false;
  String _lastCategory = 'length';
  List<ConversionRecord> _history = [];
  List<String> _favoriteCategories = [];
  List<String> _favoriteConversions = [];

  bool get isDarkMode => _isDarkMode;
  bool get isOfflineMode => _isOfflineMode;
  String get lastCategory => _lastCategory;
  List<ConversionRecord> get history => List.unmodifiable(_history);
  List<String> get favoriteCategories => List.unmodifiable(_favoriteCategories);
  List<ConversionRecord> get favoriteConversions => 
      _history.where((h) => h.isFavorite).toList();
  List<ConversionRecord> get recentConversions => 
      _history.take(20).toList();

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _isOfflineMode = prefs.getBool('isOfflineMode') ?? false;
    _lastCategory = prefs.getString('lastCategory') ?? 'length';

    final historyJson = prefs.getStringList('history') ?? [];
    _history = historyJson.map((json) => _recordFromJson(json)).toList();

    _favoriteCategories = prefs.getStringList('favoriteCategories') ?? [];
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    await prefs.setBool('isOfflineMode', _isOfflineMode);
    await prefs.setString('lastCategory', _lastCategory);
    await prefs.setStringList('favoriteCategories', _favoriteCategories);
    await prefs.setStringList('history', _history.map((r) => _recordToJson(r)).toList());
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    _savePreferences();
    notifyListeners();
  }

  void toggleOfflineMode() {
    _isOfflineMode = !_isOfflineMode;
    _savePreferences();
    notifyListeners();
  }

  void setLastCategory(String category) {
    _lastCategory = category;
    _savePreferences();
  }

  void addToHistory(ConversionRecord record) {
    // Remove duplicate if exists
    _history.removeWhere((h) => 
      h.fromUnit == record.fromUnit && 
      h.toUnit == record.toUnit && 
      h.inputValue == record.inputValue
    );
    _history.insert(0, record);
    // Keep only last 100 records
    if (_history.length > 100) _history = _history.sublist(0, 100);
    _savePreferences();
    notifyListeners();
  }

  void toggleFavorite(String recordId) {
    final index = _history.indexWhere((h) => h.id == recordId);
    if (index != -1) {
      _history[index] = _history[index].copyWith(
        isFavorite: !_history[index].isFavorite,
      );
      _savePreferences();
      notifyListeners();
    }
  }

  void clearHistory() {
    _history.clear();
    _savePreferences();
    notifyListeners();
  }

  void deleteHistoryRecord(String id) {
    _history.removeWhere((h) => h.id == id);
    _savePreferences();
    notifyListeners();
  }

  void toggleFavoriteCategory(String categoryId) {
    if (_favoriteCategories.contains(categoryId)) {
      _favoriteCategories.remove(categoryId);
    } else {
      _favoriteCategories.add(categoryId);
    }
    _savePreferences();
    notifyListeners();
  }

  String _recordToJson(ConversionRecord record) {
    return jsonEncode({
      'id': record.id,
      'categoryName': record.categoryName,
      'fromUnit': record.fromUnit,
      'toUnit': record.toUnit,
      'inputValue': record.inputValue,
      'resultValue': record.resultValue,
      'timestamp': record.timestamp.toIso8601String(),
      'isFavorite': record.isFavorite,
    });
  }

  ConversionRecord _recordFromJson(String json) {
    final map = jsonDecode(json);
    return ConversionRecord(
      id: map['id'],
      categoryName: map['categoryName'],
      fromUnit: map['fromUnit'],
      toUnit: map['toUnit'],
      inputValue: map['inputValue'],
      resultValue: map['resultValue'],
      timestamp: DateTime.parse(map['timestamp']),
      isFavorite: map['isFavorite'] ?? false,
    );
  }
}
