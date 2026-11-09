class ChoghadiyaSlot {
  final String name;
  final String nature; // Shubh, Amrit, Labh, Char, Rog, Kaal, Udveg
  final String timing;
  final bool isAuspicious;

  const ChoghadiyaSlot({
    required this.name,
    required this.nature,
    required this.timing,
    required this.isAuspicious,
  });
}

class PanchangData {
  final DateTime date;
  final String tithi;
  final String paksha;
  final String nakshatra;
  final String yoga;
  final String karana;
  final String sunrise;
  final String sunset;
  final String moonrise;
  final String abhijitMuhurat;
  final String rahuKaal;
  final String yamaganda;
  final String gulikaKaal;
  final String specialFestival;
  final List<ChoghadiyaSlot> dayChoghadiya;
  final List<ChoghadiyaSlot> nightChoghadiya;

  const PanchangData({
    required this.date,
    required this.tithi,
    required this.paksha,
    required this.nakshatra,
    required this.yoga,
    required this.karana,
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.abhijitMuhurat,
    required this.rahuKaal,
    required this.yamaganda,
    required this.gulikaKaal,
    required this.specialFestival,
    required this.dayChoghadiya,
    required this.nightChoghadiya,
  });

  factory PanchangData.forDate(DateTime date) {
    // Deterministic Vedic calculations for date
    final dayOfWeek = date.weekday;
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;

    final tithiNames = [
      "Pratipada", "Dwitiya", "Tritiya", "Chaturthi", "Panchami",
      "Shashthi", "Saptami", "Ashtami", "Navami", "Dashami",
      "Ekadashi", "Dwadashi", "Trayodashi", "Chaturdashi", "Purnima / Amavasya"
    ];
    final nakshatraNames = [
      "Ashwini", "Bharani", "Krittika", "Rohini", "Mrigashirsha",
      "Ardra", "Punarvasu", "Pushya", "Ashlesha", "Magha",
      "Purva Phalguni", "Uttara Phalguni", "Hasta", "Chitra", "Swati",
      "Vishakha", "Anuradha", "Jyeshtha", "Mula", "Purva Ashadha",
      "Uttara Ashadha", "Shravana", "Dhanishta", "Shatabhisha",
      "Purva Bhadrapada", "Uttara Bhadrapada", "Revati"
    ];
    final yogaNames = [
      "Vishkumbha", "Priti", "Ayushman", "Saubhagya", "Shobhana",
      "Atiganda", "Sukarma", "Dhriti", "Shula", "Ganda",
      "Vriddhi", "Dhruva", "Vyaghata", "Harshana", "Vajra",
      "Siddhi", "Vyatipata", "Variyan", "Parigha", "Shiva",
      "Siddha", "Sadhya", "Shubha", "Shukla", "Brahma", "Indra", "Vaidhriti"
    ];

    final tithiIdx = (dayOfYear + date.day) % tithiNames.length;
    final nakshatraIdx = (dayOfYear * 2 + date.day) % nakshatraNames.length;
    final yogaIdx = (dayOfYear + date.month) % yogaNames.length;
    final isShukla = (dayOfYear % 30) < 15;

    // Daily Rahu Kaal lookup based on weekday
    final rahuKaalMap = {
      DateTime.monday: "07:30 AM - 09:00 AM",
      DateTime.tuesday: "03:00 PM - 04:30 PM",
      DateTime.wednesday: "12:00 PM - 01:30 PM",
      DateTime.thursday: "01:30 PM - 03:00 PM",
      DateTime.friday: "10:30 AM - 12:00 PM",
      DateTime.saturday: "09:00 AM - 10:30 AM",
      DateTime.sunday: "04:30 PM - 06:00 PM",
    };

    final yamagandaMap = {
      DateTime.monday: "10:30 AM - 12:00 PM",
      DateTime.tuesday: "09:00 AM - 10:30 AM",
      DateTime.wednesday: "07:30 AM - 09:00 AM",
      DateTime.thursday: "06:00 AM - 07:30 AM",
      DateTime.friday: "03:00 PM - 04:30 PM",
      DateTime.saturday: "01:30 PM - 03:00 PM",
      DateTime.sunday: "12:00 PM - 01:30 PM",
    };

    return PanchangData(
      date: date,
      tithi: tithiNames[tithiIdx],
      paksha: isShukla ? "Shukla Paksha" : "Krishna Paksha",
      nakshatra: nakshatraNames[nakshatraIdx],
      yoga: yogaNames[yogaIdx],
      karana: "Bava / Balava",
      sunrise: "06:38 AM",
      sunset: "05:32 PM",
      moonrise: "07:15 PM",
      abhijitMuhurat: "11:43 AM - 12:28 PM",
      rahuKaal: rahuKaalMap[dayOfWeek] ?? "04:30 PM - 06:00 PM",
      yamaganda: yamagandaMap[dayOfWeek] ?? "12:00 PM - 01:30 PM",
      gulikaKaal: "01:30 PM - 03:00 PM",
      specialFestival: _getFestivalForDate(date),
      dayChoghadiya: const [
        ChoghadiyaSlot(name: "Amrit", nature: "Best (Nectar)", timing: "06:38 AM - 08:00 AM", isAuspicious: true),
        ChoghadiyaSlot(name: "Kaal", nature: "Inauspicious", timing: "08:00 AM - 09:22 AM", isAuspicious: false),
        ChoghadiyaSlot(name: "Shubh", nature: "Good / Auspicious", timing: "09:22 AM - 10:44 AM", isAuspicious: true),
        ChoghadiyaSlot(name: "Rog", nature: "Inauspicious", timing: "10:44 AM - 12:05 PM", isAuspicious: false),
        ChoghadiyaSlot(name: "Udveg", nature: "Anxiety / Inauspicious", timing: "12:05 PM - 01:27 PM", isAuspicious: false),
        ChoghadiyaSlot(name: "Char", nature: "Neutral / Travel", timing: "01:27 PM - 02:49 PM", isAuspicious: true),
        ChoghadiyaSlot(name: "Labh", nature: "Gain / Prosperous", timing: "02:49 PM - 04:10 PM", isAuspicious: true),
        ChoghadiyaSlot(name: "Amrit", nature: "Best (Nectar)", timing: "04:10 PM - 05:32 PM", isAuspicious: true),
      ],
      nightChoghadiya: const [
        ChoghadiyaSlot(name: "Char", nature: "Travel / Neutral", timing: "05:32 PM - 06:55 PM", isAuspicious: true),
        ChoghadiyaSlot(name: "Rog", nature: "Inauspicious", timing: "06:55 PM - 08:17 PM", isAuspicious: false),
        ChoghadiyaSlot(name: "Kaal", nature: "Inauspicious", timing: "08:17 PM - 09:39 PM", isAuspicious: false),
        ChoghadiyaSlot(name: "Labh", nature: "Gain / Good", timing: "09:39 PM - 11:01 PM", isAuspicious: true),
        ChoghadiyaSlot(name: "Udveg", nature: "Inauspicious", timing: "11:01 PM - 12:23 AM", isAuspicious: false),
        ChoghadiyaSlot(name: "Shubh", nature: "Auspicious", timing: "12:23 AM - 01:45 AM", isAuspicious: true),
        ChoghadiyaSlot(name: "Amrit", nature: "Nectar", timing: "01:45 AM - 03:07 AM", isAuspicious: true),
        ChoghadiyaSlot(name: "Char", nature: "Neutral", timing: "03:07 AM - 06:38 AM", isAuspicious: true),
      ],
    );
  }

  static String _getFestivalForDate(DateTime date) {
    if (date.month == 11 && date.day == 9) return "Dev Deepawali & Kartik Purnima";
    if (date.month == 11 && date.day == 10) return "Margashirsha Krishna Pratipada";
    if (date.month == 10 && date.day == 24) return "Shubh Deepawali";
    if (date.month == 3 && date.day == 25) return "Holi / Rangotsav";
    if (date.month == 1 && date.day == 14) return "Makar Sankranti & Pongal";
    return "Sadhana & Shubh Muhurat Day";
  }
}
