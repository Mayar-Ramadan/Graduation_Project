import 'package:flutter/material.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';

class WifiDialogs {
  static void showPasswordDialog({
    required BuildContext context,
    required String ssid,
    required void Function(String password) onConnect,
  }) {
    final s = AppLocalizations.of(context)!;
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        final theme = Theme.of(context);

        return AlertDialog(
          backgroundColor: theme.scaffoldBackgroundColor,
          title: Text(
            ssid,
            style: theme.textTheme.titleLarge,
          ),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: s.wifiPassword,
              prefixIcon: const Icon(Icons.lock_outline),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(s.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                final password = passwordController.text.trim();

                if (password.isEmpty) return;

                Navigator.pop(context);
                onConnect(password);
              },
              child: Text(s.connect),
            ),
          ],
        );
      },
    );
  }

  static void showHiddenNetworkDialog({
    required BuildContext context,
    required void Function(String ssid, String password) onConnect,
  }) {
    final s = AppLocalizations.of(context)!;
    final ssidController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        final theme = Theme.of(context);

        return AlertDialog(
          backgroundColor: theme.scaffoldBackgroundColor,
          title: Text(
            s.hiddenNetwork,
            style: theme.textTheme.titleLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ssidController,
                decoration: InputDecoration(
                  labelText: s.wifiNameSsid,
                  prefixIcon: const Icon(Icons.wifi),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: s.password,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(s.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                final ssid = ssidController.text.trim();
                final password = passwordController.text.trim();

                if (ssid.isEmpty || password.isEmpty) return;

                Navigator.pop(context);
                onConnect(ssid, password);
              },
              child: Text(s.connect),
            ),
          ],
        );
      },
    );
  }
}