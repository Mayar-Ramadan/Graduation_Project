import 'package:flutter/material.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';

class HiddenNetworkButton extends StatelessWidget {
  const HiddenNetworkButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.add, color: theme.primaryColor),
      label: Text(
        s.addHiddenNetwork,
        style: TextStyle(
          color: theme.primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: theme.primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}