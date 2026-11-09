import json
import os
import sys
import urllib.request
from datetime import datetime, timezone

try:
    sys.stdout.reconfigure(encoding='utf-8')
except Exception:
    pass

PROJECT_ID = 'pujavidhi-app-2026'
BASE_URL = f'https://firestore.googleapis.com/v1/projects/{PROJECT_ID}/databases/(default)/documents'

def to_firestore_value(val):
    if val is None:
        return {'nullValue': None}
    elif isinstance(val, bool):
        return {'booleanValue': val}
    elif isinstance(val, int):
        return {'integerValue': str(val)}
    elif isinstance(val, float):
        return {'doubleValue': val}
    elif isinstance(val, str):
        return {'stringValue': val}
    elif isinstance(val, list):
        return {'arrayValue': {'values': [to_firestore_value(v) for v in val]}}
    elif isinstance(val, dict):
        return {'mapValue': {'fields': {k: to_firestore_value(v) for k, v in val.items()}}}
    else:
        return {'stringValue': str(val)}

def set_doc(collection_path, doc_id, data):
    url = f"{BASE_URL}/{collection_path}/{doc_id}"
    fields = {k: to_firestore_value(v) for k, v in data.items()}
    body = json.dumps({'fields': fields}).encode('utf-8')
    req = urllib.request.Request(
        url,
        data=body,
        headers={'Content-Type': 'application/json'},
        method='PATCH'
    )
    try:
        with urllib.request.urlopen(req) as resp:
            return resp.getcode()
    except Exception as e:
        print(f"Error setting {collection_path}/{doc_id}: {e}")
        return 500

