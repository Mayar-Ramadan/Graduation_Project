import 'package:flutter/material.dart';
import 'package:gradution_project_smart_sip/core/utils/formatters.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';

class WaterProgressMessageHelper {
  static String formatActivityLabel(
    BuildContext context,
    String activity,
  ) {
    final s = AppLocalizations.of(context)!;
    final value = activity.trim().toLowerCase();

    switch (value) {
      case 'low':
        return s.activityLow;
      case 'medium':
        return s.activityMedium;
      case 'high':
        return s.activityHigh;
      default:
        return s.activityMedium;
    }
  }

  static String buildWeatherActivityLine({
    required BuildContext context,
    required String activity,
    required String temperature,
  }) {
    final s = AppLocalizations.of(context)!;

    final formattedActivity = formatActivityLabel(context, activity);
    final tempValue = double.tryParse(temperature);

    final tempText = tempValue != null
        ? AppFormatters.formatTemperature(context, tempValue)
        : '--';

    return '${s.weather}: $tempText • ${s.activityLabel}: $formattedActivity';
  }
}