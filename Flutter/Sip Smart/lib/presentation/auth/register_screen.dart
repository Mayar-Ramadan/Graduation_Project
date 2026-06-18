import 'package:flutter/material.dart';
import 'package:gradution_project_smart_sip/core/validators/app_validators.dart';
import 'package:gradution_project_smart_sip/routes/app_routes.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:gradution_project_smart_sip/providers/auth_provider.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  String _selectedGender = 'Male';
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _submitRegister() async {
    final S = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      try {
        final auth = Provider.of<AuthProvider>(context, listen: false);
        await auth.signUpWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
          fullName: _nameController.text,
        );

        await auth.saveAdditionalUserData(
          age: _ageController.text,
          gender: _selectedGender,
          weight: _weightController.text,
          height: _heightController.text,
          country: _countryController.text,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.accountCreatedSuccess),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          Navigator.of(context).pushReplacementNamed(RoutesNames.dailyTracking);
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString()), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  // --- UI Build Methods ---

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    Widget? suffixIcon,
    required Color primaryColor,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        textInputAction: TextInputAction.next,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          prefixIcon: Icon(icon), 
          suffixIcon: suffixIcon,

        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final S = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Header
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: primaryColor, 
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(S.registerTitle, style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontSize: 28)),
                        const SizedBox(height: 5),
                        Text(S.registerSubtitle, style: const TextStyle(fontSize: 16, color: Colors.white70)),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    _buildInputField(
                      controller: _nameController,
                      labelText: S.fullNameLabel,
                      hintText: S.nameHint,
                      icon: Icons.person_outline,
                      primaryColor: primaryColor,
                      validator: (value) => AppValidators.validateRequired(value, S.fullNameLabel, S),
                    ),
                    _buildInputField(
                      controller: _emailController,
                      labelText: S.emailLabel,
                      hintText: S.emailHint,
                      icon: Icons.email_outlined,
                      primaryColor: primaryColor,
                      validator: (value) => AppValidators.validateEmail(value, S),
                    ),
                    _buildInputField(
                      controller: _passwordController,
                      labelText: S.passwordLabel,
                      hintText: S.passwordHint,
                      icon: Icons.lock_outline,
                      isPassword: true,
                      primaryColor: primaryColor,
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                      ),
                      validator: (value) => AppValidators.validatePassword(value, S),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: S.ageLabel, 
                              hintText: S.ageHint,
                              prefixIcon: const Icon(Icons.calendar_today),
                            ),
                            validator: (value) => AppValidators.validateRequired(value, S.ageLabel, S),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            dropdownColor: theme.scaffoldBackgroundColor,
                            value: _selectedGender,
                            decoration: InputDecoration(
                              labelText: S.genderLabel,
                              prefixIcon: const Icon(Icons.person),
                            ),
                            items: ['Male', 'Female'].map((g) => DropdownMenuItem(
                              value: g, 
                              child: Text(g == 'Male' ? S.male : S.female)
                            )).toList(),
                            onChanged: (val) => setState(() => _selectedGender = val!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _weightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: S.weightLabel,
                              hintText: S.weightHint,
                              prefixIcon: const Icon(Icons.monitor_weight_outlined),
                            ),
                            validator: (value) => AppValidators.validateRequired(value, S.weightLabel, S),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextFormField(
                            controller: _heightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: S.heightLabel,
                              hintText: S.heightHint,
                              prefixIcon: const Icon(Icons.height),
                            ),
                            validator: (value) => AppValidators.validateRequired(value, S.heightLabel, S),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    _buildInputField(
                      controller: _countryController,
                      labelText: S.countryLabel,
                      hintText: S.countryHint,
                      icon: Icons.location_on_outlined,
                      primaryColor: primaryColor,
                      validator: (value) => AppValidators.validateRequired(value, S.countryLabel, S),
                    ),

                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading ? null : _submitRegister,
                        child: authProvider.isLoading
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text(S.registerButton, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(S.alreadyHaveAccount),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pushReplacementNamed(RoutesNames.login),
                          child: Text(
                            " ${S.loginButton}",
                            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}