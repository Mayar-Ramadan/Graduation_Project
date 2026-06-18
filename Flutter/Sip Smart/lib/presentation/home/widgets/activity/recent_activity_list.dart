import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gradution_project_smart_sip/core/services/hydration_status_helper.dart';
import 'package:gradution_project_smart_sip/core/utils/formatters.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:gradution_project_smart_sip/providers/hydration_provider.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';

class RecentActivitySection extends StatefulWidget {
  const RecentActivitySection({super.key});

  @override
  State<RecentActivitySection> createState() => _RecentActivitySectionState();
}

class _RecentActivitySectionState extends State<RecentActivitySection> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 30),
      (_) {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final S = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final hydration = Provider.of<HydrationProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.recentActivity,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildLiveBadge(theme, S),
            ],
          ),
        ),
        hydration.isEmpty
            ? _buildEmptyState(context, theme, S)
            : _buildActivityList(hydration, theme, S),
      ],
    );
  }

  Widget _buildLiveBadge(ThemeData theme, S) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: theme.primaryColor),
          const SizedBox(width: 6),
          Text(
            S.live,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme, S) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.light
            ? Colors.white
            : theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(Icons.water_drop_outlined, size: 44, color: theme.primaryColor.withOpacity(0.35)),
          const SizedBox(height: 12),
          Text(
            S.startDrinking,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.disabledColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityList(HydrationProvider hydration, ThemeData theme, S) {
    final todayReadings = hydration.todayWaterReadings;

    return Container(
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.light
            ? Colors.white
            : theme.cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: todayReadings.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          indent: 70,
          color: theme.dividerColor.withOpacity(0.1),
        ),
        itemBuilder: (context, index) {
          final activity = todayReadings[index];

          return ListTile(
            key: ValueKey(activity.createdAt),
            leading: CircleAvatar(
              backgroundColor: HydrationStatusHelper
                  .getStatusColor(activity.status)
                  .withOpacity(0.1),
              child: Icon(
                Icons.water_drop_rounded,
                color: HydrationStatusHelper.getStatusColor(activity.status),
                size: 20,
              ),
            ),
           
            title: Text(
              activity.status.isEmpty
                  ? S.drankWater
                  : HydrationStatusHelper.getStatusText(activity.status, context),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              _formatActivityTime(activity.createdAt, activity.time, S,context),
              style: theme.textTheme.bodySmall,
            ),
          
            trailing: Text(
              HydrationStatusHelper.getAmountText(activity.status, activity.amount, context),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: HydrationStatusHelper.getStatusColor(activity.status),
              ),
            ),
          );
        },
      ),
    );
  }

String _formatActivityTime(int createdAt, String fallbackTime, S, BuildContext context) {
  if (createdAt <= 0) {
    return fallbackTime.isNotEmpty ? fallbackTime : S.noTime;
  }
  final activityTime = DateTime.fromMillisecondsSinceEpoch(createdAt);
  final now = DateTime.now();
  final difference = now.difference(activityTime);

  if (difference.isNegative) {
    return fallbackTime.isNotEmpty ? fallbackTime : S.noTime;
  }
  if (difference.inSeconds < 60) {
    return S.justNow;
  }
  if (difference.inMinutes < 60) {
    final minutes = AppFormatters.formatString(context, difference.inMinutes.toString());
    final suffix = S.minutesAgoSuffix ?? 'min ago';
    return '$minutes $suffix';
  }

  
  try {
    final locale = Localizations.localeOf(context).languageCode;
    final formatter = DateFormat.jm(locale); 
    final formattedTime = formatter.format(activityTime);
  
    return AppFormatters.formatString(context, formattedTime);
  } catch (e) {
  
    return fallbackTime.isNotEmpty ? fallbackTime : S.noTime;
  }
}
}