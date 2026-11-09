class GitaChapter {
  final int chapterNumber;
  final String nameSanskrit;
  final String nameEnglish;
  final String nameTranslation;
  final int versesCount;
  final String summaryHindi;
  final String summaryEnglish;
  final String keyLesson;

  const GitaChapter({
    required this.chapterNumber,
    required this.nameSanskrit,
    required this.nameEnglish,
    required this.nameTranslation,
    required this.versesCount,
    required this.summaryHindi,
    required this.summaryEnglish,
    required this.keyLesson,
  });

  Map<String, dynamic> toJson() => {
    'chapterNumber': chapterNumber,
    'nameSanskrit': nameSanskrit,
    'nameEnglish': nameEnglish,
    'nameTranslation': nameTranslation,
    'versesCount': versesCount,
    'summaryHindi': summaryHindi,
    'summaryEnglish': summaryEnglish,
    'keyLesson': keyLesson,
  };

  factory GitaChapter.fromJson(Map<String, dynamic> json) {
    return GitaChapter(
      chapterNumber: json['chapterNumber'] is int
          ? json['chapterNumber']
          : int.tryParse(json['chapterNumber']?.toString() ?? '1') ?? 1,
      nameSanskrit: json['nameSanskrit']?.toString() ?? '',
      nameEnglish: json['nameEnglish']?.toString() ?? '',
      nameTranslation: json['nameTranslation']?.toString() ?? '',
      versesCount: json['versesCount'] is int
          ? json['versesCount']
          : int.tryParse(json['versesCount']?.toString() ?? '0') ?? 0,
      summaryHindi: json['summaryHindi']?.toString() ?? '',
      summaryEnglish: json['summaryEnglish']?.toString() ?? '',
      keyLesson: json['keyLesson']?.toString() ?? '',
    );
  }
}

class GitaShloka {
  final String id;
  final int chapterNumber;
  final int verseNumber;
  final String textSanskrit;
  final String textTransliteration;
  final String wordMeanings;
  final String translationHindi;
  final String purportHindi;
  final String translationEnglish;
  final String topicTag;
  bool isBookmarked;

  GitaShloka({
    required this.id,
    required this.chapterNumber,
    required this.verseNumber,
    required this.textSanskrit,
    required this.textTransliteration,
    this.wordMeanings = '',
    required this.translationHindi,
    this.purportHindi = '',
    required this.translationEnglish,
    this.topicTag = 'General',
    this.isBookmarked = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'chapterNumber': chapterNumber,
    'verseNumber': verseNumber,
    'textSanskrit': textSanskrit,
    'textTransliteration': textTransliteration,
    'wordMeanings': wordMeanings,
    'translationHindi': translationHindi,
    'purportHindi': purportHindi,
    'translationEnglish': translationEnglish,
    'topicTag': topicTag,
    'isBookmarked': isBookmarked,
  };

  factory GitaShloka.fromJson(Map<String, dynamic> json) {
    return GitaShloka(
      id: json['id']?.toString() ?? 'gita_1_1',
      chapterNumber: json['chapterNumber'] is int
          ? json['chapterNumber']
          : int.tryParse(json['chapterNumber']?.toString() ?? '1') ?? 1,
      verseNumber: json['verseNumber'] is int
          ? json['verseNumber']
          : int.tryParse(json['verseNumber']?.toString() ?? '1') ?? 1,
      textSanskrit: json['textSanskrit']?.toString() ?? '',
      textTransliteration: json['textTransliteration']?.toString() ?? '',
      wordMeanings: json['wordMeanings']?.toString() ?? '',
      translationHindi: json['translationHindi']?.toString() ?? '',
      purportHindi: json['purportHindi']?.toString() ?? '',
      translationEnglish: json['translationEnglish']?.toString() ?? '',
      topicTag: json['topicTag']?.toString() ?? 'General',
      isBookmarked: json['isBookmarked'] == true,
    );
  }
}
