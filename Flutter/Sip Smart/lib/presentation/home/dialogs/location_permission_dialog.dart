import 'package:flutter/material.dart';
import 'package:gradution_project_smart_sip/core/constants/app_colors.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';


Future<bool?> showLocationPermissionDialog(BuildContext context) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
 final s = AppLocalizations.of(context)!;

  const double buttonHeight = 52;

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: isDark ? Colors.white12 : Colors.black12,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //  Icon
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  size: 34,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 18),

              // Title
              Text(
                s.enableLocationTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              // Description
              Text(
                s.enableLocationMessage,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.white70 : Colors.black54,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              //  Buttons
              Row(
                children: [
                 //Not now
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(buttonHeight),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                          color: isDark ? Colors.white24 : Colors.black12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        s.notNow,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Allow 
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(buttonHeight),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        s.allowAccess,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}