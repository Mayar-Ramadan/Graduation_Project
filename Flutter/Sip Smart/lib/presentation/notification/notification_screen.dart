import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gradution_project_smart_sip/providers/notification_provider.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';
import 'package:gradution_project_smart_sip/core/constants/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final S = AppLocalizations.of(context)!;
    final provider = Provider.of<NotificationProvider>(context);

 
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.markAllAsRead();
    });

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.notificationsTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (provider.notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white),
              onPressed: () {
                provider.clearAll();
              },
            ),
        ],
      ),
      body: provider.notifications.isEmpty
          ? _buildEmptyState(context, S)
          : _buildNotificationsList(context, provider, S),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations S) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_off_outlined,
                size: 60,
                color: AppColors.primary.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              S.noNotificationsTitle, 
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              S.noNotificationsSubtitle, 
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.white60 : Colors.black54,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsList(
    BuildContext context,
    NotificationProvider provider,
    AppLocalizations S,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: provider.notifications.length,
      itemBuilder: (context, index) {
        final notification = provider.notifications[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1D23) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_active_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification['title'] ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification['body'] ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification['timestamp'] ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white38 : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}