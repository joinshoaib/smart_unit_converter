import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../utils/unit_data.dart';
import 'dart:math' as math;

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            title: Text(
              'Tools',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(icon: Icon(Icons.calculate), text: 'Calculator'),
                Tab(icon: Icon(Icons.receipt_long), text: 'GST/Tax'),
                Tab(icon: Icon(Icons.access_time), text: 'Time Zone'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [_CalculatorTab(), _GstCalculatorTab(), _TimeZoneTab()],
        ),
      ),
    );
  }
}

class _CalculatorTab extends StatefulWidget {
  @override
  State<_CalculatorTab> createState() => _CalculatorTabState();
}

class _CalculatorTabState extends State<_CalculatorTab> {
  String _display = '0';
  String _equation = '';
  double? _firstOperand;
  String? _operation;
  bool _shouldResetDisplay = false;

  void _onNumber(String num) {
    setState(() {
      if (_display == '0' || _shouldResetDisplay) {
        _display = num;
        _shouldResetDisplay = false;
      } else {
        _display += num;
      }
    });
  }

  void _onDecimal() {
    if (!_display.contains('.')) {
      setState(() => _display += '.');
    }
  }

  void _onOperation(String op) {
    setState(() {
      _firstOperand = double.tryParse(_display);
      _operation = op;
      _equation = '$_display $op';
      _shouldResetDisplay = true;
    });
  }

  void _onScientific(String func) {
    final val = double.tryParse(_display) ?? 0;
    double result = 0;
    switch (func) {
      case 'sin':
        result = math.sin(_toRadians(val));
        break;
      case 'cos':
        result = math.cos(_toRadians(val));
        break;
      case 'tan':
        result = math.tan(_toRadians(val));
        break;
      case 'log':
        result = math.log(val) / math.ln10;
        break;
      case 'ln':
        result = math.log(val);
        break;
      case 'sqrt':
        result = math.sqrt(val);
        break;
      case 'x\u00b2':
        result = val * val;
        break;
      case '1/x':
        result = 1 / val;
        break;
      case '\u03c0':
        result = math.pi;
        break;
      case 'e':
        result = math.e;
        break;
    }
    setState(() {
      _display = UnitData.formatNumber(result);
      _equation = '$func($_display)';
    });
  }

  double _toRadians(double deg) => deg * math.pi / 180;

  void _onEquals() {
    if (_operation == null || _firstOperand == null) return;
    final second = double.tryParse(_display) ?? 0;
    double result = 0;
    switch (_operation) {
      case '+':
        result = _firstOperand! + second;
        break;
      case '-':
        result = _firstOperand! - second;
        break;
      case '\u00d7':
        result = _firstOperand! * second;
        break;
      case '\u00f7':
        result = second != 0 ? _firstOperand! / second : double.infinity;
        break;
      case '%':
        result = _firstOperand! % second;
        break;
      case '^':
        result = math.pow(_firstOperand!, second).toDouble();
        break;
    }
    setState(() {
      _equation = '$_firstOperand ${_operation!} $second =';
      _display = result.isInfinite || result.isNaN
          ? 'Error'
          : UnitData.formatNumber(result);
      _firstOperand = null;
      _operation = null;
      _shouldResetDisplay = true;
    });
  }

  void _onClear() => setState(() {
    _display = '0';
    _equation = '';
    _firstOperand = null;
    _operation = null;
  });

