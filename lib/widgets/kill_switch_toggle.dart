import 'package:flutter/material.dart';

class KillSwitchToggle extends StatelessWidget {
  final bool enabled;
  final bool loading;
  final VoidCallback onToggle;

  const KillSwitchToggle({
    super.key,
    required this.enabled,
    required this.loading,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: enabled ? theme.colorScheme.errorContainer : theme.colorScheme.surfaceContainerHighest,
      child: ListTile(
        leading: Icon(
          enabled ? Icons.block : Icons.check_circle_outline,
          color: enabled ? theme.colorScheme.error : Colors.green,
          size: 28,
        ),
        title: Text(
          enabled ? 'Kill Switch ACTIVE' : 'Kill Switch OFF',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: enabled ? theme.colorScheme.error : null,
          ),
        ),
        subtitle: Text(enabled ? 'All trading is halted' : 'Trading is enabled'),
        trailing: loading
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
            : Switch(
                value: enabled,
                onChanged: (_) => _confirmToggle(context),
                activeTrackColor: theme.colorScheme.error,
              ),
      ),
    );
  }

  void _confirmToggle(BuildContext context) {
    final action = enabled ? 'disable' : 'enable';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${action[0].toUpperCase()}${action.substring(1)} Kill Switch?'),
        content: Text(enabled
            ? 'This will resume all trading activity.'
            : 'This will halt ALL trading across all strategies.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              onToggle();
            },
            style: FilledButton.styleFrom(
              backgroundColor: enabled ? Colors.green : Theme.of(context).colorScheme.error,
            ),
            child: Text(action.toUpperCase()),
          ),
        ],
      ),
    );
  }
}
