import 'package:flutter/material.dart';
import 'package:gradution_project_smart_sip/core/constants/app_assets.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';

import 'package:gradution_project_smart_sip/core/utils/formatters.dart';
import 'package:gradution_project_smart_sip/presentation/home/widgets/progress/water_progress_message_helper.dart';

class WaterProgressCardContent extends StatelessWidget {
  final ThemeData theme;
  final String userName;
  final Color onGradientColor;
  final String percentText;
  final String currentText;
  final String goalText;
  final double progress;
  final String? predictionText;
  final String activity;
  final String temperature;
  final bool showLocationWarning;
  final bool showActivityWarning;

  const WaterProgressCardContent({
    super.key,
    required this.theme,
    required this.userName,
    required this.onGradientColor,
    required this.percentText,
    required this.currentText,
    required this.goalText,
    required this.progress,
    required this.predictionText,
    required this.activity,
    required this.temperature,
    required this.showLocationWarning,
    required this.showActivityWarning,
  });

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final showAnyWarning = showLocationWarning || showActivityWarning;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.welcomeBack,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: onGradientColor.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: onGradientColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            _buildAvatar(),
          ],
        ),

        const SizedBox(height: 25),

        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: onGradientColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    s.todaysProgress,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: onGradientColor,
                    ),
                  ),
                  Text(
                    s.progressPercent(
                      AppFormatters.formatString(context, percentText),
                    ),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: onGradientColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  s.waterProgress(
                    AppFormatters.formatString(context, currentText),
                    AppFormatters.formatString(context, goalText),
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: onGradientColor.withOpacity(0.8),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: onGradientColor.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation(onGradientColor),
              ),

              const SizedBox(height: 14),

              if (predictionText != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    s.recommendedToday(
                      AppFormatters.formatString(context, predictionText!),
                    ),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: onGradientColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  WaterProgressMessageHelper.buildWeatherActivityLine(
                    context: context,
                    activity: activity,
                    temperature: temperature,
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: onGradientColor.withOpacity(0.95),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              if (showLocationWarning)
                _warningText(s.usingSavedLocationMessage),

              if (showLocationWarning && showActivityWarning)
                const SizedBox(height: 4),

              if (showActivityWarning)
                _warningText(s.usingSavedActivityMessage),

              if (!showAnyWarning)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    s.hydrationPersonalized,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: onGradientColor.withOpacity(0.85),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _warningText(String text) {
    return Row(
      children: [
        const Icon(
          Icons.error,
          color: Colors.redAccent,
          size: 16,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: onGradientColor.withOpacity(0.9),
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.19),
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.asset(AppAssets.logo, fit: BoxFit.cover),
      ),
    );
  }
}