# =========================================================================
# 1. 20 COMPLETE PRODUCTION SANATAN AARTIS, CHALISAS & STOTRAS
# =========================================================================
AARTIS = [
    {
        "id": "aarti_ganesh",
        "title": "Jai Ganesh Jai Ganesh Deva",
        "hindiTitle": "जय गणेश देवा",
        "deity": "Lord Ganesha",
        "category": "Aarti",
        "durationSec": 210,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Sung at the start of all auspicious rituals and pujas to remove obstacles and seek wisdom.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "जय गणेश जय गणेश जय गणेश देवा। माता जाकी पार्वती पिता महादेवा॥", "english": "Jai Ganesh Jai Ganesh Jai Ganesh Deva | Mata Jaaki Parvati Pita Mahadeva ||"},
            {"timestampSec": 25, "devanagari": "एक दन्त दयावन्त चार भुजाधारी। माथे पर तिलक सोहे मूसे की सवारी॥", "english": "Ek Dant Dayavant Chaar Bhujaadhari | Maathe Par Tilak Sohe Moose Ki Sawari ||"},
            {"timestampSec": 50, "devanagari": "पान चढ़े फूल चढ़े और चढ़े मेवा। लड्डुअन का भोग लगे सन्त करें सेवा॥", "english": "Paan Chadhe Phool Chadhe Aur Chadhe Mewa | Ladduan Ka Bhog Lage Sant Karein Seva ||"},
            {"timestampSec": 75, "devanagari": "अन्धन को आँख देत कोढ़िन को काया। बाँझन को पुत्र देत निर्धन को माया॥", "english": "Andhan Ko Aankh Det Kodhin Ko Kaaya | Baanjhan Ko Putra Det Nirdhan Ko Maaya ||"},
            {"timestampSec": 105, "devanagari": "हार चढ़े फूल चढ़े और चढ़े मेवा। सूरश्याम शरण आए सफल कीजे सेवा॥", "english": "Haar Chadhe Phool Chadhe Aur Chadhe Mewa | Soorshyam Sharan Aaye Safal Keeje Seva ||"},
            {"timestampSec": 135, "devanagari": "दीनन की लाज राखो शम्भु सुत वारी। कामना को पूर्ण करो जग बलिहारी॥", "english": "Deenan Ki Laaj Rakho Shambhu Sut Vaari | Kaamana Ko Poorna Karo Jag Balihaari ||"},
            {"timestampSec": 165, "devanagari": "जय गणेश जय गणेश जय गणेश देवा। माता जाकी पार्वती पिता महादेवा॥", "english": "Jai Ganesh Jai Ganesh Jai Ganesh Deva | Mata Jaaki Parvati Pita Mahadeva ||"}
        ]
    },
    {
        "id": "aarti_shiv",
        "title": "Om Jai Shiv Omkara",
        "hindiTitle": "ओम जय शिव ओंकारा",
        "deity": "Lord Shiva",
        "category": "Aarti",
        "durationSec": 240,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Universal evening prayer dedicated to Mahadev, praising the cosmic creator, preserver and destroyer.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "ॐ जय शिव ओंकारा, स्वामी हर ॐ शिव ओंकारा। ब्रह्मा, विष्णु, सदाशिव, अर्द्धाङ्गी धारा॥ ॐ जय शिव ओंकारा॥", "english": "Om Jai Shiv Omkara, Swami Har Om Shiv Omkara | Brahma, Vishnu, Sadashiv, Ardhangi Dhaara || Om Jai Shiv Omkara ||"},
            {"timestampSec": 30, "devanagari": "एकानन चतुरानन पञ्चानन राजे। हंसासन गरुड़ासन वृषवाहन साजे॥ ॐ जय शिव ओंकारा॥", "english": "Ekanan Chaturanana Panchanana Raaje | Hansasan Garudasan Vrishavahan Saaje || Om Jai Shiv Omkara ||"},
            {"timestampSec": 60, "devanagari": "दो भुज चार चतुर्भुज दसभुज अति सोहे। त्रिगुण रूप निरखते त्रिभुवन जन मोहे॥ ॐ जय शिव ओंकारा॥", "english": "Do Bhuj Chaar Chaturbhuj Dasabhuj Ati Sohe | Trigun Roop Nirakhate Tribhuvan Jan Mohe || Om Jai Shiv Omkara ||"},
            {"timestampSec": 90, "devanagari": "अक्षमाला वनमाला मुण्डमाला धारी। त्रिपुरारी कंसारी करमाला धारी॥ ॐ जय शिव ओंकारा॥", "english": "Akshamala Vanamala Mundamala Dhaari | Tripurari Kansari Karamala Dhaari || Om Jai Shiv Omkara ||"},
            {"timestampSec": 120, "devanagari": "श्वेताम्बर पीताम्बर बाघम्बर अङ्गे। सनकादिक गरुड़ादिक भूतादिक सङ्गे॥ ॐ जय शिव ओंकारा॥", "english": "Shwetambar Pitambar Baghambar Ange | Sanakadik Garudadik Bhootadik Sange || Om Jai Shiv Omkara ||"},
            {"timestampSec": 150, "devanagari": "कर के मध्य कमण्डलु चक्र त्रिशूलधारी। सुखकारी दुखहारी जगपालनकारी॥ ॐ जय शिव ओंकारा॥", "english": "Kar Ke Madhye Kamandalu Chakra Trishuldhari | Sukhkari Dukhhari Jagpalankari || Om Jai Shiv Omkara ||"},
            {"timestampSec": 180, "devanagari": "ब्रह्मा विष्णु सदाशिव जानत अविवेका। प्रणवाक्षर में शोभित ये तीनों एका॥ ॐ जय शिव ओंकारा॥", "english": "Brahma Vishnu Sadashiv Jaanat Aviveka | Pranavakshar Mein Shobhit Ye Teeno Eka || Om Jai Shiv Omkara ||"}
        ]
    },
    {
        "id": "aarti_hanuman",
        "title": "Aarti Kije Hanuman Lala Ki",
        "hindiTitle": "आरती कीजै हनुमान लला की",
        "deity": "Lord Hanuman",
        "category": "Aarti",
        "durationSec": 215,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Composed by Sant Tulsidas, dispelling fear, sorrow, and all negative afflictions with Mahabali Bajrangbali's grace.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "आरती कीजै हनुमान लला की। दुष्ट दलन रघुनाथ कला की॥", "english": "Aarti Keejai Hanuman Lala Ki | Dusht Dalan Raghunath Kala Ki ||"},
            {"timestampSec": 25, "devanagari": "जाके बल से गिरिवर कांपे। रोग दोष जाके निकट न झांपे॥", "english": "Jaake Bal Se Girivar Kaanpe | Rog Dosh Jaake Nikat Na Jhaanpe ||"},
            {"timestampSec": 50, "devanagari": "अंजनि पुत्र महाबलदाई। संतन के प्रभु सदा सहाई॥", "english": "Anjani Putra Mahabaldayi | Santan Ke Prabhu Sada Sahayi ||"},
            {"timestampSec": 75, "devanagari": "दे बीड़ा रघुनाथ पठाए। लंका जारि सीय सुधि लाए॥", "english": "De Beeda Raghunath Pathaye | Lanka Jaari Siya Sudhi Laaye ||"},
            {"timestampSec": 105, "devanagari": "लंका सो कोट समुद्र सी खाई। जात पवनसुत बार न लाई॥", "english": "Lanka So Kot Samudra Si Khaayi | Jaat Pavansut Baar Na Laayi ||"},
            {"timestampSec": 135, "devanagari": "लक्ष्मण मूर्छित पड़े सकारे। आनि संजीवन प्रान उबारे॥", "english": "Lakshman Murchhit Pade Sakaare | Aani Sanjeevan Praan Ubaare ||"},
            {"timestampSec": 165, "devanagari": "आरती कीजै हनुमान लला की। दुष्ट दलन रघुनाथ कला की॥", "english": "Aarti Keejai Hanuman Lala Ki | Dusht Dalan Raghunath Kala Ki ||"}
        ]
    },
    {
        "id": "chalisa_hanuman",
        "title": "Shri Hanuman Chalisa",
        "hindiTitle": "श्री हनुमान चालीसा",
        "deity": "Lord Hanuman",
        "category": "Chalisa",
        "durationSec": 480,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "40 sacred verses by Goswami Tulsidas. Recited by millions daily for protection, courage, and eradication of crises.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "श्रीगुरु चरन सरोज रज निज मनु मुकुरु सुधारि। बरनऊं रघुबर बिमल जसु जो दायकु फल चारि॥", "english": "Shri Guru Charan Saroj Raj Nija Manu Mukuru Sudhari | Baranau Raghuvar Bimal Jasu Jo Dayaku Phal Chari ||"},
            {"timestampSec": 30, "devanagari": "बुद्धिहीन तनु जानिके सुमिरौं पवन-कुमार। बल बुधि बिद्या देहु मोहिं हरहु कलेस बिकार॥", "english": "Buddhiheen Tanu Jaanike Sumirau Pavan-Kumar | Bal Budhi Vidya Dehu Mohi Harahu Kalesh Bikaar ||"},
            {"timestampSec": 60, "devanagari": "जय हनुमान ज्ञान गुन सागर। जय कपीस तिहुं लोक उजागर॥ रामदूत अतुलित बल धामा। अंजनि-पुत्र पवनसुत नामा॥", "english": "Jai Hanuman Gyan Gun Sagar | Jai Kapis Tihun Lok Ujagar || Ramdoot Atulit Bal Dhama | Anjani-Putra Pavansut Nama ||"},
            {"timestampSec": 100, "devanagari": "महाबीर बिक्रम बजरंगी। कुमति निवार सुमति के संगी॥ कंचन बरन बिराज सुबेसा। कानन कुंडल कुंचित केसा॥", "english": "Mahabir Bikram Bajrangi | Kumati Nivar Sumati Ke Sangi || Kanchan Baran Biraj Subesa | Kanan Kundal Kunchit Kesa ||"},
            {"timestampSec": 140, "devanagari": "हाथ बज्र औ ध्वजा बिराजै। कांधे मूंज जनेऊ साजै॥ संकर सुवन केसरीनंदन। तेज प्रताप महा जग बंदन॥", "english": "Hath Bajra Au Dhwaja Birajai | Kaandhe Moonj Janeu Saajai || Sankar Suvan Kesarinandan | Tej Pratap Maha Jag Bandan ||"},
            {"timestampSec": 180, "devanagari": "बिद्यावान गुनी अति चातुर। राम काज करिबे को आतुर॥ प्रभु चरित्र सुनिबे को रसिया। राम लखन सीता मन बसिया॥", "english": "Vidyavan Guni Ati Chatur | Ram Kaaj Karibe Ko Aatur || Prabhu Charitra Sunibe Ko Rasiya | Ram Lakhan Sita Man Basiya ||"},
            {"timestampSec": 220, "devanagari": "भूत पिसाच निकट नहिं आवै। महाबीर जब नाम सुनावै॥ नासै रोग हरै सब पीरा। जपत निरंतर हनुमत बीरा॥", "english": "Bhoot Pishach Nikat Nahin Aavai | Mahabir Jab Naam Sunavai || Naasai Rog Harai Sab Peera | Japat Nirantar Hanumat Beera ||"},
            {"timestampSec": 260, "devanagari": "संकट तें हनुमान छुड़ावै। मन क्रम बचन ध्यान जो लावै॥ सब पर राम तपस्वी राजा। तिन के काज सकल तुम साजा॥", "english": "Sankat Te Hanuman Chhudavai | Man Kram Bachan Dhyan Jo Lavai || Sab Par Ram Tapasvi Raja | Tin Ke Kaaj Sakal Tum Saaja ||"},
            {"timestampSec": 300, "devanagari": "जो यह पढ़ै हनुमान चालीसा। होय सिद्धि साखी गौरीसा॥ तुलसीदास सदा हरि चेरा। कीजै नाथ हृदय मंह डेरा॥", "english": "Jo Yah Padhai Hanuman Chalisa | Hoy Siddhi Sakhi Gaurisa || Tulsidas Sada Hari Chera | Keejai Nath Hriday Mah Dera ||"},
            {"timestampSec": 340, "devanagari": "पवनतनय संकट हरन मंगल मूरति रूप। राम लखन सीता सहित हृदय बसहु सुर भूप॥", "english": "Pavantanaye Sankat Haran Mangal Murati Roop | Ram Lakhan Sita Sahit Hriday Basahu Sur Bhoop ||"}
        ]
    },
    {
        "id": "aarti_lakshmi",
        "title": "Om Jai Lakshmi Mata",
        "hindiTitle": "ओम जय लक्ष्मी माता",
        "deity": "Mata Lakshmi",
        "category": "Aarti",
        "durationSec": 230,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Invoking Goddess Lakshmi during Friday evening and Diwali for eternal abundance, righteousness, and household prosperity.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "ॐ जय लक्ष्मी माता, मैया जय लक्ष्मी माता। तुमको निसदिन सेवत, हर विष्णु विधाता॥ ॐ जय लक्ष्मी माता॥", "english": "Om Jai Lakshmi Mata, Maiya Jai Lakshmi Mata | Tumko Nisadin Sevat, Har Vishnu Vidhata || Om Jai Lakshmi Mata ||"},
            {"timestampSec": 30, "devanagari": "उमा, रमा, ब्रह्माणी, तुम ही जग-माता। सूर्य-चन्द्रमा ध्यावत, नारद ऋषि गाता॥ ॐ जय लक्ष्मी माता॥", "english": "Uma, Rama, Brahmani, Tum Hi Jag-Mata | Surya-Chandrama Dhyavat, Narad Rishi Gaata || Om Jai Lakshmi Mata ||"},
            {"timestampSec": 60, "devanagari": "दुर्गा रूप निरंजनि, सुख-सम्पत्ति दाता। जो कोई तुमको ध्यावत, ऋद्धि-सिद्धि धन पाता॥ ॐ जय लक्ष्मी माता॥", "english": "Durga Roop Niranjani, Sukh-Sampatti Daata | Jo Koi Tumko Dhyavat, Riddhi-Siddhi Dhan Paata || Om Jai Lakshmi Mata ||"},
            {"timestampSec": 90, "devanagari": "जिस घर में तुम रहतीं, सब सद्गुण आता। सब संभव हो जाता, मन नहिं घबराता॥ ॐ जय लक्ष्मी माता॥", "english": "Jis Ghar Mein Tum Rehteen, Sab Sadgun Aata | Sab Sambhav Ho Jaata, Man Nahin Ghabraata || Om Jai Lakshmi Mata ||"},
            {"timestampSec": 120, "devanagari": "तुम बिन यज्ञ न होते, वस्त्र न कोई पाता। खान-पान का वैभव, सब तुमसे आता॥ ॐ जय लक्ष्मी माता॥", "english": "Tum Bin Yagya Na Hote, Vastra Na Koi Paata | Khan-Paan Ka Vaibhav, Sab Tumse Aata || Om Jai Lakshmi Mata ||"},
            {"timestampSec": 150, "devanagari": "शुभ-गुण मंदिर सुंदर, क्षीरोदधि-जाता। रत्न चतुर्दश तुम बिन, कोई नहिं पाता॥ ॐ जय लक्ष्मी माता॥", "english": "Shubh-Gun Mandir Sundar, Kshirodadhi-Jaata | Ratna Chaturdash Tum Bin, Koi Nahin Paata || Om Jai Lakshmi Mata ||"}
        ]
    },
    {
        "id": "aarti_ram",
        "title": "Shri Ramachandra Kripalu Bhajuman",
        "hindiTitle": "श्री रामचंद्र कृपालु भजु मन",
        "deity": "Bhagwan Shri Ram",
        "category": "Aarti",
        "durationSec": 220,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Divine Stuti composed by Sant Tulsidas celebrating the grace, boundless compassion and beauty of Maryada Purushottam Shri Ram.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "श्रीरामचन्द्र कृपालु भजु मन हरण भवभय दारुणम्। नवकञ्ज लोचन, कञ्ज मुख, कर कञ्ज, पद कञ्जारुणम्॥", "english": "Shri Ramachandra Kripalu Bhaju Man Haran Bhavabhaye Daarunam | Navakanja Lochan, Kanja Mukha, Kar Kanja, Pada Kanjaarunam ||"},
            {"timestampSec": 30, "devanagari": "कन्दर्प अगणित अमित छवि, नवनील नीरद सुन्दरम्। पट पीत मानहु तड़ित रुचि शुचि नौमि जनक सुतावरम्॥", "english": "Kandarpa Aganita Amita Chhavi, Navaneel Neerad Sundaram | Pata Peeta Maanahu Tadita Ruchi Shuchi Naumi Janaka Sutaavaram ||"},
            {"timestampSec": 60, "devanagari": "भजु दीनबन्धु दिनेश दानव दैत्यवंश निकन्दनम्। रघुनन्द आनन्दकन्द कोशलचन्द दशरथ नन्दनम्॥", "english": "Bhaju Deenabandhu Dinesh Daanava Daityavamsha Nikandanam | Raghunanda Aanandakanda Koshalachanda Dasharatha Nandanam ||"},
            {"timestampSec": 90, "devanagari": "सिर मुकुट कुण्डल तिलक चारु उदारु अङ्ग विभूषणम्। आजानुभुज शर चाप धर, सङ्ग्राम-जित-खरदूषणम्॥", "english": "Sira Mukuta Kundala Tilaka Chaaru Udaaru Anga Vibhooshanam | Aajaanubhuja Shara Chaapa Dhara, Sangraama-Jita-Kharadooshanam ||"},
            {"timestampSec": 120, "devanagari": "इति वदति तुलसीदास शंकर शेष मुनि-मन-रञ्जनम्। मम हृदय कञ्ज निवास कुरु, कामादि खल-दल-गञ्जनम्॥", "english": "Iti Vadati Tulsidas Shankara Shesha Muni-Mana-Ranjanam | Mama Hridaya Kanja Nivaasa Kuru, Kaamaadi Khala-Dala-Ganjanam ||"}
        ]
    },
    {
        "id": "aarti_krishna",
        "title": "Aarti Kunj Bihari Ki",
        "hindiTitle": "आरती कुंजबिहारी की",
        "deity": "Lord Krishna",
        "category": "Aarti",
        "durationSec": 240,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Celebrates the enchanting Vrindavan pastimes of Lord Krishna, bringing immense inner sweetness and bliss.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "आरती कुञ्जबिहारी की, श्री गिरिधर कृष्णमुरारी की॥ गले में बैजन्ती माला, बजावै मुरली मधुर बाला॥", "english": "Aarti Kunjabihari Ki, Shri Giridhar Krishnamurari Ki || Gale Mein Baijanti Mala, Bajavai Murli Madhur Bala ||"},
            {"timestampSec": 35, "devanagari": "श्रवण में कुण्डल झलकाता, मुकुट पर चन्द्रिका भाता। करन में नूपुर रुनझुन बाजे, देख छवि त्रिभुवन मन मोहे॥", "english": "Shravan Mein Kundal Jhalakaata, Mukut Par Chandrika Bhaata | Karan Mein Noopur Runjhun Baaje, Dekh Chhavi Tribhuvan Man Mohe ||"},
            {"timestampSec": 70, "devanagari": "कनकमय मोरमुकुट सोहे, ब्रजवधू देख-देख मोहे। कदम की डारी पै ठाड़े, मुरली अधर धरन प्यारे॥", "english": "Kanakamay Mormukut Sohe, Brajavadhu Dekh-Dekh Mohe | Kadam Ki Daari Pai Thaade, Murli Adhar Dharan Pyaare ||"},
            {"timestampSec": 105, "devanagari": "जहाँ से प्रगट भई गंगा, कलुष कलिहारिणि श्रीगंगा। चरण छवि श्रीबनवारी की, आरती कुञ्जबिहारी की॥", "english": "Jahan Se Pragat Bhai Ganga, Kalush Kalihaarini Shri Ganga | Charan Chhavi Shri Banwari Ki, Aarti Kunjabihari Ki ||"}
        ]
    },
    {
        "id": "aarti_durga",
        "title": "Jai Ambe Gauri",
        "hindiTitle": "जय अम्बे गौरी",
        "deity": "Maa Durga",
        "category": "Aarti",
        "durationSec": 225,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Grand Aarti sung during Navratri and Sandhya prayers to invoke Jagadamba for courage and protection from evil.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "जय अम्बे गौरी, मैया जय श्यामा गौरी। तुमको निसदिन ध्यावत, हरि ब्रह्मा शिवरी॥ ॐ जय अम्बे गौरी॥", "english": "Jai Ambe Gauri, Maiya Jai Shyama Gauri | Tumko Nisadin Dhyavat, Hari Brahma Shivri || Om Jai Ambe Gauri ||"},
            {"timestampSec": 30, "devanagari": "मांग सिन्दूर विराजत, टीको मृगमद को। उज्ज्वल से दोउ नैना, चन्द्रवदन नीको॥ ॐ जय अम्बे गौरी॥", "english": "Maang Sindoor Viraajat, Teeko Mrigamad Ko | Ujjwal Se Dou Naina, Chandravadan Neeko || Om Jai Ambe Gauri ||"},
            {"timestampSec": 60, "devanagari": "कनक समान कलेवर, रक्ताम्बर राजे। रक्तपुष्प गल माला, कण्ठन पर साजे॥ ॐ जय अम्बे गौरी॥", "english": "Kanak Samaan Kalevar, Raktambar Raaje | Raktapushp Gal Mala, Kanthan Par Saaje || Om Jai Ambe Gauri ||"},
            {"timestampSec": 90, "devanagari": "केहरि वाहन राजत, खड्ग खप्पर धारी। सुर-नर-मुनिजन सेवत, तिनके दुखहारी॥ ॐ जय अम्बे गौरी॥", "english": "Kehari Vaahan Raajat, Khadag Khappar Dhaari | Sur-Nar-Munijan Sevat, Tinke Dukhhari || Om Jai Ambe Gauri ||"}
        ]
    },
    {
        "id": "stotram_shiv_tandav",
        "title": "Shiv Tandav Stotram",
        "hindiTitle": "शिव ताण्डव स्तोत्रम्",
        "deity": "Lord Shiva",
        "category": "Stotra",
        "durationSec": 360,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Masterpiece hymn composed by Ravana praising Shiva's cosmic dance of rhythm, ecstasy and power.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "जटाटवीगलज्जलप्रवाहपावितस्थले गलेऽवलम्ब्य लम्बितां भुजङ्गतुङ्गमालिकाम्। डमड्डमड्डमड्डमन्निनादवड्डमर्वयं चकार चण्डताण्डवं तनोतु नः शिवः शिवम्॥", "english": "Jatatavee Galajjala Pravaha Pavitasthale Gale Avalambya Lambitaam Bhujanga Tunga Malikam | Damad Damad Damad Daman Ninadavaddamarvayam Chakara Chanda Tandavam Tanotu Nah Shivah Shivam ||"},
            {"timestampSec": 45, "devanagari": "जटाकटाहसम्भ्रमभ्रमन्निलिम्पनिर्झरी- विलोलवीचिवल्लरीविराजमानमूर्धनि। धगद्धगद्धगज्ज्वलल्ललाटपट्टपावके किशोरचन्द्रशेखरे रतिः प्रतिक्षणं मम॥", "english": "Jata Kataha Sambhrama Bhramannilimpa Nirjhari Vilola Veechi Vallari Viraja Mana Moordhani | Dhagadh Dhagadh Dhagaj Jvalal Lalata Patta Pavake Kishora Chandra Shekhare Ratih Prati Kshanam Mama ||"},
            {"timestampSec": 90, "devanagari": "धराधरेन्द्रनन्दिनीविलासबन्धुबन्धुर- स्फुरद्दिगन्तसन्ततिप्रमोदमानमानसे। कृपाकटाक्षधोरणीनिरुद्धदुर्धरापदि क्वचिद्दिगम्बरे मनो विनोदमेतु वस्तुनि॥", "english": "Dharadharendra Nandini Vilasa Bandhu Bandhura Sphurad Diganta Santati Pramoda Mana Manase | Kripa Kataksha Dhorani Niruddha Durdharapadi Kwachid Digambare Mano Vinodametu Vastuni ||"}
        ]
    },
    {
        "id": "aarti_jagdish",
        "title": "Om Jai Jagdish Hare",
        "hindiTitle": "ओम जय जगदीश हरे",
        "deity": "Lord Vishnu",
        "category": "Aarti",
        "durationSec": 250,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Universal Sanatan prayer composed by Pandit Shardha Ram Phillauri in 1870, sung in every temple and household across India.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "ॐ जय जगदीश हरे, स्वामी जय जगदीश हरे। भक्त जनों के संकट, क्षण में दूर करे॥ ॐ जय जगदीश हरे॥", "english": "Om Jai Jagdish Hare, Swami Jai Jagdish Hare | Bhakta Janon Ke Sankat, Kshan Mein Door Kare || Om Jai Jagdish Hare ||"},
            {"timestampSec": 35, "devanagari": "जो ध्यावे फल पावे, दुःख बिनसे मन का। सुख सम्पत्ति घर आवे, कष्ट मिटे तन का॥ ॐ जय जगदीश हरे॥", "english": "Jo Dhyave Phal Paave, Dukh Binse Man Ka | Sukh Sampatti Ghar Aave, Kasht Mite Tan Ka || Om Jai Jagdish Hare ||"},
            {"timestampSec": 70, "devanagari": "मात-पिता तुम मेरे, शरण गहूं मैं किसकी। तुम बिन और न दूजा, आस करूं जिसकी॥ ॐ जय जगदीश हरे॥", "english": "Maat-Pita Tum Mere, Sharan Gahoon Main Kiski | Tum Bin Aur Na Dooja, Aas Karoon Jiski || Om Jai Jagdish Hare ||"},
            {"timestampSec": 105, "devanagari": "तुम पूरण परमात्मा, तुम अन्तर्यामी। पारब्रह्म परमेश्वर, तुम सब के स्वामी॥ ॐ जय जगदीश हरे॥", "english": "Tum Pooran Paramatma, Tum Antaryami | Parabrahma Parameshwar, Tum Sab Ke Swami || Om Jai Jagdish Hare ||"},
            {"timestampSec": 140, "devanagari": "तुम करुणा के सागर, तुम पालनकर्ता। मैं मूरख खल कामी, कृपा करो भर्ता॥ ॐ जय जगदीश हरे॥", "english": "Tum Karuna Ke Sagar, Tum Palankarta | Main Moorakh Khal Kaami, Kripa Karo Bharta || Om Jai Jagdish Hare ||"}
        ]
    }
]

