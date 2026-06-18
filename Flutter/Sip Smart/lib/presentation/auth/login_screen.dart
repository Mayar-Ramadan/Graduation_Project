import 'package:flutter/material.dart';
import 'package:gradution_project_smart_sip/core/validators/app_validators.dart';
import 'package:gradution_project_smart_sip/presentation/auth/widgets/social_sign_in_button.dart';
import 'package:gradution_project_smart_sip/providers/auth_provider.dart';
import 'package:gradution_project_smart_sip/routes/app_routes.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';
import 'package:gradution_project_smart_sip/core/constants/app_assets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  

  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _submitForm() async {
    final S = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      try {
        await Provider.of<AuthProvider>(context, listen: false).login(
          _emailController.text,
          _passwordController.text,
        );

        if (mounted) {
          _showMessage(S.loginSuccess); 
          Navigator.of(context).pushNamedAndRemoveUntil(
            RoutesNames.dailyTracking , 
            (route) => false,
          );
        }
      } catch (error) {
        final S = AppLocalizations.of(context)!;

  String message = S.loginFailed;

  final errorText = error.toString().toLowerCase();

  if (errorText.contains("user-not-found")) {
    message = S.userNotFound;
  } else if (errorText.contains("wrong-password")) {
    message = S.wrongPassword;
  } else if (errorText.contains("invalid-email")) {
    message = S.invalidEmail;
  } else if (errorText.contains("too-many-requests")) {
    message = S.tooManyRequests;
  }

  _showMessage(message, isError: true);
      }
    }
  }

  void _handleGoogleSignIn() async {
    final S = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    setState(() {
      _isGoogleLoading = true;
    });

    try {
      await authProvider.signInWithGoogle();
      if (mounted) {
        _showMessage(S.googleSignInSuccess);
        Navigator.of(context).pushNamedAndRemoveUntil(
          RoutesNames.dailyTracking, 
          (route) => false,
        );
      }
    } catch (e) {
      if (e.toString() == "google_signin_cancelled") {
         final S = AppLocalizations.of(context)!;

      if (e.toString() == "google_signin_cancelled") {
      _showMessage(S.googleSignInCancelled, isError: true);
      } else {
      _showMessage(S.somethingWentWrong, isError: true);
     }
     } 
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final S = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: primaryColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Header Section (Logo & Welcome Text)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: Column(
                          children: [
                            Transform.scale(
                              scale: 2,
                              child: Image.asset(
                                AppAssets.logo,
                                height: 100,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              S.welcomeBack,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              S.signInSubtitle,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Form Section (Input Fields)
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
                          decoration: BoxDecoration(
                            color: theme.scaffoldBackgroundColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: S.emailHint,
                                    prefixIcon: const Icon(Icons.email_outlined),
                                  ),
                                  validator: (value) => AppValidators.validateEmail(value, S),
                                ),
                                const SizedBox(height: 20),
                                
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: !_isPasswordVisible,
                                  decoration: InputDecoration(
                                    labelText: S.passwordHint,
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                                      onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                                    ),
                                  ),
                                  validator: (value) => AppValidators.validatePassword(value, S),
                                ),
                                
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () => Navigator.of(context).pushNamed(RoutesNames.resetPassword),
                                    child: Text(
                                      S.forgotPassword, 
                                      style: TextStyle(color: primaryColor)
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                
                                // Login Button with Loading State
                                ElevatedButton(
                                  onPressed: (authProvider.isLoading || _isGoogleLoading) ? null : _submitForm,
                                  child: authProvider.isLoading
                                      ? const SizedBox(
                                          height: 20, 
                                          width: 20, 
                                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                        )
                                      : Text(
                                          S.loginButton, 
                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                        ),
                                ),
                                
                                const SizedBox(height: 30),
                                Center(
                                  child: Text(
                                    S.orSignInWith, 
                                    style: TextStyle(color: theme.textTheme.bodySmall?.color?.withOpacity(0.5))
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                        
                                _isGoogleLoading
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                                          ),
                                        ),
                                      )
                                    : SocialSignInButton(
                                        onPressed: authProvider.isLoading ? () {} : _handleGoogleSignIn,
                                        label: S.signInWithGoogle,
                                        iconPath: AppAssets.googleIcon,
                                      ),
                                
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(S.noAccount),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pushReplacementNamed(RoutesNames.register),
                                      child: Text(
                                        S.registerButton, 
                                        style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}