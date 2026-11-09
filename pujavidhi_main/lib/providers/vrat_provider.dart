import 'dart:async';
import 'package:flutter/material.dart';
import '../models/vrat_model.dart';
import '../services/firebase_sync_service.dart';

class VratProvider with ChangeNotifier {
  List<VratItem> _vrats = [];
  String _selectedFilter = 'All';
  StreamSubscription<List<VratItem>>? _vratsSub;

  List<VratItem> get vrats {
    if (_selectedFilter == 'All') return _vrats;
    return _vrats.where((v) => v.type == _selectedFilter).toList();
  }

  String get selectedFilter => _selectedFilter;

  VratProvider() {
    _loadVrats();
    _vratsSub = FirebaseSyncService.vratsStream.listen((updatedList) {
      if (updatedList.isNotEmpty) {
        _vrats = List.from(updatedList);
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _vratsSub?.cancel();
    super.dispose();
  }

  void _loadVrats() {
    if (FirebaseSyncService.latestVrats.isNotEmpty) {
      _vrats = List.from(FirebaseSyncService.latestVrats);
    } else {
      _initVrats();
    }
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void _initVrats() {
    _vrats.addAll([
      VratItem(
        id: 'ekadashi_utpanna',
        name: 'Utpanna Ekadashi',
        hindiName: 'उत्पन्ना एकादशी व्रत',
        date: DateTime.now().add(const Duration(days: 4)),
        type: 'Ekadashi',
        deity: 'Lord Vishnu & Ekadashi Devi',
        paranaTiming: 'Next day: 06:44 AM to 08:52 AM',
        significance: 'Celebrates the divine manifestation of Goddess Ekadashi from Lord Vishnu to slay the demon Mura.',
        kathaTitle: 'कथा: उत्पन्ना एकादशी का प्राकट्य',
        kathaContent: 'प्राचीन काल में मुर नामक एक महापराक्रमी दैत्य था जिसने देवराज इन्द्र सहित सभी देवताओं को स्वर्ग से निष्कासित कर दिया। तब भगवान विष्णु ने मुर दैत्य से युद्ध किया। युद्ध करते-करते जब श्रीहरि बद्रिकाश्रम की गुफा में विश्राम कर रहे थे, तब मुर दैत्य ने उन पर प्रहार करना चाहा। उसी समय श्रीहरि के दिव्य शरीर से एक सुन्दरी कन्या प्रकट हुई जिसने अपने एक हुंकार से मुर दैत्य को भस्म कर दिया। भगवान ने प्रसन्न होकर उस कन्या को एकादशी का नाम दिया और वरदान दिया कि जो भी इस दिन व्रत करेगा, उसे मोक्ष और वैकुण्ठ की प्राप्ति होगी।',
        rules: [
          'Strict fasting (Phalahar only, no grains/rice).',
          'Avoid anger, lying, and sleep during day time.',
          'Chant Vishnu Sahasranama or Om Namo Bhagavate Vasudevaya.',
          'Break fast during Dwadashi Parana Muhurat next morning.'
        ],
      ),
      VratItem(
        id: 'pradosh_som',
        name: 'Soma Pradosh Vrat',
        hindiName: 'सोम प्रदोष व्रत',
        date: DateTime.now().add(const Duration(days: 6)),
        type: 'Pradosh',
        deity: 'Lord Shiva & Mata Parvati',
        paranaTiming: 'Pradosh Kaal: 05:34 PM to 08:12 PM',
        significance: 'Occurring on Trayodashi Monday, this sacred fast removes severe karmic debts and grants mental peace.',
        kathaTitle: 'कथा: सोम प्रदोष व्रत की महिमा',
        kathaContent: 'प्राचीन काल में एक दरिद्र ब्राह्मणी अपने पुत्र के साथ जीवन यापन करती थी। एक बार उसे विदर्भ देश का राजकुमार मिला जिसके राज्य पर शत्रुओं ने अधिकार कर लिया था। ब्राह्मणी ने उस राजकुमार को अपने पुत्र की तरह पाला। एक दिन एक गन्धर्व कन्या अंशुमती ने राजकुमार को देखा और दोनों एक-दूसरे पर मोहित हो गए। ब्राह्मणी नियमपूर्वक सोम प्रदोष व्रत करती थी। भगवान शिव की कृपा से राजा ने अपनी सेना से शत्रुओं को पराजित किया और विदर्भ का राज्य पुनः प्राप्त किया। तभी से सोम प्रदोष व्रत की परंपरा चली आ रही है।',
        rules: [
          'Bathe during Pradosh twilight kaal (around sunset).',
          'Offer Panchamrit, Belpatra, and white sandalwood to Shiva Lingam.',
          'Light ghee lamps in Shiva temple.',
          'Recite Shiva Chalisa or Mahamrityunjaya Mantra.'
        ],
      ),
      VratItem(
        id: 'sankashti_chaturthi',
        name: 'Sankashti Ganesh Chaturthi',
        hindiName: 'संकष्टी गणेश चतुर्थी व्रत',
        date: DateTime.now().add(const Duration(days: 9)),
        type: 'Chaturthi',
        deity: 'Bhagwan Ganesha',
        paranaTiming: 'Moonrise Arghya: 08:42 PM',
        significance: 'Observed on Krishna Chaturthi to eliminate difficult hurdles and obstacles from life and career.',
        kathaTitle: 'कथा: संकटनाशन गणेश कथा',
        kathaContent: 'एक बार सभी देवताओं पर विपत्ति आ गई और वे अपनी रक्षा के लिए महादेव के पास पहुंचे। महादेव ने कार्तिकेय और गणेश से पूछा कि तुम दोनों में से कौन देवताओं के संकट का निवारण करेगा? कार्तिकेय ने कहा कि वे संपूर्ण पृथ्वी की परिक्रमा करके आएंगे। भगवान गणेश ने अपनी बुद्धि से माता पार्वती और पिता शिव की सात परिक्रमा कर ली और कहा कि माता-पिता के चरणों में ही संपूर्ण ब्रह्माण्ड है। महादेव अत्यंत प्रसन्न हुए और वरदान दिया कि जो संकष्टी चतुर्थी पर गणेश का पूजन करेगा, उसके समस्त संकट टल जाएंगे।',
        rules: [
          'Observe fast until moonrise in the evening.',
          'Offer 21 Durva knots and Modak to Ganesha.',
          'Offer Arghya to the Moon with raw milk, water, and chandan.',
          'Break fast with satvik prasad.'
        ],
      ),
      VratItem(
        id: 'purnima_satyanarayan',
        name: 'Kartik / Margashirsha Purnima Vrat',
        hindiName: 'पूर्णिमा व्रत एवं सत्यनारायण कथा',
        date: DateTime.now().add(const Duration(days: 12)),
        type: 'Purnima',
        deity: 'Bhagwan Satyanarayan & Maa Lakshmi',
        paranaTiming: 'Full Day Fast, Prasad after Sandhya Katha',
        significance: 'Purnima brings divine abundance, family happiness, and fulfillment of deep wishes with Satyanarayan Katha.',
        kathaTitle: 'कथा: श्री सत्यनारायण महात्म्य',
        kathaContent: 'नारद जी ने भगवान नारायण से पूछा कि कलियुग में मनुष्य के कष्टों का निवारण कैसे हो? तब श्रीहरि ने कहा कि सत्यनारायण व्रत से बढ़कर कोई सुलभ मार्ग नहीं है। जो मनुष्य सत्य का आचरण करते हुए परिवार सहित श्री सत्यनारायण की कथा श्रवण करता है, उसे धन, यश, संतति और अंत में परम पद प्राप्त होता है।',
        rules: [
          'Listen to 5 chapters of Satyanarayan Katha in evening.',
          'Offer Panchamrit and roasted wheat flour (Panjiri) prasad.',
          'Light 5 or 11 diyas at home entrance and Tulsi plant.'
        ],
      ),
      VratItem(
        id: 'amavasya_pitru',
        name: 'Margashirsha Amavasya (Pitru Tarpana)',
        hindiName: 'मार्गशीर्ष अमावस्या (पितृ तर्पण)',
        date: DateTime.now().add(const Duration(days: 26)),
        type: 'Amavasya',
        deity: 'Lord Vishnu & Pitru Devas',
        paranaTiming: 'After Midday Tarpana: 01:15 PM',
        significance: 'Bestowing peace, ancestral blessings, and freedom from Pitru Dosh through charity and sacred baths.',
        kathaTitle: 'महात्म्य: अमावस्या पितृ तर्पण',
        kathaContent: 'गरुड़ पुराण के अनुसार अमावस्या तिथि पर पितृगण अपने वंशजों के घर के द्वार पर आते हैं और जल व अन्न की आशा रखते हैं। इस दिन पीपल के वृक्ष में जल चढ़ाने, काले तिल दान करने और ब्राह्मण या निर्धनों को भोजन कराने से सात पीढ़ियों के पितृ तृप्त होकर सुख-समृद्धि का आशीर्वाद देते हैं।',
        rules: [
          'Offer water with black sesame seeds (Kala Til) facing South.',
          'Water the Peepal tree and light a mustard oil diya at sunset.',
          'Feed cows, dogs, and crows with satvik food.'
        ],
      ),
      VratItem(
        id: 'somwar_shiv_vrat',
        name: 'Shravan/Somwar Shiva Vrat',
        hindiName: 'सोमवार शिव व्रत',
        date: DateTime.now().add(const Duration(days: 2)),
        type: 'Somwar',
        deity: 'Lord Shiva',
        paranaTiming: 'Evening aarti after sunset',
        significance: 'Weekly Monday fast dedicated to Bholenath for finding a suitable life partner and peaceful family life.',
        kathaTitle: 'कथा: सोमवार व्रत कथा',
        kathaContent: 'एक नगर में एक धनी साहुकार था जिसके कोई संतान न थी। वह प्रत्येक सोमवार को शिव मंदिर जाकर दीप जलाता और भगवान शिव-पार्वती की स्तुति करता। माता पार्वती की प्रार्थना पर भगवान शिव ने उसे पुत्र प्राप्ति का वर दिया। पुत्र को अल्पायु का श्राप था, किन्तु उसके अटूट शिव पूजन और महामृत्युंजय जाप से यमराज भी उसका जीवन न ले सके।',
        rules: [
          'Fast throughout the day with milk and fruits.',
          'Bathe Shiva Lingam with water and offer 3-leaf Belpatra.',
          'Recite Somwar Vrat Katha in evening.'
        ],
      ),
    ]);
  }
}
