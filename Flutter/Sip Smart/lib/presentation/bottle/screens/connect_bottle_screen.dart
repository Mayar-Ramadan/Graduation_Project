import 'package:flutter/material.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';
import 'package:gradution_project_smart_sip/presentation/bottle/screens/blutooth_screen.dart';
import 'package:gradution_project_smart_sip/presentation/bottle/screens/wifi_screen.dart';

class ConnectBottleScreen extends StatefulWidget {
  const ConnectBottleScreen({super.key});

  @override
  State<ConnectBottleScreen> createState() => _ConnectBottleScreenState();
}

class _ConnectBottleScreenState extends State<ConnectBottleScreen> {
  bool isWifiSelected = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        isWifiSelected ? const WifiScreen() : const BluetoothScreen(),

        Positioned(
          left: 58,
          right: 58,
          bottom: 95,
          child: _ConnectionToggle(
            isWifiSelected: isWifiSelected,
            onBluetoothTap: () {
              setState(() => isWifiSelected = false);
            },
            onWifiTap: () {
              setState(() => isWifiSelected = true);
            },
          ),
        ),
      ],
    );
  }
}

class _ConnectionToggle extends StatelessWidget {
  const _ConnectionToggle({
    required this.isWifiSelected,
    required this.onBluetoothTap,
    required this.onWifiTap,
  });

  final bool isWifiSelected;
  final VoidCallback onBluetoothTap;
  final VoidCallback onWifiTap;

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final primary = theme.primaryColor;

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(30),
      color: theme.scaffoldBackgroundColor,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: theme.scaffoldBackgroundColor,
          border: Border.all(
            color: primary.withOpacity(0.15),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: _ToggleItem(
                icon: Icons.bluetooth,
                label: s.bluetooth,
                isActive: !isWifiSelected,
                activeColor: primary,
                onTap: onBluetoothTap,
              ),
            ),
            Expanded(
              child: _ToggleItem(
                icon: Icons.wifi,
                label: s.wifiTitle,
                isActive: isWifiSelected,
                activeColor: primary,
                onTap: onWifiTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleItem extends StatelessWidget {
  const _ToggleItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final inactiveColor =
        theme.textTheme.bodyMedium?.color?.withOpacity(0.35);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: isActive
              ? activeColor.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? activeColor : inactiveColor,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isActive ? activeColor : inactiveColor,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}