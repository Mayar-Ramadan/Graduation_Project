class AiPredictionModel {
  final dynamic prediction;

  AiPredictionModel({required this.prediction});

  factory AiPredictionModel.fromJson(Map<String, dynamic> json) {
    return AiPredictionModel(
      prediction: json['prediction'],
    );
  }
}