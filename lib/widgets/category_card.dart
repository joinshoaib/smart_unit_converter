import 'package:flutter/material.dart';
import '../models/unit_models.dart';

class CategoryCard extends StatelessWidget {
  final UnitCategory category;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconData = _getIcon(category.icon);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12), // was 16
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8), // was 10
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  iconData,
                  color: theme.colorScheme.primary,
                  size: 22,
                ), // was 24
              ),
              SizedBox(height: 8), // was 12
              Text(
                category.name,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2), // was 4
              Text(
                '${category.units.length} units',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'ruler':
        return Icons.straighten;
      case 'scale':
        return Icons.scale;
      case 'thermometer':
        return Icons.thermostat;
      case 'beaker':
        return Icons.water_drop;
      case 'square':
        return Icons.square_foot;
      case 'speed':
        return Icons.speed;
      case 'clock':
        return Icons.schedule;
      case 'database':
        return Icons.storage;
      case 'zap':
        return Icons.bolt;
      case 'gauge':
        return Icons.speed;
      default:
        return Icons.category;
    }
  }
}
