import 'package:flutter/material.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';

Future<String?> showActivityDialog(BuildContext context) {
  final theme = Theme.of(context);
  final s = AppLocalizations.of(context)!;

  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: theme.primaryColor.withOpacity(0.18),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(
              color: theme.primaryColor.withOpacity(0.12),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () => Navigator.pop(dialogContext, null),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: theme.iconTheme.color ?? theme.primaryColor,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Icon(
                Icons.directions_run_rounded,
                color: theme.primaryColor,
                size: 42,
              ),
              const SizedBox(height: 14),
              Text(
                s.howActiveAreYouToday,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                s.chooseActivityLevelMessage,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.75),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 22),
              _activityButton(
                dialogContext,
                text: s.low,
                icon: Icons.self_improvement_rounded,
                value: 'low',
              ),
              const SizedBox(height: 12),
              _activityButton(
                dialogContext,
                text: s.medium,
                icon: Icons.directions_walk_rounded,
                value: 'medium',
              ),
              const SizedBox(height: 12),
              _activityButton(
                dialogContext,
                text: s.high,
                icon: Icons.fitness_center_rounded,
                value: 'high',
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _activityButton(
  BuildContext context, {
  required String text,
  required IconData icon,
  required String value,
}) {
  final theme = Theme.of(context);

  return SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: () => Navigator.pop(context, value),
      icon: const SizedBox.shrink(),
      label: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: theme.elevatedButtonTheme.style?.foregroundColor?.resolve({}) ??
                Colors.white,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      style: theme.elevatedButtonTheme.style?.copyWith(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    ),
  );
}