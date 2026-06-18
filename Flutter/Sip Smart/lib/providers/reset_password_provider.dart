import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';
import 'package:gradution_project_smart_sip/presentation/auth/login_screen.dart';

class ResetPasswordLogic {
  static Future<void> sendResetEmail({
    required String email,
    required BuildContext context,
    required Function(bool) setLoading,
  }) async {

    final S = AppLocalizations.of(context)!;

    if (email.isEmpty) return;

    setLoading(true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email.trim(),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.resetEmailSentSuccess),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        Future.delayed(const Duration(seconds: 2), () {
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          }
        });
      }
    }

    on FirebaseAuthException catch (e) {
      String errorMessage;

      if (e.code == 'user-not-found') {
        errorMessage = S.resetNoUserFound;
      } else if (e.code == 'invalid-email') {
        errorMessage = S.resetInvalidEmail;
      } else {
        errorMessage = S.resetGenericError;
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.resetSomethingWentWrong),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    finally {
      setLoading(false);
    }
  }
}