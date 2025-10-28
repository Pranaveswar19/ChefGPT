import 'package:flutter/material.dart';

class IngredientChip extends StatelessWidget {
  final String label;
  final VoidCallback onDeleted;

  const IngredientChip({
    super.key,
    required this.label,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.close, size: 18),
      onDeleted: onDeleted,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      labelStyle:
          TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
    );
  }
}
