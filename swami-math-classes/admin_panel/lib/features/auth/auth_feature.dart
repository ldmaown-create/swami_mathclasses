import 'package:flutter/material.dart';

import '../../core/models/admin_models.dart';
import '../../core/widgets/admin_components.dart';

class AuthFeature extends StatefulWidget {
  const AuthFeature({
    required this.view,
    required this.onLogin,
    required this.onReturnToLogin,
    super.key,
  });

  final AuthView view;
  final void Function(String email, String password) onLogin;
  final VoidCallback onReturnToLogin;

  @override
  State<AuthFeature> createState() => _AuthFeatureState();
}

class _AuthFeatureState extends State<AuthFeature> {
  final _emailController = TextEditingController(text: 'admin@smc.edu.in');
  final _passwordController = TextEditingController(text: 'admin123');
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF050505), Color(0xFF0B0B0B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 40,
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 8),
                          const _AuthBrandBlock(),
                          const SizedBox(height: 20),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            child: switch (widget.view) {
                              AuthView.login => _buildLoginCard(context),
                              AuthView.loading => _buildLoadingCard(context),
                              AuthView.invalidCredentials => _buildMessageCard(
                                  context,
                                  title: 'Invalid Credentials',
                                  message: 'The email or password is incorrect. Use any email containing "invalid" to verify this static state.',
                                  color: BrandColors.error,
                                  primaryLabel: 'Retry Login',
                                  onPrimary: widget.onReturnToLogin,
                                ),
                              AuthView.unauthorized => _buildMessageCard(
                                  context,
                                  title: 'Unauthorized Role',
                                  message: 'This account authenticated successfully but does not have the admin role required for desktop access.',
                                  color: BrandColors.error,
                                  primaryLabel: 'Go Back',
                                  onPrimary: widget.onReturnToLogin,
                                ),
                              AuthView.sessionExpired => _buildMessageCard(
                                  context,
                                  title: 'Session Expired',
                                  message: 'For security reasons, your session timed out. Please log in again to continue managing the dashboard.',
                                  color: BrandColors.accent,
                                  primaryLabel: 'Login Again',
                                  onPrimary: widget.onReturnToLogin,
                                ),
                              AuthView.networkError => _buildMessageCard(
                                  context,
                                  title: 'Network Retry Required',
                                  message: 'The admin app could not reach the authentication service. Retry when connectivity is restored.',
                                  color: BrandColors.warning,
                                  primaryLabel: 'Retry',
                                  onPrimary: widget.onReturnToLogin,
                                ),
                              AuthView.authenticated => const SizedBox.shrink(),
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard(BuildContext context) {
    return SurfaceCard(
      key: const ValueKey('login_card'),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Admin Login',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Access the secure administrative dashboard.',
            style: TextStyle(color: BrandColors.textSecondary),
          ),
          const SizedBox(height: 28),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email Address'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: _obscureText,
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(
                onPressed: () => setState(() => _obscureText = !_obscureText),
                icon: Icon(
                  _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: AccentButton(
              label: 'Login to Admin Panel',
              onPressed: () => widget.onLogin(
                _emailController.text,
                _passwordController.text,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Static auth states for QA: use emails containing invalid, unauth, expired, or network.',
            style: TextStyle(color: BrandColors.textSecondary, fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    return SurfaceCard(
      key: const ValueKey('loading_card'),
      padding: const EdgeInsets.all(36),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: CircularProgressIndicator(
              color: BrandColors.accent,
              strokeWidth: 4,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Signing In...',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 12),
          Text(
            'Verifying administrative credentials',
            style: TextStyle(color: BrandColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard(
    BuildContext context, {
    required String title,
    required String message,
    required Color color,
    required String primaryLabel,
    required VoidCallback onPrimary,
  }) {
    return SurfaceCard(
      key: ValueKey(title),
      padding: const EdgeInsets.all(36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shield_outlined, size: 56, color: color),
          const SizedBox(height: 20),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: BrandColors.textSecondary),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: AccentButton(label: primaryLabel, onPressed: onPrimary),
          ),
        ],
      ),
    );
  }
}

class _AuthBrandBlock extends StatelessWidget {
  const _AuthBrandBlock();

  @override
  Widget build(BuildContext context) {
    return const AdminBrandLogo(
      width: 230,
      showSubtitle: false,
    );
  }
}
