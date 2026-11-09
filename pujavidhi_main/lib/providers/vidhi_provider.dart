import 'package:flutter/material.dart';
import '../models/vidhi_model.dart';

class VidhiProvider with ChangeNotifier {
  final List<PujaVidhi> _vidhis = [];
  String _selectedCategory = "All";

  List<PujaVidhi> get vidhis {
    if (_selectedCategory == "All") return _vidhis;
    return _vidhis.where((v) => v.regionalTag.contains(_selectedCategory) || v.festivalTag == _selectedCategory).toList();
  }

  VidhiProvider() {
    _initVidhis();
  }

  void filterCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void toggleSamagriItem(PujaVidhi vidhi, int index) {
    vidhi.samagriList[index].isChecked = !vidhi.samagriList[index].isChecked;
    notifyListeners();
  }

  void _initVidhis() {
    _vidhis.addAll([
      PujaVidhi(
        id: "chhath_puja",
        title: "Chhath Mahaparva Vidhi",
        deity: "Bhagwan Surya & Chhathi Maiya",
        festivalTag: "Chhath",
        regionalTag: "Bihar & UP (Chhath)",
        estimatedMinutes: 45,
        significance: "Chhath Puja is an ancient Vedic festival dedicated to the Sun God Surya and Shashthi Devi for vitality, purity, and family well-being.",
        sankalpText: "ॐ अद्य अमुक गोत्रोत्पन्नोऽहं मम सकल पापक्षयपूर्वक आयुर्बलारोग्य पुष्ट्यार्थं सूर्य षष्ठी व्रतं करिष्ये।",
        samagriList: [
          SamagriItem(name: "Soop (Bamboo winnow)", quantity: "2 units", category: "Essential"),
          SamagriItem(name: "Daura (Bamboo basket)", quantity: "1 unit", category: "Essential"),
          SamagriItem(name: "Thekua (Wheat & jaggery prasadam)", quantity: "1 bowl", category: "Offering"),
          SamagriItem(name: "Sugarcane with leaves (Ganna)", quantity: "5 stalks", category: "Offering"),
          SamagriItem(name: "Radish, Ginger & Turmeric plants", quantity: "Fresh bunch", category: "Essential"),
          SamagriItem(name: "Raw Milk & Gangajal in copper lota", quantity: "500 ml", category: "Pavitra Jal"),
          SamagriItem(name: "Clay Diyas & Camphor", quantity: "21 diyas", category: "Dhoop-Deep"),
          SamagriItem(name: "Roli, Sindoor & Akshat", quantity: "1 packet each", category: "Offering"),
        ],
        steps: const [
          PujaStep(
            stepNumber: 1,
            title: "Pavitrikaran & Snan",
            mantraSanskrit: "ॐ अपवित्रः पवित्रो वा सर्वावस्थां गतोऽपि वा। यः स्मरेत्पुण्डरीकाक्षं स बाह्याभ्यन्तरः शुचिः॥",
            mantraTransliteration: "Om Apavitrah Pavitro Vaa Sarvaavasthaam Gato'pi Vaa । Yah Smaret Pundareekaaksham Sa Baahyaabhyantarah Shuchih ॥",
            meaning: "May all impurities of body and mind be washed away by remembering the lotus-eyed Supreme Lord.",
            actionInstruction: "Sprinkle Gangajal over yourself, the family, and the puja items.",
          ),
          PujaStep(
            stepNumber: 2,
            title: "Sankalp (Solemn Vow)",
            mantraSanskrit: "ॐ तत्सत् अद्य मासे कार्तिक मासे शुक्ल पक्षे षष्ठ्यां तिथौ सूर्यदेवता प्रीत्यर्थं अर्घ्यप्रदानं करिष्ये।",
            mantraTransliteration: "Om Tat Sat Adya Maase Kartika Maase Shukla Pakshe Shashthyaam Tithau Sooryadevataa Preetyartham Arghyapradaanam Karishye ।",
            meaning: "On this sacred Kartik Shukla Shashthi, I undertake this sacred offering to please Lord Surya.",
            actionInstruction: "Take water, akshat, and a flower in your right palm and recite your family gotra.",
          ),
          PujaStep(
            stepNumber: 3,
            title: "Sandhya / Usha Arghya",
            mantraSanskrit: "ॐ सूर्याय नमः। ॐ घृणिः सूर्य आदित्यः। एहि सूर्य सहस्त्रांशो तेजोराशे जगत्पते।",
            mantraTransliteration: "Om Sooryaaya Namah । Om Ghrinih Soorya Aadityah । Ehi Soorya Sahastraansho Tejo-raashe Jagatpate ।",
            meaning: "Salutations to the Sun who illuminates the entire universe. Accept our humble offerings of devotion.",
            actionInstruction: "Offer pure water and raw cow milk through the edge of the bamboo soop facing the Sun.",
          ),
          PujaStep(
            stepNumber: 4,
            title: "Pranam & Shashthi Maiya Vandana",
            mantraSanskrit: "कात्यायनि महामाये महायोगिन्यधीश्वरि। नन्दगोपसुतं देवि पतिं मे कुरु ते नमः॥",
            mantraTransliteration: "Kaatyaayani Mahaamaaye Mahaayoginyadheeshwari । Nandagopasutam Devi Patim Me Kuru Te Namah ॥",
            meaning: "We bow to Mother Shashthi for protecting our children and granting auspicious progeny.",
            actionInstruction: "Apply sacred sindoor starting from nose tip to hairline.",
          ),
        ],
      ),
      PujaVidhi(
        id: "durga_puja",
        title: "Durga Puja & Ghatasthapana",
        deity: "Maa Durga",
        festivalTag: "Navratri",
        regionalTag: "Bengal & Pan-India",
        estimatedMinutes: 50,
        significance: "Celebrates the divine victory of Maa Durga over Mahishasura, symbolizing the triumph of righteousness and inner spiritual strength.",
        sankalpText: "ॐ विष्णुर्विष्णुर्विष्णुः अद्य श्रीमद्भगवतो महापुरुषस्य विष्णोराज्ञया प्रवर्तमानस्य अद्य मासे...",
        samagriList: [
          SamagriItem(name: "Clay or Copper Kalash with coconut", quantity: "1 unit", category: "Essential"),
          SamagriItem(name: "Seven sacred grains (Sapta Dhanya)", quantity: "1 bowl", category: "Essential"),
          SamagriItem(name: "Clean red cloth for altar", quantity: "1.25 meters", category: "Offering"),
          SamagriItem(name: "Red Hibiscus flowers & Garland", quantity: "Fresh pack", category: "Flowers"),
          SamagriItem(name: "Dhoop sticks, Ghee Diya & Camphor", quantity: "1 set", category: "Dhoop-Deep"),
          SamagriItem(name: "Sindoor, Kumkum & Chandan", quantity: "1 set", category: "Offering"),
          SamagriItem(name: "Panchamrit (Milk, Curd, Ghee, Honey, Sugar)", quantity: "1 bowl", category: "Offering"),
        ],
        steps: const [
          PujaStep(
            stepNumber: 1,
            title: "Kalash Sthapana & Varun Avahan",
            mantraSanskrit: "कलशस्य मुखे विष्णुः कण्ठे रुद्रः समाश्रितः। मूले तत्र स्थितो ब्रह्मा मध्ये मातृगणाः स्मृताः॥",
            mantraTransliteration: "Kalasasya Mukhe Vishnuh Kanthe Rudrah Samaashritah । Moole Tatra Sthito Brahmaa Madhye Maatriganaah Smritaah ॥",
            meaning: "In the Kalash resides Vishnu at the mouth, Shiva at the neck, Brahma at the base, and Divine Mothers in the center.",
            actionInstruction: "Fill the pot with Gangajal, put supari, coin, mango leaves, and place the tied coconut on top.",
          ),
          PujaStep(
            stepNumber: 2,
            title: "Maa Durga Avahan (Invocation)",
            mantraSanskrit: "ॐ जयन्ती मङ्गला काली भद्रकाली कपालिनी। दुर्गा क्षमा शिवा धात्री स्वाहा स्वधा नमोऽस्तु ते॥",
            mantraTransliteration: "Om Jayanti Mangalaa Kaali Bhadrakaali Kapaalini । Durgaa Kshamaa Shivaa Dhaatri Swaahaa Swadha Namo'stu Te ॥",
            meaning: "Salutations to Jayanti, Mangala, Kali, Bhadrakali, Durga, who forgives and nurtures the entire cosmos.",
            actionInstruction: "Offer red akshat and red hibiscus flowers to Maa Durga's vigraha.",
          ),
          PujaStep(
            stepNumber: 3,
            title: "Pushpanjali & Aarti",
            mantraSanskrit: "सर्वमङ्गलमङ्गल्ये शिवे सर्वार्थसाधिके। शरण्ये त्र्यम्बके गौरि नारायणि नमोऽस्तु ते॥",
            mantraTransliteration: "Sarva Mangala Maangalye Shive Sarvaartha Saadhike । Sharanye Tryambake Gauri Naaraayani Namo'stu Te ॥",
            meaning: "To the most auspicious among all that is auspicious, the fulfiller of all wishes, we surrender to You.",
            actionInstruction: "Light the camphor and wave the pancha-pradeep diya clockwise with bell sounding.",
          ),
        ],
      ),
      PujaVidhi(
        id: "pongal_vidhi",
        title: "Pongal & Makar Sankranti Vidhi",
        deity: "Surya Bhagwan & Mother Earth",
        festivalTag: "Pongal",
        regionalTag: "Tamil Nadu (Pongal)",
        estimatedMinutes: 35,
        significance: "Thanksgiving harvest festival honoring the Sun God for abundance, vitality, and bountiful agricultural harvest.",
        sankalpText: "ॐ सूर्याय नमः अद्य मकर संक्रान्तौ सकल समृद्धये पोंगल महापूजां करिष्ये।",
        samagriList: [
          SamagriItem(name: "Clay pot decorated with turmeric plant", quantity: "1 unit", category: "Essential"),
          SamagriItem(name: "Freshly harvested rice & Moong dal", quantity: "500 grams", category: "Offering"),
          SamagriItem(name: "Jaggery (Vellam) & Pure Cow Ghee", quantity: "250 grams each", category: "Offering"),
          SamagriItem(name: "Cashews, Raisins & Cardamom pods", quantity: "50 grams", category: "Offering"),
          SamagriItem(name: "Sugarcane sticks (Karumbu)", quantity: "2 pieces", category: "Offering"),
          SamagriItem(name: "Banana leaf & Betel leaves", quantity: "5 leaves", category: "Offering"),
        ],
        steps: const [
          PujaStep(
            stepNumber: 1,
            title: "Kolam / Rangoli Preparation",
            mantraSanskrit: "ॐ भूर्भुवः स्वः तत्सवितुर्वरेण्यं भर्गो देवस्य धीमहि धियो यो नः प्रचोदयात्॥",
            mantraTransliteration: "Om Bhur Bhuva Swaha Tat Savitur Varenyam Bhargo Devasya Dheemahi Dhiyo Yo Nah Prachodayaat ॥",
            meaning: "We meditate on the divine light of the Sun God; may it illuminate our intellect.",
            actionInstruction: "Draw the auspicious rice-flour Kolam in the courtyard or puja altar.",
          ),
          PujaStep(
            stepNumber: 2,
            title: "Sweet Pongal Boiling (Pongalo Pongal!)",
            mantraSanskrit: "अन्नं वै प्राणाः। अन्नपतेऽन्नस्य नो देह्यनमीवस्य शुष्मिणः।",
            mantraTransliteration: "Annam Vai Praanaah । Annapate'nnasya No Dehyanameevasya Shushminah ॥",
            meaning: "Food is the vital life breath. Lord of food, grant us wholesome and nourishing sustenance.",
            actionInstruction: "When milk and rice boil over the pot, joyously chant 'Pongalo Pongal!'.",
          ),
          PujaStep(
            stepNumber: 3,
            title: "Naivedyam & Surya Samarpan",
            mantraSanskrit: "ॐ नमो भगवते सूर्याय नमः। आदित्याय विद्महे प्रभाकराय धीमहि तन्नः सूर्यः प्रचोदयात्॥",
            mantraTransliteration: "Om Namo Bhagavate Sooryaaya Namah । Aadityaaya Vidmahe Prabhaakaraaya Dheemahi Tannah Sooryah Prachodayaat ॥",
            meaning: "We dedicate this sweet harvest offering to Surya Bhagwan with humble gratitude.",
            actionInstruction: "Serve warm Sweet Pongal on a fresh banana leaf with sugarcane.",
          ),
        ],
      ),
      PujaVidhi(
        id: "shiva_abhishek",
        title: "Maha Shivratri Linga Abhishek",
        deity: "Lord Shiva (Mahadev)",
        festivalTag: "Shivratri",
        regionalTag: "Pan-India",
        estimatedMinutes: 40,
        significance: "Sacred abhishekam of the Shiva Linga with Panchamrit and bilva patra for peace, destruction of negative karma, and moksha.",
        sankalpText: "ॐ तत्सत् अद्य मम सकलदुरितोपशमनार्थं श्री साम्बसदाशिव प्रीतये पञ्चामृत स्नपनं करिष्ये।",
        samagriList: [
          SamagriItem(name: "Fresh Bilva Patra (Bel Patra without tears)", quantity: "21 leaves", category: "Essential"),
          SamagriItem(name: "Panchamrit (Milk, Curd, Ghee, Honey, Ganga Jal)", quantity: "Fresh set", category: "Essential"),
          SamagriItem(name: "White Chandan (Sandalwood paste) & Bhasma", quantity: "1 bowl", category: "Offering"),
          SamagriItem(name: "Dhatura flower and fruit", quantity: "2 units", category: "Flowers"),
          SamagriItem(name: "Akshat (Unbroken rice) & Janeu", quantity: "1 packet", category: "Offering"),
          SamagriItem(name: "Ghee Diya & Dhoop", quantity: "1 set", category: "Dhoop-Deep"),
        ],
        steps: const [
          PujaStep(
            stepNumber: 1,
            title: "Jal & Panchamrit Abhishek",
            mantraSanskrit: "ॐ नमः शिवाय। त्र्यम्बकं यजामहे सुगन्धिं पुष्टिवर्धनम्। उर्वारुकमिव बन्धनान्मृत्य pushyate ॥",
            mantraTransliteration: "Om Namah Shivaaya । Tryambakam Yajaamahe Sugandhim Pushtivardhanam । Urvaarukamiva Bandhanaanmrityor Muksheeya Maamritaat ॥",
            meaning: "We worship the Three-Eyed Lord Shiva, fragrant and nourisher of all. Free us from mortal bondage.",
            actionInstruction: "Gently pour continuous stream of Gangajal and Panchamrit over Shiva Linga.",
          ),
          PujaStep(
            stepNumber: 2,
            title: "Tripundra & Bilva Patra Samarpan",
            mantraSanskrit: "त्रिदलं त्रिगुणाकारं त्रिनेत्रं च त्रियायुधम्। त्रिजन्मपापसंहारं एकबिल्वं शिवार्पणम्॥",
            mantraTransliteration: "Tridalam Trigunaakaaram Trinetram Cha Triyaayudham । Trijanma Paapa Samhaaram Eka Bilvam Shivaarpanam ॥",
            meaning: "Offering a three-leaf bilva patra destroys the sins of three lifetimes. Salutations to Shiva.",
            actionInstruction: "Apply Chandan Tripundra and place Bel patra smooth side down upon the Shiva Linga.",
          ),
          PujaStep(
            stepNumber: 3,
            title: "Shiva Aarti & Pradakshina",
            mantraSanskrit: "कर्पूरगौरं करुणावतारं संसारसारम् भुजगेन्द्रहारम्। सदावसन्तं हृदयारविन्दे भवं भवानीसहितं नमामि॥",
            mantraTransliteration: "Karpura Gauram Karunaavataaram Samsaara Saaram Bhujagendra Haaram । Sadaa Vasantam Hridayaaravinde Bhavam Bhavaani Sahitam Namaami ॥",
            meaning: "Pure white as camphor, embodiment of compassion, necklace of serpents, we bow to Shiva and Bhavani.",
            actionInstruction: "Wave camphor flame and perform half-pradakshina (do not cross the Som-sutra channel).",
          ),
        ],
      ),
      PujaVidhi(
        id: "satyanarayan_vrat",
        title: "Shri Satyanarayan Vrat Katha",
        deity: "Bhagwan Vishnu",
        festivalTag: "Purnima",
        regionalTag: "Pan-India",
        estimatedMinutes: 60,
        significance: "Performed on Purnima (Full Moon) and auspicious family milestones for peace, prosperity, and truthfulness.",
        sankalpText: "ॐ अद्य सत्यनारायण प्रीत्यर्थं पूजनं तत्कथाश्रवणं च करिष्ये।",
        samagriList: [
          SamagriItem(name: "Satyanarayan Vigraha / Picture", quantity: "1 unit", category: "Essential"),
          SamagriItem(name: "Panjiri Prasad (Roasted flour, sugar, banana)", quantity: "1 large bowl", category: "Offering"),
          SamagriItem(name: "Panchamrit & Tulsi Dal", quantity: "1 bowl", category: "Essential"),
          SamagriItem(name: "Banana tree stems for mandap", quantity: "4 pillars", category: "Essential"),
          SamagriItem(name: "Yellow cloth & Yellow flowers", quantity: "1 set", category: "Flowers"),
          SamagriItem(name: "Supari, Clove & Cardamom", quantity: "5 pairs", category: "Offering"),
        ],
        steps: const [
          PujaStep(
            stepNumber: 1,
            title: "Gauri-Ganesh & Navagraha Pujan",
            mantraSanskrit: "वक्रतुण्ड महाकाय सूर्यकोटि समप्रभ। निर्विघ्नं कुरु मे देव सर्वकार्येषु सर्वदा॥",
            mantraTransliteration: "Vakratunda Mahaakaaya Sooryakoti Samaprabha । Nirvighnam Kuru Me Deva Sarva Kaaryeshu Sarvadaa ॥",
            meaning: "O Lord Ganesha of curved trunk and mighty form, remove all obstacles from our sacred rites.",
            actionInstruction: "Worship Ganesha made of turmeric or supari before initiating Vishnu worship.",
          ),
          PujaStep(
            stepNumber: 2,
            title: "Satyanarayan Avahan & Tulsi Samarpan",
            mantraSanskrit: "शान्ताकारं भुजगशयनं पद्मनाभं सुरेशं विश्वाधारं गगनसदृशं मेघवर्णं शुभाङ्गम्।",
            mantraTransliteration: "Shaantaakaaram Bhujagashayanam Padmanaabham Suresham Vishwaadhaaram Gaganasadrisham Meghavarnam Shubhaangam ।",
            meaning: "Peaceful of form, resting on cosmic serpent, lotus-naveled, Lord of gods, we worship Vishnu.",
            actionInstruction: "Offer Tulsi leaves bathed in Gangajal directly at the Lord's feet.",
          ),
          PujaStep(
            stepNumber: 3,
            title: "Katha Shravan & Mahaprasad Vitaran",
            mantraSanskrit: "ॐ जय जगदीश हरे स्वामी जय जगदीश हरे। भक्त जनों के संकट क्षण में दूर करे॥",
            mantraTransliteration: "Om Jai Jagdish Hare Swami Jai Jagdish Hare । Bhakta Janon Ke Sankat Kshan Mein Door Kare ॥",
            meaning: "Sing the sacred Aarti and distribute the blessed Panjiri prasadam with reverence.",
            actionInstruction: "Listen to the five chapters of Katha and share Prasad with all guests.",
          ),
        ],
      ),
    ]);
  }
}
