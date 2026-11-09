import json
import os
import urllib.request
import urllib.error
from datetime import datetime

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
    except urllib.error.HTTPError as e:
        print(f"Error setting {collection_path}/{doc_id}: {e.code} {e.read().decode()[:300]}")
        return e.code

# ==========================================
# 1. 14 PRODUCTION COMPLETE SANATAN AARTIS
# ==========================================
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
        "hindiTitle": "ॐ जय शिव ओंकारा",
        "deity": "Lord Shiva",
        "category": "Aarti",
        "durationSec": 240,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "The eternal Maha Aarti of Lord Shiva celebrating the cosmic Trinity of Brahma, Vishnu, and Maheshwar.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "ॐ जय शिव ओंकारा, प्रभु हर शिव ओंकारा। ब्रह्मा, विष्णु, सदाशिव, अर्द्धाङ्गी धारा॥ ॐ जय शिव ओंकारा॥", "english": "Om Jai Shiv Omkara, Prabhu Har Shiv Omkara | Brahma Vishnu Sadashiv Ardhangi Dhaara || Om Jai Shiv Omkara ||"},
            {"timestampSec": 30, "devanagari": "एकानन चतुरानन पञ्चानन राजे। हंसासन गरुड़ासन वृषवाहन साजे॥ ॐ जय शिव ओंकारा॥", "english": "Ekanan Chaturanana Panchanana Raje | Hansasan Garudasan Vrishavahan Saaje || Om Jai Shiv Omkara ||"},
            {"timestampSec": 60, "devanagari": "दो भुज चार चतुर्भुज दसमुख अति सोहे। त्रिगुण रूप निरखते त्रिभुवन जन मोहे॥ ॐ जय शिव ओंकारा॥", "english": "Do Bhuj Chaar Chaturbhuj Dasmukh Ati Sohe | Trigun Roop Nirakhte Tribhuvan Jan Mohe || Om Jai Shiv Omkara ||"},
            {"timestampSec": 90, "devanagari": "अक्षमाला वनमाला मुण्डमाला धारी। त्रिपुरारी कंसारी कर माला धारी॥ ॐ जय शिव ओंकारा॥", "english": "Akshamala Vanamala Mundamala Dhaari | Tripurari Kansari Kar Mala Dhaari || Om Jai Shiv Omkara ||"},
            {"timestampSec": 120, "devanagari": "श्वेताम्बर पीताम्बर बाघम्बर अङ्गे। सनकादिक गरुड़ादिक भूतादिक सङ्गे॥ ॐ जय शिव ओंकारा॥", "english": "Shwetambar Peetambar Baghambar Ange | Sanakaadik Garudaadik Bhootadik Sange || Om Jai Shiv Omkara ||"},
            {"timestampSec": 150, "devanagari": "कर के मध्य कमण्डलु चक्र त्रिशूल धरता। जगकर्ता जगभर्ता जगसंहारकर्ता॥ ॐ जय शिव ओंकारा॥", "english": "Kar Ke Madhya Kamandalu Chakra Trishool Dharta | Jagkarta Jagbharta Jagsanharkarta || Om Jai Shiv Omkara ||"},
            {"timestampSec": 180, "devanagari": "ब्रह्मा विष्णु सदाशिव जानत अविवेका। प्रणवाक्षर में शोभित ये तीनों एका॥ ॐ जय शिव ओंकारा॥", "english": "Brahma Vishnu Sadashiv Jaanat Aviveka | Pranavakshar Mein Shobhit Ye Teeno Eka || Om Jai Shiv Omkara ||"},
            {"timestampSec": 210, "devanagari": "त्रिगुण शिवजी की आरती जो कोई नर गावे। कहत शिवानन्द स्वामी मनवांछित फल पावे॥ ॐ जय शिव ओंकारा॥", "english": "Trigun Shivji Ki Aarti Jo Koi Nar Gaave | Kahat Shivanand Swami Manvaanchhit Phal Paave || Om Jai Shiv Omkara ||"}
        ]
    },
    {
        "id": "aarti_hanuman",
        "title": "Aarti Kije Hanuman Lala Ki",
        "hindiTitle": "आरती कीजै हनुमान लला की",
        "deity": "Lord Hanuman",
        "category": "Aarti",
        "durationSec": 235,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Aarti composed by Saint Tulsidas to invoke Bajrangbali's divine protection from fears and negative energies.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "आरती कीजै हनुमान लला की। दुष्ट दलन रघुनाथ कला की॥", "english": "Aarti Kijai Hanuman Lala Ki | Dusht Dalan Raghunath Kala Ki ||"},
            {"timestampSec": 25, "devanagari": "जाके बल से गिरिवर कांपे। रोग दोष जाके निकट न झांपे॥", "english": "Jaake Bal Se Girivar Kaampe | Rog Dosh Jaake Nikat Na Jhaampe ||"},
            {"timestampSec": 50, "devanagari": "अंजनि पुत्र महा बलदाई। सन्तन के प्रभु सदा सहाई॥", "english": "Anjani Putra Maha Baldaai | Santan Ke Prabhu Sada Sahaai ||"},
            {"timestampSec": 75, "devanagari": "दे बीरा रघुनाथ पठाए। लंका जारि सीय सुधि लाए॥", "english": "De Beera Raghunath Pathaaye | Lanka Jaari Seeya Sudhi Laaye ||"},
            {"timestampSec": 105, "devanagari": "लंका सो कोट समुद्र सी खाई। जात पवनसुत बार न लाई॥", "english": "Lanka So Kot Samudra Si Khaai | Jaat Pawansut Baar Na Laai ||"},
            {"timestampSec": 135, "devanagari": "लक्ष्मण मूर्छित पड़े सकारे। आणि संजीवन प्रान उबारे॥", "english": "Laxman Moorchhit Pade Sakaare | Aani Sanjeevan Praan Ubaare ||"},
            {"timestampSec": 165, "devanagari": "पैठि पताल तोरि जम-कारे। अहिरावण की भुजा उखारे॥", "english": "Paithi Pataal Tori Jam-Kaare | Ahiravan Ki Bhuja Ukhaare ||"},
            {"timestampSec": 195, "devanagari": "सुर नर मुनि आरती उतारें। जय जय जय कपिराज उचारें॥", "english": "Sur Nar Muni Aarti Utaarein | Jai Jai Jai Kapiraj Uchaarein ||"},
            {"timestampSec": 215, "devanagari": "कंचन थार कपूर लौ छाई। आरति करत संजना माई॥ जो हनुमान जी की आरती गावै। बसि बैकुण्ठ परम पद पावै॥", "english": "Kanchan Thaar Kapoor Lau Chhaai | Aarati Karat Sanjana Maai || Jo Hanuman Ji Ki Aarti Gaavai | Basi Baikunth Param Pad Paavai ||"}
        ]
    },
    {
        "id": "aarti_lakshmi",
        "title": "Om Jai Lakshmi Mata",
        "hindiTitle": "ॐ जय लक्ष्मी माता",
        "deity": "Goddess Lakshmi",
        "category": "Aarti",
        "durationSec": 225,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Sung on Fridays and Diwali Mahapuja to welcome wealth, spiritual prosperity, and fortune into homes.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "ॐ जय लक्ष्मी माता, मैया जय लक्ष्मी माता। तुमको निसदिन सेवत, हर विष्णु विधाता॥ ॐ जय लक्ष्मी माता॥", "english": "Om Jai Lakshmi Mata, Maiya Jai Lakshmi Mata | Tumko Nisdin Sevat, Har Vishnu Vidhata || Om Jai Lakshmi Mata ||"},
            {"timestampSec": 30, "devanagari": "उमा, रमा, ब्रह्माणी, तुम ही जग-माता। सूर्य-चन्द्रमा ध्यावत, नारद ऋषि गाता॥ ॐ जय लक्ष्मी माता॥", "english": "Uma Rama Brahmani, Tum Hi Jag-Mata | Surya-Chandrama Dhyavat, Narad Rishi Gaata || Om Jai Lakshmi Mata ||"},
            {"timestampSec": 60, "devanagari": "दुर्गा रूप निरंजनि, सुख सम्पति दाता। जो कोई तुमको ध्यावत, ऋद्धि-सिद्धि धन पाता॥ ॐ जय लक्ष्मी माता॥", "english": "Durga Roop Niranjani, Sukh Sampati Data | Jo Koi Tumko Dhyavat, Riddhi-Siddhi Dhan Paata || Om Jai Lakshmi Mata ||"},
            {"timestampSec": 90, "devanagari": "तुम पाताल-निवासिनि, तुम ही शुभदाता। कर्म-प्रभाव-प्रकाशिनि, भव-निधि की त्राता॥ ॐ जय लक्ष्मी माता॥", "english": "Tum Pataal-Nivasini, Tum Hi Shubhdata | Karm-Prabhav-Prakashini, Bhav-Nidhi Ki Traata || Om Jai Lakshmi Mata ||"},
            {"timestampSec": 120, "devanagari": "जिस घर में तुम रहती, सब सद्गुण आता। सब संभव हो जाता, मन नहिं घबराता॥ ॐ जय लक्ष्मी माता॥", "english": "Jis Ghar Mein Tum Rehti, Sab Sadgun Aata | Sab Sambhav Ho Jaata, Man Nahin Ghabraata || Om Jai Lakshmi Mata ||"},
            {"timestampSec": 150, "devanagari": "तुम बिन यज्ञ न होते, वस्त्र न कोई पाता। खान-पान का वैभव, सब तुमसे आता॥ ॐ जय लक्ष्मी माता॥", "english": "Tum Bin Yagya Na Hote, Vastra Na Koi Paata | Khaan-Paan Ka Vaibhav, Sab Tumse Aata || Om Jai Lakshmi Mata ||"},
            {"timestampSec": 180, "devanagari": "शुभ-गुण मंदिर सुंदर, क्षीरोदधि-जाता। रत्न चतुर्दश तुम बिन, कोई नहिं पाता॥ ॐ जय लक्ष्मी माता॥", "english": "Shubh-Gun Mandir Sundar, Ksheerodadhi-Jaata | Ratna Chaturdash Tum Bin, Koi Nahin Paata || Om Jai Lakshmi Mata ||"},
            {"timestampSec": 205, "devanagari": "महालक्ष्मीजी की आरती, जो कोई नर गावे। उर आनन्द समावे, पाप उतर जावे॥ ॐ जय लक्ष्मी माता॥", "english": "Mahalakshmiji Ki Aarti, Jo Koi Nar Gaave | Ur Aanand Samaave, Paap Utar Jaave || Om Jai Lakshmi Mata ||"}
        ]
    },
    {
        "id": "aarti_ram",
        "title": "Shri Ramachandra Kripalu Bhajuman",
        "hindiTitle": "श्री रामचन्द्र कृपालु भजु मन",
        "deity": "Lord Rama",
        "category": "Stuti & Aarti",
        "durationSec": 220,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Divine Sanskritised Stuti composed by Goswami Tulsidas glorifying Maryada Purushottam Bhagwan Shri Ram.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "श्रीरामचन्द्र कृपालु भजु मन हरण भवभय दारुणं। नवकंज लोचन, कंज मुख, कर कंज, पद कंजारुणम्॥", "english": "Shri Ramachandra Kripalu Bhaju Man Haran Bhavbhaya Daarunam | Navkanj Lochan, Kanj Mukh, Kar Kanj, Pad Kanjaarunam ||"},
            {"timestampSec": 35, "devanagari": "कन्दर्प अगणित अमित छवि, नवनील नीरद सुन्दरं। पट पीत मानहु तड़ित रुचि शुचि नौमि जनक सुतावरम्॥", "english": "Kandarpa Aganita Amita Chhavi, Navneel Neerad Sundaram | Pat Peet Maanahu Tadit Ruchi Shuchi Naumi Janak Sutaavaram ||"},
            {"timestampSec": 70, "devanagari": "भजु दीनबन्धु दिनेश दानव दैत्य वंश निकन्दनं। रघुनन्द आनन्दकन्द कोशलचन्द दशरथ नन्दनम्॥", "english": "Bhaju Deenbandhu Dinesh Daanav Daitya Vansh Nikandanam | Raghunand Aanandkand Koshalchand Dashrath Nandanam ||"},
            {"timestampSec": 105, "devanagari": "सिर मुकुट कुण्डल तिलक चारु उदारु अङ्ग विभूषणं। आजानुभुज शर चाप धर, संग्राम-जित-खरदूषणम्॥", "english": "Sir Mukut Kundal Tilak Chaaru Udaaru Anga Vibhooshanam | Aajaanubhuj Shar Chaap Dhar, Sangraam-Jit-Khardooshanam ||"},
            {"timestampSec": 140, "devanagari": "इति वदति तुलसीदास शंकर शेष मुनि मन रञ्जनं। मम हृदय कञ्ज निवास कुरु, कामादि खल दल गञ्जनम्॥", "english": "Iti Vadati Tulsidas Shankar Shesh Muni Man Ranjanam | Mama Hridaya Kanj Nivaas Kuru, Kaamaadi Khal Dal Ganjanam ||"},
            {"timestampSec": 180, "devanagari": "मनु जाहिं राचेउ मिलिहि सो बरु सहज सुन्दर सांवरो। करुना निधान सुजान सीलु सनेहु जानत रावरो॥", "english": "Manu Jaahin Raacheu Milihi So Baru Sahaj Sundar Saanvaro | Karuna Nidhaan Sujaan Seelu Sanehu Jaanat Raavaro ||"}
        ]
    },
    {
        "id": "aarti_krishna",
        "title": "Aarti Kunj Bihari Ki",
        "hindiTitle": "आरती कुंजबिहारी की",
        "deity": "Lord Krishna",
        "category": "Aarti",
        "durationSec": 230,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Beloved traditional Braj Dham Aarti invoking the enchanting leelas of Lord Krishna and Radha Rani.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "आरती कुंजबिहारी की, श्री गिरिधर कृष्णमुरारी की॥ गले में बैजंती माला, बजावै मुरली मधुर बाला।", "english": "Aarti Kunj Bihari Ki, Shri Giridhar Krishna Murari Ki || Gale Mein Baijanti Mala, Bajaavai Murli Madhur Baala |"},
            {"timestampSec": 35, "devanagari": "श्रवण में कुण्डल झलकाता, मुख चन्द्र समान सुहाता। नूपुर की छुन-छुन बाजे, राधा संग रस रचावे॥ आरती कुंजबिहारी की...", "english": "Shravan Mein Kundal Jhalkata, Mukh Chandra Samaan Suhaata | Nupur Ki Chhun-Chhun Baaje, Radha Sang Ras Rachaave ||"},
            {"timestampSec": 75, "devanagari": "कनक मय मुकुट बिराजे, पीताम्बर काछी सोहे। गोपियों के मन को मोहे, मोहन रूप अनूप धरे॥ आरती कुंजबिहारी की...", "english": "Kanak May Mukut Biraaje, Peetambar Kaachhi Sohe | Gopiyon Ke Man Ko Mohe, Mohan Roop Anoop Dhare ||"},
            {"timestampSec": 115, "devanagari": "जहाँ ते प्रगटी गंगा, कलुष कलि-हारिणी श्री गंगा। स्मरन ते होत पुनीता, कलि-मल-दहन पुनीता॥ आरती कुंजबिहारी की...", "english": "Jahaan Te Pragatee Ganga, Kalush Kali-Haarini Shri Ganga | Smaran Te Hot Puneeta, Kali-Mal-Dahan Puneeta ||"},
            {"timestampSec": 155, "devanagari": "श्री राधारमण बिहारी, गिरिवरधारी गिरधारी। चरण कमल पर जाऊं बलिहारी, आरती कुंजबिहारी की॥", "english": "Shri Radharaman Bihari, Girivardhari Girdhari | Charan Kamal Par Jaaun Balihaari, Aarti Kunj Bihari Ki ||"},
            {"timestampSec": 195, "devanagari": "आरती कुंजबिहारी की, श्री गिरिधर कृष्णमुरारी की॥", "english": "Aarti Kunj Bihari Ki, Shri Giridhar Krishna Murari Ki ||"}
        ]
    },
    {
        "id": "aarti_durga",
        "title": "Jai Ambe Gauri",
        "hindiTitle": "जय अम्बे गौरी",
        "deity": "Goddess Durga",
        "category": "Aarti",
        "durationSec": 240,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Navratri and Durga Puja Aarti honoring Jagadamba, the protectress of the cosmos.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "जय अम्बे गौरी, मैया जय श्यामा गौरी। तुमको निसदिन ध्यावत, हरि ब्रह्मा शिवरी॥ जय अम्बे गौरी॥", "english": "Jai Ambe Gauri, Maiya Jai Shyama Gauri | Tumko Nisdin Dhyavat, Hari Brahma Shivree || Jai Ambe Gauri ||"},
            {"timestampSec": 30, "devanagari": "मांग सिन्दूर विराजत, टीको मृगमद को। उज्ज्वल से दोउ नैना, चन्द्रवदन नीको॥ जय अम्बे गौरी॥", "english": "Maang Sindoor Viraajat, Teeko Mrigmad Ko | Ujjwal Se Dou Naina, Chandravadan Neeko || Jai Ambe Gauri ||"},
            {"timestampSec": 60, "devanagari": "कनक समान कलेवर, रक्ताम्बर राजे। रक्तपुष्प गल माला, कण्ठन पर साजे॥ जय अम्बे गौरी॥", "english": "Kanak Samaan Kalevar, Raktambar Raaje | Raktpushp Gal Maala, Kanthan Par Saaje || Jai Ambe Gauri ||"},
            {"timestampSec": 90, "devanagari": "केहरि वाहन राजत, खड्ग खप्पर धारी। सुर-नर-मुनि-जन सेवत, तिनके दुख हारी॥ जय अम्बे गौरी॥", "english": "Kehari Vaahan Raajat, Khadag Khappar Dhaari | Sur-Nar-Muni-Jan Sevat, Tinke Dukh Haari || Jai Ambe Gauri ||"},
            {"timestampSec": 120, "devanagari": "कानन कुण्डल शोभित, नासाग्रे मोती। कोटिक चन्द्र दिवाकर, सम राजत ज्योती॥ जय अम्बे गौरी॥", "english": "Kaanan Kundal Shobhit, Naasaagre Moti | Kotik Chandra Divaakar, Sam Raajat Jyoti || Jai Ambe Gauri ||"},
            {"timestampSec": 150, "devanagari": "शुम्भ-निशुम्भ बिदारे, महिषासुर घाती। धूम्र विलोचन नैना, निशदिन मदमाती॥ जय अम्बे गौरी॥", "english": "Shumbh-Nishumbh Bidaare, Mahishasur Ghaati | Dhoomra Vilochan Naina, Nishdin Madmaati || Jai Ambe Gauri ||"},
            {"timestampSec": 180, "devanagari": "चौंसठ योगिनि गावत, नृत्य करत भैरों। बाजत ताल मृदङ्गा, और बाजत डमरू॥ जय अम्बे गौरी॥", "english": "Chaunsath Yogini Gaavat, Nritya Karat Bhairon | Baajat Taal Mridanga, Aur Baajat Damroo || Jai Ambe Gauri ||"},
            {"timestampSec": 210, "devanagari": "श्री अम्बेजी की आरती, जो कोई नर गावे। कहत शिवानन्द स्वामी, सुख-सम्पत्ति पावे॥ जय अम्बे गौरी॥", "english": "Shri Ambeji Ki Aarti, Jo Koi Nar Gaave | Kahat Shivanand Swami, Sukh-Sampatti Paave || Jai Ambe Gauri ||"}
        ]
    },
    {
        "id": "aarti_jagdish",
        "title": "Om Jai Jagdish Hare",
        "hindiTitle": "ॐ जय जगदीश हरे",
        "deity": "Lord Vishnu",
        "category": "Aarti",
        "durationSec": 240,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Universal Sanatan evening Aarti sung across millions of households for total devotion and surrender.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "ॐ जय जगदीश हरे, स्वामी जय जगदीश हरे। भक्त जनों के संकट, दास जनों के संकट, क्षण में दूर करे॥ ॐ जय जगदीश हरे॥", "english": "Om Jai Jagdish Hare, Swami Jai Jagdish Hare | Bhakt Jano Ke Sankat, Daas Jano Ke Sankat, Kshan Mein Door Kare || Om Jai Jagdish Hare ||"},
            {"timestampSec": 35, "devanagari": "जो ध्यावे फल पावे, दुख बिनसे मन का। सुख सम्पति घर आवे, कष्ट मिटे तन का॥ ॐ जय जगदीश हरे॥", "english": "Jo Dhyave Phal Paave, Dukh Binase Man Ka | Sukh Sampati Ghar Aave, Kasht Mite Tan Ka || Om Jai Jagdish Hare ||"},
            {"timestampSec": 70, "devanagari": "मात-पिता तुम मेरे, शरण गहूँ किसकी। तुम बिन और न दूजा, आस करूँ जिसकी॥ ॐ जय जगदीश हरे॥", "english": "Maat-Pita Tum Mere, Sharan Gahoon Kiski | Tum Bin Aur Na Dooja, Aas Karoon Jiski || Om Jai Jagdish Hare ||"},
            {"timestampSec": 105, "devanagari": "तुम पूरण परमात्मा, तुम अन्तर्यामी। पारब्रह्म परमेश्वर, तुम सब के स्वामी॥ ॐ जय जगदीश हरे॥", "english": "Tum Pooran Parmaatma, Tum Antaryaami | Paarbrahm Parameshwar, Tum Sab Ke Swami || Om Jai Jagdish Hare ||"},
            {"timestampSec": 140, "devanagari": "तुम करुणा के सागर, तुम पालनकर्ता। मैं मूरख खल कामी, कृपा करो भर्ता॥ ॐ जय जगदीश हरे॥", "english": "Tum Karuna Ke Saagar, Tum Paalankarta | Main Moorakh Khal Kaami, Kripa Karo Bharta || Om Jai Jagdish Hare ||"},
            {"timestampSec": 175, "devanagari": "तुम हो एक अगोचर, सब के प्राणपति। किस विधि मिलूँ दयामय, तुमको मैं कुमति॥ ॐ जय जगदीश हरे॥", "english": "Tum Ho Ek Agochar, Sab Ke Praanpati | Kis Vidhi Miloon Dayamay, Tumko Main Kumati || Om Jai Jagdish Hare ||"},
            {"timestampSec": 210, "devanagari": "दीन-बन्धु दुख-हर्ता, तुम ठाकुर मेरे। अपने हाथ उठाओ, द्वार पड़ा तेरे॥ तन-मन-धन सब है तेरा, तेरा तुझको अर्पण, क्या लागे मेरा॥ ॐ जय जगदीश हरे॥", "english": "Deen-Bandhu Dukh-Harta, Tum Thakur Mere | Apne Haath Uthaao, Dwaar Pada Tere || Tan-Man-Dhan Sab Hai Tera, Tera Tujhko Arpan, Kya Laage Mera || Om Jai Jagdish Hare ||"}
        ]
    },
    {
        "id": "aarti_saraswati",
        "title": "Jai Saraswati Mata",
        "hindiTitle": "जय सरस्वती माता",
        "deity": "Goddess Saraswati",
        "category": "Aarti",
        "durationSec": 210,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Invoking the Goddess of Vidya, music, wisdom, speech, and enlightened arts on Vasant Panchami and daily studies.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "जय सरस्वती माता, मैया जय सरस्वती माता। सद्गुण वैभव शालिनी, त्रिभुवन विख्याता॥ जय सरस्वती माता॥", "english": "Jai Saraswati Mata, Maiya Jai Saraswati Mata | Sadgun Vaibhav Shaalini, Tribhuvan Vikhyaata || Jai Saraswati Mata ||"},
            {"timestampSec": 30, "devanagari": "चन्द्रवदनि पद्मासिनि, द्युति मंगलकारी। सोहे शुभ हंस सवारी, अतुल तेजधारी॥ जय सरस्वती माता॥", "english": "Chandravadani Padmaasini, Dyuti Mangalkaari | Sohe Shubh Hans Savaari, Atul Tejdhaari || Jai Saraswati Mata ||"},
            {"timestampSec": 65, "devanagari": "बाएं कर में वीणा, दाएं कर माला। शीश मुकुट मणि सोहे, गल मोतियन माला॥ जय सरस्वती माता॥", "english": "Baayein Kar Mein Veena, Daayein Kar Maala | Sheesh Mukut Mani Sohe, Gal Motiyan Maala || Jai Saraswati Mata ||"},
            {"timestampSec": 100, "devanagari": "देवदनुज सुभामिनी, विद्या दान दियो। अमर कीन्ह जो पूजे, ज्ञान प्रकाश कियो॥ जय सरस्वती माता॥", "english": "Devdanuj Subhaamini, Vidya Daan Diyo | Amar Keenha Jo Pooje, Gyaan Prakaash Kiyo || Jai Saraswati Mata ||"},
            {"timestampSec": 135, "devanagari": "ज्ञान चक्षु दे माता, जग निस्तार करो। अज्ञान तिमिर सब हरके, मंगल रूप धरो॥ जय सरस्वती माता॥", "english": "Gyaan Chakshu De Mata, Jag Nistaar Karo | Agyaan Timir Sab Harke, Mangal Roop Dharo || Jai Saraswati Mata ||"},
            {"timestampSec": 170, "devanagari": "सरस्वतीजी की आरती, जो कोई जन गावे। हितकारी सुखकारी, ज्ञान परम पावे॥ जय सरस्वती माता॥", "english": "Saraswatiji Ki Aarti, Jo Koi Jan Gaave | Hitkaari Sukhkaari, Gyaan Param Paave || Jai Saraswati Mata ||"}
        ]
    },
    {
        "id": "aarti_shani",
        "title": "Jai Jai Shri Shanidev Bhaktan Hitkari",
        "hindiTitle": "जय जय श्री शनिदेव",
        "deity": "Lord Shani",
        "category": "Aarti",
        "durationSec": 215,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Sung on Saturdays to pacify Shani Sade Sati, remove obstacles, and cultivate karmic righteousness.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "जय जय श्री शनिदेव भक्तन हितकारी। सूर्य पुत्र प्रभु छाया महतारी॥ जय जय श्री शनिदेव...", "english": "Jai Jai Shri Shanidev Bhaktan Hitkari | Surya Putra Prabhu Chhaya Mahtaari || Jai Jai Shri Shanidev..."},
            {"timestampSec": 35, "devanagari": "चार भुजा तनु श्याम विराजै। माथे रतन मुकुट छवि छाजै॥ जय जय श्री शनिदेव...", "english": "Chaar Bhuja Tanu Shyam Viraajai | Maathe Ratan Mukut Chhavi Chhaajai || Jai Jai Shri Shanidev..."},
            {"timestampSec": 70, "devanagari": "खांग खड्ग त्रिशूल धनुष कर। चमर ढुरत शिर छत्र सुहाकर॥ जय जय श्री शनिदेव...", "english": "Khaang Khadag Trishool Dhanush Kar | Chamar Dhurat Shir Chhatra Suhaakar || Jai Jai Shri Shanidev..."},
            {"timestampSec": 105, "devanagari": "गिद्ध वाहन प्रभु सदा विराजे। पापी दलन साधु सुख साजे॥ जय जय श्री शनिदेव...", "english": "Giddha Vaahan Prabhu Sada Viraaje | Paapi Dalan Saadhu Sukh Saaje || Jai Jai Shri Shanidev..."},
            {"timestampSec": 140, "devanagari": "नित जो ध्यान धरे मन लाई। संकट कटे सकल सुख पाई॥ जय जय श्री शनिदेव...", "english": "Nit Jo Dhyaan Dhare Man Laai | Sankat Kate Sakal Sukh Paai || Jai Jai Shri Shanidev..."},
            {"timestampSec": 175, "devanagari": "आरती जो शनिदेव की गावे। कर्म शुद्ध करि परम पद पावे॥ जय जय श्री शनिदेव...", "english": "Aarti Jo Shanidev Ki Gaave | Karm Shuddh Kari Param Pad Paave || Jai Jai Shri Shanidev..."}
        ]
    },
    {
        "id": "aarti_surya",
        "title": "Jai Kashyap-Nandan",
        "hindiTitle": "जय कश्यप-नन्दन (सूर्य आरती)",
        "deity": "Lord Surya",
        "category": "Aarti",
        "durationSec": 200,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Sung at sunrise and during Chhath Puja to worship the visible divinity Surya Bhagwan for health and vitality.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "जय कश्यप-नन्दन, ॐ जय अदिति-नन्दन। त्रिभुवन तिमिर निकन्दन, भक्त-हृदय-चन्दन॥ ॐ जय सूर्य भगवान॥", "english": "Jai Kashyap-Nandan, Om Jai Aditi-Nandan | Tribhuvan Timir Nikandan, Bhakt-Hridaya-Chandan || Om Jai Surya Bhagwan ||"},
            {"timestampSec": 35, "devanagari": "सप्त-अश्वरथ साजे, अरुण सारथी संग। किरण-जाल बिखरावे, जागे जग नव उमंग॥ ॐ जय सूर्य भगवान॥", "english": "Sapt-Ashwarath Saaje, Arun Saarathi Sang | Kiran-Jaal Bikhraave, Jaage Jag Nav Umang || Om Jai Surya Bhagwan ||"},
            {"timestampSec": 70, "devanagari": "उदित होत तम नाशे, जीवन ज्योति जगे। रोग शोक सब भागे, जन-मन मंगल लगे॥ ॐ जय सूर्य भगवान॥", "english": "Udit Hot Tam Naashe, Jeevan Jyoti Jage | Rog Shok Sab Bhaage, Jan-Man Mangal Lage || Om Jai Surya Bhagwan ||"},
            {"timestampSec": 105, "devanagari": "अर्घ्य समर्पण कीन्हे, पावे दीर्घायु काया। धन धान्य सुख पावे, मिटे मोह अरु माया॥ ॐ जय सूर्य भगवान॥", "english": "Arghya Samarpan Keenhe, Paave Deerghaayu Kaaya | Dhan Dhaanya Sukh Paave, Mite Moh Aru Maaya || Om Jai Surya Bhagwan ||"},
            {"timestampSec": 145, "devanagari": "द्वादश रूप धरे प्रभु, जग का पालनहार। जो नर आरती गावे, उतरे भव से पार॥ ॐ जय सूर्य भगवान॥", "english": "Dwaadash Roop Dhare Prabhu, Jag Ka Paalanhaar | Jo Nar Aarti Gaave, Utre Bhav Se Paar || Om Jai Surya Bhagwan ||"}
        ]
    },
    {
        "id": "aarti_gayatri",
        "title": "Jayati Jay Gayatri Mata",
        "hindiTitle": "जयति जय गायत्री माता",
        "deity": "Goddess Gayatri",
        "category": "Aarti",
        "durationSec": 205,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Mother of the Vedas; chanting awakens the intellect (Dhiyo Yo Nah Prachodayat) and purifies consciousness.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "जयति जय गायत्री माता, जयति जय गायत्री माता। सत्-चित्-आनन्द-स्वरूपिणी, जगजीवन-दाता॥ जयति जय गायत्री माता॥", "english": "Jayati Jay Gayatri Mata, Jayati Jay Gayatri Mata | Sat-Chit-Aanand-Swaroopini, Jagjeevan-Daata || Jayati Jay Gayatri Mata ||"},
            {"timestampSec": 35, "devanagari": "आदि-शक्ति तुम अलख निरंजन, जग-पालन-कर्त्री। वेद-शास्त्र-उपनिषद् की जननी, ज्ञान-विज्ञान-प्रदायिनी॥ जयति जय गायत्री माता॥", "english": "Aadi-Shakti Tum Alakh Niranjan, Jag-Paalan-Kartri | Ved-Shaastra-Upanishad Ki Janani, Gyaan-Vigyaan-Pradaayini || Jayati Jay Gayatri Mata ||"},
            {"timestampSec": 75, "devanagari": "हंस वाहिनी श्वेत वसना, पुस्तक वीणा धारी। बुद्धि विवेक प्रकाशिनि, तम-अज्ञान विहारी॥ जयति जय गायत्री माता॥", "english": "Hans Vaahini Shwet Vasana, Pustak Veena Dhaari | Buddhi Vivek Prakashini, Tam-Agyaan Vihaari || Jayati Jay Gayatri Mata ||"},
            {"timestampSec": 115, "devanagari": "जो जन ध्यावे पावे विद्या, सुख शान्ति अपार। पाप ताप सब मिट जावे, मिले मोक्ष का द्वार॥ जयति जय गायत्री माता॥", "english": "Jo Jan Dhyave Paave Vidya, Sukh Shaanti Apaar | Paap Taap Sab Mit Jaave, Mile Moksh Ka Dwaar || Jayati Jay Gayatri Mata ||"},
            {"timestampSec": 155, "devanagari": "गायत्रीजी की आरती, जो नित नियम से गावे। ब्रह्मज्ञान का दीपक, हृदय में प्रकटावे॥ जयति जय गायत्री माता॥", "english": "Gayatreeji Ki Aarti, Jo Nit Niyam Se Gaave | Brahmagyaan Ka Deepak, Hridaya Mein Prakataave || Jayati Jay Gayatri Mata ||"}
        ]
    },
    {
        "id": "aarti_khatu_shyam",
        "title": "Om Jai Shri Shyam Hare",
        "hindiTitle": "ॐ जय श्री श्याम हरे",
        "deity": "Lord Khatu Shyam Ji",
        "category": "Aarti",
        "durationSec": 210,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Aarti of Baba Shyam (Barbarika / Haare Ka Sahara) worshipped at Khatu Dham for unfailing grace.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "ॐ जय श्री श्याम हरे, बाबा जय श्री श्याम हरे। खाटू धाम विराजे, अनुपम रूप धरे॥ ॐ जय श्री श्याम हरे॥", "english": "Om Jai Shri Shyam Hare, Baba Jai Shri Shyam Hare | Khaatu Dhaam Viraaje, Anupam Roop Dhare || Om Jai Shri Shyam Hare ||"},
            {"timestampSec": 35, "devanagari": "रतन जड़ित सिंहासन, चँवर ढुरैं प्यारे। गल मोतियन की माला, शीश मुकुट साजे॥ ॐ जय श्री श्याम हरे॥", "english": "Ratan Jadit Singhaasan, Chanvar Dhurein Pyaare | Gal Motiyan Ki Maala, Sheesh Mukut Saaje || Om Jai Shri Shyam Hare ||"},
            {"timestampSec": 70, "devanagari": "केसर तिलक सुहावे, मोरछड़ी हाथे। हारे के सहारे बाबा, दया करो माथे॥ ॐ जय श्री श्याम हरे॥", "english": "Kesar Tilak Suhaave, Morchhadhi Haathe | Haare Ke Sahaare Baba, Daya Karo Maathe || Om Jai Shri Shyam Hare ||"},
            {"timestampSec": 105, "devanagari": "शीश दान जो दीन्हो, कृष्ण वचन पायो। लखदातार कहावे, जग में नाम छायो॥ ॐ जय श्री श्याम हरे॥", "english": "Sheesh Daan Jo Deenho, Krishna Vachan Paayo | Lakhdaataar Kahaave, Jag Mein Naam Chhaayo || Om Jai Shri Shyam Hare ||"},
            {"timestampSec": 145, "devanagari": "आरती श्याम पिया की, जो कोई गावे। दुःख दारिद्र मिटे सब, मनवांछित फल पावे॥ ॐ जय श्री श्याम हरे॥", "english": "Aarti Shyam Piya Ki, Jo Koi Gaave | Dukh Daaridra Mite Sab, Manvaanchhit Phal Paave || Om Jai Shri Shyam Hare ||"}
        ]
    },
    {
        "id": "aarti_ganga",
        "title": "Om Jai Gange Mata",
        "hindiTitle": "ॐ जय गंगे माता",
        "deity": "Maa Ganga",
        "category": "Aarti",
        "durationSec": 220,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Sung at Haridwar, Varanasi, and Rishikesh ghats honoring the sacred Ganga for spiritual purification.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "ॐ जय गंगे माता, मैया जय गंगे माता। जो नर तुमको ध्याता, मनवांछित फल पाता॥ ॐ जय गंगे माता॥", "english": "Om Jai Gange Mata, Maiya Jai Gange Mata | Jo Nar Tumko Dhyata, Manvaanchhit Phal Paata || Om Jai Gange Mata ||"},
            {"timestampSec": 35, "devanagari": "चन्द्र-सी ज्योति तुम्हारी, जल निर्मल आता। शरण पड़े की लज्जा, राखो हे माता॥ ॐ जय गंगे माता॥", "english": "Chandra-Si Jyoti Tumhaari, Jal Nirmal Aata | Sharan Pade Ki Lajja, Raakho He Mata || Om Jai Gange Mata ||"},
            {"timestampSec": 70, "devanagari": "भागीरथ ने तप कीन्हो, सुरलोक से लाया। शिव के शीश जटा में, तूने आसन पाया॥ ॐ जय गंगे माता॥", "english": "Bhaagirath Ne Tap Keenho, Surlok Se Laaya | Shiv Ke Sheesh Jata Mein, Toone Aasan Paaya || Om Jai Gange Mata ||"},
            {"timestampSec": 105, "devanagari": "सप्त सिन्धु दरशावे, पावन निर्मल धार। जन-जन का पाप मिटावे, कर दे भव से पार॥ ॐ जय गंगे माता॥", "english": "Sapt Sindhu Darshaave, Paavan Nirmal Dhaar | Jan-Jan Ka Paap Mitaave, Kar De Bhav Se Paar || Om Jai Gange Mata ||"},
            {"timestampSec": 145, "devanagari": "गंगा मैया की आरती, जो नर-नारी गावे। अमर धाम को पावे, जन्म-मरण मिट जावे॥ ॐ जय गंगे माता॥", "english": "Ganga Maiya Ki Aarti, Jo Nar-Naari Gaave | Amar Dhaam Ko Paave, Janm-Maran Mit Jaave || Om Jai Gange Mata ||"}
        ]
    }
]

