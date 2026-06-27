import '../models/unit_models.dart';

class UnitData {
  static List<UnitCategory> get categories => [
    lengthCategory,
    weightCategory,
    temperatureCategory,
    volumeCategory,
    areaCategory,
    speedCategory,
    timeCategory,
    dataCategory,
    energyCategory,
    pressureCategory,
  ];

  static UnitCategory get lengthCategory => UnitCategory(
    id: 'length',
    name: 'Length',
    icon: 'ruler',
    description: 'Meter, Kilometer, Mile, Foot, Inch',
    units: [
      Unit(id: 'm', name: 'Meter', symbol: 'm', factor: 1.0),
      Unit(id: 'km', name: 'Kilometer', symbol: 'km', factor: 1000.0),
      Unit(id: 'cm', name: 'Centimeter', symbol: 'cm', factor: 0.01),
      Unit(id: 'mm', name: 'Millimeter', symbol: 'mm', factor: 0.001),
      Unit(id: 'mi', name: 'Mile', symbol: 'mi', factor: 1609.344),
      Unit(id: 'yd', name: 'Yard', symbol: 'yd', factor: 0.9144),
      Unit(id: 'ft', name: 'Foot', symbol: 'ft', factor: 0.3048),
      Unit(id: 'in', name: 'Inch', symbol: 'in', factor: 0.0254),
      Unit(id: 'nm', name: 'Nanometer', symbol: 'nm', factor: 1e-9),
      Unit(id: 'um', name: 'Micrometer', symbol: 'μm', factor: 1e-6),
      Unit(id: 'nmi', name: 'Nautical Mile', symbol: 'nmi', factor: 1852.0),
    ],
  );

  static UnitCategory get weightCategory => UnitCategory(
    id: 'weight',
    name: 'Weight',
    icon: 'scale',
    description: 'Kilogram, Pound, Ounce, Gram, Ton',
    units: [
      Unit(id: 'kg', name: 'Kilogram', symbol: 'kg', factor: 1.0),
      Unit(id: 'g', name: 'Gram', symbol: 'g', factor: 0.001),
      Unit(id: 'mg', name: 'Milligram', symbol: 'mg', factor: 1e-6),
      Unit(id: 'lb', name: 'Pound', symbol: 'lb', factor: 0.45359237),
      Unit(id: 'oz', name: 'Ounce', symbol: 'oz', factor: 0.02834952),
      Unit(id: 'st', name: 'Stone', symbol: 'st', factor: 6.350293),
      Unit(id: 't', name: 'Metric Ton', symbol: 't', factor: 1000.0),
      Unit(id: 'us_ton', name: 'US Ton', symbol: 'ton', factor: 907.18474),
      Unit(id: 'carat', name: 'Carat', symbol: 'ct', factor: 0.0002),
    ],
  );

  static UnitCategory get temperatureCategory => UnitCategory(
    id: 'temperature',
    name: 'Temperature',
    icon: 'thermometer',
    description: 'Celsius, Fahrenheit, Kelvin',
    units: [
      Unit(id: 'c', name: 'Celsius', symbol: '°C', factor: 1.0, offset: 0.0),
      Unit(id: 'f', name: 'Fahrenheit', symbol: '°F', factor: 0.5556, offset: -32.0),
      Unit(id: 'k', name: 'Kelvin', symbol: 'K', factor: 1.0, offset: -273.15),
      Unit(id: 'r', name: 'Rankine', symbol: '°R', factor: 0.5556, offset: -491.67),
    ],
  );

  static UnitCategory get volumeCategory => UnitCategory(
    id: 'volume',
    name: 'Volume',
    icon: 'beaker',
    description: 'Liter, Gallon, Milliliter, Cubic Meter',
    units: [
      Unit(id: 'l', name: 'Liter', symbol: 'L', factor: 1.0),
      Unit(id: 'ml', name: 'Milliliter', symbol: 'mL', factor: 0.001),
      Unit(id: 'gal_us', name: 'US Gallon', symbol: 'gal', factor: 3.78541),
      Unit(id: 'gal_uk', name: 'UK Gallon', symbol: 'gal (UK)', factor: 4.54609),
      Unit(id: 'qt', name: 'Quart', symbol: 'qt', factor: 0.946353),
      Unit(id: 'pt', name: 'Pint', symbol: 'pt', factor: 0.473176),
      Unit(id: 'cup', name: 'Cup', symbol: 'cup', factor: 0.236588),
      Unit(id: 'fl_oz', name: 'Fluid Ounce', symbol: 'fl oz', factor: 0.0295735),
      Unit(id: 'm3', name: 'Cubic Meter', symbol: 'm³', factor: 1000.0),
      Unit(id: 'cm3', name: 'Cubic Centimeter', symbol: 'cm³', factor: 0.001),
      Unit(id: 'tbsp', name: 'Tablespoon', symbol: 'tbsp', factor: 0.0147868),
      Unit(id: 'tsp', name: 'Teaspoon', symbol: 'tsp', factor: 0.00492892),
    ],
  );

