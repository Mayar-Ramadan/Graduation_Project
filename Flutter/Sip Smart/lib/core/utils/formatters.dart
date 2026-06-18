import 'package:flutter/material.dart';

class AppFormatters {
 
  static bool isArabic(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar';
  }


  static String toArabicNumbers(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

  
    final buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      final char = input[i];
      final index = english.indexOf(char);
      if (index != -1) {
        buffer.write(arabic[index]);
      } else {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }

 
  static String formatString(BuildContext context, String value) {
    return isArabic(context) ? toArabicNumbers(value) : value;
  }

  static String formatDouble(
    BuildContext context,
    double value, {
    int fractionDigits = 0,
  }) {
    final text = value.toStringAsFixed(fractionDigits);
    return formatString(context, text);
  }


  static String formatInt(BuildContext context, int value) {
    return formatString(context, value.toString());
  }


  static String formatNumber(BuildContext context, num value) {
    if (value is double) {
      return formatDouble(context, value);
    } else if (value is int) {
      return formatInt(context, value);
    }
    return formatString(context, value.toString());
  }


  static String formatTemperature(
    BuildContext context,
    double value, {
    int fractionDigits = 0,
  }) {
    final number = formatDouble(context, value, fractionDigits: fractionDigits);
    return '$number°C';
  }

  static String formatPercentage(
    BuildContext context,
    double value, {
    int fractionDigits = 0,
  }) {
    final number = formatDouble(context, value, fractionDigits: fractionDigits);
    return '$number%';
  }

  static String formatAmount(
    BuildContext context,
    double value, {
    String unit = 'ml',
    int fractionDigits = 0,
  }) {
    final number = formatDouble(context, value, fractionDigits: fractionDigits);
    return '$number $unit';
  }


  static String formatMinutesAgo(
    BuildContext context,
    int minutes, {
    String? suffixAr,
    String? suffixEn,
  }) {
    final formattedMinutes = formatInt(context, minutes);
    final isAr = isArabic(context);
    final suffix = isAr
        ? (suffixAr ?? 'دقيقة')
        : (suffixEn ?? 'min ago');
    return '$formattedMinutes $suffix';
  }

  static String formatHoursAgo(
    BuildContext context,
    int hours, {
    String? suffixAr,
    String? suffixEn,
  }) {
    final formattedHours = formatInt(context, hours);
    final isAr = isArabic(context);
    final suffix = isAr
        ? (suffixAr ?? 'ساعة')
        : (suffixEn ?? 'hours ago');
    return '$formattedHours $suffix';
  }

  static String formatDate(
    BuildContext context,
    DateTime date, {
    String pattern = 'dd/MM/yyyy',
  }) {
    final day = formatInt(context, date.day);
    final month = formatInt(context, date.month);
    final year = formatInt(context, date.year);
    return pattern
        .replaceAll('dd', day)
        .replaceAll('MM', month)
        .replaceAll('yyyy', year);
  }

  static String formatTimeOfDay(
    BuildContext context,
    TimeOfDay time,
  ) {
    final hour = formatInt(context, time.hour);
    final minute = formatInt(context, time.minute);
    return '$hour:$minute';
  }
}