# ==========================================
# 2. 8 COMPLETE PRODUCTION PUJA VIDHIS
# ==========================================
VIDHIS = [
    {
        "id": "chhath_puja",
        "title": "Chhath Mahaparva Vidhi",
        "hindiTitle": "छठ महापर्व विधि",
        "deity": "Bhagwan Surya & Chhathi Maiya",
        "festivalTag": "Chhath",
        "regionalTag": "Bihar & Eastern UP",
        "estimatedMinutes": 45,
        "significance": "Ancient Vedic Mahaparva dedicated to Sun God Surya and Shashthi Devi for vitality, purity, and family well-being.",
        "sankalpText": "ॐ विष्णुर्विष्णुर्विष्णुः अद्यैतस्य ब्रह्मणोऽह्नि द्वितीयपरार्धे श्रीश्वेतवाराहकल्पे वैवस्वतमन्वन्तरे मम सर्वपापक्षयपूर्वकं आरोग्याय श्रीसूर्यनारायण प्रीतये छठपूजनमहं करिष्ये।",
        "samagriList": [
            {"name": "Soop (Bamboo winnow)", "quantity": "2 units", "category": "Essential", "isChecked": False},
            {"name": "Daura (Bamboo basket)", "quantity": "1 unit", "category": "Essential", "isChecked": False},
            {"name": "Thekua (Wheat & jaggery prasadam)", "quantity": "1 bowl", "category": "Offering", "isChecked": False},
            {"name": "Sugarcane with leaves (Ganna)", "quantity": "5 stalks", "category": "Offering", "isChecked": False},
            {"name": "Radish, Ginger & Turmeric plants", "quantity": "Fresh bunch", "category": "Essential", "isChecked": False},
            {"name": "Raw Milk & Gangajal in copper lota", "quantity": "500 ml", "category": "Pavitra Jal", "isChecked": False},
            {"name": "Clay Diyas & Camphor", "quantity": "21 diyas", "category": "Dhoop-Deep", "isChecked": False},
            {"name": "Roli, Sindoor & Akshat", "quantity": "1 packet each", "category": "Offering", "isChecked": False}
        ],
        "steps": [
            {"stepNumber": 1, "title": "Nahay Khay (Purification)", "description": "Take ritual bath in flowing river, clean cooking area, prepare Satvik bottle gourd sabzi and rice.", "mantra": "ॐ अपवित्रः पवित्रो वा सर्वावस्थां गतोऽपि वा। यः स्मरेत्पुण्डरीकाक्षं स बाह्याभ्यन्तरः शुचिः॥"},
            {"stepNumber": 2, "title": "Kharna (Sweet Offering)", "description": "Observe day-long nirjala fast. At dusk, offer Rasiya (jaggery kheer) and Roti to Surya & Chhathi Maiya, then accept prasad.", "mantra": "ॐ सूर्याय नमः। ॐ षष्ठी देव्यै नमः।"},
            {"stepNumber": 3, "title": "Sandhya Arghya (Setting Sun)", "description": "Assemble Daura with Thekua and seasonal fruits at ghat. Stand in waist-deep water to offer milk and water to setting Surya.", "mantra": "एहि सूर्य सहस्त्रांशो तेजोराशे जगत्पते। अनुकम्पय मां भक्त्या गृहाणार्घ्यं दिवाकर॥"},
            {"stepNumber": 4, "title": "Usha Arghya (Rising Sun & Paran)", "description": "Return to ghat before dawn. Offer morning Arghya to the rising Sun, seek blessings, and break 36-hour fast with ginger and water.", "mantra": "ॐ नमो भगवते श्रीसूर्याय नमः। आदित्याय विद्महे प्रभाकराय धीमहि तन्नः सूर्यः प्रचोदयात्॥"}
        ]
    },
    {
        "id": "pongal_puja",
        "title": "Thai Pongal Harvest Vidhi",
        "hindiTitle": "थाई पोंगल विधि",
        "deity": "Surya Bhagwan & Nature",
        "festivalTag": "Pongal",
        "regionalTag": "Tamil Nadu & South India",
        "estimatedMinutes": 35,
        "significance": "Celebrates the sun entering Makara rasi (harvest abundance) with overflow of sweet milk and rice in traditional brass pots.",
        "sankalpText": "ॐ तत्सत् अद्य शुभे शोभने मुहूर्ते सूर्य नारायण प्रीत्यर्थं थाई पोंगल नैवेद्य समर्पणं करिष्ये।",
        "samagriList": [
            {"name": "New Clay/Brass Pot (Pongal Paanai)", "quantity": "1 unit", "category": "Essential", "isChecked": False},
            {"name": "Newly Harvested Raw Rice", "quantity": "1 kg", "category": "Offering", "isChecked": False},
            {"name": "Jaggery (Vellam) & Pure Ghee", "quantity": "500g each", "category": "Prasadam", "isChecked": False},
            {"name": "Fresh Turmeric Plant with leaves (Manjal)", "quantity": "2 bunches", "category": "Sacred Plant", "isChecked": False},
            {"name": "Sugarcane Stalks (Karumbu)", "quantity": "2 stalks", "category": "Offering", "isChecked": False},
            {"name": "Cashews & Cardamom (Elachi)", "quantity": "50g each", "category": "Prasadam", "isChecked": False},
            {"name": "Banana Leaves (Vazhai Ilai)", "quantity": "4 large", "category": "Essential", "isChecked": False}
        ],
        "steps": [
            {"stepNumber": 1, "title": "Kolam Design & Pot Preparation", "description": "Draw auspicious sunrise Kolam with rice flour in open courtyard. Tie fresh turmeric plant around the neck of the pot.", "mantra": "ॐ भूर्भुवः स्वः तत्सवितुर्वरेण्यं भर्गो देवस्य धीमहि धियो यो नः प्रचोदयात्॥"},
            {"stepNumber": 2, "title": "Milk Boiling (Pongalo Pongal)", "description": "Pour fresh milk and water into pot facing East. As milk boils and overflows, family chants 'Pongalo Pongal' celebrating prosperity.", "mantra": "ॐ श्रीं ह्रीं क्लीं सूर्यदेवाय नमः।"},
            {"stepNumber": 3, "title": "Sakkarai Pongal Cooking", "description": "Add roasted moong dal, freshly harvested rice, melted jaggery, cardamom, and ghee-roasted cashews into the pot.", "mantra": "अन्नपतेऽन्नस्य नो देह्यनमीवस्य शुष्मिणः। प्रप्रदातारं तारिष ऊर्जं नो धेहि द्विपदे चतुष्पदे॥"},
            {"stepNumber": 4, "title": "Surya Samarpanam", "description": "Serve Pongal on banana leaf with sugarcane, betel leaves, and coconuts facing the sun god with camphor aarti.", "mantra": "ॐ सूर्याय नमः, ॐ मित्राय नमः, ॐ खगाय नमः, ॐ पूष्णे नमः।"}
        ]
    },
    {
        "id": "durga_puja",
        "title": "Durga Puja & Sandhi Puja Vidhi",
        "hindiTitle": "दुर्गा पूजा एवं संधि पूजा",
        "deity": "Maa Durga (Mahishasuramardini)",
        "festivalTag": "Durga Puja",
        "regionalTag": "Bengal & Pan-India",
        "estimatedMinutes": 60,
        "significance": "Invoking Adi Shakti's triumph over Mahishasura during the exact junction of Ashtami and Navami tithi with 108 lotuses and 108 diyas.",
        "sankalpText": "ॐ अद्य आश्विनमासे शुक्लपक्षे महाष्टम्यामवभृथस्नाने श्रीजगद्धात्री दुर्गाप्रीत्यर्थं सन्धिपूजां करिष्ये।",
        "samagriList": [
            {"name": "Blue/Red Lotus Flowers (Padma)", "quantity": "108 flowers", "category": "Essential Offering", "isChecked": False},
            {"name": "Clay Pradeep (Diyas) with Mustard Oil/Ghee", "quantity": "108 units", "category": "Deepam", "isChecked": False},
            {"name": "Sari & Chunri with Zari border", "quantity": "1 set", "category": "Vastra", "isChecked": False},
            {"name": "Dhuno, Dhoop & Frankincense", "quantity": "1 bowl", "category": "Aarti", "isChecked": False},
            {"name": "Belpatra garland (108 leaves)", "quantity": "1 mala", "category": "Offering", "isChecked": False},
            {"name": "Khichuri, Labra & Payesh Bhog", "quantity": "Freshly cooked", "category": "Maha Bhog", "isChecked": False}
        ],
        "steps": [
            {"stepNumber": 1, "title": "Chandi Path & Dhyanam", "description": "Chant the Devi Suktam from Rigveda and recite Durga Saptashati chapters meditating on her ten-armed form.", "mantra": "सर्वमङ्गलमाङ्गल्ये शिवे सर्वार्थसाधिके। शरण्ये त्र्यम्बके गौरि नारायणि नमोऽस्तु ते॥"},
            {"stepNumber": 2, "title": "Lighting of 108 Pradeeps", "description": "Light 108 earthen lamps representing the dispelling of demonic darkness during Sandhi Kaal.", "mantra": "ॐ जयन्ती मङ्गला काली भद्रकाली कपालिनी। दुर्गा क्षमा शिवा धात्री स्वाहा स्वधा नमोऽस्तु ते॥"},
            {"stepNumber": 3, "title": "108 Lotus Offering", "description": "Offer 108 lotus blooms to the lotus feet of Mother Durga while chanting the 108 names of Durga.", "mantra": "ॐ महादेव्यै च विद्महे दुर्गFetchायै धीमहि तन्नो देवी प्रचोदयात्॥"},
            {"stepNumber": 4, "title": "Dhunuchi Dance & Maha Aarti", "description": "Perform vibrant traditional Dhunuchi aarti to the rhythmic beats of Dhak drums.", "mantra": "कर्पूरगौरं करुणावतारं संसारसारं भुजगेन्द्रहारम्। सदा वसन्तं हृदयारविन्दे भवं भवानीसहितं नमामि॥"}
        ]
    },
    {
        "id": "maha_shivratri",
        "title": "Maha Shivratri 4-Prahar Rudrabhishek",
        "hindiTitle": "महाशिवरात्रि चार प्रहर पूजा",
        "deity": "Lord Shiva (Mahadev)",
        "festivalTag": "Shivratri",
        "regionalTag": "Pan-India",
        "estimatedMinutes": 50,
        "significance": "Observing the cosmic wedding night of Shiva & Parvati through 4-Prahar Abhishekam with milk, curd, honey, and sugarcane juice.",
        "sankalpText": "ॐ नमः शिवाय अद्य महाशिवरात्रौ चतुःप्रहर शिवपूजनम् अकालमृत्युहरणं सर्वपापक्षयपूर्वकं करिष्ये।",
        "samagriList": [
            {"name": "Bilva Patra (Bel leaves, intact 3-leaflets)", "quantity": "108 leaves", "category": "Essential", "isChecked": False},
            {"name": "Panchamrit (Milk, Curd, Ghee, Honey, Sugar)", "quantity": "500 ml", "category": "Abhishek", "isChecked": False},
            {"name": "Bhang, Dhatura & Akanda flowers", "quantity": "1 set", "category": "Offering", "isChecked": False},
            {"name": "Chandan & Vibhuti (Bhasma)", "quantity": "1 box", "category": "Tilak", "isChecked": False},
            {"name": "Sugarcane Juice (Ikshu Rasa)", "quantity": "250 ml", "category": "Abhishek", "isChecked": False},
            {"name": "Gangajal in Copper Shringi", "quantity": "1 litre", "category": "Pavitra Jal", "isChecked": False}
        ],
        "steps": [
            {"stepNumber": 1, "title": "First Prahar (Dugdha Abhishek)", "description": "Bathe the Shiva Lingam with pure cow milk and chant the Mahamrityunjaya Mantra.", "mantra": "त्र्यम्बकं यजामहे सुगन्धिं पुष्टिवर्धनम्। उर्वारुकमिव बन्धनान्मृत्योर्मुक्षीय मामृतात्॥"},
            {"stepNumber": 2, "title": "Second Prahar (Dadhi Abhishek)", "description": "Offer thick curd and chant the Shiva Panchakshara Stotram for peace of mind.", "mantra": "नागेन्द्रहाराय त्रिलोचनाय भस्माङ्गरागाय महेश्वराय। नित्याय शुद्धाय दिगम्बराय तस्मै नकाराय नमः शिवाय॥"},
            {"stepNumber": 3, "title": "Third Prahar (Ghrita & Madhu)", "description": "Abhishek with melted cow ghee and sweet forest honey for health and vitality.", "mantra": "ॐ तत्पुरुषाय विद्महे महादेवाय धीमहि तन्नो रुद्रः प्रचोदयात्॥"},
            {"stepNumber": 4, "title": "Fourth Prahar & Bilvashtakam", "description": "Decorate with bhasma, dhatura, and offer 108 Belpatra with Bilvashtakam recitation.", "mantra": "त्रिदलं त्रिगुणाकारं त्रिनेत्रं च त्रियायुधम्। त्रिजन्मपापसंहारं एकबिल्वं शिवार्पणम्॥"}
        ]
    },
    {
        "id": "diwali_lakshmi_puja",
        "title": "Deepavali Maha Lakshmi-Ganesh Puja",
        "hindiTitle": "दीपावली महालक्ष्मी-गणेश पूजन",
        "deity": "Maa Lakshmi & Lord Ganesha",
        "festivalTag": "Diwali",
        "regionalTag": "Pan-India",
        "estimatedMinutes": 45,
        "significance": "Pradosh and Nishita Kaal Diwali invocation of Goddess Mahalakshmi and Lord Ganesha for wealth, auspiciousness, and accounts opening.",
        "sankalpText": "ॐ अस्यां दीपावल्यां प्रदोषकाले महालक्ष्मी-गणपति-कुबेर-सरस्वती प्रीतये पूजनमहं करिष्ये।",
        "samagriList": [
            {"name": "Lakshmi-Ganesh Clay Idols (New)", "quantity": "1 pair", "category": "Murtis", "isChecked": False},
            {"name": "Silver Coins (Shubh Labh)", "quantity": "2 coins", "category": "Auspicious", "isChecked": False},
            {"name": "Kheel & Batasha", "quantity": "500g", "category": "Traditional Bhog", "isChecked": False},
            {"name": "Clay Diyas & Pure Ghee/Mustard Oil", "quantity": "21 diyas", "category": "Deepam", "isChecked": False},
            {"name": "Kamalgatta (Lotus seeds) & Roli", "quantity": "1 pack", "category": "Offering", "isChecked": False},
            {"name": "Chopda / Bahi-Khata (New Books)", "quantity": "1 notebook", "category": "Business", "isChecked": False}
        ],
        "steps": [
            {"stepNumber": 1, "title": "Kalash Sthapana & Shubh Labh", "description": "Fill copper kalash with Gangajal, place mango leaves, betel nut, and coconut topped with red cloth. Draw Swastik with Roli.", "mantra": "कलशस्य मुखे विष्णुः कण्ठे रुद्रः समाश्रितः। मूले त्वस्य स्थितो ब्रह्मा मध्ये मातृगणाः स्मृताः॥"},
            {"stepNumber": 2, "title": "Ganesh & Navagraha Pujan", "description": "Invoke Lord Ganesha first with durva grass, yellow flowers, and modak for obstacle-free year.", "mantra": "गजाननं भूतगणादिसेवितं कपित्थजम्बूफलचारुभक्षणम्। उमासुतं शोकविनाशकारकं नमामि विघ्नेश्वरपादपङ्कजम्॥"},
            {"stepNumber": 3, "title": "Maha Lakshmi Shodashopachara", "description": "Offer 16 devotional offerings including lotus flower, attar, kheel-batasha, and silver coin to Mata Lakshmi.", "mantra": "ॐ श्रीं ह्रीं क्लीं त्रिभुवन महालक्ष्म्यै अस्मांक दारिद्र्य नाशय प्रचुर धन देहि क्लीं ह्रीं श्रीं ॐ॥"},
            {"stepNumber": 4, "title": "Deep Malika (Lighting of Lamps)", "description": "Light the main 4-wick ghee diya (Yamadeep) followed by 21 home diyas chanting Lakshmi Aarti.", "mantra": "शुभं करोति कल्याणमारोग्यं धनसंपदा। शत्रुबुद्धिविनाशाय दीपज्योतिर्नमोऽस्तु ते॥"}
        ]
    },
    {
        "id": "janmashtami_puja",
        "title": "Janmashtami Krishna Janmotsav Vidhi",
        "hindiTitle": "कृष्ण जन्माष्टमी जन्मोत्सव विधि",
        "deity": "Laddu Gopal / Shri Krishna",
        "festivalTag": "Janmashtami",
        "regionalTag": "Pan-India & Braj",
        "estimatedMinutes": 40,
        "significance": "Midnight Nishita Kaal celebration of Bhagwan Shri Krishna's avatar with Panchamrit snan, swing (Jhula), and Makhan-Mishri bhog.",
        "sankalpText": "ॐ अद्य भाद्रपदमासे कृष्णपक्षे अष्टम्यां तिथौ रोहिणी नक्षत्रे निशीथकाले श्रीकृष्ण जन्माष्टमी जन्मोत्सव पूजनं करिष्ये।",
        "samagriList": [
            {"name": "Laddu Gopal Brass Murti & Jhula", "quantity": "1 set", "category": "Murtis", "isChecked": False},
            {"name": "Peacock Feather (Mor Pankh)", "quantity": "1 feather", "category": "Shringar", "isChecked": False},
            {"name": "Makhan & Mishri in clay handi", "quantity": "1 bowl", "category": "Maha Bhog", "isChecked": False},
            {"name": "Dhaniya Panjiri & Charanamrit", "quantity": "1 bowl each", "category": "Prasadam", "isChecked": False},
            {"name": "Cucumber (Khira) with stem", "quantity": "1 unit", "category": "Janma Ritual", "isChecked": False},
            {"name": "Tulsi Dal & Yellow Flowers", "quantity": "Fresh leaves", "category": "Offering", "isChecked": False}
        ],
        "steps": [
            {"stepNumber": 1, "title": "Avatar Pratiksha & Bhajan", "description": "Fast till midnight singing Krishna bhajans and chanting Hare Krishna Mahamantra.", "mantra": "हरे कृष्ण हरे कृष्ण कृष्ण कृष्ण हरे हरे। हरे राम हरे राम राम राम हरे हरे॥"},
            {"stepNumber": 2, "title": "Midnight Birth (Nal Chhedan)", "description": "Cut cucumber stem at exact 12:00 AM representing the divine emergence of Lord Krishna from Mother Devaki.", "mantra": "नन्द घर आनन्द भयो जय कन्हैया लाल की। हाथी घोड़ा पालकी जय कन्हैया लाल की॥"},
            {"stepNumber": 3, "title": "Panchamrit Abhishek & Shringar", "description": "Bathe Laddu Gopal in conch shell with milk, curd, honey, and gangajal. Dress in yellow pitambar with Mor Pankh.", "mantra": "कस्तूरीतिलकं ललाटपटले वक्षःस्थले कौस्तुभं नासाग्रे वरमौक्तिकं करतले वेणुं करे कङ्कणम्॥"},
            {"stepNumber": 4, "title": "Jhulan & Bhog Arpan", "description": "Place Gopal in decorated swing, gently rock while offering fresh butter, mishri, and tulsi leaves.", "mantra": "त्वदीयं वस्तु गोविन्द तुभ्यमेव समर्पये। गृहाण सुमुखो भूत्वा प्रसीद परमेश्वर॥"}
        ]
    },
    {
        "id": "ganesh_chaturthi",
        "title": "Ganesh Chaturthi Sthapana & Visarjan",
        "hindiTitle": "गणेश चतुर्थी स्थापना एवं विसर्जन",
        "deity": "Lord Ganesha",
        "festivalTag": "Ganesh Utsav",
        "regionalTag": "Maharashtra & Pan-India",
        "estimatedMinutes": 50,
        "significance": "10-day celebration welcoming Bappa into homes on Bhadrapada Shukla Chaturthi with 21 modaks and durva grass.",
        "sankalpText": "ॐ अद्य भाद्रपद शुक्लपक्षे चतुर्थ्यां तिथौ श्रीसिद्धिबुद्धिसहित श्रीमहागणपति प्रीत्यर्थं प्राणप्रतिष्ठापनं पूजनं च करिष्ये।",
        "samagriList": [
            {"name": "Eco-friendly Clay Ganesha Murti", "quantity": "1 murti", "category": "Murti", "isChecked": False},
            {"name": "Steamed Ukadiche Modak", "quantity": "21 pieces", "category": "Maha Bhog", "isChecked": False},
            {"name": "Durva Grass (21 knots)", "quantity": "21 pairs", "category": "Sacred Grass", "isChecked": False},
            {"name": "Red Hibiscus (Jaswand) Flowers", "quantity": "11 flowers", "category": "Offering", "isChecked": False},
            {"name": "Sandalwood Paste & Janeu", "quantity": "1 set", "category": "Shringar", "isChecked": False},
            {"name": "Coconut, Betel leaves & Supari", "quantity": "5 sets", "category": "Tambool", "isChecked": False}
        ],
        "steps": [
            {"stepNumber": 1, "title": "Prana Pratishtha (Consecration)", "description": "Seat Ganesha on a wooden chaurang covered with red silk. Anoint eyes with ghee and chant life-infusing Vedic mantras.", "mantra": "ॐ अस्य प्राणप्रतिष्ठापन मन्त्रस्य ब्रह्मा विष्णु महेश्वरा ऋषयः ऋग्यजुःसामाथर्वाणि छन्दांसि प्राणो देवता॥"},
            {"stepNumber": 2, "title": "Durva & Jaswand Samarpan", "description": "Offer 21 blades of sacred durva grass reciting Ganesha's 21 holy names along with red hibiscus.", "mantra": "ॐ गणाधिपाय नमः, ॐ उमापुत्राय नमः, ॐ विघ्ननाशनाय नमः, ॐ विनायकाय नमः, ॐ ईशपुत्राय नमः॥"},
            {"stepNumber": 3, "title": "Naivedya Arpan (21 Modaks)", "description": "Offer 21 steaming hot jaggery and coconut modaks topped with pure cow ghee.", "mantra": "ॐ भूर्भुवः स्वः ॐ अमृतोपस्तरणमसि स्वाहा। सत्यं त्वर्तेन परिषञ्चामि।"},
            {"stepNumber": 4, "title": "Uttarpuja & Visarjan", "description": "Perform farewell aarti, shift idol slightly forward, and immerse in water chanting 'Ganpati Bappa Morya Pudhchya Varshi Lavkar Ya'.", "mantra": "यान्तु देवगणाः सर्वे पूजामादाय मामकीम्। इष्टकामसमृद्ध्यर्थं पुनरागमनाय च॥"}
        ]
    },
    {
        "id": "satyanarayan_vrat",
        "title": "Shri Satyanarayan Vrat Katha & Vidhi",
        "hindiTitle": "सत्यनारायण व्रत कथा एवं विधि",
        "deity": "Lord Vishnu (Satyanarayan)",
        "festivalTag": "Purnima",
        "regionalTag": "Pan-India",
        "estimatedMinutes": 60,
        "significance": "Performed on Purnima, Thursdays, or milestone events to invoke truth, family harmony, and fulfillment of deep wishes.",
        "sankalpText": "ॐ अद्य पौर्णमास्यां तिथौ ममाखिल मनोरथ सिद्ध्यर्थं सत्यनारायण पूजनं कथाश्रवणं च करिष्ये।",
        "samagriList": [
            {"name": "Banana Tree Stems for Mandap Pillars", "quantity": "4 stems", "category": "Mandap", "isChecked": False},
            {"name": "Panchamrit & Tulsi Leaves", "quantity": "1 vessel", "category": "Abhishek", "isChecked": False},
            {"name": "Sawa Sawa Prasadam (Wheat flour roasted with ghee and sugar)", "quantity": "1.25 kg", "category": "Maha Prasadam", "isChecked": False},
            {"name": "Ripe Bananas cut with sugar", "quantity": "1 dozen", "category": "Prasadam", "isChecked": False},
            {"name": "Yellow Silk Cloth & Supari", "quantity": "1 meter", "category": "Mandap", "isChecked": False},
            {"name": "Shri Satyanarayan Katha Book (5 Chapters)", "quantity": "1 book", "category": "Scripture", "isChecked": False}
        ],
        "steps": [
            {"stepNumber": 1, "title": "Mandap Sthapana & Kalash", "description": "Construct four-pillared mandap with banana stems. Establish Kalash and draw Navagraha mandala with colored powders.", "mantra": "ॐ नारायणाय विद्महे वासुदेवाय धीमहि तन्नो विष्णुः प्रचोदयात्॥"},
            {"stepNumber": 2, "title": "Panchamrit Snan & Shaligram Pujan", "description": "Bathe the sacred Shaligram or Vishnu idol with Panchamrit and Ganga water, applying yellow sandalwood.", "mantra": "शान्ताकारं भुजगशयनं पद्मनाभं सुरेशं विश्वाधारं गगनसदृशं मेघवर्णं शुभाङ्गम्॥"},
            {"stepNumber": 3, "title": "Shri Satyanarayan Katha (5 Chapters)", "description": "Gather family to listen to all five sacred chapters illustrating the miraculous power of truth and faith.", "mantra": "सत्यमेवेश्वरो लोके सत्ये धर्मः सदाश्रितः। सत्यमूलानि सर्वाणि सत्यान्नास्ति परं पदम्॥"},
            {"stepNumber": 4, "title": "Maha Aarti & Prasadam Distribution", "description": "Perform Vishnu Aarti with camphor, distribute wheat panjiri, bananas, and panchamrit to all participants.", "mantra": "ॐ जय जगदीश हरे, स्वामी जय जगदीश हरे। भक्त जनों के संकट, दास जनों के संकट, क्षण में दूर करे॥"}
        ]
    }
]

