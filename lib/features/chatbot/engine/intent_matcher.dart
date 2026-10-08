import 'text_normalizer.dart';
import 'score_calculator.dart';
import '../config/chatbot_intents.dart';
import '../models/chat_intent.dart';

class IntentMatcher {
  static const int minConfidenceScore = 3;

  static ChatIntent? match(String input) {
    if (input.trim().isEmpty) return null;

    final normalizedInput = TextNormalizer.normalize(input);
    
    ScoreResult? bestResult;
    
    for (final intent in chatbotIntents) {
      final result = ScoreCalculator.calculate(normalizedInput, intent);
      
      if (bestResult == null || result.score > bestResult.score) {
        bestResult = result;
      }
    }

    // Skor yeterince yüksek değilse unknown
    if (bestResult != null && bestResult.score >= minConfidenceScore) {
      return bestResult.intent;
    }

    return null;
  }
}
