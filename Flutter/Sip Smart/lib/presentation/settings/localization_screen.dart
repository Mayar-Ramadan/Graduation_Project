import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gradution_project_smart_sip/providers/app_provider.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';

class LocalizationScreen extends StatelessWidget {
  const LocalizationScreen({super.key});

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
        backgroundColor: theme.primaryColor,
        title: Text(S.localization, 
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
              S.selectLanguage,
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 25),
            
            // English Option
            _buildLanguageOption(
              context,
              title: "English",
              subtitle: "Default System Language",
              flag: "🇺🇸",
              accentColor: const Color(0xFF40C4FF),
              isSelected: appProvider.locale.languageCode == 'en',
              onTap: () => appProvider.setLocale(const Locale('en')),
            ),
            
            const SizedBox(height: 18),

            // Arabic Option
            _buildLanguageOption(
              context,
              title: "العربية",
              subtitle: "لغة الضاد الأصيلة",
              flag: "🇪🇬",
              accentColor: const Color(0xFF00E676),
              isSelected: appProvider.locale.languageCode == 'ar',
              onTap: () => appProvider.setLocale(const Locale('ar')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String flag,
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
                color: accentColor.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Text(flag, style: const TextStyle(fontSize: 28)),
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