import '../datasources/ai/ai_service.dart';
import '../models/ai_prediction_model.dart';

class AiRepository {
  final AiService aiService;

  AiRepository(this.aiService);

  Future<AiPredictionModel> getPrediction(List<dynamic> features) async {
    final data = await aiService.getPrediction(features);
    return AiPredictionModel.fromJson(data);
  }
}