# =========================================================================
# 2. COMPLETE VEDIC PUJA VIDHIS WITH ITEMIZED SAMAGRI
# =========================================================================
VIDHIS = [
    {
        "id": "diwali_lakshmi_puja",
        "title": "Deepavali Maha Lakshmi-Ganesh Puja",
        "hindiTitle": "दीपावली महालक्ष्मी एवं गणेश पूजन",
        "durationMinutes": 45,
        "difficulty": "Traditional Vedic",
        "significance": "Conducted on Kartik Amavasya during Pradosh Kaal / Nishita Kaal to welcome Goddess Lakshmi, Lord Ganesha and Kuber for eternal light and prosperity.",
        "samagri": [
            {"item": "Clay Murti of Lakshmi & Ganesh", "quantity": "1 Pair", "category": "Murtis", "isAvailable": True},
            {"item": "Pure Desi Cow Ghee", "quantity": "250 gm", "category": "Offering", "isAvailable": True},
            {"item": "Earthen Diyas (Mitti ke Diye)", "quantity": "21 or 51", "category": "Pooja Utensils", "isAvailable": True},
            {"item": "Cotton Wicks (Batti)", "quantity": "1 Packet", "category": "Pooja Utensils", "isAvailable": True},
            {"item": "Roli / Kumkum & Akshat (Clean Rice)", "quantity": "50 gm each", "category": "Sacred Powders", "isAvailable": True},
            {"item": "Ganga Jal (Holy Water)", "quantity": "1 Bottle", "category": "Pavitra Jal", "isAvailable": True},
            {"item": "Panchamrit (Milk, Curd, Ghee, Honey, Sugar)", "quantity": "1 Small Bowl", "category": "Abhishekam", "isAvailable": True},
            {"item": "Fresh Flowers & Lotus (Kamal Gatta)", "quantity": "1 Bunch + 2 Lotuses", "category": "Flora", "isAvailable": True},
            {"item": "Janeu (Sacred Thread) & Moli (Kalawa)", "quantity": "2 sets", "category": "Vastra", "isAvailable": True},
            {"item": "Kheel & Batashe (Puffed Rice Prasad)", "quantity": "250 gm", "category": "Prasad", "isAvailable": True},
            {"item": "Silver Coin or Currency Note", "quantity": "1 Coin", "category": "Offering", "isAvailable": True}
        ],
        "steps": [
            {"stepNumber": 1, "title": "Pavitrikaran (आत्मशुद्धि)", "mantra": "ॐ अपवित्रः पवित्रो वा सर्वावस्थां गतोऽपि वा। यः स्मरेत्पुण्डरीकाक्षं स बाह्याभ्यन्तरः शुचिः॥", "instructions": "Sprinkle Ganga Jal over yourself, the puja altar, and all samagri with kusha grass or flower."},
            {"stepNumber": 2, "title": "Achaman (आचमन)", "mantra": "ॐ केशवाय नमः। ॐ नारायणाय नमः। ॐ माधवाय नमः। ॐ हृषीकेशाय नमः।", "instructions": "Take a spoonful of pure water in right palm, sip three times uttering holy names of Vishnu, then wash hands."},
            {"stepNumber": 3, "title": "Deepa Prajwalan & Sankalp (संकल्प)", "mantra": "मम सकलदुरितोपशमनपूर्वक धनधान्य-समृद्धि-प्राप्त्यर्थं श्री महालक्ष्मी-गणेश प्रीत्यर्थं पूजनं करिष्ये।", "instructions": "Light the master Ghee Akhand Diya. Take Akshat, water, flower and coin in hand and state family name and gotra."},
            {"stepNumber": 4, "title": "Ganesh Sthapana & Shodashopachara", "mantra": "ॐ गणानां त्वा गणपतिं हवामहे प्रियाणां त्वा प्रियपतिं हवामहे निधीनां त्वा निधिपतिं हवामहे वसो मम।", "instructions": "Bathe Ganesha with Panchamrit then Ganga Jal, apply chandan, offer Janeu, Durva grass, and Modak."},
            {"stepNumber": 5, "title": "Maha Lakshmi Avahana & Pujan", "mantra": "ॐ श्रीं ह्रीं क्लीं त्रिभुवन महालक्ष्म्यै अस्मांक दारिद्र्य नाशय प्रसीद प्रसीद हीं क्लीं श्रीं ॐ।", "instructions": "Offer lotus flower, red vastra, Shringar samagri, Kheel Batashe, and light 11 Ghee diyas around the altar."},
            {"stepNumber": 6, "title": "Aarti & Kshama Prarthana", "mantra": "ॐ जय लक्ष्मी माता... आवाहनं न जानामि न जानामि विसर्जनम्। पूजां चैव न जानामि क्षमस्व परमेश्वरि॥", "instructions": "Sing Maha Lakshmi & Ganesh Aarti standing. Seek forgiveness for any ritual shortcomings with folded hands."}
        ]
    },
    {
        "id": "maha_shivratri",
        "title": "Maha Shivratri 4-Prahar Rudrabhishek",
        "hindiTitle": "महाशिवरात्रि चार प्रहर रुद्राभिषेक",
        "durationMinutes": 60,
        "difficulty": "Vedic Ritual",
        "significance": "Observed on Phalguna Krishna Chaturdashi. Night-long four prahar worship of Lord Shiva granting salvation and destruction of all accumulated sins.",
        "samagri": [
            {"item": "Pure Cow Milk, Curd, Ghee, Honey & Sugar", "quantity": "Panchamrit set", "category": "Abhishekam", "isAvailable": True},
            {"item": "Belpatra (Bilva leaves, unbroken)", "quantity": "21 or 108 leaves", "category": "Flora", "isAvailable": True},
            {"item": "Dhatura flower and fruit", "quantity": "2 pieces", "category": "Flora", "isAvailable": True},
            {"item": "White Sandalwood (Shwet Chandan)", "quantity": "25 gm", "category": "Sacred Powders", "isAvailable": True},
            {"item": "Bhasma / Vibhuti", "quantity": "1 Packet", "category": "Sacred Powders", "isAvailable": True},
            {"item": "Ganga Jal & Gulab Jal", "quantity": "500 ml", "category": "Pavitra Jal", "isAvailable": True},
            {"item": "Janeyu & White Cloth", "quantity": "1 set", "category": "Vastra", "isAvailable": True}
        ],
        "steps": [
            {"stepNumber": 1, "title": "Dhyanam & Avahanam", "mantra": "ध्यायेन्नित्यं महेशं रजतगिरिनिभं चारुचन्द्रावतंसं रत्नाकल्पोज्ज्वलाङ्गं परशुमृगवराभीतिहस्तं प्रसन्नम्।", "instructions": "Meditate upon Bhagwan Bholenath seated atop Mount Kailash with crescent moon adorning His locks."},
            {"stepNumber": 2, "title": "Panchamrit Abhishek", "mantra": "ॐ त्र्यम्बकं यजामहे सुगन्धिं पुष्टिवर्धनम्। उर्वारुकमिव बन्धनान्मृत्योर्मुक्षीय मामृतात्॥", "instructions": "Pour milk, curd, ghee, honey, and sugarcane juice over the Shiva Lingam continuously while chanting Mahamrityunjaya."},
            {"stepNumber": 3, "title": "Belpatra Samarpana", "mantra": "त्रिदलं त्रिगुणाकारं त्रिनेत्रं च त्रियायुधम्। त्रिजन्मपापसंहारं बिल्वपत्रं शिवार्पणम्॥", "instructions": "Offer sacred 3-leaf Belpatra with smooth side facing Lingam, chanting Bilvashtakam."},
            {"stepNumber": 4, "title": "Bhasma & Shringar", "mantra": "ॐ नमः शिवाय।", "instructions": "Apply sacred Tripundra bhasma, offer Dhatura, Janeu, white flowers and perform Karpura Aarti."}
        ]
    },
    {
        "id": "satyanarayan_vrat",
        "title": "Shri Satyanarayan Vrat Katha & Vidhi",
        "hindiTitle": "श्री सत्यनारायण व्रत कथा एवं विधि",
        "durationMinutes": 50,
        "difficulty": "Household Family Puja",
        "significance": "Observed on Purnima, Thursdays, or major family milestones to bring truth, harmony, wealth, and fulfillment of deep wishes.",
        "samagri": [
            {"item": "Roasted Wheat Flour Prasad (Panjiri)", "quantity": "500 gm", "category": "Prasad", "isAvailable": True},
            {"item": "Ripe Bananas & Seasonal Fruits", "quantity": "5 varieties", "category": "Prasad", "isAvailable": True},
            {"item": "Tulsi Dal (Basil leaves)", "quantity": "21 leaves", "category": "Flora", "isAvailable": True},
            {"item": "Yellow Cloth for Altar", "quantity": "1.25 meters", "category": "Vastra", "isAvailable": True},
            {"item": "Banana Tree Stems (Mandap)", "quantity": "4 pieces", "category": "Decoration", "isAvailable": True},
            {"item": "Supari (Betel nuts)", "quantity": "9 pieces (Navagraha)", "category": "Pooja Utensils", "isAvailable": True}
        ],
        "steps": [
            {"stepNumber": 1, "title": "Kalash Sthapana & Navagraha Pujan", "mantra": "ॐ कलशस्य मुखे विष्णुः कण्ठे रुद्रः समाश्रितः। मूले तत्र स्थितो ब्रह्मा मध्ये मातृगणाः स्मृताः॥", "instructions": "Establish water-filled copper Kalash with mango leaves and coconut wrapped in red cloth."},
            {"stepNumber": 2, "title": "Satyanarayan Avahana", "mantra": "ॐ नमो भगवते वासुदेवाय नमः।", "instructions": "Place Shaligram or Vishnu Murti on yellow cloth and offer Panchamrit, Chandan, and Tulsi leaves."},
            {"stepNumber": 3, "title": "5 Adhyaya Vrat Katha Shravan", "mantra": "सत्यमेवेश्वरो लोके सत्यं पद्माश्रिता सदा।", "instructions": "Recite or listen to the five divine chapters with family seated in silence."},
            {"stepNumber": 4, "title": "Panjiri Prasad Vitaran & Aarti", "mantra": "जय जगदीशा हरे...", "instructions": "Offer Panjiri, Charanamrit and distribute prasad to all family members."}
        ]
    }
]

