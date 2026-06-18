import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gradution_project_smart_sip/providers/app_provider.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final S = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1115) : const Color(0xFFF7F9FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor:theme.primaryColor,
        title: Text(S.appearance, 
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1, color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.chooseTheme, 
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 25),
            
            // Light Mode Option
            _buildThemeOption(
              context,
              title: S.lightMode, 
              subtitle: S.lightModeSub, 
              icon: Icons.wb_sunny_rounded,
              accentColor: const Color(0xFFFFD740),
              isSelected: appProvider.themeMode == ThemeMode.light,
              onTap: () => appProvider.setThemeMode(ThemeMode.light),
            ),
            
            const SizedBox(height: 20),

            // Dark Mode Option
            _buildThemeOption(
              context,
              title: S.darkMode, 
              subtitle: S.darkModeSub, 
              icon: Icons.dark_mode_rounded,
              accentColor: const Color(0xFF40C4FF),
              isSelected: appProvider.themeMode == ThemeMode.dark,
              onTap: () => appProvider.setThemeMode(ThemeMode.dark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1D23) : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isSelected ? accentColor : accentColor.withOpacity(0.1),
            width: 2.5,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: accentColor.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
  
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: accentColor, size: 28),
          ],
        ),
      ),
    );
  }
}