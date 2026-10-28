import 'package:flutter/material.dart';

class RefreshScaffold extends StatelessWidget {
  final String title;
  final Future<void> Function() onRefresh;
  final Widget child;
  final List<Widget>? actions;

  const RefreshScaffold({
    super.key,
    required this.title,
    required this.onRefresh,
    required this.child,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: child),
        ],
      ),
    );
  }
}
