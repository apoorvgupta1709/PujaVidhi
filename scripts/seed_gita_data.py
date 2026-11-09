import json
import os
import sys
import urllib.request
from datetime import datetime

try:
    sys.stdout.reconfigure(encoding='utf-8')
except Exception:
    pass

PROJECT_ID = 'pujavidhi-app-2026'
BASE_URL = f'https://firestore.googleapis.com/v1/projects/{PROJECT_ID}/databases/(default)/documents'

CHAPTERS = [
    {
        "chapterNumber": 1,
        "nameSanskrit": "अर्जुनविषादयोग",
        "nameEnglish": "Arjuna Vishada Yoga",
        "nameTranslation": "The Distress of Arjuna",
        "versesCount": 47,
        "summaryHindi": "कुरुक्षेत्र के युद्धस्थल में दोनों सेनाओं के मध्य उपस्थित होकर अर्जुन अपने सगे-संबंधियों को देखकर मोह और विषाद से ग्रस्त हो जाते हैं और धनुष-बाण त्यागकर रथ में बैठ जाते हैं।",
        "summaryEnglish": "On the battlefield of Kurukshetra, observing friends and revered elders on the opposing side, Arjuna is overwhelmed by grief and moral dilemma, refusing to fight.",
        "keyLesson": "कर्तव्य पथ पर मोह और दुर्बलता का त्याग कर विवेक का आश्रय लेना।"
    },
    {
        "chapterNumber": 2,
        "nameSanskrit": "सांख्ययोग",
        "nameEnglish": "Sankhya Yoga",
        "nameTranslation": "The Yoga of Knowledge & Intellect",
        "versesCount": 72,
        "summaryHindi": "श्रीकृष्ण आत्मा की अमरता, निष्काम कर्मयोग और स्थितप्रज्ञ पुरुष के लक्षणों का दिव्य उपदेश देते हैं। यह अध्याय संपूर्ण गीता का सार माना जाता है।",
        "summaryEnglish": "Lord Krishna enlightens Arjuna on the eternal indestructible nature of the soul, the discipline of selfless action (Nishkama Karma), and the serene qualities of a person of steady intellect (Sthitaprajna).",
        "keyLesson": "कर्मण्येवाधिकारस्ते मा फलेषु कदाचन — केवल निष्काम कर्म में तुम्हारा अधिकार है, फल में नहीं।"
    },
    {
        "chapterNumber": 3,
        "nameSanskrit": "कर्मयोग",
        "nameEnglish": "Karma Yoga",
        "nameTranslation": "The Yoga of Action",
        "versesCount": 43,
        "summaryHindi": "संसार में प्रत्येक मनुष्य कर्म करने के लिए बाध्य है। फल की इच्छा त्यागकर लोक-कल्याण की भावना से कर्म करना ही सच्चा संन्यास और मोक्ष का साधन है।",
        "summaryEnglish": "Krishna explains that cessation of physical work is not true renunciation. Performing obligatory duties with detached dedication for the welfare of the world leads to self-realization.",
        "keyLesson": "कर्म त्याग से नहीं, अपितु फल की आसक्ति के त्याग से मोक्ष मिलता है।"
    },
    {
        "chapterNumber": 4,
        "nameSanskrit": "ज्ञानकर्मसंन्यासयोग",
        "nameEnglish": "Jnana Karma Sanyasa Yoga",
        "nameTranslation": "The Yoga of Wisdom & Renunciation of Action",
        "versesCount": 42,
        "summaryHindi": "भगवान के दिव्य अवतार के रहस्य, ज्ञानयज्ञ की महिमा और ज्ञान की अग्नि द्वारा समस्त कर्म-बंधनों के भस्म होने का निरूपण।",
        "summaryEnglish": "Krishna reveals the mystery of divine incarnation for restoring cosmic righteousness (Dharma) and explains that spiritual wisdom purifies all karma like fire purifies gold.",
        "keyLesson": "यदा यदा हि धर्मस्य ग्लानिर्भवति भारत — अधर्म के विनाश और धर्म की स्थापना हेतु प्रभु का प्राकट्य।"
    },
    {
        "chapterNumber": 5,
        "nameSanskrit": "कर्मसंन्यासयोग",
        "nameEnglish": "Karma Sanyasa Yoga",
        "nameTranslation": "The Yoga of Renunciation",
        "versesCount": 29,
        "summaryHindi": "कर्मयोग और सांख्य दोनों एक ही सत्य तक पहुंचाते हैं। जो मनुष्य जल में कमल के पत्ते की तरह संसार में निर्लिप्त रहता है, उसे पाप स्पर्श नहीं करते।",
        "summaryEnglish": "Krishna elucidates the harmony between renunciation of actions and selfless action. Living untouched by mundane attachments like a lotus leaf in water brings liberation.",
        "keyLesson": "मन, बुद्धि और इन्द्रियों को ईश्वराधीन कर संसार में अनासक्त भाव से विचरण।"
    },
    {
        "chapterNumber": 6,
        "nameSanskrit": "आत्मसंयमयोग (ध्यानयोग)",
        "nameEnglish": "Dhyana Yoga",
        "nameTranslation": "The Yoga of Meditation",
        "versesCount": 47,
        "summaryHindi": "मन के निग्रह, ध्यान की विधि, संतुलित जीवनशैली और अभ्यास व वैराग्य द्वारा चंचल मन को वश में करने का मार्ग।",
        "summaryEnglish": "The discipline of mastering the restless mind through consistent practice (Abhyasa) and detachment (Vairagya), establishing inner stillness in the supreme self.",
        "keyLesson": "मन ही मनुष्य का सबसे बड़ा मित्र है और यदि अनियंत्रित रहे तो सबसे बड़ा शत्रु।"
    },
    {
        "chapterNumber": 7,
        "nameSanskrit": "ज्ञानविज्ञानयोग",
        "nameEnglish": "Jnana Vijnana Yoga",
        "nameTranslation": "The Yoga of Knowledge & Discernment",
        "versesCount": 30,
        "summaryHindi": "परमात्मा की अपरा और परा प्रकृति का वर्णन। चार प्रकार के भक्त (आर्त, जिज्ञासु, अर्थार्थी, ज्ञानी) और ज्ञानी भक्त की प्रभु को प्रियता।",
        "summaryEnglish": "Krishna describes His material and spiritual energies, and how four classes of people seek Him, highlighting that the devotee established in pure wisdom is dearest.",
        "keyLesson": "समस्त चराचर जगत में भगवान ही सूत्र में मणियों की तरह पिरोए हुए हैं।"
    },
    {
        "chapterNumber": 8,
        "nameSanskrit": "अक्षरब्रह्मयोग",
        "nameEnglish": "Akshara Brahma Yoga",
        "nameTranslation": "The Yoga of the Imperishable Absolute",
        "versesCount": 28,
        "summaryHindi": "मृत्यु के समय अंतःकरण के चिंतन का महत्व, ॐ एकाक्षर ब्रह्म का जाप और उत्तरायण-दक्षिणायन गतियों का वर्णन।",
        "summaryEnglish": "How the thought state at the moment of departing the physical vessel determines future existence, and how meditating upon OM leads to eternal transcendence.",
        "keyLesson": "अन्तकाले च मामेव स्मरन्मुक्त्वा कलेवरम् — अंत समय में प्रभु का निरंतर स्मरण मोक्ष प्रदाता है।"
    },
    {
        "chapterNumber": 9,
        "nameSanskrit": "राजविद्याराजगुह्ययोग",
        "nameEnglish": "Raja Vidya Raja Guhya Yoga",
        "nameTranslation": "The Yoga of Sovereign Science & Secret",
        "versesCount": 34,
        "summaryHindi": "परम गुह्य ज्ञान, अनन्य भक्ति की महिमा और पत्रं पुष्पं फलं तोयं के भाव से की गई सरल भेंट का प्रभु द्वारा सहर्ष स्वीकार।",
        "summaryEnglish": "The king of all spiritual wisdom and deepest secrets: surrender through love, where even a humble leaf, flower, fruit or water offered with devotion is lovingly accepted by Krishna.",
        "keyLesson": "अनन्याश्चिन्तयन्तो मां ये जनाः पर्युपासते — जो अनन्य भाव से मुझे भजते हैं, उनका योगक्षेम मैं वहन करता हूँ।"
    },
    {
        "chapterNumber": 10,
        "nameSanskrit": "विभूतियोग",
        "nameEnglish": "Vibhuti Yoga",
        "nameTranslation": "The Yoga of Divine Splendors",
        "versesCount": 42,
        "summaryHindi": "सृष्टि के समस्त श्रेष्ठ रूपों में परमात्मा की दिव्य विभूतियों का दर्शन — सूर्यों में विष्णु, रुद्रों में शंकर, नदियों में गंगा।",
        "summaryEnglish": "Krishna reveals how His divine opulences sustain the universe, manifesting as the soul within all beings, the sun, the Himalayas, and sacred vibrations like OM.",
        "keyLesson": "संसार में जो कुछ भी ऐश्वर्यवान, कांतियुक्त और शक्तिशाली है, वह प्रभु के तेज का अंश है।"
    },
    {
        "chapterNumber": 11,
        "nameSanskrit": "विश्वरूपदर्शनयोग",
        "nameEnglish": "Vishwarupa Darshana Yoga",
        "nameTranslation": "The Yoga of the Vision of Cosmic Form",
        "versesCount": 55,
        "summaryHindi": "अर्जुन की प्रार्थना पर श्रीकृष्ण दिव्य चक्षु प्रदान कर अपना अनंत, सहस्रों मुख-नेत्रों वाला विराट विश्वरूप प्रकट करते हैं।",
        "summaryEnglish": "Krishna bestows celestial vision upon Arjuna to perceive His majestic, awe-inspiring multi-dimensional Universal Form containing all galaxies, gods, and cosmic time.",
        "keyLesson": "अनन्य भक्ति द्वारा ही प्रभु के इस परम दिव्य स्वरूप का साक्षात्कार संभव है।"
    },
    {
        "chapterNumber": 12,
        "nameSanskrit": "भक्तियोग",
        "nameEnglish": "Bhakti Yoga",
        "nameTranslation": "The Yoga of Devotion",
        "versesCount": 20,
        "summaryHindi": "सगुण और निर्गुण उपासना की तुलना, प्रभु के प्रिय भक्त के ३५ दिव्य लक्षण (अद्वेष्टा सर्वभूतानां, मैत्रः करुण एव च)।",
        "summaryEnglish": "The sweet science of pure devotion: qualities of the ideal bhakta who is free from malice, compassionate, serene in praise and criticism, and completely surrendered.",
        "keyLesson": "जो सभी प्राणियों में द्वेषरहित, दयालु और समभाव से युक्त है, वही प्रभु का अत्यंत प्रिय भक्त है।"
    },
    {
        "chapterNumber": 13,
        "nameSanskrit": "क्षेत्रक्षेत्रज्ञविभागयोग",
        "nameEnglish": "Kshetra Kshetragya Vibhaga Yoga",
        "nameTranslation": "The Yoga of the Field & Knower of Field",
        "versesCount": 35,
        "summaryHindi": "यह नश्वर शरीर 'क्षेत्र' (खेत) है और इसमें स्थित चेतन आत्मा 'क्षेत्रज्ञ' (जानने वाला) है। प्रकृति और पुरुष का भेद विवेक।",
        "summaryEnglish": "The profound distinction between the mortal physical body (the Field) and the immortal observing Consciousness (the Knower of the Field).",
        "keyLesson": "शरीर अनित्य है, किन्तु उसमें निवास करने वाली आत्मा शाश्वत और निर्लेप है।"
    },
    {
        "chapterNumber": 14,
        "nameSanskrit": "गुणत्रयविभागयोग",
        "nameEnglish": "Gunatraya Vibhaga Yoga",
        "nameTranslation": "The Yoga of Three Modes of Nature",
        "versesCount": 27,
        "summaryHindi": "प्रकृति के तीन गुण — सत्त्व (ज्ञान व सुख), रज (कामना व क्रियाशीलता), तम (अज्ञान व प्रमाद) — और गुणातीत होने का मार्ग।",
        "summaryEnglish": "Detailed analysis of the three fundamental cosmic modes (Gunas) — Sattva, Rajas, and Tamas — and how transcending all three leads to spiritual liberation.",
        "keyLesson": "सत्त्व गुण का आश्रय लेते हुए अंततः तीनों गुणों के पार 'गुणातीत' होना ही परम ध्येय है।"
    },
    {
        "chapterNumber": 15,
        "nameSanskrit": "पुरुषोत्तमयोग",
        "nameEnglish": "Purushottama Yoga",
        "nameTranslation": "The Yoga of the Supreme Divine Person",
        "versesCount": 20,
        "summaryHindi": "संसार रूपी अश्वत्थ वृक्ष का रूपक, क्षर (नाशवान शरीर), अक्षर (अविनाशी जीवात्मा) और उत्तम पुरुष (परमात्मा) का रहस्य।",
        "summaryEnglish": "The metaphor of the cosmic upside-down Banyan tree (Ashvattha) and the supreme status of Purushottama beyond both the perishable cosmos and the imperishable soul.",
        "keyLesson": "अहं वैश्वानरो भूत्वा प्राणिनां देहमाश्रितः — समस्त प्राणियों के भीतर वैश्वानर अग्नि रूप में प्रभु ही अन्न पचाते हैं।"
    },
    {
        "chapterNumber": 16,
        "nameSanskrit": "दैवासुरसम्पद्विभागयोग",
        "nameEnglish": "Daivasura Sampad Vibhaga Yoga",
        "nameTranslation": "The Yoga of Divine & Demonic Natures",
        "versesCount": 24,
        "summaryHindi": "दैवी संपदा (अभय, दान, अहिंसा, सत्य) और आसुरी संपदा (दम्भ, दर्प, क्रोध, लोभ) का वर्णन। काम, क्रोध और लोभ नरक के तीन द्वार।",
        "summaryEnglish": "The clear demarcation between divine virtues (fearlessness, compassion, truth) and demonic tendencies (ego, arrogance, deceit).",
        "keyLesson": "त्रिविधं नरकस्येदं द्वारं नाशनमात्मनः — काम, क्रोध और लोभ आत्मा का पतन करने वाले नरक के तीन द्वार हैं।"
    },
    {
        "chapterNumber": 17,
        "nameSanskrit": "श्रद्धात्रयविभागयोग",
        "nameEnglish": "Shraddhatraya Vibhaga Yoga",
        "nameTranslation": "The Yoga of Threefold Faith",
        "versesCount": 28,
        "summaryHindi": "सात्त्विक, राजसिक और तामसिक आहार, यज्ञ, तप और दान का वर्गीकरण। 'ॐ तत्सत्' के पवित्र उच्चारण का महात्म्य।",
        "summaryEnglish": "Classification of human faith, food choices, sacrifices, austerities, and charity into the three Gunas, concluding with the sacred mystic utterance 'OM TAT SAT'.",
        "keyLesson": "श्रद्धामयोऽयं पुरुषो यो यच्छ्रद्धः स एव सः — मनुष्य अपनी श्रद्धा के अनुरूप ही बनता है।"
    },
    {
        "chapterNumber": 18,
        "nameSanskrit": "मोक्षसंन्यासयोग",
        "nameEnglish": "Moksha Sanyasa Yoga",
        "nameTranslation": "The Yoga of Liberation through Renunciation",
        "versesCount": 78,
        "summaryHindi": "गीता का अंतिम उपसंहार। संन्यास और त्याग का अंतर, पांच कर्म के कारक, चारों वर्णों के स्वाभाविक कर्म और शरणागति का अंतिम महामंत्र।",
        "summaryEnglish": "The crowning summary of the entire Bhagavad Gita: true renunciation of selfish desires, fulfilling sacred duties with devotion, and the supreme surrender (Sharanagati) unto Krishna.",
        "keyLesson": "सर्वधर्मान्परित्यज्य मामेकं शरणं व्रज — सब धर्मों को मुझमें समर्पित कर केवल मेरी शरण में आ जाओ, मैं तुम्हें समस्त पापों से मुक्त कर दूंगा।"
    }
]

