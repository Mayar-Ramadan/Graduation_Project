import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradution_project_smart_sip/core/services/ai_helper.dart';
import 'package:gradution_project_smart_sip/data/models/ai_prediction_summary_model.dart';
import 'package:gradution_project_smart_sip/presentation/home/widgets/progress/water_progress_card_content.dart';
import 'package:provider/provider.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';
import 'package:gradution_project_smart_sip/providers/hydration_provider.dart';

class WaterProgressCard extends StatelessWidget {
  const WaterProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final hydration = Provider.of<HydrationProvider>(context);

    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName ?? s.user;

    const onColor = Colors.white;

    if (user == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor.withOpacity(0.9),
            theme.primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          final data = snapshot.data?.data();

          final String activityDialogStatus =
              (data?['activityDialogStatus'] ?? '').toString();

          final savedActivity =
              data?['activityLevel']?.toString().trim();

          final String activity =
          savedActivity != null && savedActivity.isNotEmpty
           ? savedActivity.toLowerCase()
           : 'medium';

          final bool showActivityWarning =
              activityDialogStatus == 'closed';

          return FutureBuilder<AiPredictionSummaryModel?>(
            
            future: AiHelper.getPrediction(fallbackActivity: activity),
            builder: (context, aiSnapshot) {
              if (aiSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              final result = aiSnapshot.data;

              final prediction = result?.prediction;
              final temperature = result?.temperature;
              final activityUsed = result?.activity ?? activity;

              final bool showLocationWarning =
                  result?.usedSavedCoordinates ?? false;

              final current = hydration.currentAmount / 1000;

              final double goal = prediction ??
                  (hydration.dailyGoal > 0
                      ? hydration.dailyGoal / 1000
                      : 2.0);

              final double progressValue =
                  goal <= 0 ? 0.0 : (current / goal).clamp(0.0, 1.0).toDouble();

              final percent = (progressValue * 100).toStringAsFixed(0);

              return WaterProgressCardContent(
                theme: theme,
                userName: userName,
                onGradientColor: onColor,
                percentText: percent,
                currentText: current.toStringAsFixed(1),
                goalText: goal.toStringAsFixed(1),
                progress: progressValue,
                predictionText: goal.toStringAsFixed(1),
                activity: activityUsed,
                temperature: temperature?.toStringAsFixed(1) ?? '--',
                showLocationWarning: showLocationWarning,
                showActivityWarning: showActivityWarning,
              );
            },
          );
        },
      ),
    );
  }
}