import 'package:flutter/material.dart';

class DevotionalWallpaper {
  final String id;
  final String title;
  final String deity;
  final String imageUrl;
  final String thumbnail;
  final String mantraSanskrit;
  final String quoteEnglish;
  final List<Color> gradientColors;
  final String iconBadge;
  final bool isFeatured;
  final bool is4k;
  final int downloadsCount;
  final String category;

  const DevotionalWallpaper({
    required this.id,
    required this.title,
    required this.deity,
    required this.imageUrl,
    this.thumbnail = '',
    this.mantraSanskrit = '',
    this.quoteEnglish = '',
    this.gradientColors = const [Color(0xFF1E1B4B), Color(0xFF312E81), Color(0xFF6366F1)],
    this.iconBadge = '🕉️',
    this.isFeatured = true,
    this.is4k = true,
    this.downloadsCount = 108,
    this.category = 'General',
  });

  static Color _parseColor(String? hexString) {
    if (hexString == null || hexString.isEmpty) return const Color(0xFF1E1B4B);
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    try {
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return const Color(0xFF1E1B4B);
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'deity': deity,
    'imageUrl': imageUrl,
    'thumbnail': thumbnail,
    'mantraSanskrit': mantraSanskrit,
    'quoteEnglish': quoteEnglish,
    'gradientColors': gradientColors.map((c) => '#${c.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}').toList(),
    'iconBadge': iconBadge,
    'isFeatured': isFeatured,
    'is4k': is4k,
    'downloadsCount': downloadsCount,
    'category': category,
  };

  factory DevotionalWallpaper.fromJson(Map<String, dynamic> json) {
    List<Color> colors = [const Color(0xFF1E1B4B), const Color(0xFF312E81), const Color(0xFF6366F1)];
    if (json['gradientColors'] is List) {
      colors = (json['gradientColors'] as List)
          .map((c) => _parseColor(c.toString()))
          .toList();
    }

    return DevotionalWallpaper(
      id: json['id']?.toString() ?? 'wp_${DateTime.now().millisecondsSinceEpoch}',
      title: json['title']?.toString() ?? 'Divine Darshan',
      deity: json['deity']?.toString() ?? 'All Deities',
      imageUrl: json['imageUrl']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ?? json['imageUrl']?.toString() ?? '',
      mantraSanskrit: json['mantraSanskrit']?.toString() ?? '',
      quoteEnglish: json['quoteEnglish']?.toString() ?? '',
      gradientColors: colors.isEmpty ? [const Color(0xFF1E1B4B), const Color(0xFF312E81)] : colors,
      iconBadge: json['iconBadge']?.toString() ?? '🕉️',
      isFeatured: json['isFeatured'] == true || json['isFeatured'] == 'true',
      is4k: json['is4k'] != false && json['is4k'] != 'false',
      downloadsCount: int.tryParse(json['downloadsCount']?.toString() ?? '108') ?? 108,
      category: json['category']?.toString() ?? 'General',
    );
  }
}
