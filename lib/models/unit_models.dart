import 'package:equatable/equatable.dart';

class UnitCategory {
  final String id;
  final String name;
  final String icon;
  final String description;
  final List<Unit> units;
  final bool isCurrency;

  const UnitCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.units,
    this.isCurrency = false,
  });
}

class Unit extends Equatable {
  final String id;
  final String name;
  final String symbol;
  final double factor; // conversion factor to base unit
  final double? offset; // for temperature conversions

  const Unit({
    required this.id,
    required this.name,
    required this.symbol,
    required this.factor,
    this.offset,
  });

  @override
  List<Object?> get props => [id, name, symbol, factor, offset];
}

class ConversionRecord {
  final String id;
  final String categoryName;
  final String fromUnit;
  final String toUnit;
  final double inputValue;
  final double resultValue;
  final DateTime timestamp;
  final bool isFavorite;

  ConversionRecord({
    required this.id,
    required this.categoryName,
    required this.fromUnit,
    required this.toUnit,
    required this.inputValue,
    required this.resultValue,
    required this.timestamp,
    this.isFavorite = false,
  });

  ConversionRecord copyWith({bool? isFavorite}) {
    return ConversionRecord(
      id: id,
      categoryName: categoryName,
      fromUnit: fromUnit,
      toUnit: toUnit,
      inputValue: inputValue,
      resultValue: resultValue,
      timestamp: timestamp,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class CurrencyRate {
  final String code;
  final String name;
  final String symbol;
  final double rate; // rate relative to USD
  final DateTime? lastUpdated;

  const CurrencyRate({
    required this.code,
    required this.name,
    required this.symbol,
    required this.rate,
    this.lastUpdated,
  });
}