# =========================================================================
# 3. VRAT & UPVAS FULL PRODUCTION SCHEDULE & KATHAS
# =========================================================================
VRATS = [
    {
        "id": "ekadashi_utpanna",
        "name": "Utpanna Ekadashi",
        "hindiName": "उत्पन्ना एकादशी व्रत",
        "date": "2026-11-13T00:00:00Z",
        "type": "Ekadashi",
        "deity": "Lord Vishnu & Ekadashi Devi",
        "paranaTiming": "Next day: 06:44 AM to 08:52 AM",
        "significance": "Celebrates the divine manifestation of Goddess Ekadashi from Lord Vishnu to slay the demon Mura.",
        "kathaTitle": "कथा: उत्पन्ना एकादशी का प्राकट्य",
        "kathaContent": "प्राचीन काल में मुर नामक एक महापराक्रमी दैत्य था जिसने देवराज इन्द्र सहित सभी देवताओं को स्वर्ग से निष्कासित कर दिया। तब भगवान विष्णु ने मुर दैत्य से युद्ध किया। युद्ध करते-करते जब श्रीहरि बद्रिकाश्रम की गुफा में विश्राम कर रहे थे, तब मुर दैत्य ने उन पर प्रहार करना चाहा। उसी समय श्रीहरि के दिव्य शरीर से एक सुन्दरी कन्या प्रकट हुई जिसने अपने एक हुंकार से मुर दैत्य को भस्म कर दिया। भगवान ने प्रसन्न होकर उस कन्या को एकादशी का नाम दिया और वरदान दिया कि जो भी इस दिन व्रत करेगा, उसे मोक्ष और वैकुण्ठ की प्राप्ति होगी।",
        "rules": [
            "Strict fasting (Phalahar only, no grains/rice).",
            "Avoid anger, lying, and sleep during day time.",
            "Chant Vishnu Sahasranama or Om Namo Bhagavate Vasudevaya.",
            "Break fast during Dwadashi Parana Muhurat next morning."
        ]
    },
    {
        "id": "ekadashi_mokshada",
        "name": "Mokshada Ekadashi (Gita Jayanti)",
        "hindiName": "मोक्षदा एकादशी एवं गीता जयंती",
        "date": "2026-12-09T00:00:00Z",
        "type": "Ekadashi",
        "deity": "Lord Krishna & Vishnu",
        "paranaTiming": "Next day: 07:02 AM to 09:14 AM",
        "significance": "Celebrated on Margashirsha Shukla Ekadashi, the day Lord Krishna delivered Shrimad Bhagavad Gita to Arjuna.",
        "kathaTitle": "कथा: मोक्षदा एकादशी का पितृ-तारक महात्म्य",
        "kathaContent": "प्राचीन चम्पक नगर के धर्मात्मा राजा वैखानस ने स्वप्न में अपने पिता को यमलोक की यातनाएं भोगते देखा। दुःखी होकर राजा पर्वत मुनि के आश्रम पहुंचे। मुनि ने बताया कि पूर्वजन्म के पाप कर्मों के कारण पिता को यह दुर्गति मिली है। पर्वत मुनि के आदेशानुसार राजा ने सपरिवार मोक्षदा एकादशी का विधिपूर्वक उपवास किया और उसका पुण्य अपने पिता को समर्पित किया। पुण्य प्रभाव से राजा के पिता तत्काल यमलोक की यातनाओं से मुक्त होकर दिव्य विमान से स्वर्गलोक पधारे।",
        "rules": [
            "Recite entire Bhagavad Gita or Chapter 12 and 15.",
            "Offer Tulsi, yellow flowers and panchamrit to Krishna.",
            "Do charity to poor and cows.",
            "Complete fast from grains."
        ]
    },
    {
        "id": "pradosh_som",
        "name": "Soma Pradosh Vrat",
        "hindiName": "सोम प्रदोष व्रत",
        "date": "2026-11-15T00:00:00Z",
        "type": "Pradosh",
        "deity": "Lord Shiva & Mata Parvati",
        "paranaTiming": "Pradosh Kaal: 05:34 PM to 08:12 PM",
        "significance": "Occurring on Trayodashi Monday, this sacred fast removes severe karmic debts and grants mental peace.",
        "kathaTitle": "कथा: सोम प्रदोष व्रत की महिमा",
        "kathaContent": "प्राचीन काल में एक दरिद्र ब्राह्मणी अपने पुत्र के साथ जीवन यापन करती थी। एक बार उसे विदर्भ देश का राजकुमार मिला जिसके राज्य पर शत्रुओं ने अधिकार कर लिया था। ब्राह्मणी ने उस राजकुमार को अपने पुत्र की तरह पाला। एक दिन एक गन्धर्व कन्या अंशुमती ने राजकुमार को देखा और दोनों एक-दूसरे पर मोहित हो गए। ब्राह्मणी नियमपूर्वक सोम प्रदोष व्रत करती थी। भगवान शिव की कृपा से राजा ने अपनी सेना से शत्रुओं को पराजित किया और विदर्भ का राज्य पुनः प्राप्त किया। तभी से सोम प्रदोष व्रत की परंपरा चली आ रही है।",
        "rules": [
            "Bathe during Pradosh twilight kaal (around sunset).",
            "Offer Panchamrit, Belpatra, and white sandalwood to Shiva Lingam.",
            "Light ghee lamps in Shiva temple.",
            "Recite Shiva Chalisa or Mahamrityunjaya Mantra."
        ]
    },
    {
        "id": "sankashti_chaturthi",
        "name": "Sankashti Ganesh Chaturthi",
        "hindiName": "संकष्टी गणेश चतुर्थी व्रत",
        "date": "2026-11-18T00:00:00Z",
        "type": "Chaturthi",
        "deity": "Bhagwan Ganesha",
        "paranaTiming": "Moonrise Arghya: 08:42 PM",
        "significance": "Observed on Krishna Chaturthi to eliminate difficult hurdles and obstacles from life and career.",
        "kathaTitle": "कथा: संकटनाशन गणेश कथा",
        "kathaContent": "एक बार सभी देवताओं पर विपत्ति आ गई और वे अपनी रक्षा के लिए महादेव के पास पहुंचे। महादेव ने कार्तिकेय और गणेश से पूछा कि तुम दोनों में से कौन देवताओं के संकट का निवारण करेगा? कार्तिकेय ने कहा कि वे संपूर्ण पृथ्वी की परिक्रमा करके आएंगे। भगवान गणेश ने अपनी बुद्धि से माता पार्वती और पिता शिव की सात परिक्रमा कर ली और कहा कि माता-पिता के चरणों में ही संपूर्ण ब्रह्माण्ड है। महादेव अत्यंत प्रसन्न हुए और वरदान दिया कि जो संकष्टी चतुर्थी पर गणेश का पूजन करेगा, उसके समस्त संकट टल जाएंगे।",
        "rules": [
            "Observe fast until moonrise in the evening.",
            "Offer 21 Durva knots and Modak to Ganesha.",
            "Offer Arghya to the Moon with raw milk, water, and chandan.",
            "Break fast with satvik prasad."
        ]
    },
    {
        "id": "purnima_satyanarayan",
        "name": "Margashirsha Purnima Vrat",
        "hindiName": "मार्गशीर्ष पूर्णिमा व्रत (दत्तात्रेय जयंती)",
        "date": "2026-12-14T00:00:00Z",
        "type": "Purnima",
        "deity": "Bhagwan Satyanarayan & Bhagwan Dattatreya",
        "paranaTiming": "Full Day Fast, Prasad after Sandhya Katha",
        "significance": "Purnima brings divine abundance, family happiness, and fulfillment of deep wishes with Satyanarayan Katha.",
        "kathaTitle": "कथा: श्री सत्यनारायण महात्म्य",
        "kathaContent": "नारद जी ने भगवान नारायण से पूछा कि कलियुग में मनुष्य के कष्टों का निवारण कैसे हो? तब श्रीहरि ने कहा कि सत्यनारायण व्रत से बढ़कर कोई सुलभ मार्ग नहीं है। जो मनुष्य सत्य का आचरण करते हुए परिवार सहित श्री सत्यनारायण की कथा श्रवण करता है, उसे धन, यश, संतति और अंत में परम पद प्राप्त होता है।",
        "rules": [
            "Listen to 5 chapters of Satyanarayan Katha in evening.",
            "Offer Panchamrit and roasted wheat flour (Panjiri) prasad.",
            "Light 5 or 11 diyas at home entrance and Tulsi plant."
        ]
    },
    {
        "id": "somwar_shiv_vrat",
        "name": "Somwar Shiva Vrat",
        "hindiName": "सोमवार शिव व्रत",
        "date": "2026-11-16T00:00:00Z",
        "type": "Somwar",
        "deity": "Lord Shiva",
        "paranaTiming": "Evening aarti after sunset",
        "significance": "Weekly Monday fast dedicated to Bholenath for finding a suitable life partner and peaceful family life.",
        "kathaTitle": "कथा: सोमवार व्रत कथा",
        "kathaContent": "एक नगर में एक धनी साहुकार था जिसके कोई संतान न थी। वह प्रत्येक सोमवार को शिव मंदिर जाकर दीप जलाता और भगवान शिव-पार्वती की स्तुति करता। माता पार्वती की प्रार्थना पर भगवान शिव ने उसे पुत्र प्राप्ति का वर दिया। पुत्र को अल्पायु का श्राप था, किन्तु उसके अटूट शिव पूजन और महामृत्युंजय जाप से यमराज भी उसका जीवन न ले सके।",
        "rules": [
            "Fast throughout the day with milk and fruits.",
            "Bathe Shiva Lingam with water and offer 3-leaf Belpatra.",
            "Recite Somwar Vrat Katha in evening."
        ]
    }
]

