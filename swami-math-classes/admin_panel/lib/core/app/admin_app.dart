import 'package:flutter/material.dart';

import '../data/admin_mock_store.dart';
import '../models/admin_models.dart';
import '../theme/admin_theme.dart';
import '../widgets/admin_shell.dart';
import '../../features/auth/auth_feature.dart';

class AdminApp extends StatefulWidget {
  const AdminApp({super.key});

  @override
  State<AdminApp> createState() => _AdminAppState();
}

class _AdminAppState extends State<AdminApp> {
  final AdminMockStore _store = AdminMockStore.seeded();
  AuthView _authView = AuthView.login;
  AdminSection _section = AdminSection.dashboard;

  void _handleLogin(String email, String password) {
    setState(() {
      _authView = AuthView.loading;
    });

    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) {
        return;
      }

      final normalizedEmail = email.toLowerCase().trim();
      if (normalizedEmail.contains('network')) {
        setState(() => _authView = AuthView.networkError);
        return;
      }
      if (normalizedEmail.contains('expired')) {
        setState(() => _authView = AuthView.sessionExpired);
        return;
      }
      if (normalizedEmail.contains('unauth')) {
        setState(() => _authView = AuthView.unauthorized);
        return;
      }
      if (normalizedEmail.contains('invalid') || password.trim().length < 6) {
        setState(() => _authView = AuthView.invalidCredentials);
        return;
      }

      setState(() {
        _authView = AuthView.authenticated;
        _section = AdminSection.dashboard;
      });
    });
  }

  void _returnToLogin() {
    setState(() => _authView = AuthView.login);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swami Math Classes Admin',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: buildAdminTheme(),
      home: _authView == AuthView.authenticated
          ? AdminShell(
              store: _store,
              currentSection: _section,
              onSectionChanged: (section) => setState(() => _section = section),
              onLogout: _returnToLogin,
            )
          : AuthFeature(
              view: _authView,
              onLogin: _handleLogin,
              onReturnToLogin: _returnToLogin,
            ),
    );
  }
}
