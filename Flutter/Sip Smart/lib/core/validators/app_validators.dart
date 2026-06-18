import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';


class AppValidators {
  
  // ---------------- EMAIL ----------------
  static String? validateEmail(String? value, AppLocalizations S) {
    if (value == null || value.isEmpty) {
      return S.validatorEmailEmpty;
    }

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return S.validatorEmailInvalid;
    }

    return null;
  }

  // ---------------- PASSWORD ----------------
  static String? validatePassword(String? value, AppLocalizations S) {
    if (value == null || value.isEmpty) {
      return S.validatorPasswordEmpty;
    }

    if (value.length < 6) {
      return S.validatorPasswordShort;
    }

    return null;
  }

  // ---------------- CONFIRM PASSWORD ----------------
  static String? validateConfirmPassword(
    String? value,
    String password,
    AppLocalizations S,
  ) {
    if (value == null || value.isEmpty) {
      return S.validatorConfirmPasswordEmpty;
    }

    if (value != password) {
      return S.validatorPasswordMismatch;
    }

    return null;
  }

  // ---------------- REQUIRED FIELD ----------------
  static String? validateRequired(
    String? value,
    String fieldName,
    AppLocalizations S,
  ) {
    if (value == null || value.isEmpty) {
      return S.validatorFieldRequired(fieldName);
    }
    return null;
  }

  //  PROFILE VALIDATORS 
  

  // AGE
  static String? validateAge(String? value, AppLocalizations S) {
    if (value == null || value.isEmpty) {
      return S.allFieldsRequired;
    }

    final age = int.tryParse(value);

    if (age == null || age <= 0 || age > 120) {
      return S.invalidAge;
    }

    return null;
  }

  // WEIGHT
  static String? validateWeight(String? value, AppLocalizations S) {
    if (value == null || value.isEmpty) {
      return S.allFieldsRequired;
    }

    final weight = double.tryParse(value);

    if (weight == null || weight <= 0 || weight > 300) {
      return S.invalidWeight;
    }

    return null;
  }

  // HEIGHT
  static String? validateHeight(String? value, AppLocalizations S) {
    if (value == null || value.isEmpty) {
      return S.allFieldsRequired;
    }

    final height = double.tryParse(value);

    if (height == null || height <= 0 || height > 250) {
      return S.invalidHeight;
    }

    return null;
  }
}