  void _onDelete() => setState(() {
    if (_display.length > 1) {
      _display = _display.substring(0, _display.length - 1);
    } else {
      _display = '0';
    }
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _equation,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  _display,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                [
                      'sin',
                      'cos',
                      'tan',
                      'log',
                      'ln',
                      'sqrt',
                      'x\u00b2',
                      '1/x',
                      '\u03c0',
                      'e',
                      '^',
                    ]
                    .map(
                      (f) => ActionChip(
                        label: Text(f, style: theme.textTheme.labelSmall),
                        onPressed: () => _onScientific(f),
                        backgroundColor: theme.colorScheme.secondaryContainer
                            .withOpacity(0.5),
                      ),
                    )
                    .toList(),
          ),
          SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              childAspectRatio: 1.3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                _CalcButton('C', theme.colorScheme.error, _onClear),
                _CalcButton(
                  '\u232b',
                  theme.colorScheme.onSurfaceVariant,
                  _onDelete,
                ),
                _CalcButton(
                  '%',
                  theme.colorScheme.primary,
                  () => _onOperation('%'),
                ),
                _CalcButton(
                  '\u00f7',
                  theme.colorScheme.primary,
                  () => _onOperation('\u00f7'),
                ),
                _CalcButton('7', null, () => _onNumber('7')),
                _CalcButton('8', null, () => _onNumber('8')),
                _CalcButton('9', null, () => _onNumber('9')),
                _CalcButton(
                  '\u00d7',
                  theme.colorScheme.primary,
                  () => _onOperation('\u00d7'),
                ),
                _CalcButton('4', null, () => _onNumber('4')),
                _CalcButton('5', null, () => _onNumber('5')),
                _CalcButton('6', null, () => _onNumber('6')),
                _CalcButton(
                  '-',
                  theme.colorScheme.primary,
                  () => _onOperation('-'),
                ),
                _CalcButton('1', null, () => _onNumber('1')),
                _CalcButton('2', null, () => _onNumber('2')),
                _CalcButton('3', null, () => _onNumber('3')),
                _CalcButton(
                  '+',
                  theme.colorScheme.primary,
                  () => _onOperation('+'),
                ),
                _CalcButton('0', null, () => _onNumber('0')),
                _CalcButton('.', null, _onDecimal),
                _CalcButton(
                  '=',
                  theme.colorScheme.primary,
                  _onEquals,
                  isFilled: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _CalcButton(
    String label,
    Color? color,
    VoidCallback onTap, {
    bool isFilled = false,
  }) {
    final theme = Theme.of(context);
    return Material(
      color: isFilled
          ? (color ?? theme.colorScheme.primary)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: isFilled
              ? null
              : BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
          child: Center(
            child: Text(
              label,
              style: theme.textTheme.titleLarge?.copyWith(
                color: isFilled
                    ? Colors.white
                    : (color ?? theme.colorScheme.onSurface),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GstCalculatorTab extends StatefulWidget {
  @override
  State<_GstCalculatorTab> createState() => _GstCalculatorTabState();
}

class _GstCalculatorTabState extends State<_GstCalculatorTab> {
  final _amountController = TextEditingController();
  double _taxRate = 18.0;
  bool _isInclusive = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final amount = double.tryParse(_amountController.text) ?? 0;

    final taxAmount = _isInclusive
        ? amount * _taxRate / (100 + _taxRate)
        : amount * _taxRate / 100;
    final total = _isInclusive ? amount : amount + taxAmount;
    final baseAmount = _isInclusive ? amount - taxAmount : amount;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'Amount',
              prefixIcon: Icon(Icons.attach_money),
            ),
            style: theme.textTheme.headlineSmall,
          ),
          SizedBox(height: 20),
          Text('Tax Rate', style: theme.textTheme.titleMedium),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              ...[5, 12, 18, 28].map(
                (r) => ChoiceChip(
                  label: Text('$r%'),
                  selected: _taxRate == r.toDouble(),
                  onSelected: (_) => setState(() => _taxRate = r.toDouble()),
                ),
              ),
              ActionChip(
                label: Text('Custom'),
                onPressed: () => _showCustomTaxDialog(context),
              ),
            ],
          ),
          SizedBox(height: 8),
          Slider(
            value: _taxRate,
            min: 0,
            max: 50,
            divisions: 100,
            label: '${_taxRate.toStringAsFixed(1)}%',
            onChanged: (v) => setState(() => _taxRate = v),
          ),
          SizedBox(height: 16),
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(value: false, label: Text('Exclusive')),
              ButtonSegment(value: true, label: Text('Inclusive')),
            ],
            selected: {_isInclusive},
            onSelectionChanged: (s) => setState(() => _isInclusive = s.first),
          ),
          SizedBox(height: 24),
          Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  _ResultRow('Base Amount', baseAmount, theme),
                  Divider(),
                  _ResultRow(
                    'Tax (${_taxRate.toStringAsFixed(1)}%)',
                    taxAmount,
                    theme,
                    isHighlight: true,
                  ),
                  Divider(),
                  _ResultRow('Total Amount', total, theme, isTotal: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomTaxDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Custom Tax Rate'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Rate (%)', suffixText: '%'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final rate = double.tryParse(controller.text);
              if (rate != null) setState(() => _taxRate = rate);
              Navigator.pop(context);
            },
            child: Text('Apply'),
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final double value;
  final ThemeData theme;
  final bool isHighlight;
  final bool isTotal;

  const _ResultRow(
    this.label,
    this.value,
    this.theme, {
    this.isHighlight = false,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: isTotal ? FontWeight.bold : null,
            ),
          ),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isTotal
                  ? theme.colorScheme.primary
                  : (isHighlight ? theme.colorScheme.secondary : null),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeZoneTab extends StatefulWidget {
  @override
  State<_TimeZoneTab> createState() => _TimeZoneTabState();
}

class _TimeZoneTabState extends State<_TimeZoneTab> {
  DateTime _selectedTime = DateTime.now();
  String _fromZone = 'UTC';
  String _toZone = 'Asia/Tokyo';

  final List<Map<String, String>> _timeZones = [
    {'name': 'UTC', 'offset': '+00:00'},
    {'name': 'New York (EST)', 'offset': '-05:00'},
    {'name': 'Los Angeles (PST)', 'offset': '-08:00'},
    {'name': 'London (GMT)', 'offset': '+00:00'},
    {'name': 'Paris (CET)', 'offset': '+01:00'},
    {'name': 'Berlin (CET)', 'offset': '+01:00'},
    {'name': 'Moscow (MSK)', 'offset': '+03:00'},
    {'name': 'Dubai (GST)', 'offset': '+04:00'},
    {'name': 'Mumbai (IST)', 'offset': '+05:30'},
    {'name': 'Bangkok (ICT)', 'offset': '+07:00'},
    {'name': 'Singapore (SGT)', 'offset': '+08:00'},
    {'name': 'Hong Kong (HKT)', 'offset': '+08:00'},
    {'name': 'Shanghai (CST)', 'offset': '+08:00'},
    {'name': 'Seoul (KST)', 'offset': '+09:00'},
    {'name': 'Tokyo (JST)', 'offset': '+09:00'},
    {'name': 'Sydney (AEDT)', 'offset': '+11:00'},
    {'name': 'Auckland (NZDT)', 'offset': '+13:00'},
  ];

  DateTime _convertTime(DateTime time, String fromOffset, String toOffset) {
    Duration parseOffset(String o) {
      final sign = o.startsWith('-') ? -1 : 1;
      final parts = o.substring(1).split(':');
      final hours = int.parse(parts[0]);
      final mins = parts.length > 1 ? int.parse(parts[1]) : 0;
      return Duration(hours: hours * sign, minutes: mins * sign);
    }

    final fromDur = parseOffset(fromOffset);
    final toDur = parseOffset(toOffset);
    final utc = time.subtract(fromDur);
    return utc.add(toDur);
  }

  String _getOffset(String zoneName) {
    return _timeZones.firstWhere(
      (z) => z['name'] == zoneName,
      orElse: () => {'name': 'UTC', 'offset': '+00:00'},
    )['offset']!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fromOffset = _getOffset(_fromZone);
    final toOffset = _getOffset(_toZone);
    final converted = _convertTime(_selectedTime, fromOffset, toOffset);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.access_time),
              title: Text('Select Time'),
              subtitle: Text(
                DateFormat('MMM d, yyyy \u2022 h:mm a').format(_selectedTime),
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(_selectedTime),
                );
                if (time != null) {
                  setState(() {
                    _selectedTime = DateTime(
                      _selectedTime.year,
                      _selectedTime.month,
                      _selectedTime.day,
                      time.hour,
                      time.minute,
                    );
                  });
                }
              },
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _ZoneSelector(
                  'From',
                  _fromZone,
                  _timeZones,
                  (z) => setState(() => _fromZone = z),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(
                  Icons.arrow_forward,
                  color: theme.colorScheme.primary,
                ),
              ),
              Expanded(
                child: _ZoneSelector(
                  'To',
                  _toZone,
                  _timeZones,
                  (z) => setState(() => _toZone = z),
                ),
              ),
            ],
          ),
          SizedBox(height: 32),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  DateFormat('h:mm a').format(converted),
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(converted),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '$_toZone ($toOffset)',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _formatTimeDiff(fromOffset, toOffset),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeDiff(String from, String to) {
    Duration parse(String o) {
      final sign = o.startsWith('-') ? -1 : 1;
      final p = o.substring(1).split(':');
      return Duration(
        hours: int.parse(p[0]) * sign,
        minutes: (p.length > 1 ? int.parse(p[1]) : 0) * sign,
      );
    }

    final diff = parse(to).inMinutes - parse(from).inMinutes;
    final hours = diff.abs() ~/ 60;
    final mins = diff.abs() % 60;
    final ahead = diff >= 0 ? 'ahead' : 'behind';
    return '${hours}h${mins > 0 ? ' ${mins}m' : ''} $ahead of ${_fromZone.split(' ').first}';
  }
}

class _ZoneSelector extends StatelessWidget {
  final String label;
  final String selected;
  final List<Map<String, String>> zones;
  final Function(String) onSelect;

  const _ZoneSelector(this.label, this.selected, this.zones, this.onSelect);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: () => _showPicker(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.3),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selected.split(' ').first,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  selected.contains('(')
                      ? selected.substring(selected.indexOf('('))
                      : '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemCount: zones.length,
        itemBuilder: (context, i) {
          final z = zones[i];
          return ListTile(
            title: Text(z['name']!),
            trailing: Text(z['offset']!, style: TextStyle(color: Colors.grey)),
            selected: z['name'] == selected,
            onTap: () {
              onSelect(z['name']!);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
