import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/unit_models.dart';
import '../utils/unit_data.dart';

class CurrencyProvider extends ChangeNotifier {
  List<CurrencyRate> _currencies = [];
  bool _isLoading = false;
  String? _error;
  DateTime? _lastUpdated;
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  double _amount = 1.0;

  List<CurrencyRate> get currencies => List.unmodifiable(_currencies);
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime? get lastUpdated => _lastUpdated;
  String get fromCurrency => _fromCurrency;
  String get toCurrency => _toCurrency;
  double get amount => _amount;

  CurrencyRate? get fromRate => _currencies.firstWhere(
    (c) => c.code == _fromCurrency,
    orElse: () => _currencies.isNotEmpty ? _currencies.first : UnitData.defaultCurrencies.first,
  );

  CurrencyRate? get toRate => _currencies.firstWhere(
    (c) => c.code == _toCurrency,
    orElse: () => _currencies.isNotEmpty ? _currencies.first : UnitData.defaultCurrencies.first,
  );

  double get convertedAmount {
    if (fromRate == null || toRate == null) return 0;
    // Convert via USD base
    final usdAmount = _amount / fromRate!.rate;
    return usdAmount * toRate!.rate;
  }

  CurrencyProvider() {
    _currencies = List.from(UnitData.defaultCurrencies);
  }

  Future<void> loadSavedRates() async {
    final prefs = await SharedPreferences.getInstance();
    final savedRates = prefs.getString('savedRates');
    final savedTime = prefs.getString('lastRateUpdate');
    final from = prefs.getString('fromCurrency');
    final to = prefs.getString('toCurrency');

    if (savedRates != null) {
      try {
        final List<dynamic> decoded = jsonDecode(savedRates);
        _currencies = decoded.map((m) => CurrencyRate(
          code: m['code'],
          name: m['name'],
          symbol: m['symbol'],
          rate: (m['rate'] as num).toDouble(),
        )).toList();
      } catch (e) {
        _currencies = List.from(UnitData.defaultCurrencies);
      }
    }

    if (savedTime != null) {
      _lastUpdated = DateTime.tryParse(savedTime);
    }

    if (from != null) _fromCurrency = from;
    if (to != null) _toCurrency = to;

    notifyListeners();
  }

  Future<void> _saveRates() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_currencies.map((c) => {
      'code': c.code,
      'name': c.name,
      'symbol': c.symbol,
      'rate': c.rate,
    }).toList());
    await prefs.setString('savedRates', encoded);
    if (_lastUpdated != null) {
      await prefs.setString('lastRateUpdate', _lastUpdated!.toIso8601String());
    }
    await prefs.setString('fromCurrency', _fromCurrency);
    await prefs.setString('toCurrency', _toCurrency);
  }

  Future<void> fetchLiveRates() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Free endpoint - no API key needed, updates daily
      final response = await http.get(
        Uri.parse('https://open.er-api.com/v6/latest/USD'),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;

        _currencies = _currencies.map((c) {
          if (rates.containsKey(c.code)) {
            return CurrencyRate(
              code: c.code,
              name: c.name,
              symbol: c.symbol,
              rate: (rates[c.code] as num).toDouble(),
              lastUpdated: DateTime.now(),
            );
          }
          return c;
        }).toList();

        _lastUpdated = DateTime.now();
        _error = null;
        await _saveRates();
      } else {
        _error = 'Failed to fetch rates. Using last saved rates.';
      }
    } catch (e) {
      _error = 'Network error. Using offline rates.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFromCurrency(String code) {
    _fromCurrency = code;
    _saveRates();
    notifyListeners();
  }

  void setToCurrency(String code) {
    _toCurrency = code;
    _saveRates();
    notifyListeners();
  }

  void setAmount(double value) {
    _amount = value;
    notifyListeners();
  }

  void swapCurrencies() {
    final temp = _fromCurrency;
    _fromCurrency = _toCurrency;
    _toCurrency = temp;
    _saveRates();
    notifyListeners();
  }

  List<CurrencyRate> searchCurrencies(String query) {
    if (query.isEmpty) return _currencies;
    final lower = query.toLowerCase();
    return _currencies.where((c) =>
      c.name.toLowerCase().contains(lower) ||
      c.code.toLowerCase().contains(lower) ||
      c.symbol.toLowerCase().contains(lower)
    ).toList();
  }
}
