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
    'login_title': {
      'en': 'Devotee Sign In',
      'hi': 'भक्त लॉगिन',
      'gu': 'ભક્ત લૉગિન',
      'mr': 'भक्त लॉगिन',
      'ta': 'பக்தர் உள்நுழைவு',
      'te': 'భక్తుల లాగిన్',
      'bn': 'ভক্ত লগইন',
    },
    'welcome_title': {
      'en': 'Welcome to PujaVidhi',
      'hi': 'पूजाविधि में आपका स्वागत है',
      'gu': 'પૂજાવિધિમાં આપનું સ્વાગત છે',
      'mr': 'पूजाविधी मध्ये आपले स्वागत आहे',
      'ta': 'பூஜாவிதிக்கு வரவேற்கிறோம்',
      'te': 'పూజావిధికి స్వాగతం',
      'bn': 'পূজাবিধিতে আপনাকে স্বাগতম',
    },
    'login_subtitle': {
      'en': 'Sign in to sync your Japa Sadhana, Bhagavad Gita bookmarks, and customized festival cards across devices.',
      'hi': 'अपनी जप साधना, भगवद्गीता श्लोक और त्योहार शुभकामना कार्ड्स को सिंक करने हेतु लॉगिन करें।',
      'gu': 'તમારી જપ સાધના અને ગીતા શ્લોક સિંક કરવા માટે લૉગિન કરો.',
      'mr': 'आपली जप साधना आणि गीता श्लोक सिंक करण्यासाठी लॉगिन करा.',
      'ta': 'உங்கள் ஜெப சாதனை மற்றும் கீதை வசனங்களை ஒத்திசைக்க உள்நுழையவும்.',
      'te': 'మీ జప సాధన మరియు గీతా శ్లోకాలను సింక్ చేయడానికి లాగిన్ అవ్వండి.',
      'bn': 'আপনার জপ সাধনা ও গীতার শ্লোক সিঙ্ক করতে সাইন ইন করুন।',
    },
    'email': {
      'en': 'Email Address',
      'hi': 'ईमेल पता',
      'gu': 'ઇમેઇલ સરનામું',
      'mr': 'ईमेल पत्ता',
      'ta': 'மின்னஞ்சல் முகவரி',
      'te': 'ఈమెయిల్ చిరునామా',
      'bn': 'ইমেল ঠিকানা',
    },
    'password': {
      'en': 'Password',
      'hi': 'पासवर्ड',
      'gu': 'પાસવર્ડ',
      'mr': 'पासवर्ड',
      'ta': 'கடவுச்சொல்',
      'te': 'పాస్‌వర్డ్',
      'bn': 'পাসওয়ার্ড',
    },
    'confirm_password': {
      'en': 'Confirm Password',
      'hi': 'पासवर्ड की पुष्टि करें',
      'gu': 'પાસવર્ડની પુષ્ટિ કરો',
      'mr': 'पासवर्डची पुष्टी करा',
      'ta': 'கடவுச்சொல்லை உறுதிப்படுத்தவும்',
      'te': 'పాస్‌వర్డ్‌ను నిర్ధారించండి',
      'bn': 'পাসওয়ার্ড নিশ্চিত করুন',
    },
    'forgot_password': {
      'en': 'Forgot Password?',
      'hi': 'पासवर्ड भूल गए?',
      'gu': 'પાસવર્ડ ભૂલી ગયા છો?',
      'mr': 'पासवर्ड विसरलात?',
      'ta': 'கடவுச்சொல்லை மறந்துவிட்டீர்களா?',
      'te': 'పాస్‌వర్డ్ మర్చిపోయారా?',
      'bn': 'পাসওয়ার্ড ভুলে গেছেন?',
    },
    'continue_google': {
      'en': 'Continue with Google',
      'hi': 'Google के साथ आगे बढ़ें',
      'gu': 'Google સાથે ચાલુ રાખો',
      'mr': 'Google सह सुरू ठेवा',
      'ta': 'Google உடன் தொடரவும்',
      'te': 'Google తో కొనసాగించండి',
      'bn': 'Google এর সাথে এগিয়ে যান',
    },
    'continue_guest': {
      'en': 'Continue as Guest',
      'hi': 'अतिथि के रूप में जारी रखें',
      'gu': 'અતિથિ તરીકે ચાલુ રાખો',
      'mr': 'अतिथी म्हणून सुरू ठेवा',
      'ta': 'விருந்தினராக தொடரவும்',
      'te': 'అతిథిగా కొనసాగించండి',
      'bn': 'অতিথি হিসাবে চালিয়ে যান',
    },
    'dont_have_account': {
      'en': "Don't have an account? Sign Up",
      'hi': 'खाता नहीं है? नया पंजीकरण करें',
      'gu': 'ખાતું નથી? સાઇન અપ કરો',
      'mr': 'खाते नाही का? नोंदणी करा',
      'ta': 'கணக்கு இல்லையா? பதிவு செய்க',
      'te': 'ఖాతా లేదా? సైన్ అప్ చేయండి',
      'bn': 'অ্যাকাউন্ট নেই? সাইন আপ করুন',
    },
    'already_have_account': {
      'en': 'Already have an account? Sign In',
      'hi': 'पहले से खाता है? साइन इन करें',
      'gu': 'પહેલેથી ખાતું છે? સાઇન ઇન કરો',
      'mr': 'आधीच खाते आहे? साइन इन करा',
      'ta': 'ஏற்கனவே கணக்கு உள்ளதா? உள்நுழையவும்',
      'te': 'ఇప్పటికే ఖాతా ఉందా? సైన్ ఇన్ చేయండి',
      'bn': 'ইতিমধ্যে অ্যাকাউন্ট আছে? সাইন ইন করুন',
    },
    'register_title': {
      'en': 'Create Devotee Account',
      'hi': 'नया भक्त पंजीकरण',
      'gu': 'નવું ભક્ત રજીસ્ટ્રેશન',
      'mr': 'नवीन भक्त नोंदणी',
      'ta': 'புதிய பக்தர் கணக்கு உருவாக்கவும்',
      'te': 'కొత్త భక్త ఖాతాను సృష్టించండి',
      'bn': 'নতুন ভক্ত অ্যাকাউন্ট তৈরি করুন',
    },
    'full_name': {
      'en': 'Full Name',
      'hi': 'पूरा नाम',
      'gu': 'પૂરું નામ',
      'mr': 'पूर्ण नाव',
      'ta': 'முழு பெயர்',
      'te': 'పూర్తి పేరు',
      'bn': 'সম্পূর্ণ নাম',
    },
    'family_name': {
      'en': 'Greeting Card Family Name',
      'hi': 'ग्रीटिंग कार्ड परिवार का नाम',
      'gu': 'શુભેચ્છા કાર્ડ પરિવારનું નામ',
      'mr': 'शुभेच्छा कार्ड कुटुंबाचे नाव',
      'ta': 'வாழ்த்து அட்டை குடும்ப பெயர்',
      'te': 'శుభాకాంక్షల కార్డు కుటుంబ పేరు',
      'bn': 'শুভেচ্ছা কার্ড পরিবারের নাম',
    },
    'create_account': {
      'en': 'Create Account',
      'hi': 'पंजीकरण करें',
      'gu': 'ખાતું બનાવો',
      'mr': 'खाते तयार करा',
      'ta': 'கணக்கு உருவாக்கவும்',
      'te': 'ఖాతాను సృష్టించండి',
      'bn': 'অ্যাকাউন্ট তৈরি করুন',
    },
    'profile_title': {
      'en': 'Devotee Profile',
      'hi': 'भक्त प्रोफ़ाइल',
      'gu': 'ભક્ત પ્રોફાઇલ',
      'mr': 'भक्त प्रोफाइल',
      'ta': 'பக்தர் சுயவிவரம்',
      'te': 'భక్తుని ప్రొఫైల్',
      'bn': 'ভক্ত প্রোফাইল',
    },
    'cloud_verified': {
      'en': 'Verified Cloud Devotee',
      'hi': 'सत्यापित क्लाउड भक्त',
      'gu': 'પ્રમાણિત ક્લાઉડ ભક્ત',
      'mr': 'प्रमाणित क्लाउड भक्त',
      'ta': 'சரிபார்க்கப்பட்ட பக்தர்',
      'te': 'ధృవీకరించబడిన భక్తుడు',
      'bn': 'যাচাইকৃত ভক্ত',
    },
    'guest_mode': {
      'en': 'Guest Mode',
      'hi': 'अतिथि मोड',
      'gu': 'અતિથિ મોડ',
      'mr': 'अतिथी मोड',
      'ta': 'விருந்தினர் நிலை',
      'te': 'అతిథి మోడ్',
      'bn': 'অতিথি মোড',
    },
    'spiritual_sadhana': {
      'en': 'Spiritual Sadhana Summary',
      'hi': 'दैनिक साधना प्रगति',
      'gu': 'દૈનિક સાધના પ્રગતિ',
      'mr': 'दैनंदिन साधना प्रगती',
      'ta': 'ஆன்மீக சாதனை விவரம்',
      'te': 'ఆధ్యాత్మిక సాధన సారాంశం',
      'bn': 'আধ্যাত্মিক সাধনা অগ্রগতি',
    },
    'malas_completed': {
      'en': 'Malas Chanted',
      'hi': 'जप मालाएं पूर्ण',
      'gu': 'જપ માળા પૂર્ણ',
      'mr': 'जप माळा पूर्ण',
      'ta': 'ஜெப மாலைகள்',
      'te': 'పూర్తయిన జప మాలలు',
      'bn': 'সম্পূর্ণ জপমালা',
    },
    'verses_bookmarked': {
      'en': 'Verses Bookmarked',
      'hi': 'श्लोक सहेजे गए',
      'gu': 'શ્લોક સાચવેલ',
      'mr': 'श्लोक सेव्ह केले',
      'ta': 'சேமிக்கப்பட்ட ஸ்லோகங்கள்',
      'te': 'బుక్‌మార్క్ చేసిన శ్లోకాలు',
      'bn': 'সংরক্ষিত শ্লোক',
    },
    'ishta_devta': {
      'en': 'Ishta Devta',
      'hi': 'इष्ट देव',
      'gu': 'ઇષ્ટ દેવ',
      'mr': 'इष्ट दैवत',
      'ta': 'இஷ்ட தெய்வம்',
      'te': 'ఇష్ట దైవం',
      'bn': 'ইষ্ট দেবতা',
    },
    'choose_ishta_devta': {
      'en': 'Choose Ishta Devta',
      'hi': 'अपने इष्ट देव का चयन करें',
      'gu': 'તમારા ઇષ્ટ દેવ પસંદ કરો',
      'mr': 'आपले इष्ट दैवत निवडा',
      'ta': 'உங்கள் இஷ்ட தெய்வத்தைத் தேர்ந்தெடுக்கவும்',
      'te': 'మీ ఇష్ట దైవాన్ని ఎంచుకోండి',
      'bn': 'আপনার ইষ্ট দেবতা নির্বাচন করুন',
    },
    'sign_out': {
      'en': 'Sign Out',
      'hi': 'लॉग आउट',
      'gu': 'લૉગ આઉટ',
      'mr': 'लॉग आउट',
      'ta': 'வெளியேறு',
      'te': 'లాగ్ అవుట్',
      'bn': 'লগ আউট',
    },
    'cancel': {
      'en': 'Cancel',
      'hi': 'रद्द करें',
      'gu': 'રદ કરો',
      'mr': 'रद्द करा',
      'ta': 'ரத்துசெய்',
      'te': 'రద్దు చేయండి',
      'bn': 'বাতিল করুন',
    },
    'save': {
      'en': 'Save',
      'hi': 'सहेजें',
      'gu': 'સાચવો',
      'mr': 'जतन करा',
      'ta': 'சேமிக்கவும்',
      'te': 'భద్రపరచండి',
      'bn': 'সংরক্ষণ করুন',
    },
    'today_panchang': {
      'en': "Today's Panchang",
      'hi': 'आज का पंचांग',
      'gu': 'આજનું પંચાંગ',
      'mr': 'आजचे पंचांग',
      'ta': 'இன்றைய பஞ்சாங்கம்',
      'te': 'నేటి పంచాంగం',
      'bn': 'আজকের পঞ্জিকা',
    },
    'full_view': {
      'en': 'Full View',
      'hi': 'विस्तार देखें',
      'gu': 'સંપૂર્ણ જુઓ',
      'mr': 'पूर्ण पहा',
      'ta': 'முழு விவரம்',
      'te': 'పూర్తి వివరాలు',
      'bn': 'সম্পূর্ণ বিবরণ',
    },
    'tithi': {
      'en': 'Tithi',
      'hi': 'तिथि',
      'gu': 'તિથિ',
      'mr': 'तिथी',
      'ta': 'திதி',
      'te': 'తిథి',
      'bn': 'তিথি',
    },
    'nakshatra': {
      'en': 'Nakshatra',
      'hi': 'नक्षत्र',
      'gu': 'નક્ષત્ર',
      'mr': 'नक्षत्र',
      'ta': 'நட்சத்திரம்',
      'te': 'నక్షత్రం',
      'bn': 'নক্ষত্র',
    },
    'abhijit_muhurat': {
      'en': 'Abhijit Muhurat (Shubh)',
      'hi': 'अभिजीत मुहूर्त (शुभ)',
      'gu': 'અભિજીત મુહૂર્ત (શુભ)',
      'mr': 'अभिजीत मुहूर्त (शुभ)',
      'ta': 'அபிஜித் முஹூர்த்தம் (சுப)',
      'te': 'అభిజిత్ ముహూర్తం (శుభ)',
      'bn': 'অভিজিৎ মুহূর্ত (শুভ)',
    },
    'rahu_kaal': {
      'en': 'Rahu Kaal (Varjya)',
      'hi': 'राहु काल (अशुभ)',
      'gu': 'રાહુ કાળ (અશુભ)',
      'mr': 'राहु काळ (अशुभ)',
      'ta': 'ராகு காலம்',
      'te': 'రాహు కాలం',
      'bn': 'রাহু কাল',
    },
  };

  String tr(String key, {String fallback = ''}) {
    final langMap = _strings[key];
    if (langMap == null) return fallback.isNotEmpty ? fallback : key;
    return langMap[_currentLanguage.code] ?? langMap['en'] ?? (fallback.isNotEmpty ? fallback : key);
  }
}