SHLOKAS = [
    {
        "id": "gita_1_1",
        "chapterNumber": 1,
        "verseNumber": 1,
        "textSanskrit": "धृतराष्ट्र उवाच |\nधर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः |\nमामकाः पाण्डवाश्चैव किमकुर्वत सञ्जय || १ ||",
        "textTransliteration": "dhṛtarāṣṭra uvāca |\ndharmakṣetre kurukṣetre samavetā yuyutsavaḥ |\nmāmakāḥ pāṇḍavāścaiva kimakurvata sañjaya || 1 ||",
        "wordMeanings": "धृतराष्ट्रः उवाच—धृतराष्ट्र ने कहा; धर्म-क्षेत्रे—पवित्र भूमि पर; कुरु-क्षेत्रे—कुरुक्षेत्र में; समवेताः—एकत्रित; युयुत्सवः—युद्ध की इच्छा से; मामकाः—मेरे पुत्र; पाण्डवाः—पाण्डु के पुत्र; च—तथा; एव—निश्चय ही; किम्—क्या; अकुर्वत—किया; सञ्जय—हे संजय।",
        "translationHindi": "धृतराष्ट्र ने पूछा: हे संजय! धर्मभूमि कुरुक्षेत्र में युद्ध की इच्छा से एकत्रित हुए मेरे और पाण्डु के पुत्रों ने क्या किया?",
        "purportHindi": "श्रीमद्भगवद्गीता का प्रथम श्लोक राजा धृतराष्ट्र के प्रश्न से प्रारंभ होता है। कुरुक्षेत्र केवल एक रणभूमि नहीं, अपितु 'धर्मक्षेत्र' था जहाँ धर्म और अधर्म का महासंग्राम होने जा रहा था।",
        "translationEnglish": "Dhritarashtra said: O Sanjaya, assembled on the sacred field of Kurukshetra, desirous of fighting, what did my sons and the sons of Pandu do?",
        "topicTag": "Dharma"
    },
    {
        "id": "gita_2_20",
        "chapterNumber": 2,
        "verseNumber": 20,
        "textSanskrit": "न जायते म्रियते वा कदाचि-\nन्नायं भूत्वा भविता वा न भूयः |\nअजो नित्यः शाश्वतोऽयं पुराणो\nन हन्यते हन्यमाने शरीरे || २० ||",
        "textTransliteration": "na jāyate mriyate vā kadācin\nnāyaṁ bhūtvā bhavitā vā na bhūyaḥ |\najo nityaḥ śāśvato'yaṁ purāṇo\nna hanyate hanyamāne śarīre || 20 ||",
        "wordMeanings": "न—नहीं; जायते—जन्म लेता है; म्रियते—मरता है; वा—अथवा; कदाचित्—कभी भी; न—नहीं; अयम्—यह; भूत्वा—होकर; भविता—होने वाला है; वा—अथवा; न—नहीं; भूयः—पुनः; अजः—अजन्मा; नित्यः—सदा रहने वाला; शाश्वतः—सनातन; अयम्—यह; पुराणः—पुरातन; न—नहीं; हन्यते—मारा जाता है; हन्यमाने—मारे जाने पर; शरीरे—शरीर के।",
        "translationHindi": "आत्मा किसी भी काल में न तो जन्म लेती है और न कभी मरती है। यह अजन्मा, नित्य, सनातन और पुरातन है। शरीर के नष्ट होने पर भी आत्मा कभी नष्ट नहीं होती।",
        "purportHindi": "भगवान श्रीकृष्ण अर्जुन को आत्मा के अमर, अविकारी और शाश्वत स्वरूप का ज्ञान देते हैं। मृत्यु केवल वस्त्र बदलने के समान शरीर का परिवर्तन है, आत्मा सदा चैतन्य रहती है।",
        "translationEnglish": "The soul is never born, nor does it ever die; nor having once existed, does it ever cease to be. It is unborn, eternal, ever-existing, undying and primeval. It is not slain when the body is slain.",
        "topicTag": "Soul (आत्मा)"
    },
    {
        "id": "gita_2_47",
        "chapterNumber": 2,
        "verseNumber": 47,
        "textSanskrit": "कर्मण्येवाधिकारस्ते मा फलेषु कदाचन |\nमा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि || ४७ ||",
        "textTransliteration": "karmaṇyevādhikāraste mā phaleṣu kadācana |\nmā karmaphalaheturbhūrmā te saṅgo'stvakarmaṇi || 47 ||",
        "wordMeanings": "कर्मणि—कर्म में; एव—ही; अधिकारः—अधिकार; ते—तुम्हारा; मा—कभी नहीं; फलेषु—फलों में; कदाचन—किसी भी काल में; मा—मत; कर्म-फल—कर्म के फल का; हेतुः—कारण; भूः—बनो; मा—न; ते—तुम्हारा; सङ्गः—आसक्ति; अस्तु—हो; अकर्मणि—कर्म न करने में।",
        "translationHindi": "तुम्हारा केवल कर्म करने में ही अधिकार है, उसके फलों में कभी नहीं। इसलिए तुम कर्मफल के प्रेरक मत बनो और न ही तुम्हारी अकर्मण्यता (कर्म न करने) में आसक्ति हो।",
        "purportHindi": "यह भगवद्गीता का सबसे प्रसिद्ध महामंत्र है। निष्काम कर्मयोग का आधार यही है कि अपना कर्तव्य पूर्ण निष्ठा, ईमानदारी और समर्पण से करो, परिणाम की चिंता ईश्वर पर छोड़ दो।",
        "translationEnglish": "You have a right to perform your prescribed duties, but you are not entitled to the fruits of your actions. Never consider yourself the cause of the results of your activities, nor be attached to inaction.",
        "topicTag": "Karma Yoga"
    },
    {
        "id": "gita_3_19",
        "chapterNumber": 3,
        "verseNumber": 19,
        "textSanskrit": "तस्मादसक्तः सततं कार्यं कर्म समाचर |\nअसक्तो ह्याचरन्कर्म परमाप्नोति पूरुषः || १९ ||",
        "textTransliteration": "tasmādasaktaḥ satataṁ kāryaṁ karma samācara |\nasakto hyācarankarma paramāpnoti pūruṣaḥ || 19 ||",
        "wordMeanings": "तस्मात्—अतएव; असक्तः—आसक्तिरहित; सततम्—निरन्तर; कार्यम्—कर्तव्य रूप; कर्म—कर्म; समाचर—भली-भाँति करो; असक्तः—अनासक्त होकर; हि—निश्चय ही; आचरन्—आचरण करता हुआ; कर्म—कर्म; परम्—परम पद को; आप्नोति—प्राप्त होता है; पूरुषः—मनुष्य।",
        "translationHindi": "अतः आसक्तिरहित होकर निरंतर कर्तव्य कर्म का भली-भाँति आचरण करो; क्योंकि अनासक्त होकर कर्म करता हुआ मनुष्य परम तत्व (मोक्ष) को प्राप्त हो जाता है।",
        "purportHindi": "अनासक्ति का अर्थ कार्य से भागना नहीं, अपितु कार्य करते हुए उसके व्यक्तिगत लाभ-हानि के भाव से ऊपर उठना है। यही जीवन में सच्ची शांति का मार्ग है।",
        "translationEnglish": "Therefore, without being attached to the fruits of activities, one should act as a matter of duty; for by working without attachment one attains the Supreme.",
        "topicTag": "Karma Yoga"
    },
    {
        "id": "gita_4_7",
        "chapterNumber": 4,
        "verseNumber": 7,
        "textSanskrit": "यदा यदा हि धर्मस्य ग्लानिर्भवति भारत |\nअभ्युत्थानमधर्मस्य तदात्मानं सृजाम्यहम् || ७ ||",
        "textTransliteration": "yadā yadā hi dharmasya glānirbhavati bhārata |\nabhyutthānamadharmasya tadātmānaṁ sṛjāmyaham || 7 ||",
        "wordMeanings": "यदा यदा—जब जब; हि—निश्चय ही; धर्मस्य—धर्म की; ग्लानिः—हानि; भवति—होती है; भारत—हे अर्जुन; अभ्युत्थानम्—वृद्धि; अधर्मस्य—अधर्म की; तदा—तब; आत्मानम्—अपने आपको; सृजामि—प्रकट करता हूँ; अहम्—मैं।",
        "translationHindi": "हे भारत (अर्जुन)! जब-जब धर्म की हानि और अधर्म की वृद्धि होती है, तब-तब मैं अपने आपको साकार रूप में प्रकट करता हूँ।",
        "purportHindi": "भगवान के अवतार का यह विश्वप्रसिद्ध श्लोक स्पष्ट करता है कि ईश्वर संसार में संतुलन, सत्य और धर्म की रक्षा के लिए युग-युग में स्वयं अवतरित होते हैं।",
        "translationEnglish": "Whenever and wherever there is a decline in righteousness, O Arjuna, and an ascendance of unrighteousness, at that time I manifest Myself.",
        "topicTag": "Avatara (अवतार)"
    },
    {
        "id": "gita_4_8",
        "chapterNumber": 4,
        "verseNumber": 8,
        "textSanskrit": "परित्राणाय साधूनां विनाशाय च दुष्कृताम् |\nधर्मसंस्थापनार्थाय सम्भवामि युगे युगे || ८ ||",
        "textTransliteration": "paritrāṇāya sādhūnāṁ vināśāya ca duṣkṛtām |\ndharmasaṁsthāpanārthāya sambhavāmi yuge yuge || 8 ||",
        "wordMeanings": "परित्राणाय—उद्धार के लिए; साधूनाम्—सज्जनों के; विनाशाय—विनाश के लिए; च—तथा; दुष्कृताम्—दुष्टों के; धर्म—धर्म की; संस्थापन-अर्थाय—स्थापना करने के लिए; सम्भवामि—प्रकट होता हूँ; युगे युगे—प्रत्येक युग में।",
        "translationHindi": "साधु-सज्जनों के उद्धार के लिए, दुष्कर्मियों के विनाश के लिए और धर्म की भली-भाँति स्थापना करने के लिए मैं युग-युग में प्रकट होता हूँ।",
        "purportHindi": "सच्चे भक्तों को अभय दान देना, समाज से क्रूरता और अन्याय को मिटाना और सनातन सत्य का मार्ग प्रशस्त करना ही प्रभु के अवतार का मूल उद्देश्य है।",
        "translationEnglish": "For the protection of the good, for the destruction of the wicked and for the establishment of righteousness, I am born in every age.",
        "topicTag": "Avatara (अवतार)"
    },
    {
        "id": "gita_6_5",
        "chapterNumber": 6,
        "verseNumber": 5,
        "textSanskrit": "उद्धरेदात्मनात्मानं नात्मानमवसादयेत् |\nआत्मैव ह्यात्मनो बन्धुरात्मैव रिपुरात्मनः || ५ ||",
        "textTransliteration": "uddharedātmanātmānaṁ nātmānamavasādayet |\nātmaiva hyātmano bandhurātmaiva ripurātmanaḥ || 5 ||",
        "wordMeanings": "उद्धरेत्—उद्धार करे; आत्मना—अपने मन द्वारा; आत्मानम्—अपने आपको; न—नहीं; आत्मानम्—अपने आपको; अवसादयेत्—गिराए; आत्मा—मन; एव—ही; हि—निश्चय ही; आत्मनः—अपना; बन्धुः—मित्र; आत्मा—मन; एव—ही; रिपुः—शत्रु; आत्मनः—अपना।",
        "translationHindi": "मनुष्य को चाहिए कि वह अपने मन द्वारा अपना उद्धार करे, अपने को नीचे न गिराए; क्योंकि यह मन ही आत्मा का मित्र है और मन ही आत्मा का सबसे बड़ा शत्रु है।",
        "purportHindi": "मनुष्य की अपनी इच्छाशक्ति और आत्मसंयम ही उसकी उन्नति अथवा पतन का कारण है। जब मन वश में होता है तो वह श्रेष्ठ मित्र बन जाता है।",
        "translationEnglish": "One must elevate oneself by one's own mind, and not degrade oneself. For the mind is the greatest friend of the self, and the mind can also be the greatest enemy.",
        "topicTag": "Mind & Meditation"
    },
    {
        "id": "gita_6_26",
        "chapterNumber": 6,
        "verseNumber": 26,
        "textSanskrit": "यतो यतो निश्चरति मनश्चञ्चलमस्थिरम् |\nततस्ततो नियम्यैतदात्मन्येव वशं नयेत् || २६ ||",
        "textTransliteration": "yato yato niścarati manaścañcalamasthiram |\ntatastato niyamyaitadātmanyeva vaśaṁ nayet || 26 ||",
        "wordMeanings": "यतः यतः—जहाँ-जहाँ; निश्चरति—विचलित होता है; मनः—मन; चञ्चलम्—अति चंचल; अस्थिरम्—अस्थिर; ततः ततः—वहाँ-वहाँ से; नियम्य—रोककर; एतत्—इसको; आत्मनि—परमात्मा में; एव—ही; वशम्—वश में; नयेत्—लाना चाहिए।",
        "translationHindi": "यह अत्यंत चंचल और अस्थिर मन जिस-जिस विषय की ओर भागे, वहाँ-वहाँ से इसे रोककर बार-बार परमात्मा के ध्यान में ही स्थिर करना चाहिए।",
        "purportHindi": "ध्यान और एकाग्रता का सरलतम अभ्यास यही है कि मन के भटकाव पर निराश न हों, अपितु धैर्यपूर्वक उसे वापस अपने लक्ष्य पर ले आएं।",
        "translationEnglish": "From wherever the restless and unsteady mind wanders, one should rein it in and bring it back under the control of the Self.",
        "topicTag": "Mind & Meditation"
    },
    {
        "id": "gita_9_22",
        "chapterNumber": 9,
        "verseNumber": 22,
        "textSanskrit": "अनन्याश्चिन्तयन्तो मां ये जनाः पर्युपासते |\nतेषां नित्याभियुक्तानां योगक्षेमं वहाम्यहम् || २२ ||",
        "textTransliteration": "ananyāścintayanto māṁ ye janāḥ paryupāsate |\nteṣāṁ nityābhiyuktānāṁ yogakṣemaṁ vahāmyaham || 22 ||",
        "wordMeanings": "अनन्याः—अनन्य भाव से; चिन्तयन्तः—चिन्तन करते हुए; माम्—मुझको; ये—जो; जनाः—लोग; पर्युपासते—उपासना करते हैं; तेषाम्—उन; नित्य-अभियुक्तानाम्—निरन्तर युक्त रहने वालों का; योग-क्षेमम्—योग (अप्राप्त की प्राप्ति) और क्षेम (प्राप्त की रक्षा); वहामि—वहन करता हूँ; अहम्—मैं।",
        "translationHindi": "जो अनन्य भक्त केवल मेरा ही चिंतन करते हुए निष्काम भाव से मेरी उपासना करते हैं, उन नित्य युक्त भक्तों के योग (आवश्यकताओं की पूर्ति) और क्षेम (उनकी रक्षा) का भार मैं स्वयं वहन करता हूँ।",
        "purportHindi": "भगवान का यह सबसे बड़ा आश्वासन है। जो पूर्ण शरणागत होकर ईश्वर पर निर्भर हो जाता है, उसकी समस्त भौतिक और आध्यात्मिक आवश्यकताओं की पूर्ति स्वयं प्रभु करते हैं।",
        "translationEnglish": "To those who always worship Me with exclusive devotion, meditating on My transcendental form, to them I carry what they lack, and I preserve what they have.",
        "topicTag": "Bhakti (भक्ति)"
    },
    {
        "id": "gita_9_26",
        "chapterNumber": 9,
        "verseNumber": 26,
        "textSanskrit": "पत्रं पुष्पं फलं तोयं यो मे भक्त्या प्रयच्छति |\nतदहं भक्त्युपहृतमश्नामि प्रयतात्मनः || २६ ||",
        "textTransliteration": "patraṁ puṣpaṁ phalaṁ toyaṁ yo me bhaktyā prayacchati |\ntadahaṁ bhaktyupahṛtamaśnāmi prayatātmanaḥ || 26 ||",
        "wordMeanings": "पत्रम्—पत्ता; पुष्पम्—फूल; फलम्—फल; तोयम्—जल; यः—जो; मे—मुझको; भक्त्या—प्रेम-भक्ति से; प्रयच्छति—अर्पित करता है; तत्—उस; अहम्—मैं; भक्ति-उपहृतम्—भक्तिपूर्वक भेंट की गई वस्तु को; अश्नामि—स्वीकार करता हूँ; प्रयत-आत्मनः—शुद्ध अन्तःकरण वाले का।",
        "translationHindi": "जो भक्त प्रेमपूर्वक मुझे एक पत्ता, एक फूल, एक फल या थोड़ा-सा जल भी अर्पित करता है, उस शुद्ध अन्तःकरण वाले भक्त की उस प्रेममयी भेंट को मैं सहर्ष स्वीकार करता हूँ।",
        "purportHindi": "पूजा में आडंबर या धन का कोई मूल्य नहीं, केवल हृदय के शुद्ध प्रेम और समर्पण का महत्व है। शबरी के बेर और विदुर की भाजी इसका श्रेष्ठ प्रमाण हैं।",
        "translationEnglish": "If one offers Me with love and devotion a leaf, a flower, a fruit or water, I will accept it with delight.",
        "topicTag": "Bhakti (भक्ति)"
    },
    {
        "id": "gita_12_13",
        "chapterNumber": 12,
        "verseNumber": 13,
        "textSanskrit": "अद्वेष्टा सर्वभूतानां मैत्रः करुण एव च |\nनिर्ममो निरहङ्कारः समदुःखसुखः क्षमी || १३ ||",
        "textTransliteration": "adveṣṭā sarvabhūtānāṁ maitraḥ karuṇa eva ca |\nnirmamo nirahaṅkāraḥ samaduḥkhasukhaḥ kṣamī || 13 ||",
        "wordMeanings": "अद्वेष्टा—द्वेषरहित; सर्व-भूतानाम्—समस्त प्राणियों में; मैत्रः—मित्रभाव वाला; करुणः—दयालु; एव—ही; च—तथा; निर्ममः—ममता से रहित; निरहङ्कारः—अहंकार से रहित; सम—समान; दुःख-सुखः—दुःख और सुख में; क्षमी—क्षमाशील।",
        "translationHindi": "जो किसी भी प्राणी से द्वेष नहीं करता, जो सबका मित्र और दयालु है, ममता और अहंकार से रहित है, सुख-दुःख में सम और क्षमाशील है, वही भक्त मुझे अत्यंत प्रिय है।",
        "purportHindi": "श्रीकृष्ण बताते हैं कि उनका सच्चा भक्त केवल मंदिर में पूजा करने वाला नहीं, अपितु समाज में सबके प्रति मैत्री, करुणा और अहंकारहीनता से जीने वाला व्यक्ति है।",
        "translationEnglish": "One who is not envious but is a kind friend to all living entities, who does not think himself a proprietor and is free from false ego, who is equal in both happiness and distress, forgiving, is very dear to Me.",
        "topicTag": "Ideal Devotee (प्रिय भक्त)"
    },
    {
        "id": "gita_18_66",
        "chapterNumber": 18,
        "verseNumber": 66,
        "textSanskrit": "सर्वधर्मान्परित्यज्य मामेकं शरणं व्रज |\nअहं त्वां सर्वपापेभ्यो मोक्षयिष्यामि मा शुचः || ६६ ||",
        "textTransliteration": "sarvadharmānparityajya māmekaṁ śaraṇaṁ vraja |\nahaṁ tvāṁ sarvapāpebhyo mokṣayiṣyāmi mā śucaḥ || 66 ||",
        "wordMeanings": "सर्व-धर्मान्—समस्त धर्मों को; परित्यज्य—त्यागकर; माम्—मेरी; एकम्—केवल एक; शरणम्—शरण में; व्रज—आ जाओ; अहम्—मैं; त्वाम्—तुमको; सर्व-पापेभ्यः—समस्त पापों से; मोक्षयिष्यामि—मुक्त कर दूँगा; मा—मत; शुचः—शोक करो।",
        "translationHindi": "संपूर्ण धर्मों और कर्तव्यों के अहंकार को त्यागकर केवल मेरी ही शरण में आ जाओ। मैं तुम्हें समस्त पापों और बंधनों से मुक्त कर दूँगा, तुम शोक मत करो।",
        "purportHindi": "यह श्रीमद्भगवद्गीता का चरम उपसंहार और 'चरम श्लोक' है। पूर्ण समर्पण (प्रपत्ति) ही जीवन की समस्त चिंताओं, भयों और संशयों से मुक्ति का सर्वोच्च सोपान है।",
        "translationEnglish": "Abandon all varieties of dharmas and simply surrender unto Me alone. I shall liberate you from all sinful reactions. Do not fear or grieve.",
        "topicTag": "Moksha & Surrender (शरणागति)"
    },
    {
        "id": "gita_18_78",
        "chapterNumber": 18,
        "verseNumber": 78,
        "textSanskrit": "यत्र योगेश्वरः कृष्णो यत्र पार्थो धनुर्धरः |\nतत्र श्रीर्विजयो भूतिर्ध्रुवा नीतिर्मतिर्मम || ७८ ||",
        "textTransliteration": "yatra yogeśvaraḥ kṛṣṇo yatra pārtho dhanurdharaḥ |\ntatra śrīrvijayo bhūtirdhruvā nītirmatirmama || 78 ||",
        "wordMeanings": "यत्र—जहाँ; योग-ईश्वरः—योग के स्वामी; कृष्णः—श्रीकृष्ण; यत्र—जहाँ; पार्थः—अर्जुन; धनुः-धरः—धनुष धारण करने वाले; तत्र—वहाँ; श्रीः—लक्ष्मी; विजयः—विजय; भूतिः—अनंत ऐश्वर्य; ध्रुवा—अटल; नीतिः—न्याय; मतिः मम—मेरा ऐसा मत है।",
        "translationHindi": "जहाँ योगेश्वर श्रीकृष्ण हैं और जहाँ गाण्डीवधारी धनुर्धर अर्जुन हैं, वहीं लक्ष्मी, विजय, अलौकिक ऐश्वर्य और अटल नीति है — ऐसा मेरा दृढ़ मत है।",
        "purportHindi": "गीता का अंतिम श्लोक संजय के मुख से उद्घोष करता है कि जहाँ ईश्वर का मार्गदर्शन (श्रीकृष्ण) और मनुष्य का निष्काम पुरुषार्थ (अर्जुन) एक साथ होते हैं, वहाँ विजय और समृद्धि अवश्यंभावी है।",
        "translationEnglish": "Wherever there is Krishna, the master of all mystics, and wherever there is Arjuna, the supreme archer, there will also certainly be opulence, victory, extraordinary power, and morality. That is my firm conviction.",
        "topicTag": "Victory & Dharma (विजय)"
    }
]

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

