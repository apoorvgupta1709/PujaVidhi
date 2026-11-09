import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage {
  english('en', 'English', 'English'),
  hindi('hi', 'हिन्दी', 'Hindi'),
  gujarati('gu', 'ગુજરાતી', 'Gujarati'),
  marathi('mr', 'मराठी', 'Marathi'),
  tamil('ta', 'தமிழ்', 'Tamil'),
  telugu('te', 'తెలుగు', 'Telugu'),
  bengali('bn', 'বাংলা', 'Bengali');

  final String code;
  final String nativeName;
  final String englishName;
  const AppLanguage(this.code, this.nativeName, this.englishName);
}

class LocalizationService with ChangeNotifier {
  static const String _keyLang = 'pujavidhi_selected_language';
  AppLanguage _currentLanguage = AppLanguage.english;

  AppLanguage get currentLanguage => _currentLanguage;
  String get languageCode => _currentLanguage.code;

  LocalizationService() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_keyLang) ?? 'en';
      _currentLanguage = AppLanguage.values.firstWhere(
        (l) => l.code == code,
        orElse: () => AppLanguage.english,
      );
      notifyListeners();
    } catch (_) {}
  }

  Future<void> setLanguage(AppLanguage lang) async {
    _currentLanguage = lang;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyLang, lang.code);
    } catch (_) {}
  }

  // Translation Strings dictionary
  static final Map<String, Map<String, String>> _strings = {
    'app_name': {
      'en': 'PujaVidhi',
      'hi': 'पूजाविधि',
      'gu': 'પૂજાવિધિ',
      'mr': 'पूजाविधी',
      'ta': 'பூஜாவிதி',
      'te': 'పూజావిధి',
      'bn': 'পূজাবিধি',
    },
    'home': {
      'en': 'Home',
      'hi': 'होम',
      'gu': 'હોમ',
      'mr': 'मुख्य',
      'ta': 'முகப்பு',
      'te': 'హోమ్',
      'bn': 'হোম',
    },
    'panchang': {
      'en': 'Panchang',
      'hi': 'पंचांग',
      'gu': 'પંચાંગ',
      'mr': 'पंचांग',
      'ta': 'பஞ்சாங்கம்',
      'te': 'పంచాంగం',
      'bn': 'পঞ্জিকা',
    },
    'vrats': {
      'en': 'Vrat & Upvas',
      'hi': 'व्रत एवं उपवास',
      'gu': 'વ્રત અને ઉપવાસ',
      'mr': 'व्रत व उपवास',
      'ta': 'விரதம்',
      'te': 'వ్రతాలు',
      'bn': 'ব্রত ও উপবাস',
    },
    'aartis': {
      'en': 'Aartis',
      'hi': 'आरतियां',
      'gu': 'આરતીઓ',
      'mr': 'आरत्या',
      'ta': 'ஆரத்திகள்',
      'te': 'హారతులు',
      'bn': 'আরতি',
    },
    'vidhis': {
      'en': 'Puja Vidhis',
      'hi': 'पूजा विधियां',
      'gu': 'પૂજા વિધિઓ',
      'mr': 'पूजा विधी',
      'ta': 'பூஜை முறைகள்',
      'te': 'పూజా విధానాలు',
      'bn': 'পূজা পদ্ধতি',
    },
    'japa_mala': {
      'en': 'Japa Mala',
      'hi': 'जप माला',
      'gu': 'જપ માળા',
      'mr': 'जप माळ',
      'ta': 'ஜெப மாலை',
      'te': 'జప మాల',
      'bn': 'জপ মালা',
    },
    'virtual_diya': {
      'en': 'Akhand Diya',
      'hi': 'अखंड दिया',
      'gu': 'અખંડ દીવો',
      'mr': 'अखंड दिवा',
      'ta': 'அகண்ட தீபம்',
      'te': 'అఖండ దీపం',
      'bn': 'অখণ্ড প্রদীপ',
    },
    'wallpapers': {
      'en': '4K Wallpapers',
      'hi': '4K वॉलपेपर',
      'gu': '4K વૉલપેપર્સ',
      'mr': '4K वॉलपेपर',
      'ta': '4K வால்பேப்பர்கள்',
      'te': '4K వాల్‌పేపర్లు',
      'bn': '4K ওয়ালপেপার',
    },
    'greeting_cards': {
      'en': 'Card Maker',
      'hi': 'शुभकामना कार्ड',
      'gu': 'શુભકામના કાર્ડ',
      'mr': 'शुभेच्छा कार्ड',
      'ta': 'வாழ்த்து அட்டை',
      'te': 'శుభాకాంక్షల కార్డు',
      'bn': 'শুভেচ্ছা কার্ড',
    },
    'prime_pass': {
      'en': 'Bhakt Prime',
      'hi': 'भक्त प्राइम',
      'gu': 'ભક્ત પ્રાઇમ',
      'mr': 'भक्त प्राईम',
      'ta': 'பக்த பிரைம்',
      'te': 'భక్త్ ప్రైమ్',
      'bn': 'ভক্ত প্রাইম',
    },
    'settings': {
      'en': 'Settings',
      'hi': 'सेटिंग्स',
      'gu': 'સેટિંગ્સ',
      'mr': 'सेटिंग्ज',
      'ta': 'அமைப்புகள்',
      'te': 'సెట్టింగులు',
      'bn': 'সেটিংস',
    },
    'share_whatsapp': {
      'en': 'Share on WhatsApp',
      'hi': 'व्हाट्सएप पर शेयर करें',
      'gu': 'વોટ્સએપ પર શેર કરો',
      'mr': 'व्हॉट्सॲपवर शेअर करा',
      'ta': 'வாட்ஸ்அப்பில் பகிரவும்',
      'te': 'వాట్సాప్‌లో షేర్ చేయండి',
      'bn': 'হোয়াটসঅ্যাপে শেয়ার করুন',
    },
    'export_samagri': {
      'en': 'Export Samagri List',
      'hi': 'सामग्री सूची साझा करें',
      'gu': 'સામગ્રી યાદી શેર કરો',
      'mr': 'सामग्री यादी पाठवा',
      'ta': 'பொருட்கள் பட்டியலை அனுப்பு',
      'te': 'సామగ్రి జాబితా షేర్ చేయండి',
      'bn': 'সামগ্রী তালিকা শেয়ার করুন',
    },
    'sign_in': {
      'en': 'Sign In',
      'hi': 'साइन इन करें',
      'gu': 'સાઇન ઇન',
      'mr': 'साइन इन',
      'ta': 'உள்நுழையவும்',
      'te': 'సైన్ ఇన్',
      'bn': 'সাইন ইন',
    },
    'guest_user': {
      'en': 'Guest Devotee',
      'hi': 'अतिथि भक्त',
      'gu': 'અતિથિ ભક્ત',
      'mr': 'अतिथी भक्त',
      'ta': 'விருந்தினர் பக்தர்',
      'te': 'అతిథి భక్తుడు',
      'bn': 'অতিথি ভক্ত',
    },
  };

  String tr(String key, {String fallback = ''}) {
    final langMap = _strings[key];
    if (langMap == null) return fallback.isNotEmpty ? fallback : key;
    return langMap[_currentLanguage.code] ?? langMap['en'] ?? (fallback.isNotEmpty ? fallback : key);
  }
}
