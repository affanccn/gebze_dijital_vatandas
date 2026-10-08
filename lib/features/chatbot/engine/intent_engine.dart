import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class IntentMatchResult {
  final String intentId;
  final String response;
  final String? route;
  final String action;
  final double confidence;
  final List<String>? suggestions;
  final String debugInfo;

  IntentMatchResult({
    required this.intentId,
    required this.response,
    this.route,
    required this.action,
    required this.confidence,
    this.suggestions,
    required this.debugInfo,
  });
}

class IntentEngine {
  List<dynamic> _intents = [];
  Map<String, dynamic> _routeRegistry = {};
  bool _isLoaded = false;
  
  // Stop words that carry little intent weight
  final Set<String> _stopWords = {
    'ne', 'neler', 'hangi', 'hangileri', 'nasıl', 'nerede', 'neresi', 'var', 'yok', 
    'mı', 'mi', 'mu', 'mü', 'bir', 'ben', 'bana', 'istiyorum', 'için', 'bugün', 
    'yarın', 'misin', 'mısın', 'musun', 'müsün', 'gibi', 'olmuş', 'yapmalıyım',
    'göster', 'gösterir', 'bulunuyor', 'bulabilirim'
  };

  // Context words that give a small location/context bonus but don't define the core intent
  final Set<String> _contextWords = {
    'gebze', 'gebzeye', 'gebzenin', 'gebzede', 'gebzedeki', 
    'ilçe', 'şehir', 'belediye', 'belediyesine', 'belediyesi'
  };

