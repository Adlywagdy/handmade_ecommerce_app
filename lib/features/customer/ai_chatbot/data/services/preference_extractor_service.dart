import '../models/user_preferences_model.dart';

class PreferenceExtractorService {
  UserPreferencesModel extract(String message) {
    final text = message.toLowerCase();

    String? category;
    String? roomType;
    String? roomSize;
    String? style;
    int? budget;

    final List<String> colors = [];
    final List<String> tags = [];

    // Categories
    if (_containsAny(text, ['شمعة', 'شموع', 'candle', 'candles'])) {
      category = 'candles';
      tags.add('candle');
    }

    if (_containsAny(text, ['فازة', 'فازات', 'vase', 'ceramic'])) {
      category = 'ceramic_vases';
      tags.add('vase');
      tags.add('ceramic');
    }

    if (_containsAny(text, ['مكرمية', 'ماكرميه', 'macrame'])) {
      category = 'macrame';
      tags.add('macrame');
    }

    if (_containsAny(text, ['رف', 'ارفف', 'رفوف', 'shelf', 'shelves'])) {
      category = 'wooden_shelves';
      tags.add('wooden_shelf');
    }

    if (_containsAny(text, ['لمبة', 'اباجورة', 'lamp', 'light'])) {
      category = 'handmade_lamps';
      tags.add('lamp');
      tags.add('lighting');
    }

    if (_containsAny(text, ['كروشيه', 'crochet'])) {
      category = 'crochet_products';
      tags.add('crochet');
    }

    // Room type
    if (_containsAny(text, ['اوضة نوم', 'أوضة نوم', 'غرفة نوم', 'bedroom'])) {
      roomType = 'bedroom';
      tags.add('bedroom');
    }

    if (_containsAny(text, ['ريسبشن', 'ليفنج', 'living', 'living room'])) {
      roomType = 'living_room';
      tags.add('living_room');
    }

    if (_containsAny(text, ['مكتب', 'office', 'desk'])) {
      roomType = 'office';
      tags.add('office');
    }

    if (_containsAny(text, ['مطبخ', 'kitchen'])) {
      roomType = 'kitchen';
      tags.add('kitchen');
    }

    if (_containsAny(text, ['بلكونة', 'بالكونة', 'balcony'])) {
      roomType = 'balcony';
      tags.add('balcony');
    }

    if (_containsAny(text, ['اطفال', 'أطفال', 'kids', 'kids room'])) {
      roomType = 'kids_room';
      tags.add('kids_room');
    }

    if (_containsAny(text, ['حمام', 'bathroom'])) {
      roomType = 'bathroom';
      tags.add('bathroom');
    }

    // Room size
    if (_containsAny(text, ['صغيرة', 'صغيره', 'small'])) {
      roomSize = 'small';
      tags.add('small_room');
    }

    if (_containsAny(text, ['متوسطة', 'متوسطه', 'medium'])) {
      roomSize = 'medium';
    }

    if (_containsAny(text, ['كبيرة', 'كبيره', 'large'])) {
      roomSize = 'large';
    }

    // Colors
    _addColorIfFound(text, colors, tags, ['pink', 'بينك', 'وردي'], 'pink');
    _addColorIfFound(text, colors, tags, ['white', 'ابيض', 'أبيض'], 'white');
    _addColorIfFound(text, colors, tags, ['yellow', 'اصفر', 'أصفر'], 'yellow');
    _addColorIfFound(text, colors, tags, ['blue', 'ازرق', 'أزرق'], 'blue');
    _addColorIfFound(text, colors, tags, ['green', 'اخضر', 'أخضر'], 'green');
    _addColorIfFound(text, colors, tags, ['brown', 'بني'], 'brown');
    _addColorIfFound(text, colors, tags, ['black', 'اسود', 'أسود'], 'black');
    _addColorIfFound(text, colors, tags, ['beige', 'بيج'], 'beige');
    _addColorIfFound(text, colors, tags, ['cream', 'كريمي'], 'cream');
    _addColorIfFound(text, colors, tags, ['purple', 'موف', 'بنفسجي'], 'purple');
    _addColorIfFound(text, colors, tags, ['red', 'احمر', 'أحمر'], 'red');
    _addColorIfFound(text, colors, tags, ['orange', 'برتقالي'], 'orange');
    _addColorIfFound(text, colors, tags, ['gold', 'ذهبي'], 'gold');

    // Style
    if (_containsAny(text, ['رومانسي', 'رقيق', 'رقيقة', 'romantic'])) {
      style = 'romantic';
      tags.add('romantic');
    }

    if (_containsAny(text, ['هادي', 'هادئ', 'بسيط', 'minimal', 'calm'])) {
      style = 'minimal';
      tags.add('minimal');
      tags.add('calm');
    }

    if (_containsAny(text, ['مودرن', 'modern'])) {
      style = 'modern';
      tags.add('modern');
    }

    if (_containsAny(text, ['بوهيمي', 'boho'])) {
      style = 'boho';
      tags.add('boho');
    }

    if (_containsAny(text, ['كوzy', 'cozy', 'دافي', 'دافئ'])) {
      style = 'cozy';
      tags.add('cozy');
    }

    if (_containsAny(text, ['طبيعي', 'natural'])) {
      style = 'natural';
      tags.add('natural');
    }

    if (_containsAny(text, ['ملون', 'colorful'])) {
      style = 'colorful';
      tags.add('colorful');
    }

    // Budget extraction: simple numbers
    budget = _extractBudget(text);

    return UserPreferencesModel(
      category: category,
      roomType: roomType,
      roomSize: roomSize,
      colors: colors.toSet().toList(),
      style: style,
      budget: budget,
      tags: tags.toSet().toList(),
    );
  }

  bool _containsAny(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword.toLowerCase()));
  }

  void _addColorIfFound(
    String text,
    List<String> colors,
    List<String> tags,
    List<String> keywords,
    String color,
  ) {
    if (_containsAny(text, keywords)) {
      colors.add(color);
      tags.add(color);
    }
  }

  int? _extractBudget(String text) {
    final regex = RegExp(r'\d+');
    final matches = regex.allMatches(text).toList();

    if (matches.isEmpty) return null;

    final numbers = matches
        .map((match) => int.tryParse(match.group(0) ?? ''))
        .whereType<int>()
        .toList();

    if (numbers.isEmpty) return null;

    return numbers.reduce((a, b) => a > b ? a : b);
  }
}