def main():
    print("=" * 65)
    print("SEEDING SHRIMAD BHAGAVAD GITA TO FIRESTORE (pujavidhi-app-2026)")
    print("=" * 65)

    # 1. Push 18 Chapters to Firestore
    print(f"\n[1/2] Pushing {len(CHAPTERS)} Chapters to 'gita_chapters' collection...")
    for ch in CHAPTERS:
        doc_id = f"chapter_{ch['chapterNumber']}"
        code = set_doc("gita_chapters", doc_id, ch)
        print(f"  -> {doc_id} ('{ch['nameSanskrit']}'): HTTP {code}")

    # 2. Push Curated Shlokas to Firestore
    print(f"\n[2/2] Pushing {len(SHLOKAS)} Curated Shlokas to 'gita_shlokas' collection...")
    for shloka in SHLOKAS:
        code = set_doc("gita_shlokas", shloka["id"], shloka)
        print(f"  -> {shloka['id']} (Ch {shloka['chapterNumber']} Verse {shloka['verseNumber']}): HTTP {code}")

    # 3. Save bundled local JSON for 100% offline access in both apps
    gita_bundle = {
        "chapters": CHAPTERS,
        "shlokas": SHLOKAS,
    }

    main_data_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "pujavidhi_main", "assets", "data"))
    admin_data_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "pujavidhi_admin", "assets", "data"))

    for out_dir in [main_data_dir, admin_data_dir]:
        os.makedirs(out_dir, exist_ok=True)
        with open(os.path.join(out_dir, "gita_production.json"), "w", encoding="utf-8") as f:
            json.dump(gita_bundle, f, ensure_ascii=False, indent=2)
        print(f"Saved local offline Gita production bundle in: {out_dir}")

    print("\nDone! Shrimad Bhagavad Gita is live in Firebase Firestore and cached locally for offline study.")

if __name__ == '__main__':
    main()
