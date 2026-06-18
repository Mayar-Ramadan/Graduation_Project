import 'package:flutter/material.dart';
import 'package:gradution_project_smart_sip/presentation/settings/about_screen.dart';
import 'package:gradution_project_smart_sip/presentation/settings/appearance_screen.dart';

import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';
import 'package:gradution_project_smart_sip/presentation/settings/localization_screen.dart';
import 'package:gradution_project_smart_sip/presentation/settings/privacy_screen.dart';
import 'package:gradution_project_smart_sip/presentation/settings/terms_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final S = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      
      backgroundColor: isDark ? const Color(0xFF0F1115) : const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(
          S.settings, 
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          _buildSettingsItem(
            context,
            icon: Icons.palette_rounded,
            title: S.appearance, 
            subtitle: S.appearanceSub, 
            accentColor: const Color(0xFF40C4FF),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AppearanceScreen())),
          ),
          _buildSettingsItem(
            context,
            icon: Icons.language_rounded,
            title: S.localization, 
            subtitle: S.localizationSub, 
            accentColor: const Color(0xFF00E676),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LocalizationScreen())),
          ),
          _buildSettingsItem(
            context,
            icon: Icons.security_rounded,
            title: S.privacyPolicy, // "Privacy Policy"
            subtitle: S.privacySub,
            accentColor: const Color(0xFFFFD740),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyPage())),
          ),
          _buildSettingsItem(
            context,
            icon: Icons.description_rounded,
            title: S.termsConditions, // "Terms & Conditions"
            subtitle: S.termsSub,
            accentColor: const Color(0xFFD4E157),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsPage())),
          ),
          _buildSettingsItem(
            context,
            icon: Icons.info_rounded,
            title: S.about, // "About"
            subtitle: S.aboutSub,
            accentColor: Colors.deepPurpleAccent,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutPage())),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1D23) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: accentColor.withOpacity(isDark ? 0.3 : 0.1),
          width: 1.5,
        ),
        boxShadow: [
          if (isDark)
            BoxShadow(
              color: accentColor.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          else
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: accentColor, size: 26),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.white54 : Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: accentColor.withOpacity(0.5),
        ),
      ),
    );
  }
}