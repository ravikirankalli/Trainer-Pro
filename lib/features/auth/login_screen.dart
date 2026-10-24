import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../dashboard/dashboard_screen.dart';
import 'auth_service.dart';
import 'widgets/brand_wave.dart';
import 'widgets/trust_branding.dart';

/// Trainer Pro login screen: gym photograph header, white rounded login panel,
/// decorative wave and Andhra Educational Trust branding.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _trainerIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _obscurePassword = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _trainerIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    FocusScope.of(context).unfocus();
    if (_isSubmitting) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final result = await _authService.login(
      trainerId: _trainerIdController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (result.success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
      return;
    }

    setState(() => _errorMessage = result.message);
  }

  Future<void> _onForgotPasswordPressed() async {
    final email = await showDialog<String>(
      context: context,
      builder: (_) => const _ForgotPasswordDialog(),
    );
    if (email == null || email.isEmpty || !mounted) return;

    final result = await _authService.requestPasswordReset(email);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message ?? 'Request sent.'),
        backgroundColor:
            result.success ? AppColors.navy : AppColors.secondaryRed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final headerHeight = size.height * 0.46;
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final bottomSafeArea = MediaQuery.paddingOf(context).bottom;
    final isKeyboardOpen = keyboardInset > 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      // The layout is sized to the full screen and manages the keyboard inset
      // itself, so the Scaffold must not resize the body as well.
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: size.height,
        child: Stack(
          children: [
            // Section A - gym photograph header.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: headerHeight,
              child: Image.asset(
                'assets/images/login_header.webp',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),

            // Sections B-H - login panel overlapping the photograph.
            Positioned(
              top: headerHeight - 32,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.panel,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(34),
                  ),
                ),
                child: Column(
                  children: [
                    // Only the form scrolls, and only when it has to; the wave
                    // and the trust branding below stay pinned to the bottom
                    // of the panel so they are always visible.
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: keyboardInset),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            _buildHeading(),
                            const SizedBox(height: 22),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    _buildTrainerIdField(),
                                    const SizedBox(height: 14),
                                    _buildPasswordField(),
                                    _buildErrorMessage(),
                                    const SizedBox(height: 20),
                                    _buildLoginButton(),
                                    const SizedBox(height: 12),
                                    _buildForgotPassword(),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),

                    // Sections G and H - hidden while the keyboard is up so
                    // the form keeps the room it needs.
                    if (!isKeyboardOpen) ...[
                      const BrandWave(),
                      const SizedBox(height: 10),
                      const TrustBranding(),
                      SizedBox(height: 18 + bottomSafeArea),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeading() {
    return Column(
      children: [
        const Text(
          'Login',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 74,
          height: 3,
          decoration: BoxDecoration(
            color: AppColors.primaryRed,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ],
    );
  }

  Widget _buildTrainerIdField() {
    return TextFormField(
      controller: _trainerIdController,
      textInputAction: TextInputAction.next,
      style: const TextStyle(fontSize: 15, color: AppColors.navy),
      decoration: _inputDecoration(
        hint: 'Trainer ID',
        prefixIcon: Icons.person_outline,
      ),
      validator: (value) => (value == null || value.trim().isEmpty)
          ? 'Please enter your Trainer ID'
          : null,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _onLoginPressed(),
      style: const TextStyle(fontSize: 15, color: AppColors.navy),
      decoration: _inputDecoration(
        hint: 'Password',
        prefixIcon: Icons.lock_outline,
        suffix: IconButton(
          onPressed: () =>
              setState(() => _obscurePassword = !_obscurePassword),
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 20,
            color: AppColors.iconGrey,
          ),
          tooltip: _obscurePassword ? 'Show password' : 'Hide password',
        ),
      ),
      validator: (value) => (value == null || value.isEmpty)
          ? 'Please enter your password'
          : null,
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefixIcon,
    Widget? suffix,
  }) {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide(color: AppColors.inputBorder, width: 1.4),
    );

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 15, color: AppColors.greyText),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      prefixIcon: Icon(prefixIcon, size: 21, color: AppColors.navy),
      suffixIcon: suffix,
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.primaryRed, width: 1.6),
      ),
      errorBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.secondaryRed, width: 1.4),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.secondaryRed, width: 1.6),
      ),
    );
  }

  Widget _buildErrorMessage() {
    final message = _errorMessage;
    if (message == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline,
            size: 18,
            color: AppColors.secondaryRed,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                height: 1.3,
                color: AppColors.secondaryRed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _onLoginPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryRed,
            disabledBackgroundColor: AppColors.primaryRed,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 9),
                    Icon(Icons.arrow_forward, size: 19),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: _onForgotPasswordPressed,
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.link,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.link,
          ),
        ),
      ),
    );
  }
}

/// Collects the e-mail address the backend sends the reset code to.
class _ForgotPasswordDialog extends StatefulWidget {
  const _ForgotPasswordDialog();

  @override
  State<_ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<_ForgotPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(_emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: const Text(
        'Forgot Password',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.navy,
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your registered e-mail address and we will send you a '
              'reset code.',
              style: TextStyle(fontSize: 13.5, color: AppColors.greyText),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autofocus: true,
              onFieldSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                hintText: 'E-mail address',
                prefixIcon: const Icon(
                  Icons.mail_outline,
                  size: 20,
                  color: AppColors.navy,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              validator: (value) {
                final email = value?.trim() ?? '';
                if (email.isEmpty) return 'Please enter your e-mail address';
                final valid = RegExp(
                  r'^[\w.+-]+@[\w-]+\.[\w.-]+$',
                ).hasMatch(email);
                return valid ? null : 'Please enter a valid e-mail address';
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.greyText),
          ),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryRed,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Send'),
        ),
      ],
    );
  }
}
