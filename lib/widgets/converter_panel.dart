import 'package:flutter/material.dart';

class ConverterPanel extends StatelessWidget {
  final String label;
  final String value;
  final Widget selector;
  final bool isOutput;

  const ConverterPanel({
    super.key,
    required this.label,
    required this.value,
    required this.selector,
    this.isOutput = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: isOutput ? theme.colorScheme.secondary : theme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isOutput ? theme.colorScheme.primary : null,
                    ),
                  ),
                ),
                selector,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