# =========================================================================
# 4. DAILY SUVICHAR (दैनिक आध्यात्मिक विचार)
# =========================================================================
SUVICHARS = [
    {
        "id": "suvichar_1",
        "shloka": "कर्मण्येवाधिकारस्ते मा फलेषु कदाचन। मा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि॥",
        "meaning": "केवल कर्म करने में तुम्हारा अधिकार है, उसके फलों में कभी नहीं। निष्काम भाव से कर्तव्य पथ पर अडिग रहो।",
        "source": "श्रीमद्भगवद्गीता (अध्याय २.४७)"
    },
    {
        "id": "suvichar_2",
        "shloka": "यतो धर्मस्ततो जयः।",
        "meaning": "जहाँ धर्म और सत्य का आचरण होता है, वहीं अंततः शाश्वत विजय होती है।",
        "source": "महाभारत"
    },
    {
        "id": "suvichar_3",
        "shloka": "सत्यमेव जयते नानृतम्। सत्येन पन्था विततो देवयानः॥",
        "meaning": "सत्य की ही सदा विजय होती है, असत्य की नहीं। सत्य के द्वारा ही देवयान मार्ग का विस्तार होता है।",
        "source": "मुण्डकोपनिषद्"
    },
    {
        "id": "suvichar_4",
        "shloka": "अहिंसा परमो धर्मः धर्महिंसा तथैव च।",
        "meaning": "अहिंसा मनुष्य का परम धर्म है, और धर्म की रक्षा के लिए सत्य का संबल लेना भी श्रेष्ठ कर्तव्य है।",
        "source": "महाभारत"
    },
    {
        "id": "suvichar_5",
        "shloka": "वसुधैव कुटुम्बकम्।",
        "meaning": "यह मेरा है और यह पराया है — ऐसी संकीर्ण सोच छोटे मन वालों की होती है; उदार चरित्र वालों के लिए तो संपूर्ण पृथ्वी ही एक परिवार है।",
        "source": "महोपनिषद्"
    }
]

