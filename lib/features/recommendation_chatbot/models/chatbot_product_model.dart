class ChatbotProductModel {
  final String id;
  final String name;
  final String category;
  final int price;
  final String imageUrl;
  final List<String> colors;
  final String style;
  final List<String> roomType;
  final List<String> roomSize;
  final List<String> tags;

  ChatbotProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.colors,
    required this.style,
    required this.roomType,
    required this.roomSize,
    required this.tags,
  });
}