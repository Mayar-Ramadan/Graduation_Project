import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';


class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final S = AppLocalizations.of(context)!;

   
    final primaryColor = theme.primaryColor;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final greyColor = theme.hintColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: primaryColor,
          statusBarIconBrightness: Brightness.light,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          S.terms_title,
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Last Updated
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: primaryColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.update_rounded,
                    color: primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    S.terms_last_updated,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Welcome Section
            _buildSection(
              context: context,
              icon: Icons.celebration_rounded,
              title: S.terms_welcome_title,
              content: S.terms_welcome_content,
              isDark: isDark,
            ),

            const SizedBox(height: 24),

            // Acceptance Section
            _buildSection(
              context: context,
              icon: Icons.check_circle_outline_rounded,
              title: S.terms_acceptance_title,
              content: S.terms_acceptance_content,
              isDark: isDark,
            ),

            const SizedBox(height: 24),

            // Data Collection Section
            _buildSection(
              context: context,
              icon: Icons.data_usage_rounded,
              title: S.terms_data_collection_title,
              content: S.terms_data_collection_content,
              isDark: isDark,
              bulletPoints: [
                S.terms_data_bullet_1,
                S.terms_data_bullet_2,
                S.terms_data_bullet_3,
                S.terms_data_bullet_4,
              ],
            ),

            const SizedBox(height: 24),

            // Privacy Section
            _buildSection(
              context: context,
              icon: Icons.privacy_tip_rounded,
              title: S.terms_privacy_title,
              content: S.terms_privacy_content,
              isDark: isDark,
            ),

            const SizedBox(height: 24),

            // User Responsibilities
            _buildSection(
              context: context,
              icon: Icons.account_circle_rounded,
              title: S.terms_responsibilities_title,
              content: S.terms_responsibilities_content,
              isDark: isDark,
              bulletPoints: [
                S.terms_responsibilities_bullet_1,
                S.terms_responsibilities_bullet_2,
                S.terms_responsibilities_bullet_3,
              ],
            ),

            const SizedBox(height: 24),

            // Prohibited Activities
            _buildSection(
              context: context,
              icon: Icons.block_rounded,
              title: S.terms_prohibited_title,
              content: S.terms_prohibited_content,
              isDark: isDark,
              bulletPoints: [
                S.terms_prohibited_bullet_1,
                S.terms_prohibited_bullet_2,
                S.terms_prohibited_bullet_3,
                S.terms_prohibited_bullet_4,
              ],
            ),

            const SizedBox(height: 24),

            // Intellectual Property
            _buildSection(
              context: context,
              icon: Icons.copyright_rounded,
              title: S.terms_intellectual_title,
              content: S.terms_intellectual_content,
              isDark: isDark,
            ),

            const SizedBox(height: 24),

            // Termination
            _buildSection(
              context: context,
              icon: Icons.exit_to_app_rounded,
              title: S.terms_termination_title,
              content: S.terms_termination_content,
              isDark: isDark,
            ),

            const SizedBox(height: 24),

            // Contact
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withOpacity(0.1),
                    primaryColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: primaryColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.contact_support_rounded,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.terms_contact_title,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          S.terms_contact_content,
                          style: TextStyle(
                            color: greyColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: primaryColor,
                    size: 18,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Footer
            Center(
              child: Column(
                children: [
                  Text(
                    S.terms_footer,
                    style: TextStyle(
                      color: greyColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    S.copyright_text,
                    style: TextStyle(
                      color: greyColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String content,
    required bool isDark,
    List<String>? bulletPoints,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final greyColor = theme.hintColor;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              color: greyColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.6,
            ),
          ),
          if (bulletPoints != null) ...[
            const SizedBox(height: 12),
            ...bulletPoints.map((point) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          point,
                          style: TextStyle(
                            color: greyColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }
}