class PujaStep {
  final int stepNumber;
  final String title;
  final String mantraSanskrit;
  final String mantraTransliteration;
  final String meaning;
  final String actionInstruction;

  const PujaStep({
    required this.stepNumber,
    required this.title,
    this.mantraSanskrit = '',
    this.mantraTransliteration = '',
    this.meaning = '',
    this.actionInstruction = '',
  });

  Map<String, dynamic> toJson() => {
    'stepNumber': stepNumber,
    'title': title,
    'mantraSanskrit': mantraSanskrit,
    'mantraTransliteration': mantraTransliteration,
    'meaning': meaning,
    'actionInstruction': actionInstruction,
  };

  factory PujaStep.fromJson(Map<String, dynamic> json) {
    return PujaStep(
      stepNumber: json['stepNumber'] is int
          ? json['stepNumber']
          : int.tryParse(json['stepNumber']?.toString() ?? '1') ?? 1,
      title: json['title']?.toString() ?? '',
      mantraSanskrit: json['mantraSanskrit']?.toString() ?? json['mantra']?.toString() ?? '',
      mantraTransliteration: json['mantraTransliteration']?.toString() ?? '',
      meaning: json['meaning']?.toString() ?? json['description']?.toString() ?? '',
      actionInstruction: json['actionInstruction']?.toString() ?? json['description']?.toString() ?? '',
    );
  }
}

class SamagriItem {
  final String name;
  final String quantity;
  final String category; // Essential, Flowers, Fragrance, Offering
  bool isChecked;

  SamagriItem({
    required this.name,
    required this.quantity,
    required this.category,
    this.isChecked = false,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'quantity': quantity,
    'category': category,
    'isChecked': isChecked,
  };

  factory SamagriItem.fromJson(Map<String, dynamic> json) {
    return SamagriItem(
      name: json['name']?.toString() ?? '',
      quantity: json['quantity']?.toString() ?? '',
      category: json['category']?.toString() ?? 'Essential',
      isChecked: json['isChecked'] == true,
    );
  }
}

class PujaVidhi {
  final String id;
  final String title;
  final String hindiTitle;
  final String deity;
  final String festivalTag;
  final String regionalTag; // Pan-India, Bihar/UP (Chhath), Tamil Nadu (Pongal), Bengal (Durga Puja)
  final int estimatedMinutes;
  final String significance;
  final String sankalpText;
  final List<SamagriItem> samagriList;
  final List<PujaStep> steps;

  PujaVidhi({
    required this.id,
    required this.title,
    this.hindiTitle = '',
    required this.deity,
    required this.festivalTag,
    required this.regionalTag,
    required this.estimatedMinutes,
    required this.significance,
    required this.sankalpText,
    required this.samagriList,
    required this.steps,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'hindiTitle': hindiTitle,
    'deity': deity,
    'festivalTag': festivalTag,
    'regionalTag': regionalTag,
    'estimatedMinutes': estimatedMinutes,
    'significance': significance,
    'sankalpText': sankalpText,
    'samagriList': samagriList.map((s) => s.toJson()).toList(),
    'steps': steps.map((s) => s.toJson()).toList(),
  };

  factory PujaVidhi.fromJson(Map<String, dynamic> json) {
    final rawSamagri = json['samagriList'] as List<dynamic>? ?? [];
    final rawSteps = json['steps'] as List<dynamic>? ?? [];
    return PujaVidhi(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      hindiTitle: json['hindiTitle']?.toString() ?? '',
      deity: json['deity']?.toString() ?? '',
      festivalTag: json['festivalTag']?.toString() ?? '',
      regionalTag: json['regionalTag']?.toString() ?? '',
      estimatedMinutes: json['estimatedMinutes'] is int
          ? json['estimatedMinutes']
          : int.tryParse(json['estimatedMinutes']?.toString() ?? '30') ?? 30,
      significance: json['significance']?.toString() ?? '',
      sankalpText: json['sankalpText']?.toString() ?? '',
      samagriList: rawSamagri.map((s) => SamagriItem.fromJson(s as Map<String, dynamic>)).toList(),
      steps: rawSteps.map((s) => PujaStep.fromJson(s as Map<String, dynamic>)).toList(),
    );
  }
}
