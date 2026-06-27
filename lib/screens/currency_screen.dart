import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/currency_provider.dart';
import '../providers/app_provider.dart';
import '../models/unit_models.dart';
import '../utils/unit_data.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final _amountController = TextEditingController(text: '100');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CurrencyProvider>().fetchLiveRates();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Consumer<CurrencyProvider>(
        builder: (context, provider, child) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                title: Text('Currency Converter', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                actions: [
                  IconButton(
                    onPressed: () => provider.fetchLiveRates(),
                    icon: provider.isLoading
                        ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Icon(Icons.refresh),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (provider.lastUpdated != null)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Rates updated: ${_formatDate(provider.lastUpdated!)}',
                            style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary),
                          ),
                        ),
                      if (provider.error != null)
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.errorContainer.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.wifi_off, size: 16, color: theme.colorScheme.error),
                              SizedBox(width: 8),
                              Expanded(child: Text(provider.error!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error))),
                            ],
                          ),
                        ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                        onChanged: (v) {
                          final val = double.tryParse(v) ?? 0;
                          provider.setAmount(val);
                        },
                        style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: '0.00',
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 16, right: 8),
                            child: Text(provider.fromRate?.symbol ?? '\$', style: theme.textTheme.titleLarge),
                          ),
                          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _CurrencySelector(
                              label: 'From',
                              selected: provider.fromRate,
                              currencies: provider.currencies,
                              onSelect: (c) => provider.setFromCurrency(c.code),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: provider.swapCurrencies,
                                icon: Icon(Icons.swap_horiz, color: Colors.white),
                              ),
                            ),
                          ),
                          Expanded(
                            child: _CurrencySelector(
                              label: 'To',
                              selected: provider.toRate,
                              currencies: provider.currencies,
                              onSelect: (c) => provider.setToCurrency(c.code),
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
                            colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${provider.toRate?.symbol ?? ''}${UnitData.formatNumber(provider.convertedAmount)}',
                              style: theme.textTheme.headlineLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '1 ${provider.fromRate?.code} = ${UnitData.formatNumber(provider.convertedAmount / (provider.amount == 0 ? 1 : provider.amount))} ${provider.toRate?.code}',
                              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      ).animate().fadeIn().scale(begin: Offset(0.95, 0.95)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _CurrencySelector extends StatelessWidget {
  final String label;
  final CurrencyRate? selected;
  final List<CurrencyRate> currencies;
  final Function(CurrencyRate) onSelect;

  const _CurrencySelector({
    required this.label,
    required this.selected,
    required this.currencies,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => _showCurrencyPicker(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  selected?.code ?? 'USD',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Icon(Icons.keyboard_arrow_down),
              ],
            ),
            SizedBox(height: 4),
            Text(
              selected?.name ?? '',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context) {
    final theme = Theme.of(context);
    final searchController = TextEditingController();
    var filtered = currencies;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: TextField(
                  controller: searchController,
                  onChanged: (v) => setState(() {
                    final lower = v.toLowerCase();
                    filtered = currencies.where((c) =>
                      c.name.toLowerCase().contains(lower) ||
                      c.code.toLowerCase().contains(lower)
                    ).toList();
                  }),
                  decoration: InputDecoration(
                    hintText: 'Search currency...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final c = filtered[index];
                    final isSelected = c.code == selected?.code;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surfaceContainerHighest,
                        child: Text(
                          c.code.substring(0, 1),
                          style: TextStyle(
                            color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(c.name),
                      subtitle: Text(c.code),
                      trailing: isSelected ? Icon(Icons.check_circle, color: theme.colorScheme.primary) : null,
                      onTap: () {
                        onSelect(c);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
