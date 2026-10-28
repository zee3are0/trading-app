import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';

class AuthGate extends StatelessWidget {
  final Widget child;

  const AuthGate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!auth.isSignedIn) {
      return const _LoginScreen();
    }

    return child;
  }
}

class _LoginScreen extends StatefulWidget {
  const _LoginScreen();

  @override
  State<_LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<_LoginScreen> {
  bool _signingIn = false;
  String? _error;

  Future<void> _handleSignIn() async {
    setState(() {
      _signingIn = true;
      _error = null;
    });

    final auth = context.read<AuthProvider>();
    final success = await auth.signIn();

    if (mounted) {
      setState(() {
        _signingIn = false;
        if (!success) _error = 'Sign-in cancelled or failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.show_chart, size: 72, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text('Trading Bot', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text('Sign in to continue', style: theme.textTheme.bodyLarge),
              const SizedBox(height: 32),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
                ),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _signingIn ? null : _handleSignIn,
                  icon: _signingIn
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.login),
                  label: Text(_signingIn ? 'Signing in...' : 'Sign in with Google'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