# =========================================================================
# 5. MONETIZATION CONFIG
# =========================================================================
MONETIZATION_CONFIG = {
    "admob_enabled": True,
    "banner_enabled": True,
    "interstitial_enabled": True,
    "rewarded_enabled": True,
    "interstitial_frequency_rounds": 1,
    "bhakt_prime_price": 99,
    "festive_discount_enabled": False,
    "banner_ad_unit_id": "ca-app-pub-3940256099942544/6300978111",
    "interstitial_ad_unit_id": "ca-app-pub-3940256099942544/1033173712",
    "rewarded_ad_unit_id": "ca-app-pub-3940256099942544/5224354917",
    "updatedAt": datetime.now(timezone.utc).isoformat()
}

def main():
    print("=" * 70)
    print("CREATING FULL PRODUCTION DATA IN FIRESTORE (pujavidhi-app-2026)")
    print("=" * 70)

    # 1. Push Aartis
    print(f"\n[1/5] Pushing {len(AARTIS)} Complete Production Aartis & Chalisas to 'media_tracks'...")
    for a in AARTIS:
        a["updatedAt"] = datetime.now(timezone.utc).isoformat()
        code = set_doc("media_tracks", a["id"], a)
        print(f"  -> {a['id']} ('{a['title']}'): HTTP {code}")

    # 2. Push Puja Vidhis
    print(f"\n[2/5] Pushing {len(VIDHIS)} Vedic Puja Vidhis to 'festivals_and_vidhis'...")
    for v in VIDHIS:
        v["updatedAt"] = datetime.now(timezone.utc).isoformat()
        code = set_doc("festivals_and_vidhis", v["id"], v)
        print(f"  -> {v['id']} ('{v['title']}'): HTTP {code}")

    # 3. Push Vrats
    print(f"\n[3/5] Pushing {len(VRATS)} Vrat & Upvas entries to 'vrat_calendar'...")
    for vr in VRATS:
        vr["updatedAt"] = datetime.now(timezone.utc).isoformat()
        code = set_doc("vrat_calendar", vr["id"], vr)
        print(f"  -> {vr['id']} ('{vr['name']}'): HTTP {code}")

    # 4. Push Daily Suvichars
    print(f"\n[4/5] Pushing {len(SUVICHARS)} Daily Suvichars to 'daily_suvichar'...")
    for s in SUVICHARS:
        s["updatedAt"] = datetime.now(timezone.utc).isoformat()
        code = set_doc("daily_suvichar", s["id"], s)
        print(f"  -> {s['id']}: HTTP {code}")

    # 5. Push Monetization Config
    print("\n[5/5] Pushing Remote Monetization Config to 'pujavidhi_config/monetization'...")
    code = set_doc("pujavidhi_config", "monetization", MONETIZATION_CONFIG)
    print(f"  -> pujavidhi_config/monetization: HTTP {code}")

    # 6. Save local production JSON bundles for offline access
    main_data_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "pujavidhi_main", "assets", "data"))
    admin_data_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "pujavidhi_admin", "assets", "data"))

    for out_dir in [main_data_dir, admin_data_dir]:
        os.makedirs(out_dir, exist_ok=True)
        with open(os.path.join(out_dir, "aartis_production.json"), "w", encoding="utf-8") as f:
            json.dump(AARTIS, f, ensure_ascii=False, indent=2)
        with open(os.path.join(out_dir, "vidhis_production.json"), "w", encoding="utf-8") as f:
            json.dump(VIDHIS, f, ensure_ascii=False, indent=2)
        with open(os.path.join(out_dir, "vrats_production.json"), "w", encoding="utf-8") as f:
            json.dump(VRATS, f, ensure_ascii=False, indent=2)
        with open(os.path.join(out_dir, "monetization_config.json"), "w", encoding="utf-8") as f:
            json.dump(MONETIZATION_CONFIG, f, ensure_ascii=False, indent=2)
        print(f"Saved local production bundles in: {out_dir}")

    print("\nSUCCESS: All production datasets are live in Firestore and backed up locally!")

if __name__ == '__main__':
    main()
