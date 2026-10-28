import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color? color;

  const StatusBadge({super.key, required this.label, this.color});

  factory StatusBadge.ok([String label = 'OK']) =>
      StatusBadge(label: label, color: Colors.green);

  factory StatusBadge.warning([String label = 'Warning']) =>
      StatusBadge(label: label, color: Colors.orange);

  factory StatusBadge.error([String label = 'Error']) =>
      StatusBadge(label: label, color: Colors.red);

  factory StatusBadge.fromStatus(String status) {
    switch (status.toLowerCase()) {
      case 'ok':
      case 'active':
      case 'approved':
      case 'connected':
        return StatusBadge.ok(status);
      case 'degraded':
      case 'pending':
      case 'pending_review':
        return StatusBadge.warning(status);
      case 'down':
      case 'error':
      case 'rejected':
      case 'disconnected':
        return StatusBadge.error(status);
      default:
        return StatusBadge(label: status);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.outline;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: c.withValues(alpha: 0.4)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: c,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
