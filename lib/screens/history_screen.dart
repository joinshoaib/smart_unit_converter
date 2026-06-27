import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/unit_models.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appProvider = context.watch<AppProvider>();
    final history = appProvider.history;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: Text('History', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            actions: history.isNotEmpty
                ? [
                    TextButton(
                      onPressed: () => _showClearConfirm(context, appProvider),
                      child: Text('Clear All'),
                    ),
                  ]
                : null,
          ),
          if (history.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history_outlined, size: 64, color: Colors.grey[400]),
                    SizedBox(height: 16),
                    Text('No conversions yet', style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[500])),
                    SizedBox(height: 8),
                    Text('Your recent conversions will appear here', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[400])),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final record = history[index];
                    return _HistoryTile(
                      record: record,
                      onDelete: () => appProvider.deleteHistoryRecord(record.id),
                      onFavorite: () => appProvider.toggleFavorite(record.id),
                    );
                  },
                  childCount: history.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showClearConfirm(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear History?'),
        content: Text('This will delete all conversion records. This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          FilledButton(
            onPressed: () {
              provider.clearHistory();
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final ConversionRecord record;
  final VoidCallback onDelete;
  final VoidCallback onFavorite;

  const _HistoryTile({
    required this.record,
    required this.onDelete,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Slidable(
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onFavorite(),
              backgroundColor: Colors.amber,
              foregroundColor: Colors.white,
              icon: record.isFavorite ? Icons.star : Icons.star_border,
              label: record.isFavorite ? 'Unstar' : 'Star',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => onDelete(),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Card(
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getCategoryIcon(record.categoryName),
                color: theme.colorScheme.primary,
              ),
            ),
            title: Text(
              '${record.fromUnit} \u2192 ${record.toUnit}',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              '${record.categoryName} \u2022 ${DateFormat('MMM d, h:mm a').format(record.timestamp)}',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            trailing: record.isFavorite
                ? Icon(Icons.star, color: Colors.amber, size: 20)
                : null,
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'length': return Icons.straighten;
      case 'weight': return Icons.fitness_center;
      case 'temperature': return Icons.thermostat;
      case 'volume': return Icons.water_drop;
      case 'area': return Icons.square_foot;
      case 'speed': return Icons.speed;
      case 'time': return Icons.schedule;
      case 'data': return Icons.storage;
      case 'energy': return Icons.bolt;
      case 'pressure': return Icons.compress;
      case 'currency': return Icons.currency_exchange;
      default: return Icons.swap_horiz;
    }
  }
}
