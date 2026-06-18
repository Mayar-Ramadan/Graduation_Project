import 'package:flutter/material.dart';
import 'package:gradution_project_smart_sip/core/utils/formatters.dart';
import '../../l10n/app_localizations.dart';


class HydrationStatusHelper {

  static Color getStatusColor(String status) {
    switch (status) {
      case 'Drank water':
        return Colors.blue;
      case 'Spilling':
        return Colors.red;
      case 'Remaining Water':
        return Colors.orange;
      case 'Normal':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }


  static String getStatusText(String status, BuildContext context) {
    final S = AppLocalizations.of(context)!;
    switch (status) {
      case 'Drank water':
        return S.drankWater;
      case 'Spilling':
        return S.spillingStatus;
      case 'Remaining Water':
        return S.remainingWaterStatus;
      case 'Normal':
        return S.normalStatus;
      default:
        return status;
    }
  }

  static String getAmountText(String status, double amount, BuildContext context) {
    final S = AppLocalizations.of(context)!;
    final formattedAmount = AppFormatters.formatDouble(context, amount);

    if (status == 'Spilling' || status == 'Normal') {
      return '$formattedAmount ${S.mlUnit}';
    }
    if (status == 'Remaining Water') {
      return '$formattedAmount ${S.mlUnit} ${S.left}';
    }
    return '$formattedAmount ${S.mlUnit}';
  }

  // 🔹 أيقونة الحالة
  static IconData getStatusIcon(String status) {
    switch (status) {
      case 'Drank water':
        return Icons.water_drop_rounded;
      case 'Spilling':
        return Icons.warning_rounded;
      case 'Remaining Water':
        return Icons.water_drop_outlined;
      case 'Normal':
        return Icons.check_circle_outline;
      default:
        return Icons.help_outline;
    }
  }

  static String getStatusDescription(String status, BuildContext context) {
    final S = AppLocalizations.of(context)!;
    switch (status) {
      case 'Drank water':
        return S.drankWaterDescription;
      case 'Spilling':
        return S.spillingDescription;
      case 'Remaining Water':
        return S.remainingWaterDescription;
      case 'Normal':
        return S.normalDescription;
      default:
        return S.unknownStatus;
    }
  }

  static bool isDrinkingStatus(String status) {
    return status == 'Drank water';
  }

  static bool isWarningStatus(String status) {
    return status == 'Spilling' || status == 'Remaining Water';
  }

  static int getStatusPriority(String status) {
    switch (status) {
      case 'Spilling':
        return 3;
      case 'Drank water':
        return 2;
      case 'Remaining Water':
        return 1;
      case 'Normal':
        return 0;
      default:
        return 0;
    }
  }
}