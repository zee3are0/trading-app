import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PlText extends StatelessWidget {
  final double value;
  final TextStyle? style;
  final bool showSign;
  final bool compact;

  const PlText({
    super.key,
    required this.value,
    this.style,
    this.showSign = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = value > 0
        ? Colors.green
        : value < 0
            ? Colors.red
            : null;
    final prefix = showSign && value > 0 ? '+' : '';
    final formatted = compact
        ? _formatCompact(value)
        : NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(value);

    return Text(
      '$prefix$formatted',
      style: (style ?? const TextStyle()).copyWith(color: color),
    );
  }

  static String _formatCompact(double v) {
    final abs = v.abs();
    if (abs >= 1000000) return '\$${(v / 1000000).toStringAsFixed(1)}M';
    if (abs >= 1000) return '\$${(v / 1000).toStringAsFixed(1)}K';
    return '\$${v.toStringAsFixed(2)}';
  }
}
