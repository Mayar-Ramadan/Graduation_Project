import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';
import 'package:gradution_project_smart_sip/providers/notification_provider.dart';
import 'package:gradution_project_smart_sip/presentation/notification/notification_screen.dart';
import 'package:intl/intl.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final S = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final String currentLocale = Localizations.localeOf(context).languageCode;
    final String currentDate = DateFormat('EEEE, MMMM d', currentLocale).format(DateTime.now());

    return Container(
      padding: const EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor,
            theme.primaryColor.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentDate,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                S.sipSmart,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 26,
                ),
              ),
            ],
          ),
         
          Consumer<NotificationProvider>(
            builder: (context, provider, child) {
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                        size: 29,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationScreen(),
                          ),
                        );
                      },
                    ),
                  ),
               
                  if (provider.unreadCount > 0)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: Text(
                          '${provider.unreadCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}