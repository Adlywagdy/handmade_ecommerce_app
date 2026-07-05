class UserPreferencesModel {
  final String? category;
  final String? roomType;
  final String? roomSize;
  final List<String> colors;
  final String? style;
  final int? budget;
  final List<String> tags;

  UserPreferencesModel({
    this.category,
    this.roomType,
    this.roomSize,
    required this.colors,
    this.style,
    this.budget,
    required this.tags,
  });

  bool get hasAnyPreference {
    return category != null ||
        roomType != null ||
        roomSize != null ||
        colors.isNotEmpty ||
        style != null ||
        budget != null ||
        tags.isNotEmpty;
  }

  String get summary {
    final parts = <String>[];

    if (category != null) {
      parts.add('category: $category');
    }

    if (roomType != null) {
      parts.add('room: $roomType');
    }

    if (roomSize != null) {
      parts.add('size: $roomSize');
    }

    if (colors.isNotEmpty) {
      parts.add('colors: ${colors.join(', ')}');
    }

    if (style != null) {
      parts.add('style: $style');
    }

    if (budget != null) {
      parts.add('budget: $budget EGP');
    }

    if (tags.isNotEmpty) {
      parts.add('tags: ${tags.join(', ')}');
    }

    if (parts.isEmpty) {
      return 'I need more details about your room, colors, style, or product type.';
    }

    return parts.join(' | ');
  }
}