import 'package:flutter/material.dart';

import '../../models/chatbot_message_model.dart';
import '../../services/preference_extractor_service.dart';
import '../../services/recommendation_service.dart';
import '../../services/firebase_ai_service.dart';
import '../widgets/chatbot_bubble.dart';
import '../widgets/chatbot_input_field.dart';
import '../widgets/recommended_products_widget.dart';

class RecommendationChatbotScreen extends StatefulWidget {
  const RecommendationChatbotScreen({super.key});

  @override
  State<RecommendationChatbotScreen> createState() =>
      _RecommendationChatbotScreenState();
}

class _RecommendationChatbotScreenState
    extends State<RecommendationChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final PreferenceExtractorService _preferenceExtractor =
      PreferenceExtractorService();

  final RecommendationService _recommendationService = RecommendationService();

  final FirebaseAIService _firebaseAIService = FirebaseAIService();

  final List<ChatbotMessageModel> _messages = [
    ChatbotMessageModel(
      text:
          'Hi! Tell me about your room size, colors, style, and what handmade product you are looking for.',
      isUser: false,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final userMessage = _messageController.text.trim();

    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add(
        ChatbotMessageModel(
          text: userMessage,
          isUser: true,
        ),
      );
      _messageController.clear();
    });

    _addBotResponse(userMessage);
    _scrollToBottom();
  }

 Future<void> _addBotResponse(String userMessage) async {
  setState(() {
    _messages.add(
      ChatbotMessageModel(
        text: 'Thinking...',
        isUser: false,
      ),
    );
  });

  _scrollToBottom();

  final aiPreferences =
      await _firebaseAIService.extractPreferences(userMessage);

  final preferences =
      aiPreferences ?? _preferenceExtractor.extract(userMessage);

  final recommendedProducts =
      _recommendationService.getRecommendations(preferences);

  String botReply;

  if (!preferences.hasAnyPreference) {
    botReply =
        'I need more details. Please tell me the room type, size, colors, or product type you want.';
  } else if (recommendedProducts.isEmpty) {
    botReply =
        'I understood your preferences:\n\n${preferences.summary}\n\n'
        'Sorry, I could not find an exact matching product right now. '
        'Try changing the color, room type, or product category.';
  } else {
    botReply =
        'Great! I found 2 handmade products that may match your room:\n\n${preferences.summary}';
  }

  if (!mounted) return;

  setState(() {
    _messages.removeLast();
    _messages.add(
      ChatbotMessageModel(
        text: botReply,
        isUser: false,
        recommendedProducts: recommendedProducts,
      ),
    );
  });

  _scrollToBottom();
}

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _showExampleMessage() {
    _messageController.text =
        'عايزة حاجة رقيقة لأوضة نوم صغيرة لونها بينك وأبيض وستايل رومانسي';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F4EF),
      appBar: AppBar(
        title: const Text('Recommendation Chatbot'),
        backgroundColor: const Color(0xff8B5E3C),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _showExampleMessage,
            icon: const Icon(Icons.lightbulb_outline),
            tooltip: 'Example',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];

                return Column(
                  crossAxisAlignment: message.isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    ChatbotBubble(
                      message: message,
                    ),
                    if (message.hasRecommendations)
                      RecommendedProductsWidget(
                        products: message.recommendedProducts,
                      ),
                  ],
                );
              },
            ),
          ),
          ChatbotInputField(
            controller: _messageController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}