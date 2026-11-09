import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IshtaDeity {
  final String id;
  final String name;
  final String hindiName;
  final String greeting;
  final String mantra;
  final Color primaryColor;
  final Color accentColor;
  final String defaultAartiId;
  final String iconSymbol;

  const IshtaDeity({
    required this.id,
    required this.name,
    required this.hindiName,
    required this.greeting,
    required this.mantra,
    required this.primaryColor,
    required this.accentColor,
    required this.defaultAartiId,
    required this.iconSymbol,
  });
}

class IshtaDevtaProvider with ChangeNotifier {
  static const String _keyDeity = 'pujavidhi_selected_ishta_devta';

  static const List<IshtaDeity> availableDeities = [
    IshtaDeity(
      id: 'shiva',
      name: 'Lord Shiva',
      hindiName: 'भगवान शिव (महादेव)',
      greeting: 'ॐ नमः शिवाय • हर हर महादेव',
      mantra: 'कर्पूरगौरं करुणावतारं संसारसारं भुजगेन्द्रहारम्।',
      primaryColor: Color(0xFF1E293B),
      accentColor: Color(0xFF38BDF8),
      defaultAartiId: 'aarti_shiv',
      iconSymbol: '🔱',
    ),
    IshtaDeity(
      id: 'hanuman',
      name: 'Lord Hanuman',
      hindiName: 'पवनपुत्र हनुमान (बजरंगबली)',
      greeting: 'जय बजरंगबली • संकट मोचन',
      mantra: 'मनोजवं मारुततुल्यवेगं जितेन्द्रियं बुद्धिमतां वरिष्ठम्।',
      primaryColor: Color(0xFF7C2D12),
      accentColor: Color(0xFFFB923C),
      defaultAartiId: 'aarti_hanuman',
      iconSymbol: '🚩',
    ),
    IshtaDeity(
      id: 'krishna',
      name: 'Lord Krishna',
      hindiName: 'श्री कृष्ण (गोविन्द)',
      greeting: 'राधे राधे • जय श्री कृष्णा',
      mantra: 'वसुदेवसुतं देवं कंसचाणूरमर्दनम् देवकीपरमानन्दं कृष्णं वन्दे जगद्गुरुम्।',
      primaryColor: Color(0xFF0F172A),
      accentColor: Color(0xFFFBBF24),
      defaultAartiId: 'aarti_krishna',
      iconSymbol: '🪶',
    ),
    IshtaDeity(
      id: 'durga',
      name: 'Maa Durga',
      hindiName: 'माँ दुर्गा (जगदम्बा)',
      greeting: 'जय माता दी • सर्वमंगल मांगल्ये',
      mantra: 'सर्वमङ्गलमाङ्गल्ये शिवे सर्वार्थसाधिके शरण्ये त्र्यम्बके गौरि नारायणि नमोऽस्तु ते।',
      primaryColor: Color(0xFF831843),
      accentColor: Color(0xFFF43F5E),
      defaultAartiId: 'aarti_durga',
      iconSymbol: '🦁',
    ),
    IshtaDeity(
      id: 'ganesha',
      name: 'Lord Ganesha',
      hindiName: 'भगवान गणेश (विघ्नहर्ता)',
      greeting: 'गणपति बप्पा मोरया • श्री गणेशाय नमः',
      mantra: 'वक्रतुण्ड महाकाय सूर्यकोटि समप्रभ। निर्विघ्नं कुरु मे देव सर्वकार्येषु सर्वदा॥',
      primaryColor: Color(0xFF78350F),
      accentColor: Color(0xFFF59E0B),
      defaultAartiId: 'aarti_ganesh',
      iconSymbol: '🐘',
    ),
    IshtaDeity(
      id: 'ram',
      name: 'Lord Rama',
      hindiName: 'श्री राम (मर्यादा पुरुषोत्तम)',
      greeting: 'जय सिया राम • रघुपति राघव',
      mantra: 'रामाय रामभद्राय रामचन्द्राय वेधसे। रघुनाथाय नाथाय सीतायाः पतये नमः॥',
      primaryColor: Color(0xFF7E191B),
      accentColor: Color(0xFFF59E0B),
      defaultAartiId: 'aarti_ram',
      iconSymbol: '🏹',
    ),
  ];

  IshtaDeity _selectedDeity = availableDeities[0];

  IshtaDeity get selectedDeity => _selectedDeity;

  IshtaDevtaProvider() {
    _loadDeity();
  }

  Future<void> _loadDeity() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString(_keyDeity);
      if (id != null) {
        _selectedDeity = availableDeities.firstWhere(
          (d) => d.id == id,
          orElse: () => availableDeities[0],
        );
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> selectDeity(IshtaDeity deity) async {
    _selectedDeity = deity;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyDeity, deity.id);
    } catch (_) {}
  }
}