# ==========================================
# 3. REMOTE MONETIZATION & ADMOB CONFIG
# ==========================================
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
    "updatedAt": datetime.utcnow().isoformat() + "Z"
}

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
        "hindiName": "पूर्णिमा व्रत एवं सत्यनारायण कथा",
        "date": "2026-11-21T00:00:00Z",
        "type": "Purnima",
        "deity": "Bhagwan Satyanarayan & Maa Lakshmi",
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
        "id": "amavasya_pitru",
        "name": "Margashirsha Amavasya (Pitru Tarpana)",
        "hindiName": "मार्गशीर्ष अमावस्या (पितृ तर्पण)",
        "date": "2026-12-05T00:00:00Z",
        "type": "Amavasya",
        "deity": "Lord Vishnu & Pitru Devas",
        "paranaTiming": "After Midday Tarpana: 01:15 PM",
        "significance": "Bestowing peace, ancestral blessings, and freedom from Pitru Dosh through charity and sacred baths.",
        "kathaTitle": "महात्म्य: अमावस्या पितृ तर्पण",
        "kathaContent": "गरुड़ पुराण के अनुसार अमावस्या तिथि पर पितृगण अपने वंशजों के घर के द्वार पर आते हैं और जल व अन्न की आशा रखते हैं। इस दिन पीपल के वृक्ष में जल चढ़ाने, काले तिल दान करने और ब्राह्मण या निर्धनों को भोजन कराने से सात पीढ़ियों के पितृ तृप्त होकर सुख-समृद्धि का आशीर्वाद देते हैं।",
        "rules": [
            "Offer water with black sesame seeds (Kala Til) facing South.",
            "Water the Peepal tree and light a mustard oil diya at sunset.",
            "Feed cows, dogs, and crows with satvik food."
        ]
    },
    {
        "id": "somwar_shiv_vrat",
        "name": "Somwar Shiva Vrat",
        "hindiName": "सोमवार शिव व्रत",
        "date": "2026-11-11T00:00:00Z",
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

def main():
    print("=" * 65)
    print("PUSHING PRODUCTION PUJAVIDHI DATA TO FIRESTORE (pujavidhi-app-2026)")
    print("=" * 65)

    # 1. Push 14 Complete Aartis
    print(f"\n[1/4] Pushing {len(AARTIS)} Complete Aartis to 'media_tracks' collection...")
    for aarti in AARTIS:
        aarti["updatedAt"] = datetime.utcnow().isoformat() + "Z"
        code = set_doc("media_tracks", aarti["id"], aarti)
        print(f"  -> {aarti['id']} ('{aarti['title']}'): HTTP {code}")

    # 2. Push 8 Complete Puja Vidhis
    print(f"\n[2/4] Pushing {len(VIDHIS)} Complete Puja Vidhis to 'festivals_and_vidhis' collection...")
    for vidhi in VIDHIS:
        vidhi["updatedAt"] = datetime.utcnow().isoformat() + "Z"
        code = set_doc("festivals_and_vidhis", vidhi["id"], vidhi)
        print(f"  -> {vidhi['id']} ('{vidhi['title']}'): HTTP {code}")

    # 3. Push Vrat Calendar
    print(f"\n[3/4] Pushing {len(VRATS)} Vrat & Upvas items to 'vrat_calendar' collection...")
    for vrat in VRATS:
        vrat["updatedAt"] = datetime.utcnow().isoformat() + "Z"
        code = set_doc("vrat_calendar", vrat["id"], vrat)
        print(f"  -> {vrat['id']} ('{vrat['name']}'): HTTP {code}")

    # 4. Push Monetization Remote Config
    print("\n[4/4] Pushing Monetization Remote Config to 'pujavidhi_config/monetization'...")
    code = set_doc("pujavidhi_config", "monetization", MONETIZATION_CONFIG)
    print(f"  -> pujavidhi_config/monetization: HTTP {code}")

    # 5. Save local JSON bundles for offline-first support
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

    print("\nDone! All production data is live in dedicated Firebase Firestore (pujavidhi-app-2026) and cached locally.")

if __name__ == '__main__':
    main()
