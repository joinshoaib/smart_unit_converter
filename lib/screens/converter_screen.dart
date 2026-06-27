import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../models/unit_models.dart';
import '../providers/app_provider.dart';
import '../utils/unit_data.dart';
import '../widgets/category_card.dart';
import '../widgets/converter_panel.dart';
import '../widgets/unit_selector.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  UnitCategory? _selectedCategory;
  Unit? _fromUnit;
  Unit? _toUnit;
  final _inputController = TextEditingController(text: '1');
  double _result = 0;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appProvider = context.read<AppProvider>();
      final lastCat = appProvider.lastCategory;
      final category = UnitData.categories.firstWhere(
        (c) => c.id == lastCat,
        orElse: () => UnitData.categories.first,
      );
      _selectCategory(category);
    });
  }

  void _selectCategory(UnitCategory category) {
    setState(() {
      _selectedCategory = category;
      _fromUnit = category.units.first;
      _toUnit = category.units.length > 1
          ? category.units[1]
          : category.units.first;
    });
    context.read<AppProvider>().setLastCategory(category.id);
    _calculate();
  }

  void _calculate() {
    if (_fromUnit == null || _toUnit == null) return;
    final input = double.tryParse(_inputController.text) ?? 0;
    setState(() {
      _result = UnitData.convert(input, _fromUnit!, _toUnit!);
    });
  }

  void _swapUnits() {
    setState(() {
      final temp = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = temp;
    });
    _calculate();
  }

  void _saveToHistory() {
    if (_fromUnit == null || _toUnit == null) return;
    final input = double.tryParse(_inputController.text) ?? 0;
    final record = ConversionRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      categoryName: _selectedCategory!.name,
      fromUnit: '${input.toStringAsFixed(2)} ${_fromUnit!.symbol}',
      toUnit: '${UnitData.formatNumber(_result)} ${_toUnit!.symbol}',
      inputValue: input,
      resultValue: _result,
      timestamp: DateTime.now(),
    );
    context.read<AppProvider>().addToHistory(record);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved to history'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = UnitData.categories;
    final filteredCategories = _searchQuery.isEmpty
        ? categories
        : categories
              .where(
                (c) =>
                    c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    c.description.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
              )
              .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: Text(
              'Smart Converter',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search categories...',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () => setState(() => _searchQuery = ''),
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
          if (_selectedCategory == null)
            SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final cat = filteredCategories[index];
                  return CategoryCard(
                    category: cat,
                    onTap: () => _selectCategory(cat),
                  ).animate(delay: (index * 50).ms).fadeIn().slideY(begin: 0.3);
                }, childCount: filteredCategories.length),
              ),
            )
          else
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Back button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () =>
                              setState(() => _selectedCategory = null),
                          icon: Icon(Icons.arrow_back),
                        ),
                        Text(
                          _selectedCategory!.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: _saveToHistory,
                          icon: Icon(Icons.bookmark_border),
                          tooltip: 'Save to history',
                        ),
                      ],
                    ),
                  ),
                  // Converter Panel
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        // Input
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'From',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: TextField(
                                        controller: _inputController,
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                              decimal: true,
                                            ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d*\.?\d*'),
                                          ),
                                        ],
                                        onChanged: (_) => _calculate(),
                                        style: theme.textTheme.headlineSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                        decoration: InputDecoration(
                                          hintText: '0',
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      flex: 1,
                                      child: UnitSelector(
                                        units: _selectedCategory!.units,
                                        selected: _fromUnit,
                                        onSelected: (u) {
                                          setState(() => _fromUnit = u);
                                          _calculate();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        // Swap button
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.3,
                                ),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: _swapUnits,
                            icon: Icon(Icons.swap_vert, color: Colors.white),
                            iconSize: 28,
                          ),
                        ),
                        SizedBox(height: 8),
                        // Output
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'To',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        UnitData.formatNumber(_result),
                                        style: theme.textTheme.headlineSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: theme.colorScheme.primary,
                                            ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      flex: 1,
                                      child: UnitSelector(
                                        units: _selectedCategory!.units,
                                        selected: _toUnit,
                                        onSelected: (u) {
                                          setState(() => _toUnit = u);
                                          _calculate();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        // Formula display
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest
                                .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '1 ${_fromUnit?.symbol} = ${UnitData.formatNumber(UnitData.convert(1, _fromUnit!, _toUnit!))} ${_toUnit?.symbol}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
