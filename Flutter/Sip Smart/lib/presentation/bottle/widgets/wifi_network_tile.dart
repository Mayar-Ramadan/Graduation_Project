import 'package:flutter/material.dart';

class WifiNetworkTile extends StatelessWidget {
  const WifiNetworkTile({
    super.key,
    required this.ssid,
    required this.level,
    required this.onTap,
  });

  final String ssid;
  final int level;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.06) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primary.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Icon(Icons.wifi, color: primary),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                ssid,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }
}