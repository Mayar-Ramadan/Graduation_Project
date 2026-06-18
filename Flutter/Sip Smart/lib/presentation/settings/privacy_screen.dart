import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradution_project_smart_sip/core/constants/app_colors.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';



class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
          S.privacy_title,
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
            // Last Updated Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.update_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    S.privacy_last_updated,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Introduction
            _buildSection(
              icon: Icons.info_outline_rounded,
              title: S.privacy_introduction_title,
              content: S.privacy_introduction_content,
              isDark: isDark,
            ),

            const SizedBox(height: 24),

            // Information We Collect
            _buildSection(
              icon: Icons.collections_bookmark_rounded,
              title: S.privacy_collect_title,
              content: S.privacy_collect_content,
              isDark: isDark,
              bulletPoints: [
                S.privacy_collect_bullet_1,
                S.privacy_collect_bullet_2,
                S.privacy_collect_bullet_3,
                S.privacy_collect_bullet_4,
                S.privacy_collect_bullet_5,
              ],
            ),

            const SizedBox(height: 24),

            // How We Use Your Information
            _buildSection(
              icon: Icons.analytics_rounded,
              title: S.privacy_use_title,
              content: S.privacy_use_content,
              isDark: isDark,
              bulletPoints: [
                S.privacy_use_bullet_1,
                S.privacy_use_bullet_2,
                S.privacy_use_bullet_3,
                S.privacy_use_bullet_4,
                S.privacy_use_bullet_5,
                S.privacy_use_bullet_6,
                S.privacy_use_bullet_7,
              ],
            ),

            const SizedBox(height: 24),

            // Data Storage & Security
            _buildSection(
              icon: Icons.security_rounded,
              title: S.privacy_storage_title,
              content: S.privacy_storage_content,
              isDark: isDark,
            ),

            const SizedBox(height: 24),

            // Data Sharing
            _buildSection(
              icon: Icons.share_rounded,
              title: S.privacy_sharing_title,
              content: S.privacy_sharing_content,
              isDark: isDark,
              bulletPoints: [
                S.privacy_sharing_bullet_1,
                S.privacy_sharing_bullet_2,
                S.privacy_sharing_bullet_3,
                S.privacy_sharing_bullet_4,
                S.privacy_sharing_bullet_5,
              ],
            ),

            const SizedBox(height: 24),

            // Your Rights
            _buildSection(
              icon: Icons.assignment_ind_rounded,
              title: S.privacy_rights_title,
              content: S.privacy_rights_content,
              isDark: isDark,
              bulletPoints: [
                S.privacy_rights_bullet_1,
                S.privacy_rights_bullet_2,
                S.privacy_rights_bullet_3,
                S.privacy_rights_bullet_4,
                S.privacy_rights_bullet_5,
                S.privacy_rights_bullet_6,
              ],
            ),

            const SizedBox(height: 24),

            // Third-Party Services
            _buildSection(
              icon: Icons.apps_rounded,
              title: S.privacy_third_party_title,
              content: S.privacy_third_party_content,
              isDark: isDark,
            ),

            const SizedBox(height: 24),

            // Children's Privacy
            _buildSection(
              icon: Icons.family_restroom_rounded,
              title: S.privacy_children_title,
              content: S.privacy_children_content,
              isDark: isDark,
            ),

            const SizedBox(height: 24),

            // Cookies & Tracking
            _buildSection(
              icon: Icons.cookie_rounded,
              title: S.privacy_cookies_title,
              content: S.privacy_cookies_content,
              isDark: isDark,
            ),

            const SizedBox(height: 24),

            // Policy Updates
            _buildSection(
              icon: Icons.update_rounded,
              title: S.privacy_updates_title,
              content: S.privacy_updates_content,
              isDark: isDark,
            ),

            const SizedBox(height: 24),

            // Contact Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.primary.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.contact_mail_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.privacy_contact_title,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          S.privacy_contact_content,
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.primary,
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
                    S.privacy_footer,
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    S.copyright_text,
                    style: TextStyle(
                      color: AppColors.grey,
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
    required IconData icon,
    required String title,
    required String content,
    required bool isDark,
    List<String>? bulletPoints,
  }) {
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
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
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
              color: AppColors.grey,
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
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          point,
                          style: TextStyle(
                            color: AppColors.grey,
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