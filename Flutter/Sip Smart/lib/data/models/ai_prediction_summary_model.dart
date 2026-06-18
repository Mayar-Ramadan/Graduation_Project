class AiPredictionSummaryModel {
  final double prediction;
  final double temperature;
  final String activity;
  final bool usedSavedCoordinates;

  const AiPredictionSummaryModel({
    required this.prediction,
    required this.temperature,
    required this.activity,
    required this.usedSavedCoordinates,
  });
}