  static UnitCategory get areaCategory => UnitCategory(
    id: 'area',
    name: 'Area',
    icon: 'square',
    description: 'Square Meter, Acre, Hectare, Square Foot',
    units: [
      Unit(id: 'm2', name: 'Square Meter', symbol: 'm²', factor: 1.0),
      Unit(id: 'km2', name: 'Square Kilometer', symbol: 'km²', factor: 1e6),
      Unit(id: 'ha', name: 'Hectare', symbol: 'ha', factor: 10000.0),
      Unit(id: 'acre', name: 'Acre', symbol: 'ac', factor: 4046.86),
      Unit(id: 'ft2', name: 'Square Foot', symbol: 'ft²', factor: 0.092903),
      Unit(id: 'in2', name: 'Square Inch', symbol: 'in²', factor: 0.00064516),
      Unit(id: 'yd2', name: 'Square Yard', symbol: 'yd²', factor: 0.836127),
      Unit(id: 'mi2', name: 'Square Mile', symbol: 'mi²', factor: 2.59e6),
    ],
  );

  static UnitCategory get speedCategory => UnitCategory(
    id: 'speed',
    name: 'Speed',
    icon: 'speed',
    description: 'km/h, mph, m/s, Knot',
    units: [
      Unit(id: 'mps', name: 'Meter/Second', symbol: 'm/s', factor: 1.0),
      Unit(id: 'kph', name: 'Kilometer/Hour', symbol: 'km/h', factor: 0.277778),
      Unit(id: 'mph', name: 'Mile/Hour', symbol: 'mph', factor: 0.44704),
      Unit(id: 'knot', name: 'Knot', symbol: 'kn', factor: 0.514444),
      Unit(id: 'mach', name: 'Mach', symbol: 'Ma', factor: 343.0),
      Unit(id: 'fps', name: 'Foot/Second', symbol: 'ft/s', factor: 0.3048),
    ],
  );

  static UnitCategory get timeCategory => UnitCategory(
    id: 'time',
    name: 'Time',
    icon: 'clock',
    description: 'Second, Minute, Hour, Day, Week, Year',
    units: [
      Unit(id: 's', name: 'Second', symbol: 's', factor: 1.0),
      Unit(id: 'min', name: 'Minute', symbol: 'min', factor: 60.0),
      Unit(id: 'h', name: 'Hour', symbol: 'h', factor: 3600.0),
      Unit(id: 'd', name: 'Day', symbol: 'd', factor: 86400.0),
      Unit(id: 'wk', name: 'Week', symbol: 'wk', factor: 604800.0),
      Unit(id: 'mo', name: 'Month', symbol: 'mo', factor: 2.628e6),
      Unit(id: 'yr', name: 'Year', symbol: 'yr', factor: 3.154e7),
      Unit(id: 'ms', name: 'Millisecond', symbol: 'ms', factor: 0.001),
      Unit(id: 'us', name: 'Microsecond', symbol: 'μs', factor: 1e-6),
      Unit(id: 'ns', name: 'Nanosecond', symbol: 'ns', factor: 1e-9),
    ],
  );

  static UnitCategory get dataCategory => UnitCategory(
    id: 'data',
    name: 'Data',
    icon: 'database',
    description: 'Byte, KB, MB, GB, TB',
    units: [
      Unit(id: 'b', name: 'Byte', symbol: 'B', factor: 1.0),
      Unit(id: 'kb', name: 'Kilobyte', symbol: 'KB', factor: 1024.0),
      Unit(id: 'mb', name: 'Megabyte', symbol: 'MB', factor: 1048576.0),
      Unit(id: 'gb', name: 'Gigabyte', symbol: 'GB', factor: 1073741824.0),
      Unit(id: 'tb', name: 'Terabyte', symbol: 'TB', factor: 1099511627776.0),
      Unit(id: 'pb', name: 'Petabyte', symbol: 'PB', factor: 1.1259e15),
      Unit(id: 'bit', name: 'Bit', symbol: 'bit', factor: 0.125),
      Unit(id: 'kib', name: 'Kibibyte', symbol: 'KiB', factor: 1024.0),
      Unit(id: 'mib', name: 'Mebibyte', symbol: 'MiB', factor: 1048576.0),
      Unit(id: 'gib', name: 'Gibibyte', symbol: 'GiB', factor: 1073741824.0),
    ],
  );

