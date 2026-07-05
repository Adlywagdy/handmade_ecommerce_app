import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';

import '../models/user_preferences_model.dart';

class FirebaseAIService {
  final GenerativeModel _model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.5-flash',
  );

  Future<UserPreferencesModel?> extractPreferences(String userMessage) async {
    final prompt = '''
You are an AI assistant for a handmade e-commerce app.

Your task is to extract the user's shopping and room preferences from their message.

Return ONLY valid JSON.
Do not write markdown.
Do not add explanations.
Do not add text before or after the JSON.

Allowed categories:
candles, ceramic_vases, macrame, wooden_shelves, handmade_lamps, crochet_products

Allowed roomType:
bedroom, living_room, office, kitchen, balcony, kids_room, bathroom

Allowed roomSize:
small, medium, large

Allowed styles:
romantic, minimal, modern, boho, cozy, natural, colorful, cute, elegant, cheerful, rustic, soft, playful, warm, calm

Return this exact JSON structure:
{
  "category": null,
  "roomType": null,
  "roomSize": null,
  "colors": [],
  "style": null,
  "budget": null,
  "tags": []
}

Examples:

User message:
"عايزة حاجة رقيقة لأوضة نوم صغيرة لونها بينك وأبيض"
JSON:
{
  "category": null,
  "roomType": "bedroom",
  "roomSize": "small",
  "colors": ["pink", "white"],
  "style": "romantic",
  "budget": null,
  "tags": ["soft", "romantic", "bedroom", "pink", "white"]
}

User message:
"عايزة لمبة مودرن للمكتب لونها أبيض وذهبي"
JSON:
{
  "category": "handmade_lamps",
  "roomType": "office",
  "roomSize": null,
  "colors": ["white", "gold"],
  "style": "modern",
  "budget": null,
  "tags": ["lamp", "modern", "office", "white", "gold"]
}

Now extract preferences from this user message:
"$userMessage"
''';

    try {
      final response = await _model.generateContent([
        Content.text(prompt),
      ]);

      final responseText = response.text;

      if (responseText == null || responseText.trim().isEmpty) {
        return null;
      }

      final cleanedJson = _cleanJsonText(responseText);
      final decodedJson = jsonDecode(cleanedJson) as Map<String, dynamic>;

      return UserPreferencesModel(
        category: decodedJson['category'] as String?,
        roomType: decodedJson['roomType'] as String?,
        roomSize: decodedJson['roomSize'] as String?,
        colors: List<String>.from(decodedJson['colors'] ?? []),
        style: decodedJson['style'] as String?,
        budget: _parseBudget(decodedJson['budget']),
        tags: List<String>.from(decodedJson['tags'] ?? []),
      );
    } catch (e) {
      return null;
    }
  }

  String _cleanJsonText(String text) {
    return text
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();
  }

  int? _parseBudget(dynamic value) {
    if (value == null) return null;

    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }
}