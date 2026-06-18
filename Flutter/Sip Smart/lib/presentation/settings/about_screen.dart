import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradution_project_smart_sip/core/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';


class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final S = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.primary,
          statusBarIconBrightness: Brightness.light,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          S.about_title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.white.withOpacity(0.2),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),

            // Logo & App Name
            Center(
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, Color(0xFF6DD5FA)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.water_drop,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    S.app_name,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    S.app_tagline,
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // App Information Card
            _buildInfoCard(context, isDark, textColor, S),

            const SizedBox(height: 28),

            // Key Features
            Text(
              S.key_features_title,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 14),
            _buildFeatureGrid(isDark, textColor, S),

            const SizedBox(height: 28),

            // Contact Section
            Text(
              S.contact_us_title,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 14),
            _buildContactCard(isDark, textColor, S),

            const SizedBox(height: 32),

            // Footer
            Center(
              child: Column(
                children: [
                  Text(
                    S.made_with_love,
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    S.by_team,
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    S.copyright_text,
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, bool isDark, Color textColor, AppLocalizations S) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildInfoRow(S.version_label, S.version_value, isDark),
          const Divider(height: 16),
          _buildInfoRow(S.build_label, S.build_value, isDark),
          const Divider(height: 16),
          _buildInfoRow(S.release_date_label, S.release_date_value, isDark),
          const Divider(height: 16),
          _buildInfoRow(S.size_label, S.size_value, isDark),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(bool isDark, Color textColor, AppLocalizations S) {
    final features = [
      {'icon': Icons.water_drop, 'label': S.feature_hydration},
      {'icon': Icons.psychology, 'label': S.feature_ai_reminders},
      {'icon': Icons.wb_sunny, 'label': S.feature_weather},
      {'icon': Icons.smart_toy, 'label': S.feature_bottle},
      {'icon': Icons.emoji_events, 'label': S.feature_achievements},
      {'icon': Icons.bar_chart, 'label': S.feature_statistics},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.grey[50],
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                features[index]['icon'] as IconData,
                color: AppColors.primary,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                features[index]['label'] as String,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContactCard(bool isDark, Color textColor, AppLocalizations S) {
    final contacts = [
      {'icon': Icons.email_outlined, 'label': S.contact_email, 'value': S.contact_email_value},
      {'icon': Icons.public, 'label': S.contact_website, 'value': S.contact_website_value},
      {'icon': Icons.code, 'label': S.contact_open_source, 'value': S.contact_open_source_value},
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        children: contacts.map((contact) {
          final index = contacts.indexOf(contact);
          return Column(
            children: [
              if (index > 0) const Divider(height: 1),
              ListTile(
                leading: Icon(
                  contact['icon'] as IconData,
                  color: AppColors.primary,
                  size: 24,
                ),
                title: Text(
                  contact['label'] as String,
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      contact['value'] as String,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.grey,
                      size: 20,
                    ),
                  ],
                ),
                onTap: () {
                  final value = contact['value'] as String;
                  if (contact['label'] == S.contact_email) {
                    _launchUrl('mailto:$value');
                  } else if (contact['label'] == S.contact_website) {
                    _launchUrl('https://$value');
                  } else if (contact['label'] == S.contact_open_source) {
                    _launchUrl('https://$value');
                  }
                },
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Handle error silently
    }
  }
}