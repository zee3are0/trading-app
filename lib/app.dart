import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'api/api_client.dart';
import 'auth/auth_gate.dart';
import 'auth/auth_provider.dart';
import 'screens/broker_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/decisions_screen.dart';
import 'screens/recommendations_screen.dart';
import 'screens/strategies_screen.dart';

class TradingApp extends StatelessWidget {
  const TradingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: Builder(builder: (context) {
        return MaterialApp.router(
          title: 'Trading Bot',
          theme: _buildTheme(Brightness.light),
          darkTheme: _buildTheme(Brightness.dark),
          themeMode: ThemeMode.dark,
          routerConfig: _router(context),
        );
      }),
    );
  }

  GoRouter _router(BuildContext context) {
    return GoRouter(
      initialLocation: '/',
      routes: [
        ShellRoute(
          builder: (context, state, child) {
            return AuthGate(
              child: _AppShell(child: child),
            );
          },
          routes: [
            GoRoute(path: '/', builder: (context, state) {
              final client = _getApiClient(context);
              return DashboardScreen(apiClient: client);
            }),
            GoRoute(path: '/broker', builder: (context, state) {
              final client = _getApiClient(context);
              return BrokerScreen(apiClient: client);
            }),
            GoRoute(path: '/strategies', builder: (context, state) {
              final client = _getApiClient(context);
              return StrategiesScreen(apiClient: client);
            }),
            GoRoute(path: '/decisions', builder: (context, state) {
              final client = _getApiClient(context);
              return DecisionsScreen(apiClient: client);
            }),
            GoRoute(path: '/recommendations', builder: (context, state) {
              final client = _getApiClient(context);
              return RecommendationsScreen(apiClient: client);
            }),
            GoRoute(path: '/chat', builder: (context, state) {
              final client = _getApiClient(context);
              return ChatScreen(apiClient: client);
            }),
          ],
        ),
      ],
    );
  }

  ApiClient _getApiClient(BuildContext context) {
    final auth = context.read<AuthProvider>();
    return ApiClient(auth);
  }

  ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1565C0),
      brightness: brightness,
    );
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _AppShell extends StatelessWidget {
  final Widget child;
  const _AppShell({required this.child});

  static const _tabs = [
    (icon: Icons.dashboard, label: 'Dashboard', path: '/'),
    (icon: Icons.account_balance, label: 'Broker', path: '/broker'),
    (icon: Icons.auto_graph, label: 'Strategies', path: '/strategies'),
    (icon: Icons.gavel, label: 'Decisions', path: '/decisions'),
    (icon: Icons.lightbulb, label: 'Recs', path: '/recommendations'),
    (icon: Icons.chat, label: 'Chat', path: '/chat'),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final idx = _tabs.indexWhere((t) => t.path == location);
    return idx >= 0 ? idx : 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_tabs[currentIndex].label),
        actions: [
          if (auth.user != null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => auth.signOut(),
              tooltip: 'Sign out',
            ),
        ],
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => context.go(_tabs[index].path),
        destinations: _tabs
            .map((t) => NavigationDestination(icon: Icon(t.icon), label: t.label))
            .toList(),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
    );
  }
}
