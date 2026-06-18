import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:gradution_project_smart_sip/core/validators/app_validators.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';
import 'package:gradution_project_smart_sip/presentation/auth/login_screen.dart';
import 'package:gradution_project_smart_sip/providers/reset_password_provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final S = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildBackToLogin(context, S),
            const SizedBox(height: 20),
            _buildTopIcon(isDark),
            const SizedBox(height: 24),
            Text(
              S.resetPasswordTitle,
              style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
            ),
            _buildSubTitle(S),
            const SizedBox(height: 40),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: isDark ?Colors.black : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50), 
                    topRight: Radius.circular(50)
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.emailLabel, 
                          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)
                        ),
                        const SizedBox(height: 10),
                        _buildEmailField(S, theme),
                        const SizedBox(height: 20),
                        _buildInfoBox(S, theme, isDark),
                        const SizedBox(height: 30),
                        _buildSubmitButton(S, theme),
                        _buildFooterLink(context, S, theme),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackToLogin(BuildContext context, var S) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: GestureDetector(
        onTap: () =>Navigator.pop(context),
        child: Row(
          children: [
            const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(S.backToLogin, style: const TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopIcon(bool isDark) {
    return Container(
      width: 110, height: 110,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: const Icon(Icons.lock_reset_rounded, size: 55, color: Colors.white),
    );
  }

  Widget _buildSubTitle(var S) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 10),
      child: Text(
        S.resetSubtitle,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
      ),
    );
  }

Widget _buildEmailField(var S, ThemeData theme) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => AppValidators.validateEmail(value, S),
      
      decoration: InputDecoration(
        hintText: S.emailHint,
        prefixIcon: const Icon(Icons.mail_outline_rounded),
        
      ),
    );
  }

  Widget _buildInfoBox(var S, ThemeData theme, bool isDark) {
    final infoColor = isDark ? const Color(0xFF40C4FF) : const Color(0xFF1976D2);
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: infoColor.withOpacity(0.1), 
        borderRadius: BorderRadius.circular(15), 
        border: Border.all(color: infoColor.withOpacity(0.2))
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: infoColor, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(S.resetInfoNote, style: TextStyle(color: infoColor, fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(var S, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: theme.elevatedButtonTheme.style,
        onPressed: _isLoading ? null : () {
          if (_formKey.currentState!.validate()) {
            ResetPasswordLogic.sendResetEmail(
              email: _emailController.text,
              context: context,
              setLoading: (val) => setState(() => _isLoading = val),
            );
          }
        },
        child: _isLoading 
          ? const CircularProgressIndicator(color: Colors.white) 
          : Text(S.sendResetLinkBtn, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildFooterLink(BuildContext context, var S, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Center(
        child: RichText(
          text: TextSpan(
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            children: [
              TextSpan(text: S.rememberPasswordText + " "),
              TextSpan(
                text: S.signInLink,
                style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => const LoginScreen())
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}