  Future<void> loadConfig() async {
    if (_isLoaded) return;
    try {
      final jsonString = await rootBundle.loadString('assets/mock/gebze_dijital_chatbot_intents.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      _intents = data['intents'] ?? [];
      _routeRegistry = data['route_registry'] ?? {};
      _isLoaded = true;
    } catch (e) {
      print('Chatbot config load error: $e');
    }
  }

  // Use for unit testing
  void setConfig(Map<String, dynamic> data) {
    _intents = data['intents'] ?? [];
    _routeRegistry = data['route_registry'] ?? {};
    _isLoaded = true;
  }

  String _normalize(String input) {
    return input.toLowerCase()
        .replaceAll(RegExp(r"['’]"), '') // Remove apostrophes (gebze'de -> gebzede)
        .replaceAll(RegExp(r'[^\w\sğüşıöç]'), '') // Remove other punctuation
        .trim();
  }

  IntentMatchResult matchIntent(String userInput, {bool debugMode = false}) {
    if (!_isLoaded || userInput.trim().isEmpty) {
      return _unknownResult("Engine not loaded or empty input");
    }

    final normalizedInput = _normalize(userInput);
    final allWords = normalizedInput.split(' ').where((w) => w.isNotEmpty).toList();
    
    // Tokenization & Filtering
    final tokens = allWords.where((w) => !_stopWords.contains(w)).toList();
    int locationBonus = 0;
    
    // Count context words
    for (var word in tokens) {
      if (_contextWords.any((c) => word.startsWith(c))) {
        locationBonus += 1;
      }
    }

    double bestScore = 0;
    Map<String, dynamic>? bestIntent;
    String debugLog = "Input: $userInput\nNormalized: $normalizedInput\nTokens: $tokens\nLocation Bonus: $locationBonus\n\nCandidates:\n";

    for (var intent in _intents) {
      double score = 0;
      int keywordMatchCount = 0;
      final intentId = intent['id'];
      final priority = (intent['priority'] ?? 1).toDouble();
      
      String intentDebug = "[$intentId]\n";

      // 1. Phrase Matching
      final phrases = (intent['phrases'] as List<dynamic>? ?? []);
      for (var p in phrases) {
        final phraseStr = _normalize(p.toString());
        if (normalizedInput == phraseStr) {
          score += 10.0;
          intentDebug += "  +10 (Exact phrase: $phraseStr)\n";
        } else if (normalizedInput.contains(phraseStr)) {
          score += 8.0;
          intentDebug += "  +8 (Contains phrase: $phraseStr)\n";
        }
      }

      // 2. Keyword Matching
      final keywords = (intent['keywords'] as List<dynamic>? ?? []);
      for (var k in keywords) {
        final keyStr = _normalize(k.toString());
        bool matched = false;

        if (keyStr.contains(' ')) {
          // Multi-word keyword
          if (normalizedInput.contains(keyStr)) {
            score += 6.0;
            keywordMatchCount++;
            matched = true;
            intentDebug += "  +6 (Exact multi-word keyword: $keyStr)\n";
          }
        } else {
          // Single-word keyword
          // Skip if the keyword is a stop/context word in the config (should be avoided in config, but just in case)
          if (_stopWords.contains(keyStr) || _contextWords.contains(keyStr)) continue;

          for (var word in tokens) {
            if (word == keyStr) {
              score += 5.0;
              keywordMatchCount++;
              matched = true;
              intentDebug += "  +5 (Exact keyword: $keyStr == $word)\n";
              break;
            } else if (keyStr.length >= 3 && word.startsWith(keyStr)) {
              score += 3.0;
              keywordMatchCount++;
              matched = true;
              intentDebug += "  +3 (Stem match: $word startsWith $keyStr)\n";
              break;
            }
          }
          
          if (!matched && normalizedInput.contains(keyStr)) {
             score += 1.0;
             intentDebug += "  +1 (Partial contains: $keyStr)\n";
          }
        }
      }

      // Add context/location bonus only if there is at least one meaningful keyword/phrase match
      if (score > 0) {
        score += locationBonus * 1.0;
        if (locationBonus > 0) intentDebug += "  +${locationBonus.toDouble()} (Location bonus)\n";
        
        // Multiple keyword bonus
        if (keywordMatchCount > 1) {
          double multiBonus = (keywordMatchCount - 1) * 2.0;
          score += multiBonus;
          intentDebug += "  +$multiBonus (Multiple keyword bonus)\n";
        }
        
        // Specificity/Priority bonus
        score += priority;
        intentDebug += "  +$priority (Priority/Specificity bonus)\n";
      }
      
      intentDebug += "  Total: $score\n\n";
      
      if (score > 0) {
        debugLog += intentDebug;
      }

      if (score > bestScore) {
        bestScore = score;
        bestIntent = intent;
      }
    }

    debugLog += "Result: ${bestIntent?['id'] ?? 'none'} (Score: $bestScore)";
    if (debugMode) print(debugLog);

    if (bestIntent != null && bestScore >= 4.0) {
      String? route;
      final routeKey = bestIntent['route_key'];
      if (routeKey != null) {
        route = _routeRegistry[routeKey];
      }
      
      List<String>? suggestions;
      if (bestIntent['choices'] != null) {
        suggestions = (bestIntent['choices'] as List)
            .map((e) => e['label'].toString())
            .toList();
      }

      return IntentMatchResult(
        intentId: bestIntent['id'] ?? 'unknown',
        response: bestIntent['response'] ?? '',
        route: route,
        action: bestIntent['action'] ?? 'answer',
        confidence: bestScore,
        suggestions: suggestions,
        debugInfo: debugLog,
      );
    }

    return _unknownResult(debugLog);
  }

  IntentMatchResult _unknownResult(String debugLog) {
    dynamic unknownIntent;
    try {
      unknownIntent = _intents.firstWhere((i) => i['id'] == 'unknown');
    } catch (_) {
      unknownIntent = {
        'id': 'unknown',
        'response': 'Anlayamadım, lütfen farklı kelimelerle tekrar eder misiniz?',
        'action': 'answer'
      };
    }
    return IntentMatchResult(
      intentId: 'unknown',
      response: unknownIntent['response'],
      route: null,
      action: 'answer',
      confidence: 0,
      debugInfo: debugLog,
    );
  }
}