  static UnitCategory get energyCategory => UnitCategory(
    id: 'energy',
    name: 'Energy',
    icon: 'zap',
    description: 'Joule, Calorie, kWh, BTU',
    units: [
      Unit(id: 'j', name: 'Joule', symbol: 'J', factor: 1.0),
      Unit(id: 'kj', name: 'Kilojoule', symbol: 'kJ', factor: 1000.0),
      Unit(id: 'cal', name: 'Calorie', symbol: 'cal', factor: 4.184),
      Unit(id: 'kcal', name: 'Kilocalorie', symbol: 'kcal', factor: 4184.0),
      Unit(id: 'wh', name: 'Watt Hour', symbol: 'Wh', factor: 3600.0),
      Unit(id: 'kwh', name: 'Kilowatt Hour', symbol: 'kWh', factor: 3.6e6),
      Unit(id: 'btu', name: 'BTU', symbol: 'BTU', factor: 1055.06),
      Unit(id: 'ev', name: 'Electronvolt', symbol: 'eV', factor: 1.602e-19),
    ],
  );

  static UnitCategory get pressureCategory => UnitCategory(
    id: 'pressure',
    name: 'Pressure',
    icon: 'gauge',
    description: 'Pascal, Bar, PSI, Atmosphere',
    units: [
      Unit(id: 'pa', name: 'Pascal', symbol: 'Pa', factor: 1.0),
      Unit(id: 'kpa', name: 'Kilopascal', symbol: 'kPa', factor: 1000.0),
      Unit(id: 'mpa', name: 'Megapascal', symbol: 'MPa', factor: 1e6),
      Unit(id: 'bar', name: 'Bar', symbol: 'bar', factor: 100000.0),
      Unit(id: 'mbar', name: 'Millibar', symbol: 'mbar', factor: 100.0),
      Unit(id: 'psi', name: 'PSI', symbol: 'psi', factor: 6894.76),
      Unit(id: 'atm', name: 'Atmosphere', symbol: 'atm', factor: 101325.0),
      Unit(id: 'torr', name: 'Torr', symbol: 'Torr', factor: 133.322),
      Unit(id: 'mmhg', name: 'mmHg', symbol: 'mmHg', factor: 133.322),
    ],
  );

