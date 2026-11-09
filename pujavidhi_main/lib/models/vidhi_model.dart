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
    required this.mantraSanskrit,
    required this.mantraTransliteration,
    required this.meaning,
    required this.actionInstruction,
  });
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
}

class PujaVidhi {
  final String id;
  final String title;
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
    required this.deity,
    required this.festivalTag,
    required this.regionalTag,
    required this.estimatedMinutes,
    required this.significance,
    required this.sankalpText,
    required this.samagriList,
    required this.steps,
  });
}
