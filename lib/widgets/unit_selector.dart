import 'package:flutter/material.dart';
import '../models/unit_models.dart';

class UnitSelector extends StatelessWidget {
  final List<Unit> units;
  final Unit? selected;
  final Function(Unit) onSelected;

  const UnitSelector({
    super.key,
    required this.units,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => _showUnitPicker(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                selected?.symbol ?? 'Select',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
    );
  }

  void _showUnitPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemCount: units.length,
        itemBuilder: (context, index) {
          final unit = units[index];
          return ListTile(
            title: Text(unit.name),
            trailing: Text(unit.symbol, style: TextStyle(fontWeight: FontWeight.bold)),
            selected: unit.id == selected?.id,
            onTap: () {
              onSelected(unit);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