  static List<CurrencyRate> get defaultCurrencies => [
    CurrencyRate(code: 'USD', name: 'US Dollar', symbol: '\$', rate: 1.0),
    CurrencyRate(code: 'EUR', name: 'Euro', symbol: '€', rate: 0.92),
    CurrencyRate(code: 'GBP', name: 'British Pound', symbol: '£', rate: 0.79),
    CurrencyRate(code: 'JPY', name: 'Japanese Yen', symbol: '¥', rate: 150.5),
    CurrencyRate(code: 'CNY', name: 'Chinese Yuan', symbol: '¥', rate: 7.19),
    CurrencyRate(code: 'INR', name: 'Indian Rupee', symbol: '₹', rate: 83.0),
    CurrencyRate(code: 'AUD', name: 'Australian Dollar', symbol: 'A\$', rate: 1.53),
    CurrencyRate(code: 'CAD', name: 'Canadian Dollar', symbol: 'C\$', rate: 1.35),
    CurrencyRate(code: 'CHF', name: 'Swiss Franc', symbol: 'Fr', rate: 0.88),
    CurrencyRate(code: 'HKD', name: 'Hong Kong Dollar', symbol: 'HK\$', rate: 7.82),
    CurrencyRate(code: 'SGD', name: 'Singapore Dollar', symbol: 'S\$', rate: 1.34),
    CurrencyRate(code: 'KRW', name: 'South Korean Won', symbol: '₩', rate: 1330.0),
    CurrencyRate(code: 'BRL', name: 'Brazilian Real', symbol: 'R\$', rate: 4.95),
    CurrencyRate(code: 'MXN', name: 'Mexican Peso', symbol: 'Mex\$', rate: 17.1),
    CurrencyRate(code: 'RUB', name: 'Russian Ruble', symbol: '₽', rate: 92.5),
    CurrencyRate(code: 'ZAR', name: 'South African Rand', symbol: 'R', rate: 19.0),
    CurrencyRate(code: 'TRY', name: 'Turkish Lira', symbol: '₺', rate: 30.5),
    CurrencyRate(code: 'AED', name: 'UAE Dirham', symbol: 'dh', rate: 3.67),
    CurrencyRate(code: 'SAR', name: 'Saudi Riyal', symbol: 'SR', rate: 3.75),
    CurrencyRate(code: 'THB', name: 'Thai Baht', symbol: '฿', rate: 35.8),
    CurrencyRate(code: 'IDR', name: 'Indonesian Rupiah', symbol: 'Rp', rate: 15600.0),
    CurrencyRate(code: 'MYR', name: 'Malaysian Ringgit', symbol: 'RM', rate: 4.72),
    CurrencyRate(code: 'PHP', name: 'Philippine Peso', symbol: '₱', rate: 56.0),
    CurrencyRate(code: 'VND', name: 'Vietnamese Dong', symbol: '₫', rate: 24500.0),
    CurrencyRate(code: 'PKR', name: 'Pakistani Rupee', symbol: '₨', rate: 278.0),
    CurrencyRate(code: 'NGN', name: 'Nigerian Naira', symbol: '₦', rate: 1500.0),
    CurrencyRate(code: 'EGP', name: 'Egyptian Pound', symbol: 'E£', rate: 30.9),
    CurrencyRate(code: 'PLN', name: 'Polish Zloty', symbol: 'zł', rate: 3.97),
    CurrencyRate(code: 'SEK', name: 'Swedish Krona', symbol: 'kr', rate: 10.4),
    CurrencyRate(code: 'NOK', name: 'Norwegian Krone', symbol: 'kr', rate: 10.6),
    CurrencyRate(code: 'DKK', name: 'Danish Krone', symbol: 'kr', rate: 6.91),
    CurrencyRate(code: 'NZD', name: 'New Zealand Dollar', symbol: 'NZ\$', rate: 1.62),
    CurrencyRate(code: 'ARS', name: 'Argentine Peso', symbol: '\$', rate: 850.0),
    CurrencyRate(code: 'CLP', name: 'Chilean Peso', symbol: '\$', rate: 960.0),
    CurrencyRate(code: 'COP', name: 'Colombian Peso', symbol: '\$', rate: 3900.0),
    CurrencyRate(code: 'PEN', name: 'Peruvian Sol', symbol: 'S/', rate: 3.7),
    CurrencyRate(code: 'UYU', name: 'Uruguayan Peso', symbol: '\$', rate: 39.0),
    CurrencyRate(code: 'ILS', name: 'Israeli Shekel', symbol: '₪', rate: 3.65),
    CurrencyRate(code: 'HUF', name: 'Hungarian Forint', symbol: 'Ft', rate: 360.0),
    CurrencyRate(code: 'CZK', name: 'Czech Koruna', symbol: 'Kč', rate: 23.2),
    CurrencyRate(code: 'RON', name: 'Romanian Leu', symbol: 'lei', rate: 4.58),
    CurrencyRate(code: 'BGN', name: 'Bulgarian Lev', symbol: 'лв', rate: 1.8),
    CurrencyRate(code: 'HRK', name: 'Croatian Kuna', symbol: 'kn', rate: 7.0),
    CurrencyRate(code: 'ISK', name: 'Icelandic Krona', symbol: 'kr', rate: 137.0),
    CurrencyRate(code: 'UAH', name: 'Ukrainian Hryvnia', symbol: '₴', rate: 38.0),
    CurrencyRate(code: 'KZT', name: 'Kazakhstani Tenge', symbol: '₸', rate: 500.0),
    CurrencyRate(code: 'BDT', name: 'Bangladeshi Taka', symbol: '৳', rate: 109.5),
    CurrencyRate(code: 'LKR', name: 'Sri Lankan Rupee', symbol: 'Rs', rate: 310.0),
  ];

  static double convert(double value, Unit from, Unit to) {
    if (from.id == to.id) return value;

    // Special handling for temperature
    if (from.id == 'c' && to.id == 'f') return (value * 9 / 5) + 32;
    if (from.id == 'f' && to.id == 'c') return (value - 32) * 5 / 9;
    if (from.id == 'c' && to.id == 'k') return value + 273.15;
    if (from.id == 'k' && to.id == 'c') return value - 273.15;
    if (from.id == 'f' && to.id == 'k') return (value - 32) * 5 / 9 + 273.15;
    if (from.id == 'k' && to.id == 'f') return (value - 273.15) * 9 / 5 + 32;
    if (from.id == 'c' && to.id == 'r') return (value + 273.15) * 9 / 5;
    if (from.id == 'r' && to.id == 'c') return value * 5 / 9 - 273.15;
    if (from.id == 'f' && to.id == 'r') return value + 459.67;
    if (from.id == 'r' && to.id == 'f') return value - 459.67;
    if (from.id == 'k' && to.id == 'r') return value * 9 / 5;
    if (from.id == 'r' && to.id == 'k') return value * 5 / 9;

    // Standard conversion: convert to base then to target
    double baseValue = value * from.factor;
    return baseValue / to.factor;
  }

  static String formatNumber(double value, {int maxDecimals = 6}) {
    if (value == 0) return '0';
    if (value.isInfinite || value.isNaN) return 'Error';

    // Check if it's essentially an integer
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    // Format with appropriate decimals
    String result = value.toStringAsFixed(maxDecimals);
    // Remove trailing zeros
    result = result.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');

    // Use scientific notation for very small or large numbers
    if (value.abs() > 1e9 || (value.abs() < 1e-6 && value != 0)) {
      return value.toStringAsExponential(4);
    }

    return result;
  }
}
