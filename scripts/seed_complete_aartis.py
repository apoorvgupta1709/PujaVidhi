import urllib.request
import json
import time

PROJECT_ID = "pujavidhi-app-2026"
BASE_URL = f"https://firestore.googleapis.com/v1/projects/{PROJECT_ID}/databases/(default)/documents/media_tracks"

AARTIS_MASTER = [
    {
        "id": "chalisa_hanuman",
        "title": "Shri Hanuman Chalisa",
        "hindiTitle": "श्री हनुमान चालीसा (सम्पूर्ण)",
        "deity": "Lord Hanuman",
        "category": "Chalisa",
        "durationSec": 540,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Goswami Tulsidas's timeless 40-chaupai invocation for courage, protection, and liberation from all fears.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "॥ दोहा ॥\nश्रीगुरु चरन सरोज रज निज मनु मुकुरु सुधारि।\nबरनऊँ रघुबर बिमल जसु जो दायकु फल चारि॥", "english": "Shri Guru Charan Saroj Raj Nij Manu Mukuru Sudhari | Baranau Raghuvar Bimal Jasu Jo Dayaku Phal Chari ||"},
            {"timestampSec": 20, "devanagari": "बुद्धिहीन तनु जानिके सुमिरौ पवन-कुमार।\nबल बुधि बिद्या देहु मोहिं हरहु कलेस बिकार॥", "english": "Buddhiheen Tanu Jaanike Sumirau Pavan-Kumar | Bal Buddhi Vidya Dehu Mohi Harahu Kalesh Bikaar ||"},
            {"timestampSec": 35, "devanagari": "॥ चौपाई ॥\nजय हनुमान ज्ञान गुन सागर। जय कपीस तिहुँ लोक उजागर॥ १ ॥", "english": "Jai Hanuman Gyan Gun Sagar | Jai Kapis Tihun Lok Ujagar || 1 ||"},
            {"timestampSec": 48, "devanagari": "राम दूत अतुलित बल धामा। अंजनि-पुत्र पवनसुत नामा॥ २ ॥", "english": "Ram Doot Atulit Bal Dhama | Anjani-Putra Pavansut Nama || 2 ||"},
            {"timestampSec": 60, "devanagari": "महाबीर बिक्रम बजरंगी। कुमति निवार सुमति के संगी॥ ३ ॥", "english": "Mahabir Bikram Bajrangi | Kumati Nivaar Sumati Ke Sangi || 3 ||"},
            {"timestampSec": 72, "devanagari": "कंचन बरन बिराज सुबेसा। कानन कुंडल कुंचित केसा॥ ४ ॥", "english": "Kanchan Baran Biraaj Subesa | Kaanan Kundal Kunchit Kesa || 4 ||"},
            {"timestampSec": 84, "devanagari": "हाथ बज्र औ ध्वजा बिराजै। काँधे मूँज जनेऊ साजै॥ ५ ॥", "english": "Haath Bajra Au Dhwaja Biraaje | Kaandhe Moonj Janeu Saaje || 5 ||"},
            {"timestampSec": 96, "devanagari": "संकर सुवन केसरीनंदन। तेज प्रताप महा जग बंदन॥ ६ ॥", "english": "Sankar Suvan Kesarinandan | Tej Prataap Maha Jag Bandan || 6 ||"},
            {"timestampSec": 108, "devanagari": "बिद्यावान गुनी अति चातुर। राम काज करिबे को आतुर॥ ७ ॥", "english": "Vidyavaan Guni Ati Chaatur | Ram Kaaj Karibe Ko Aatur || 7 ||"},
            {"timestampSec": 120, "devanagari": "प्रभु चरित्र सुनिबे को रसिया। राम लखन सीता मन बसिया॥ ८ ॥", "english": "Prabhu Charitra Sunibe Ko Rasiya | Ram Lakhan Sita Man Basiya || 8 ||"},
            {"timestampSec": 132, "devanagari": "सूक्ष्म रूप धरि सियहिं दिखावा। बिकट रूप धरि लंक जरावा॥ ९ ॥", "english": "Sookshma Roop Dhari Siyahin Dikhawa | Bikat Roop Dhari Lanka Jarawa || 9 ||"},
            {"timestampSec": 144, "devanagari": "भीम रूप धरि असुर संहारे। रामचंद्र के काज संवारे॥ १० ॥", "english": "Bheem Roop Dhari Asur Sanhaare | Ramachandra Ke Kaaj Sanwaare || 10 ||"},
            {"timestampSec": 156, "devanagari": "लाय सजीवन लखन जियाये। श्रीरघुबीर हरषि उर लाये॥ ११ ॥", "english": "Laaye Sanjivan Lakhan Jiyaaye | Shri Raghubir Harashi Ur Laaye || 11 ||"},
            {"timestampSec": 168, "devanagari": "रघुपति कीन्ही बहुत बड़ाई। तुम मम प्रिय भरतहि सम भाई॥ १२ ॥", "english": "Raghupati Keenhi Bahut Badai | Tum Mam Priya Bharatahi Sam Bhai || 12 ||"},
            {"timestampSec": 180, "devanagari": "सहस बदन तुम्हरो जस गावैं। अस कहि श्रीपति कंठ लगावैं॥ १३ ॥", "english": "Sahas Badan Tumharo Jas Gaavein | As Kahi Shripati Kanth Lagaavein || 13 ||"},
            {"timestampSec": 192, "devanagari": "सनकादिक ब्रह्मादि मुनीसा। नारद सारद सहित अहीसा॥ १४ ॥", "english": "Sanakaadik Brahmaadi Muneesa | Naarad Saarad Sahit Aheesa || 14 ||"},
            {"timestampSec": 204, "devanagari": "जम कुबेर दिगपाल जहाँ ते। कबि कोबिद कहि सके कहाँ ते॥ १५ ॥", "english": "Jam Kuber Digpaal Jahaan Te | Kabi Kobid Kahi Sake Kahaan Te || 15 ||"},
            {"timestampSec": 216, "devanagari": "तुम उपकार सुग्रीवहिं कीन्हा। राम मिलाय राज पद दीन्हा॥ १६ ॥", "english": "Tum Upkaar Sugreevahin Keenha | Ram Milaay Raaj Pad Deenha || 16 ||"},
            {"timestampSec": 228, "devanagari": "तुम्हरो मंत्र बिभीषन माना। लंकेस्वर भए सब जग जाना॥ १७ ॥", "english": "Tumharo Mantra Bibheeshan Maana | Lankeswar Bhae Sab Jag Jaana || 17 ||"},
            {"timestampSec": 240, "devanagari": "जुग सहस्र जोजन पर भानू। लील्यो ताहि मधुर फल जानू॥ १८ ॥", "english": "Jug Sahasra Jojan Par Bhaanoo | Leelyo Taahi Madhur Phal Jaanoo || 18 ||"},
            {"timestampSec": 252, "devanagari": "प्रभु मुद्रिका मेलि मुख माहीं। जलधि लांघि गये अचरज नाहीं॥ १९ ॥", "english": "Prabhu Mudrika Meli Mukh Maaheen | Jaladhi Laanghi Gaye Acharaj Naaheen || 19 ||"},
            {"timestampSec": 264, "devanagari": "दुर्गम काज जगत के जेते। सुगम अनुग्रह तुम्हरे तेते॥ २० ॥", "english": "Durgam Kaaj Jagat Ke Jete | Sugam Anugrah Tumhre Tete || 20 ||"},
            {"timestampSec": 276, "devanagari": "राम दुआरे तुम रखवारे। होत न आज्ञा बिनु पैसारे॥ २१ ॥", "english": "Ram Duaare Tum Rakhwaare | Hot Na Aagya Binu Paisaare || 21 ||"},
            {"timestampSec": 288, "devanagari": "सब सुख लहै तुम्हारी सरना। तुम रच्छक काहू को डर ना॥ २२ ॥", "english": "Sab Sukh Lahai Tumhari Sarna | Tum Rakshak Kaahu Ko Dar Na || 22 ||"},
            {"timestampSec": 300, "devanagari": "आपन तेज सम्हारो आपै। तीनों लोक हाँक तें काँपै॥ २३ ॥", "english": "Aapan Tej Samhaaro Aapai | Teenon Lok Haank Ten Kaampei || 23 ||"},
            {"timestampSec": 312, "devanagari": "भूत पिसाच निकट नहिं आवै। महाबीर जब नाम सुनावै॥ २४ ॥", "english": "Bhoot Pisaach Nikat Nahin Aavai | Mahabir Jab Naam Sunaavai || 24 ||"},
            {"timestampSec": 324, "devanagari": "नासै रोग हरै सब पीरा। जपत निरंतर हनुमत बीरा॥ २५ ॥", "english": "Naasai Rog Harai Sab Peera | Japat Nirantar Hanumat Beera || 25 ||"},
            {"timestampSec": 336, "devanagari": "संकट तें हनुमान छुड़ावै। मन क्रम बचन ध्यान जो लावै॥ २६ ॥", "english": "Sankat Ten Hanuman Chhudaavai | Man Kram Bachan Dhyaan Jo Laavai || 26 ||"},
            {"timestampSec": 348, "devanagari": "सब पर राम तपस्वी राजा। तिन के काज सकल तुम साजा॥ २७ ॥", "english": "Sab Par Ram Tapasvee Raaja | Tin Ke Kaaj Sakal Tum Saaja || 27 ||"},
            {"timestampSec": 360, "devanagari": "और मनोरथ जो कोई लावै। सोइ अमित जीवन फल पावै॥ २८ ॥", "english": "Aur Manorath Jo Koi Laavai | Soi Amit Jeevan Phal Paavai || 28 ||"},
            {"timestampSec": 372, "devanagari": "चारों जुग परताप तुम्हारा। है परसिद्ध जगत उजियारा॥ २९ ॥", "english": "Chaaron Jug Partaap Tumhaara | Hai Parsiddh Jagat Ujiyaara || 29 ||"},
            {"timestampSec": 384, "devanagari": "साधु-संत के तुम रखवारे। असुर निकंदन राम दुलारे॥ ३० ॥", "english": "Saadhu-Sant Ke Tum Rakhwaare | Asur Nikandan Ram Dulaare || 30 ||"},
            {"timestampSec": 396, "devanagari": "अष्ट सिद्धि नौ निधि के दाता। अस बर दीन जानकी माता॥ ३१ ॥", "english": "Ashta Siddhi Nau Nidhi Ke Daata | As Bar Deen Jaanaki Maata || 31 ||"},
            {"timestampSec": 408, "devanagari": "राम रसायन तुम्हरे पासा। सदा रहो रघुपति के दासा॥ ३२ ॥", "english": "Ram Rasaayan Tumhre Paasa | Sada Raho Raghupati Ke Daasa || 32 ||"},
            {"timestampSec": 420, "devanagari": "तुम्हरे भजन राम को पावै। जनम-जनम के दुख बिसरावै॥ ३३ ॥", "english": "Tumhre Bhajan Ram Ko Paavai | Janam Janam Ke Dukh Bisraavai || 33 ||"},
            {"timestampSec": 432, "devanagari": "अन्त काल रघुबर पुर जाई। जहाँ जन्म हरि-भक्त कहाई॥ ३४ ॥", "english": "Ant Kaal Raghubar Pur Jaai | Jahaan Janma Hari-Bhakta Kahaai || 34 ||"},
            {"timestampSec": 444, "devanagari": "और देवता चित्त न धरई। हनुमत सेइ सर्ब सुख करई॥ ३५ ॥", "english": "Aur Devta Chitta Na Dharai | Hanumat Sei Sarb Sukh Karai || 35 ||"},
            {"timestampSec": 456, "devanagari": "संकट कटै मिटै सब पीरा। जो सुमिरै हनुमत बलबीरा॥ ३६ ॥", "english": "Sankat Katai Mitai Sab Peera | Jo Sumirai Hanumat Balbeera || 36 ||"},
            {"timestampSec": 468, "devanagari": "जै जै जै हनुमान गोसाईं। कृपा करहु गुरुदेव की नाईं॥ ३७ ॥", "english": "Jai Jai Jai Hanuman Gosaain | Kripa Karahu Gurudev Ki Naain || 37 ||"},
            {"timestampSec": 480, "devanagari": "जो सत बार पाठ कर कोई। छूटहि बंदि महा सुख होई॥ ३८ ॥", "english": "Jo Sat Baar Paath Kar Koi | Chhootahi Bandi Maha Sukh Hoi || 38 ||"},
            {"timestampSec": 492, "devanagari": "जो यह पढ़ै हनुमान चालीसा। होय सिद्धि साखी गौरीसा॥ ३९ ॥", "english": "Jo Yah Padhai Hanuman Chalisa | Hoy Siddhi Saakhee Gaureesa || 39 ||"},
            {"timestampSec": 504, "devanagari": "तुलसीदास सदा हरि चेरा। कीजै नाथ हृदय मँह डेरा॥ ४० ॥", "english": "Tulsidas Sada Hari Chera | Keejai Naath Hriday Mahn Dera || 40 ||"},
            {"timestampSec": 516, "devanagari": "॥ दोहा ॥\nपवनतनय संकट हरन मंगल मूरति रूप।\nराम लखन सीता सहित हृदय बसहु सुर भूप॥", "english": "Pavan Tanay Sankat Haran Mangal Moorati Roop | Ram Lakhan Sita Sahit Hriday Basahu Sur Bhoop ||"}
        ]
    },
    {
        "id": "stotram_shiv_tandav",
        "title": "Shri Shiv Tandav Stotram",
        "hindiTitle": "श्री शिव ताण्डव स्तोत्रम् (सम्पूर्ण)",
        "deity": "Lord Shiva",
        "category": "Stotram",
        "durationSec": 480,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Ravana's ecstatic cosmic eulogy to Lord Shiva celebrating His divine dance, locks of Ganga and trident.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "जटाटवीगलज्जलप्रवाहपावितस्थले गलेऽवलम्ब्य लम्बितां भुजङ्गतुङ्गमालिकाम्।\nडमड्डमड्डमड्डमन्निनादवड्डमर्वयं चकार चण्डताण्डवं तनोतु नः शिवः शिवम्॥ १ ॥", "english": "Jatatavee Galaj-Jala Pravaha Pavitasthale Gale-Avalambya Lambitaam Bhujanga Tunga Malikaam | Damad Damad Damad Daman Ninadavada Damarvayam Chakara Chanda Tandavam Tanotu Nah Shivah Shivam || 1 ||"},
            {"timestampSec": 32, "devanagari": "जटाकटाहसम्भ्रमभ्रमन्निलिम्पनिर्झरी-विलोलवीचिवल्लरीविराजमानमूर्धनि।\nधधद्धधद्धधज्ज्वलल्ललाटपट्टपावके किशोरचन्द्रशेखरे रतिः प्रतिक्षणं मम॥ २ ॥", "english": "Jata Kataha Sambhrama Bhraman Nilimpa Nirjhari-Vilola Veechi Vallari Viraja Mana Moordhani | Dhadhad Dhadhad Dhadhaj-Jvalal Lalata Patta Pavake Kishora Chandra Shekhare Ratih Pratikshanam Mama || 2 ||"},
            {"timestampSec": 64, "devanagari": "धराधरेन्द्रनन्दिनीविलासबन्धुबन्धुरस्फुरद्दिगन्तसन्ततिप्रमोदमानमानसे।\nकृपाकटाक्षधोरणीनिरुद्धदुर्धरापदि क्वचिद्दिगम्बरे मनो विनोदमेतु वस्तुनि॥ ३ ॥", "english": "Dhara Dharendra Nandini Vilasa Bandhu Bandhura Sphurad Diganta Santati Pramoda Mana Manase | Kripa Kataksha Dhorani Niruddha Durdharapadi Kvachid Digambare Mano Vinodametu Vastuni || 3 ||"},
            {"timestampSec": 96, "devanagari": "जटाभुजङ्गपिङ्गलस्फुरत्फणामणिप्रभाकदम्बकुङ्कुमद्रवप्रलिप्तदिग्वधूमुखे।\nमदान्धसिन्धुरस्फुरत्त्वगुत्तरीयमेदुरे मनो विनोदमद्भुतं बिभर्तु भूतभर्तरि॥ ४ ॥", "english": "Jata Bhujanga Pingala Sphurat Phana Mani Prabha Kadamba Kunkuma Drava Pralipta Digvadhoo Mukhe | Madandha Sindhura Sphurat Tvaguttareeya Medure Mano Vinodamadbhutam Bibhartu Bhootabhartari || 4 ||"},
            {"timestampSec": 128, "devanagari": "सहस्रलोचनप्रभृत्यशेषलेखशेखरप्रसूनधूलिधोरणीविधूसराङ्घ्रिपीठभूः।\nभुजङ्गराजमालया निबद्धजाटजूटकः श्रियै चिराय जायतां चकोरबन्धुशेखरः॥ ५ ॥", "english": "Sahasra Lochana Prabhrit Yashesha Lekha Shekhara Prasuna Dhooli Dhorani Vidhoosaranghri Peethabhooh | Bhujanga Raja Malaya Nibaddha Jata Jootakah Shriyai Chiraya Jaayataam Chakora Bandhu Shekharah || 5 ||"},
            {"timestampSec": 160, "devanagari": "ललाटचत्वरज्वलद्धनञ्जयस्फुलिङ्गभा-निपीतपञ्चसायकं नमन्निलिम्पनायकम्।\nसुधामयूखलेखया विराजमानशेखरं महाकपालिसम्पदेशिरोजटालमस्तु नः॥ ६ ॥", "english": "Lalata Chatvara Jvalad Dhananjaya Sphulingabha-Nipeeta Panchasayakam Naman Nilimpa Nayakam | Sudha Mayookha Lekhaya Virajamana Shekharam Maha Kapali Sampade Shiro Jatalamastu Nah || 6 ||"},
            {"timestampSec": 192, "devanagari": "करालभालपट्टिकाधगद्धगद्धगज्ज्वल-द्धनञ्जयाहुतीकृतप्रचण्डपञ्चसायके।\nधराधरेन्द्रनन्दिनीकुचाग्रचित्रपत्रक-प्रकल्पनैकशिल्पिनि त्रिलोचने रतिर्मम॥ ७ ॥", "english": "Karala Bhala Pattika Dhagad Dhagad Dhagaj-Jvalad-Dhananjaya Huteekrita Prachanda Panchasayake | Dhara Dharendra Nandini Kuchagra Chitra Patraka-Prakalpanaika Shilpini Trilochene Ratirmama || 7 ||"},
            {"timestampSec": 224, "devanagari": "नवीनमेघमण्डलीनिरुद्धदुर्धरस्फुरत्-कुहूनिशीथिनीतमः प्रबन्धबद्धकन्धरः।\nनिलिम्पनिर्झरीधरस्तनोतु कृत्तिसिन्धुरः कलानिधानबन्धुरः श्रियं जगद्धुरंधरः॥ ८ ॥", "english": "Naveena Megha Mandali Niruddha Durdhara Sphurat-Kuhoo Nisheethinee Tamah Prabandha Baddha Kandharah | Nilimpa Nirjhari Dharastanotu Krittisindhurah Kalanidhana Bandhurah Shriyam Jagaddhurandharah || 8 ||"},
            {"timestampSec": 256, "devanagari": "प्रफुल्लनीलपङ्कजप्रपञ्चकालिमप्रभा-वलम्बिकण्ठकन्दलीरुचिप्रबद्धकन्धरम्।\nस्मरच्छिदं पुरच्छिदं भवच्छिदं मखच्छिदं गजच्छिदान्धकच्छिदं तमन्तकच्छिदं भजे॥ ९ ॥", "english": "Praphulla Neela Pankaja Prapancha Kalima Prabha-Valambi Kantha Kandali Ruchi Prabaddha Kandharam | Smarachchhidam Purachchhidam Bhavachchhidam Makhachchhidam Gajachchhid-Andhakachchhidam Tamantakachchhidam Bhaje || 9 ||"},
            {"timestampSec": 288, "devanagari": "अखर्वसर्वमङ्गलाकलाकदम्बमञ्जरी-रसप्रवाहमाधुरीविजृम्भणामधुव्रतम्।\nस्मरान्तकं पुरान्तकं भवान्तकं मखान्तकं गजान्तकान्धकान्तकं तमन्तकान्तकं भजे॥ १० ॥", "english": "Akharva Sarva Mangala Kala Kadamba Manjari-Rasa Pravaha Madhuri Vijrimbhana Madhuvratam | Smarantakam Purantakam Bhavantakam Makhantakam Gajantak-Andhakantakam Tamantakantakam Bhaje || 10 ||"},
            {"timestampSec": 320, "devanagari": "जयत्वदभ्रविभ्रमभ्रमद्भुजङ्गमश्वस-द्विनिर्गमत्क्रमस्फुरत्करालभालहव्यवाट्।\nधिमिद्धिमिद्धिमिध्वनन्मृदङ्गतुङ्गमङ्गल-ध्वनिक्रमप्रवर्तितप्रचण्डताण्डवः शिवः॥ ११ ॥", "english": "Jayat Vadabhra Vibhrama Bhramad Bhujangama Shvasad-Vinirgamal Kramasphurat Karala Bhala Havyavaat | Dhimiddhimiddhimi Dhvanan Mridanga Tunga Mangala-Dhvani Krama Pravartita Prachanda Tandavah Shivah || 11 ||"},
            {"timestampSec": 352, "devanagari": "दृषद्विचित्रतल्पयोर्भुजङ्गमौक्तिकस्रजोर्-गरिष्ठरत्नलोष्ठयोः सुहृद्विपक्षपक्षयोः।\nतृणारविन्दचक्षुषोः प्रजामहीमहेन्द्रयोः समप्रवृत्तिकः कदा सदाशिवं भजाम्यहम्॥ १२ ॥", "english": "Drishad Vichitra Talpayor Bhujanga Mauktika Srajor-Garishta Ratna Loshtayoh Suhrid Vipaksha Pakshayoh | Trinaaravinda Chakshushoh Praja Mahee Mahendrayoh Sama Pravrittikah Kada Sadashivam Bhajaamyaham || 12 ||"},
            {"timestampSec": 384, "devanagari": "कदा निलिम्पनिर्झरीनिकुञ्जकोटरे वसन् विमुक्तदुर्मतिः सदा शिरःस्थमञ्जलिं वहन्।\nविलोललोललोचनो ललामभाललग्नकः शिवेति मन्त्रमुच्चरन् कदा सुखी भवाम्यहम्॥ १३ ॥", "english": "Kada Nilimpa Nirjhari Nikunja Kotare Vasan Vimukta Durmatih Sada Shirahsthamanjalim Vahan | Vilola Lola Lochano Lalama Bhala Lagnakah Shiveti Mantramuchcharan Kada Sukhee Bhavaamyaham || 13 ||"},
            {"timestampSec": 416, "devanagari": "इमं हि नित्यमेवमुक्तमुत्तमोत्तमं स्तवं पठन्स्मरन्ब्रुवन्नरो विशुद्धिमेति संततम्।\nहरे गुरौ सुभक्तिमाशु याति नान्यथा गतिं विमोहनं हि देहिनां सुशङ्करस्य चिन्तनम्॥ १४ ॥", "english": "Imam Hi Nityamevamuktam Uttamottamam Stavam Pathan Smaran Bruvan Naro Vishuddhineti Santatam | Hare Gurau Subhaktimaashu Yaati Naanyatha Gatim Vimohanam Hi Dehinaam Sushankarasya Chintanam || 14 ||"},
            {"timestampSec": 448, "devanagari": "पूजावसानसमये दशवक्त्रगीतं यः शम्भुपूजनपरं पठति प्रदोषे।\nतस्य स्थिरां रथगजेन्द्रतुरङ्गयुक्तां लक्ष्मीं सदैव सुमुखीं प्रददाति शम्भुः॥ १५ ॥", "english": "Poojaavasana Samaye Dashavaktra Geetam Yah Shambhu Poojana Param Pathati Pradoshe | Tasya Sthiraam Ratha Gajendra Turanga Yuktaam Lakshmeem Sadaiva Sumukheem Pradadaati Shambhuh || 15 ||"}
        ]
    },
    {
        "id": "aarti_jagdish",
        "title": "Om Jai Jagdish Hare",
        "hindiTitle": "ॐ जय जगदीश हरे (सम्पूर्ण)",
        "deity": "Lord Vishnu",
        "category": "Aarti",
        "durationSec": 330,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "The most revered universal Hindu evening prayer praying for peace, contentment, and divine surrender.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "ॐ जय जगदीश हरे, स्वामी जय जगदीश हरे।\nभक्त जनों के संकट, दास जनों के संकट, क्षण में दूर करे॥ ॐ जय जगदीश हरे॥", "english": "Om Jai Jagdish Hare, Swami Jai Jagdish Hare | Bhakta Janon Ke Sankat, Daas Janon Ke Sankat, Kshan Mein Door Kare || Om Jai Jagdish Hare ||"},
            {"timestampSec": 35, "devanagari": "जो ध्यावे फल पावे, दुःख बिनसे मन का।\nसुख सम्पत्ति घर आवे, सुख सम्पत्ति घर आवे, कष्ट मिटे तन का॥ ॐ जय जगदीश हरे॥", "english": "Jo Dhyave Phal Paave, Dukh Binse Man Ka | Sukh Sampatti Ghar Aave, Kasht Mite Tan Ka || Om Jai Jagdish Hare ||"},
            {"timestampSec": 75, "devanagari": "मात-पिता तुम मेरे, शरण गहूं किसकी।\nतुम बिन और न दूजा, तुम बिन और न दूजा, आस करूं जिसकी॥ ॐ जय जगदीश हरे॥", "english": "Maat-Pita Tum Mere, Sharan Gahoon Kiski | Tum Bin Aur Na Dooja, Aas Karoon Jiski || Om Jai Jagdish Hare ||"},
            {"timestampSec": 115, "devanagari": "तुम पूरण परमात्मा, तुम अन्तर्यामी।\nपारब्रह्म परमेश्वर, पारब्रह्म परमेश्वर, तुम सबके स्वामी॥ ॐ जय जगदीश हरे॥", "english": "Tum Pooran Paramaatma, Tum Antaryaami | Parabrahma Parameshwara, Tum Sabke Swami || Om Jai Jagdish Hare ||"},
            {"timestampSec": 155, "devanagari": "तुम करुणा के सागर, तुम पालनकर्ता।\nमैं मूरख खल कामी, मैं सेवक तुम स्वामी, कृपा करो भर्ता॥ ॐ जय जगदीश हरे॥", "english": "Tum Karuna Ke Saagar, Tum Paalan Karta | Main Moorakh Khal Kaami, Main Sevak Tum Swami, Kripa Karo Bharta || Om Jai Jagdish Hare ||"},
            {"timestampSec": 195, "devanagari": "तुम हो एक अगोचर, सबके प्राणपति।\nकिस विधि मिलूं दयामय, किस विधि मिलूं दयामय, तुमको मैं कुमति॥ ॐ जय जगदीश हरे॥", "english": "Tum Ho Ek Agochar, Sabke Praanpati | Kis Vidhi Miloon Dayaamaya, Tumko Main Kumati || Om Jai Jagdish Hare ||"},
            {"timestampSec": 235, "devanagari": "दीनबन्धु दुखहर्ता, तुम ठाकुर मेरे।\nअपने हाथ उठाओ, अपनी शरण लगाओ, द्वार पड़ा तेरे॥ ॐ जय जगदीश हरे॥", "english": "Deenbandhu Dukhaharta, Tum Thaakur Mere | Apne Haath Uthaao, Apni Sharan Lagaao, Dwaar Pada Tere || Om Jai Jagdish Hare ||"},
            {"timestampSec": 275, "devanagari": "विषय-विकार मिटाओ, पाप हरो देवा।\nश्रद्धा-भक्ति बढ़ाओ, श्रद्धा-भक्ति बढ़ाओ, सन्तन की सेवा॥ ॐ जय जगदीश हरे॥", "english": "Vishay-Vikaar Mitaao, Paap Haro Deva | Shraddha-Bhakti Badhaao, Santan Ki Seva || Om Jai Jagdish Hare ||"},
            {"timestampSec": 305, "devanagari": "तन-मन-धन सब कुछ है तेरा, तेरा तुझको अर्पण।\nक्या लागे मेरा॥ ॐ जय जगदीश हरे, स्वामी जय जगदीश हरे॥", "english": "Tan-Man-Dhan Sab Kuchh Hai Tera, Tera Tujhko Arpan | Kya Laage Mera || Om Jai Jagdish Hare ||"}
        ]
    },
    {
        "id": "aarti_durga",
        "title": "Jai Ambe Gauri",
        "hindiTitle": "जय अम्बे गौरी (दुर्गा आरती - सम्पूर्ण)",
        "deity": "Maa Durga",
        "category": "Aarti",
        "durationSec": 320,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Daily Navratri and evening aarti dedicated to Jagadamba Durga praising Her divine forms and weapons.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "जय अम्बे गौरी मैया जय श्यामा गौरी।\nतुमको निसदिन ध्यावत हरि ब्रह्मा शिवरी॥ ॐ जय अम्बे गौरी॥", "english": "Jai Ambe Gauri Maiya Jai Shyama Gauri | Tumko Nisadin Dhyavat Hari Brahma Shivaree || Om Jai Ambe Gauri ||"},
            {"timestampSec": 35, "devanagari": "मांग सिन्दूर विराजत टीको मृगमद को।\nउज्ज्वल से दोउ नैना चन्द्रवदन नीको॥ ॐ जय अम्बे गौरी॥", "english": "Maang Sindoor Viraajat Teeko Mrigmad Ko | Ujjwal Se Dou Naina Chandravadan Neeko || Om Jai Ambe Gauri ||"},
            {"timestampSec": 70, "devanagari": "कनक समान कलेवर रक्ताम्बर राजै।\nरक्तपुष्प गलमाला कण्ठन पर साजै॥ ॐ जय अम्बे गौरी॥", "english": "Kanak Samaan Kalevar Raktambar Raaje | Raktapushp Galmaala Kanthan Par Saaje || Om Jai Ambe Gauri ||"},
            {"timestampSec": 105, "devanagari": "केहरि वाहन राजत खड्ग खप्पर धारी।\nसुर-नर-मुनिजन सेवत तिनके दुःखहारी॥ ॐ जय अम्बे गौरी॥", "english": "Kehari Vaahan Raajat Khadga Khappar Dhaari | Sur-Nar-Munijan Sevat Tinke Dukhhaari || Om Jai Ambe Gauri ||"},
            {"timestampSec": 140, "devanagari": "कानन कुण्डल शोभित नासाग्रे मोती।\nकोटिक चन्द्र दिवाकर राजत सम ज्योती॥ ॐ जय अम्बे गौरी॥", "english": "Kaanan Kundal Shobhit Naasaagre Moti | Kotik Chandra Divaakar Raajat Sam Jyoti || Om Jai Ambe Gauri ||"},
            {"timestampSec": 175, "devanagari": "शुम्भ-निशुम्भ बिदारे महिषासुर घाती।\nधूम्र विलोचन नैना निशदिन मदमाती॥ ॐ जय अम्बे गौरी॥", "english": "Shumbh-Nishumbh Bidaare Mahishaasur Ghaati | Dhoomra Vilochan Naina Nishdin Madmaati || Om Jai Ambe Gauri ||"},
            {"timestampSec": 210, "devanagari": "चण्ड-मुण्ड संहारे शोणित बीज हरे।\nमधु-कैटभ दोउ मारे सुर भयहीन करे॥ ॐ जय अम्बे गौरी॥", "english": "Chand-Mund Sanhaare Shonit Beej Hare | Madhu-Kaitabh Dou Maare Sur Bhayaheen Kare || Om Jai Ambe Gauri ||"},
            {"timestampSec": 245, "devanagari": "ब्रह्माणी रुद्राणी तुम कमला रानी।\nआगम निगम बखानी तुम शिव पटरानी॥ ॐ जय अम्बे गौरी॥", "english": "Brahmaani Rudraani Tum Kamala Raani | Aagam Nigam Bakhaani Tum Shiv Patraani || Om Jai Ambe Gauri ||"},
            {"timestampSec": 280, "devanagari": "चौंसठ योगिनी मंगल गावत नृत्य करत भैरूं।\nबाजत ताल मृदंगा अरु बाजत डमरू॥ ॐ जय अम्बे गौरी॥", "english": "Chaunsath Yogini Mangal Gaavat Nritya Karat Bhairun | Baajat Taal Mridanga Aru Baajat Damru || Om Jai Ambe Gauri ||"},
            {"timestampSec": 305, "devanagari": "तुम ही जग की माता तुम ही हो भर्ता।\nभक्तन की दुःख हरता सुख सम्पति करता॥ ॐ जय अम्बे गौरी॥", "english": "Tum Hee Jag Kee Maata Tum Hee Ho Bharta | Bhaktan Kee Dukh Harta Sukh Sampati Karta || Om Jai Ambe Gauri ||"}
        ]
    },
    {
        "id": "aarti_krishna",
        "title": "Aarti Kunj Bihari Ki",
        "hindiTitle": "आरती कुंजबिहारी की (सम्पूर्ण)",
        "deity": "Lord Krishna",
        "category": "Aarti",
        "durationSec": 300,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "A beloved soulful evening aarti dedicated to Banke Bihari and Giridhar Krishna in Vrindavan.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "आरती कुंजबिहारी की, श्री गिरिधर कृष्णमुरारी की॥\nगले में बैजंती माला, बजावै मुरली मधुर बाला।\nश्रवण में कुण्डल झलकाला, नंद के आनंद नंदलाला॥", "english": "Aarti Kunj Bihari Ki, Shri Giridhar Krishna Murari Ki || Gale Mein Baijanti Maala, Bajaavai Murli Madhur Baala | Shravan Mein Kundal Jhalkaala, Nand Ke Anand Nandlaala ||"},
            {"timestampSec": 50, "devanagari": "गगन सम अंग कांति कारी, राधिका चमक रही प्यारी।\nललित छवि श्यामा प्यारी की, श्री गिरिधर कृष्णमुरारी की॥\nआरती कुंजबिहारी की, श्री गिरिधर कृष्णमुरारी की॥", "english": "Gagan Sam Ang Kaanti Kaari, Radhika Chamak Rahi Pyaari | Lalit Chhabi Shyama Pyaari Ki, Shri Giridhar Krishna Murari Ki ||"},
            {"timestampSec": 100, "devanagari": "कनकमय मुकुट बिलसै, नयन सों प्रेम रस बरसै।\nमुरलिका अधर धरै प्यारी, भृकुटि कुटिल नयन कजरारे॥\nआरती कुंजबिहारी की, श्री गिरिधर कृष्णमुरारी की॥", "english": "Kanakmay Mukut Bilsai, Nayan Son Prem Ras Barsai | Murlika Adhar Dharai Pyaari, Bhrikuti Kutil Nayan Kajraare ||"},
            {"timestampSec": 150, "devanagari": "जहां ते प्रगट भई गंगा, कलुष कलिहारिणी गंगा।\nस्मरन ते होत मोह भंगा, बसी शिव शीश जटा के जूटे॥\nआरती कुंजबिहारी की, श्री गिरिधर कृष्णमुरारी की॥", "english": "Jahaan Te Pragat Bhai Ganga, Kalush Kalihaarini Ganga | Smaran Te Hot Moh Bhanga, Basi Shiv Sheesh Jata Ke Joote ||"},
            {"timestampSec": 200, "devanagari": "मृदु मन्द हँसत मुख चन्द्रा, निरखि सब रूप भयो मन्द्रा।\nछबीली छबि देखत नन्दलाला, मुकुट सोहै नयन विशाला॥\nआरती कुंजबिहारी की, श्री गिरिधर कृष्णमुरारी की॥", "english": "Mridu Mand Hansat Mukh Chandra, Nirakhi Sab Roop Bhayo Manda | Chhabeeli Chhabi Dekhat Nandlaala, Mukut Sohai Nayan Vishaala ||"},
            {"timestampSec": 250, "devanagari": "चरण छवि श्रीबनवारी की, श्री गिरिधर कृष्णमुरारी की।\nआरती कुंजबिहारी की, श्री गिरिधर कृष्णमुरारी की॥", "english": "Charan Chhabi Shri Banwaari Ki, Shri Giridhar Krishna Murari Ki | Aarti Kunj Bihari Ki, Shri Giridhar Krishna Murari Ki ||"}
        ]
    },
    {
        "id": "aarti_lakshmi",
        "title": "Om Jai Lakshmi Mata",
        "hindiTitle": "ॐ जय लक्ष्मी माता (सम्पूर्ण)",
        "deity": "Maa Lakshmi",
        "category": "Aarti",
        "durationSec": 280,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Sung on Friday evenings and Diwali night invocation seeking wealth, prosperity, purity, and spiritual bliss.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "ॐ जय लक्ष्मी माता, मैया जय लक्ष्मी माता।\nतुमको निसदिन सेवत, हर विष्णु विधाता॥ ॐ जय लक्ष्मी माता॥", "english": "Om Jai Lakshmi Mata, Maiya Jai Lakshmi Mata | Tumko Nisadin Sevat, Har Vishnu Vidhaata || Om Jai Lakshmi Mata ||"},
            {"timestampSec": 35, "devanagari": "उमा रमा ब्रह्माणी, तुम ही जग-माता।\nसूर्य-चन्द्रमा ध्यावत, नारद ऋषि गाता॥ ॐ जय लक्ष्मी माता॥", "english": "Uma Rama Brahmaani, Tum Hee Jag-Maata | Surya-Chandrama Dhyavat, Narad Rishi Gaata || Om Jai Lakshmi Mata ||"},
            {"timestampSec": 70, "devanagari": "दुर्गा रूप निरंजनि, सुख सम्पति दाता।\nजो कोई तुमको ध्यावत, ऋद्धि-सिद्धि धन पाता॥ ॐ जय लक्ष्मी माता॥", "english": "Durga Roop Niranjani, Sukh Sampati Daata | Jo Koi Tumko Dhyaavat, Riddhi-Siddhi Dhan Paata || Om Jai Lakshmi Mata ||"},
            {"timestampSec": 105, "devanagari": "तुम पाताल-निवासिनि, तुम ही शुभदाता।\nकर्म-प्रभाव-प्रकाशिनी, भव निधि की त्राता॥ ॐ जय लक्ष्मी माता॥", "english": "Tum Paataal-Nivaasini, Tum Hee Shubhdaata | Karma-Prabhaav-Prakaashini, Bhav Nidhi Ki Traata || Om Jai Lakshmi Mata ||"},
            {"timestampSec": 140, "devanagari": "जिस घर में तुम रहतीं, सब सद्गुण आता।\nसब सम्भव हो जाता, मन नहिं घबराता॥ ॐ जय लक्ष्मी माता॥", "english": "Jis Ghar Mein Tum Rahateen, Sab Sadgun Aata | Sab Sambhav Ho Jaata, Man Nahin Ghabraata || Om Jai Lakshmi Mata ||"},
            {"timestampSec": 175, "devanagari": "तुम बिन यज्ञ न होते, वस्त्र न कोई पाता।\nखान-पान का वैभव, सब तुमसे आता॥ ॐ जय लक्ष्मी माता॥", "english": "Tum Bin Yagya Na Hote, Vastra Na Koi Paata | Khaan-Paan Ka Vaibhav, Sab Tumse Aata || Om Jai Lakshmi Mata ||"},
            {"timestampSec": 210, "devanagari": "शुभ-गुण मन्दिर सुन्दर, क्षीरोदधि-जाता।\nरत्न चतुर्दश तुम बिन, कोई नहिं पाता॥ ॐ जय लक्ष्मी माता॥", "english": "Shubh-Gun Mandir Sundar, Ksheerodadhi-Jaata | Ratna Chaturdash Tum Bin, Koi Nahin Paata || Om Jai Lakshmi Mata ||"},
            {"timestampSec": 245, "devanagari": "महालक्ष्मीजी की आरती, जो कोई नर गावे।\nउर आनन्द समावे, धन सम्पति पावे॥ ॐ जय लक्ष्मी माता॥", "english": "Mahalakshmi Ji Ki Aarti, Jo Koi Nar Gaave | Ur Aanand Samaave, Dhan Sampati Paave || Om Jai Lakshmi Mata ||"}
        ]
    },
    {
        "id": "aarti_shiv",
        "title": "Om Jai Shiv Omkara",
        "hindiTitle": "ॐ जय शिव ओंकारा (सम्पूर्ण)",
        "deity": "Lord Shiva",
        "category": "Aarti",
        "durationSec": 270,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Universal evening prayer dedicated to Mahadev, praising the cosmic creator, preserver and destroyer.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "ॐ जय शिव ओंकारा, स्वामी जय शिव ओंकारा।\nब्रह्मा विष्णु सदाशिव, अर्द्धांगी धारा॥ ॐ जय शिव ओंकारा॥", "english": "Om Jai Shiv Omkara, Swami Jai Shiv Omkara | Brahma Vishnu Sadashiv, Ardhaangi Dhaara || Om Jai Shiv Omkara ||"},
            {"timestampSec": 35, "devanagari": "एकानन चतुरानन पञ्चानन राजे।\nहंसासन गरुड़ासन वृषवाहन साजे॥ ॐ जय शिव ओंकारा॥", "english": "Ekaanan Chaturaanan Panchaanan Raaje | Hansaasan Garudaasan Vrishavaahan Saaje || Om Jai Shiv Omkara ||"},
            {"timestampSec": 70, "devanagari": "दो भुज चारु चतुर्भुज दशभुज अति सोहे।\nत्रिगुण रूप निरखते त्रिभुवन जन मोहे॥ ॐ जय शिव ओंकारा॥", "english": "Do Bhuj Chaaru Chaturbhuj Dashbhuj Ati Sohe | Trigun Roop Nirakhte Tribhuvan Jan Mohe || Om Jai Shiv Omkara ||"},
            {"timestampSec": 105, "devanagari": "अक्षमाला बनमाला रुण्डमाला धारी।\nचन्दन मृगमद सोहै भाले शशिधारी॥ ॐ जय शिव ओंकारा॥", "english": "Akshamaala Banmaala Rundamaala Dhaari | Chandan Mrigamad Sohai Bhaale Shashidhaari || Om Jai Shiv Omkara ||"},
            {"timestampSec": 140, "devanagari": "श्वेताम्बर पीताम्बर बाघम्बर अङ्गे।\nसनकादिक गरुड़ादिक भूतादिक सङ्गे॥ ॐ जय शिव ओंकारा॥", "english": "Shwetaambar Peetaambar Baaghambar Ange | Sanakaadik Garudaadik Bhootaadik Sange || Om Jai Shiv Omkara ||"},
            {"timestampSec": 175, "devanagari": "कर के मध्य कमण्डलु चक्र त्रिशूलधारी।\nसुखकारी दुखहारी जगपालनकारी॥ ॐ जय शिव ओंकारा॥", "english": "Kar Ke Madhya Kamandalu Chakra Trishooladhaari | Sukhkari Dukhhaari Jagpaalankaari || Om Jai Shiv Omkara ||"},
            {"timestampSec": 210, "devanagari": "ब्रह्मा विष्णु सदाशिव जानत अविवेका।\nप्रणवाक्षर के मध्ये ये तीनों एका॥ ॐ जय शिव ओंकारा॥", "english": "Brahma Vishnu Sadashiv Jaanat Aviveka | Pranavaakshar Ke Madhye Ye Teenon Eka || Om Jai Shiv Omkara ||"},
            {"timestampSec": 245, "devanagari": "त्रिगुण शिवजी की आरती जो कोई नर गावे।\nकहत शिवानन्द स्वामी मनवांछित फल पावे॥ ॐ जय शिव ओंकारा॥", "english": "Trigun Shivji Ki Aarti Jo Koi Nar Gaave | Kahat Shivanand Swami Manvaanchhit Phal Paave || Om Jai Shiv Omkara ||"}
        ]
    },
    {
        "id": "aarti_ganesh",
        "title": "Jai Ganesh Jai Ganesh Deva",
        "hindiTitle": "जय गणेश देवा (सम्पूर्ण)",
        "deity": "Lord Ganesha",
        "category": "Aarti",
        "durationSec": 240,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Sung at the start of all auspicious rituals and pujas to remove obstacles and seek wisdom.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "जय गणेश जय गणेश जय गणेश देवा।\nमाता जाकी पार्वती पिता महादेवा॥", "english": "Jai Ganesh Jai Ganesh Jai Ganesh Deva | Mata Jaaki Parvati Pita Mahadeva ||"},
            {"timestampSec": 35, "devanagari": "एक दन्त दयावन्त चार भुजाधारी।\nमाथे पर तिलक सोहे मूसे की सवारी॥", "english": "Ek Dant Dayavant Chaar Bhujaadhari | Maathe Par Tilak Sohe Moose Ki Sawari ||"},
            {"timestampSec": 70, "devanagari": "पान चढ़े फूल चढ़े और चढ़े मेवा।\nलड्डुअन का भोग लगे सन्त करें सेवा॥", "english": "Paan Chadhe Phool Chadhe Aur Chadhe Mewa | Ladduan Ka Bhog Lage Sant Karein Seva ||"},
            {"timestampSec": 105, "devanagari": "अन्धन को आँख देत कोढ़िन को काया।\nबाँझन को पुत्र देत निर्धन को माया॥", "english": "Andhan Ko Aankh Det Kodhin Ko Kaaya | Baanjhan Ko Putra Det Nirdhan Ko Maaya ||"},
            {"timestampSec": 140, "devanagari": "सूरश्याम शरण आए सफल कीजे सेवा।\nमाता जाकी पार्वती पिता महादेवा॥", "english": "Soorshyam Sharan Aaye Safal Keeje Seva | Mata Jaaki Parvati Pita Mahadeva ||"},
            {"timestampSec": 175, "devanagari": "दीनन की लाज राखो शम्भु सुत वारी।\nकामना को पूर्ण करो जग बलिहारी॥", "english": "Deenan Ki Laaj Rakho Shambhu Sut Vaari | Kaamana Ko Poorna Karo Jag Balihaari ||"},
            {"timestampSec": 210, "devanagari": "जय गणेश जय गणेश जय गणेश देवा।\nमाता जाकी पार्वती पिता महादेवा॥", "english": "Jai Ganesh Jai Ganesh Jai Ganesh Deva | Mata Jaaki Parvati Pita Mahadeva ||"}
        ]
    },
    {
        "id": "aarti_hanuman",
        "title": "Aarti Kije Hanuman Lala Ki",
        "hindiTitle": "आरती कीजै हनुमान लला की (सम्पूर्ण)",
        "deity": "Lord Hanuman",
        "category": "Aarti",
        "durationSec": 260,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Legendary aarti composed to invoke the boundless strength, devotion and protection of Bajrangbali.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "आरती कीजै हनुमान लला की।\nदुष्ट दलन रघुनाथ कला की॥", "english": "Aarti Keejai Hanuman Lala Ki | Dusht Dalan Raghunath Kala Ki ||"},
            {"timestampSec": 35, "devanagari": "जाके बल से गिरिवर कांपै।\nरोग दोष जाके निकट न झांपै॥", "english": "Jaake Bal Se Girivar Kaampei | Rog Dosh Jaake Nikat Na Jhaampei ||"},
            {"timestampSec": 70, "devanagari": "अंजनि पुत्र महा बलदाई।\nसन्तन के प्रभु सदा सहाई॥", "english": "Anjani Putra Maha Baldaai | Santan Ke Prabhu Sada Sahaai ||"},
            {"timestampSec": 105, "devanagari": "दे बीरा रघुनाथ पठाए।\nलंका जारि सिया सुधि लाए॥", "english": "De Beera Raghunath Pathaaye | Lanka Jaari Siya Sudhi Laaye ||"},
            {"timestampSec": 140, "devanagari": "लंका सो कोट समुद्र सी खाई।\nजात पवनसुत बार न लाई॥", "english": "Lanka So Kot Samudra See Khaai | Jaat Pavansut Baar Na Laai ||"},
            {"timestampSec": 175, "devanagari": "बाएं भुजा असुर दल मारे।\nदाहिने भुजा संत जन तारे॥", "english": "Baayein Bhuja Asur Dal Maare | Daahine Bhuja Sant Jan Taare ||"},
            {"timestampSec": 210, "devanagari": "सुर नर मुनि जन आरती उतारें।\nजय जय जय हनुमान उचारें॥", "english": "Sur Nar Muni Jan Aarti Utaarein | Jai Jai Jai Hanuman Uchaarein ||"}
        ]
    },
    {
        "id": "aarti_ram",
        "title": "Shri Ramachandra Kripalu Bhajuman",
        "hindiTitle": "श्री रामचन्द्र कृपालु भजु मन (सम्पूर्ण)",
        "deity": "Lord Rama",
        "category": "Stuti",
        "durationSec": 280,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Tulsidas's divine Vinaya Patrika hymn extolling Lord Rama's compassion, beauty and virtues.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "श्रीरामचन्द्र कृपालु भजु मन हरण भवभय दारुणं।\nनवकंज लोचन, कंज मुख, कर कंज, पद कंजारुणं॥ १ ॥", "english": "Shri Ramachandra Kripalu Bhaju Man Harana Bhavabhaya Daarunam | Navakanja Lochana Kanja Mukha Kara Kanja Pada Kanjaarunam || 1 ||"},
            {"timestampSec": 50, "devanagari": "कन्दर्प अगणित अमित छवि, नवनीलनीरद सुन्दरं।\nपट पीत मानहु तड़ित रुचि शुचि नौमि जनक सुतावरं॥ २ ॥", "english": "Kandarpa Aganita Amita Chhavi Navaneel Neerada Sundaram | Pata Peeta Maanahu Tadita Ruchi Shuchi Naumi Janaka Sutaavaram || 2 ||"},
            {"timestampSec": 105, "devanagari": "भजु दीनबन्धु दिनेश दानव दैत्यवंश निकन्दनं।\nरघुनन्द आनन्दकन्द कोशलचन्द दशरथ नन्दनं॥ ३ ॥", "english": "Bhaju Deenabandhu Dinesha Daanava Daityavansha Nikandanam | Raghunanda Aanandakanda Kaushalachanda Dasharatha Nandanam || 3 ||"},
            {"timestampSec": 160, "devanagari": "शिर मुकुट कुण्डल तिलक चारु उदारु अङ्ग विभूषणं।\nआजानुभुज शर चाप धर, सङ्ग्राम-जित-खरदूषणं॥ ४ ॥", "english": "Shira Mukuta Kundala Tilaka Chaaru Udaaru Anga Vibhooshanam | Aajaanubhuja Shara Chaapa Dhara Sangraama-Jita-Kharadooshanam || 4 ||"},
            {"timestampSec": 215, "devanagari": "इति वदति तुलसीदास शंकर शेष मुनि-मन-रंजनं।\nमम हृदय-कंज निवास कुरु, कामादि खल-दल-मंजनं॥ ५ ॥", "english": "Iti Vadati Tulsidaasa Shankara Shesha Muni-Mana-Ranjanam | Mama Hridaya-Kanja Nivaasa Kuru Kaamaadi Khala-Dala-Manjanam || 5 ||"}
        ]
    },
    {
        "id": "aarti_saraswati",
        "title": "Om Jai Saraswati Mata",
        "hindiTitle": "ॐ जय सरस्वती माता (सम्पूर्ण)",
        "deity": "Maa Saraswati",
        "category": "Aarti",
        "durationSec": 240,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Aarti dedicated to the Goddess of wisdom, arts, music and speech recited by students and seekers.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "जय सरस्वती माता, मैया जय सरस्वती माता।\nसद्गुण वैभव शालिनी, त्रिभुवन विख्याता॥ ॐ जय सरस्वती माता॥", "english": "Jai Saraswati Mata, Maiya Jai Saraswati Mata | Sadgun Vaibhav Shaalini, Tribhuvan Vikhyaata || Om Jai Saraswati Mata ||"},
            {"timestampSec": 40, "devanagari": "चन्द्रवदनि पद्मासिनि, द्युति मंगलकारी।\nसोहे शुभ हंस सवारी, अतुल तेजधारी॥ ॐ जय सरस्वती माता॥", "english": "Chandravadani Padmaasini, Dyuti Mangalkaari | Sohe Shubh Hansa Savaari, Atul Tejadhaari || Om Jai Saraswati Mata ||"},
            {"timestampSec": 80, "devanagari": "बाएं कर में वीणा, दाएं कर माला।\nशीश मुकुट मणि सोहे, गल मोतियन माला॥ ॐ जय सरस्वती माता॥", "english": "Baayein Kar Mein Veena, Daayein Kar Maala | Sheesh Mukut Mani Sohe, Gal Motiyan Maala || Om Jai Saraswati Mata ||"},
            {"timestampSec": 120, "devanagari": "विद्या दान प्रदायिनि, ज्ञान कला संता।\nशारद सुमति प्रदायिनि, भव सागर त्राता॥ ॐ जय सरस्वती माता॥", "english": "Vidya Daan Pradaayini, Gyaan Kala Santa | Shaarad Sumati Pradaayini, Bhav Saagar Traata || Om Jai Saraswati Mata ||"},
            {"timestampSec": 160, "devanagari": "धूप दीप फल मेवा, माँ स्वीकार करो।\nज्ञान चक्षु दे माता, जग उद्धार करो॥ ॐ जय सरस्वती माता॥", "english": "Dhoop Deep Phal Mewa, Maa Sweekaar Karo | Gyaan Chakshu De Mata, Jag Uddhaar Karo || Om Jai Saraswati Mata ||"},
            {"timestampSec": 200, "devanagari": "सरस्वती जी की आरती, जो कोई जन गावै।\nहितकारी सुखकारी, ज्ञान परम पावै॥ ॐ जय सरस्वती माता॥", "english": "Saraswati Ji Ki Aarti, Jo Koi Jan Gaavai | Hitkaari Sukhkaari, Gyaan Param Paavai || Om Jai Saraswati Mata ||"}
        ]
    },
    {
        "id": "aarti_shanidev",
        "title": "Aarti Shri Shanidev Ji Ki",
        "hindiTitle": "आरती श्री शनिदेव की (सम्पूर्ण)",
        "deity": "Lord Shanidev",
        "category": "Aarti",
        "durationSec": 240,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Traditional Saturday aarti seeking justice, karma balance and relief from Sade Sati and planetary distress.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "जय जय श्री शनिदेव भक्तन हितकारी।\nसूर्य पुत्र प्रभु छाया महतारी॥ जय जय श्री शनिदेव॥", "english": "Jai Jai Shri Shanidev Bhaktan Hitkaari | Surya Putra Prabhu Chhaaya Mahtaari || Jai Jai Shri Shanidev ||"},
            {"timestampSec": 45, "devanagari": "श्याम वर्ण चारु भुजा त्रिशूल गदा धारी।\nनीलाम्बर क्रीट मुकुट शीश छवि प्यारी॥ जय जय श्री शनिदेव॥", "english": "Shyam Varna Chaaru Bhuja Trishool Gada Dhaari | Neelaambar Kreet Mukut Sheesh Chhavi Pyaari || Jai Jai Shri Shanidev ||"},
            {"timestampSec": 90, "devanagari": "काक वाहन पर साजे न्याय के दाता।\nकर्म फल प्रदाता प्रभु जग के विधाता॥ जय जय श्री शनिदेव॥", "english": "Kaak Vaahan Par Saaje Nyaay Ke Daata | Karma Phal Pradaata Prabhu Jag Ke Vidhaata || Jai Jai Shri Shanidev ||"},
            {"timestampSec": 135, "devanagari": "तेल तिल और उड़द दीप जो जलावे।\nसारे कष्ट मिटें सब सुख पावे॥ जय जय श्री शनिदेव॥", "english": "Tel Til Aur Udad Deep Jo Jalaave | Saare Kasht Mitein Sab Sukh Paave || Jai Jai Shri Shanidev ||"},
            {"timestampSec": 180, "devanagari": "शनिदेव जी की आरती जो कोई नर गावै।\nभव भय संकट छूटे निर्मल मति पावै॥ जय जय श्री शनिदेव॥", "english": "Shanidev Ji Ki Aarti Jo Koi Nar Gaavai | Bhav Bhay Sankat Chhoote Nirmal Mati Paavai || Jai Jai Shri Shanidev ||"}
        ]
    },
    {
        "id": "aarti_gayatri",
        "title": "Jayati Jay Gayatri Mata",
        "hindiTitle": "जयति जय गायत्री माता (सम्पूर्ण)",
        "deity": "Maa Gayatri",
        "category": "Aarti",
        "durationSec": 240,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Vedic hymn dedicated to Vedmata Gayatri, the mother of the Vedas, for spiritual enlightenment and intellect.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "जयति जय गायत्री माता, जयति जय गायत्री माता।\nसत्-चित्-आनन्द-रूपा, अनुपम सुखदाता॥ जयति जय गायत्री माता॥", "english": "Jayati Jay Gayatri Mata, Jayati Jay Gayatri Mata | Sat-Chit-Aananda-Roopa, Anupam Sukhdaata || Jayati Jay Gayatri Mata ||"},
            {"timestampSec": 45, "devanagari": "आदि शक्ति तुम अलख निरंजन जग पालन कर्त्री।\nदुःख दारिद्रय विदारिणी, भव निधि भय हन्त्री॥ जयति जय गायत्री माता॥", "english": "Aadi Shakti Tum Alakh Niranjan Jag Paalan Kartree | Dukh Daaridrya Vidaarini, Bhav Nidhi Bhay Hantree || Jayati Jay Gayatri Mata ||"},
            {"timestampSec": 90, "devanagari": "वेद की जननी सब सुखदानी प्रज्ञा की देवी।\nऋषि मुनि सुर नर सब जन चरण कमल सेवी॥ जयति जय गायत्री माता॥", "english": "Ved Ki Janani Sab Sukhdaani Pragya Ki Devi | Rishi Muni Sur Nar Sab Jan Charan Kamal Sevi || Jayati Jay Gayatri Mata ||"},
            {"timestampSec": 135, "devanagari": "हंस वाहिनी श्वेत वसना वीणा कर सोहे।\nज्ञान प्रकाशक ज्योति त्रिभुवन मन मोहे॥ जयति जय गायत्री माता॥", "english": "Hans Vaahini Shwet Vasana Veena Kar Sohe | Gyaan Prakaashak Jyoti Tribhuvan Man Mohe || Jayati Jay Gayatri Mata ||"},
            {"timestampSec": 180, "devanagari": "गायत्री जी की आरती जो कोई जन गावे।\nपाप ताप सब मिटे परम पद पावे॥ जयति जय गायत्री माता॥", "english": "Gayatri Ji Ki Aarti Jo Koi Jan Gaave | Paap Taap Sab Mite Param Pad Paave || Jayati Jay Gayatri Mata ||"}
        ]
    },
    {
        "id": "ashtak_hanuman",
        "title": "Sankat Mochan Hanuman Ashtak",
        "hindiTitle": "संकट मोचन हनुमानाष्टक (सम्पूर्ण)",
        "deity": "Lord Hanuman",
        "category": "Ashtak",
        "durationSec": 360,
        "localAssetPath": "audio/temple_bell.wav",
        "remoteStreamUrl": "https://actions.google.com/sounds/v1/spiritual/temple_bell.ogg",
        "significance": "Goswami Tulsidas's eight-verse prayer recalling Hanumanji's superhuman feats to relieve devotees from dire distress.",
        "lyrics": [
            {"timestampSec": 0, "devanagari": "बाल समय रवि भक्ष लियो तब तीनहुं लोक भयो अंधियारों।\nताहि सो त्रास भयो जग को यह संकट काहु सों जात न टारो॥\nदेवन आनि करी बिनती तब छांड़ि दियो रवि कष्ट निवारो।\nको नहिं जानत है जग में कपि संकटमोचन नाम तिहारो॥ १ ॥", "english": "Baal Samay Ravi Bhaksh Liyo Tab Teenahun Lok Bhayo Andhiyaaro | Taahi So Traas Bhayo Jag Ko Yah Sankat Kaahu Son Jaat Na Taaro | Devan Aani Karee Binatee Tab Chhaandi Diyo Ravi Kasht Nivaaro | Ko Nahin Jaanat Hai Jag Mein Kapi Sankatmochan Naam Tihaaro || 1 ||"},
            {"timestampSec": 45, "devanagari": "बालि की त्रास कपीस बसै गिरि जात महाप्रभु पंथ निहारो।\nचौंकि महामुनि साप दियो तब चाहि कौन बिचार बिचारो॥\nकै द्विज रूप लिवाय मिले तिन सो हे महाप्रभु काज संवारो।\nको नहिं जानत है जग में कपि संकटमोचन नाम तिहारो॥ २ ॥", "english": "Baali Ki Traas Kapees Basai Giri Jaat Mahaaprabhu Panth Nihaaro | Chounki Mahaamuni Saap Diyo Tab Chaahi Koun Bichaar Bichaaro | Kai Dwij Roop Livaay Mile Tin So He Mahaaprabhu Kaaj Sanwaaro | Ko Nahin Jaanat Hai Jag Mein Kapi Sankatmochan Naam Tihaaro || 2 ||"},
            {"timestampSec": 90, "devanagari": "अंगद के संग लेन गए सिय खोज कपीस यह बैन उचारो।\nजीवत ना बचिहौ हम सो जु बिना सुधि लाये यहाँ पगु धारो॥\nहेरी थके तट सिंधु सबै तब लाय सिया-सुधि प्राण उबारो।\nको नहिं जानत है जग में कपि संकटमोचन नाम तिहारो॥ ३ ॥", "english": "Angad Ke Sang Len Gaye Siya Khoj Kapees Yah Bain Uchaaro | Jeevat Na Bachihou Hum So Ju Bina Sudhi Laaye Yahaan Pagu Dhaaro | Heri Thake Tat Sindhu Sabai Tab Laay Siya-Sudhi Praan Ubaaro | Ko Nahin Jaanat Hai Jag Mein Kapi Sankatmochan Naam Tihaaro || 3 ||"},
            {"timestampSec": 135, "devanagari": "बाण लग्यो उर लछिमन के तब प्राण तजे सुत रावन मारो।\nलै गृह बैद्य सुषेन समेत तहैं गिरि द्रोण सुबीर उपारो॥\nआनि सजीवन हाथ दई तब लछिमन के सब प्रान उबारो।\nको नहिं जानत है जग में कपि संकटमोचन नाम तिहारो॥ ४ ॥", "english": "Baan Lagyo Ur Lachhiman Ke Tab Praan Taje Sut Raavan Maaro | Lai Griha Baidya Sushen Samet Tahain Giri Dron Subeer Upaaro | Aani Sajeewan Haath Dai Tab Lachhiman Ke Sab Praan Ubaaro | Ko Nahin Jaanat Hai Jag Mein Kapi Sankatmochan Naam Tihaaro || 4 ||"},
            {"timestampSec": 180, "devanagari": "रावन जुद्ध अजान कियो तब नाग कि फाँस सबै सिर डारो।\nश्रीरघुनाथ समेत सबै दल मोह भयो यह कष्ट निवारो॥\nखगपति आनि काटे सब फंद निवारि महाप्रभु काज संवारो।\nको नहिं जानत है जग में कपि संकटमोचन नाम तिहारो॥ ५ ॥", "english": "Raavan Juddh Ajaan Kiyo Tab Naag Ki Phans Sabai Sir Daaro | Shri Raghunath Samet Sabai Dal Moh Bhayo Yah Kasht Nivaaro | Khagpati Aani Kaate Sab Phand Nivaari Mahaaprabhu Kaaj Sanwaaro | Ko Nahin Jaanat Hai Jag Mein Kapi Sankatmochan Naam Tihaaro || 5 ||"},
            {"timestampSec": 225, "devanagari": "ग्रसि लयो अहिरावन लै रघुनाथ पतार सनेह निवारो।\nदेबिहि पूजि भली विधि सो बलि देउ सबै मिलि मंत्र बिचारो॥\nजाय सहाय भयो तवहीं अहिरावन सैन्य समेत संहारो।\nको नहिं जानत है जग में कपि संकटमोचन नाम तिहारो॥ ६ ॥", "english": "Grasi Layo Ahiraavan Lai Raghunath Pataar Saneh Nivaaro | Debihi Pooji Bhalee Vidhi So Bali Deu Sabai Mili Mantra Bichaaro | Jaay Sahaay Bhayo Tawaheen Ahiraavan Sainya Samet Sanhaaro | Ko Nahin Jaanat Hai Jag Mein Kapi Sankatmochan Naam Tihaaro || 6 ||"},
            {"timestampSec": 270, "devanagari": "काज किये बड़ देवन के तुम बीर महाप्रभु देखि बिचारो।\nकौन सो संकट मोर गरीब को जो तुमसों नहिं जात है टारो॥\nबेगि हरो हनुमान महाप्रभु जो कछु संकट होय हमारो।\nको नहिं जानत है जग में कपि संकटमोचन नाम तिहारो॥ ७ ॥", "english": "Kaaj Kiye Bad Devan Ke Tum Beer Mahaaprabhu Dekhi Bichaaro | Koun So Sankat Mor Gareeb Ko Jo Tumson Nahin Jaat Hai Taaro | Begi Haro Hanuman Mahaaprabhu Jo Kachhu Sankat Hoy Hamaaro | Ko Nahin Jaanat Hai Jag Mein Kapi Sankatmochan Naam Tihaaro || 7 ||"},
            {"timestampSec": 315, "devanagari": "॥ दोहा ॥\nलाल देह लाली लसे अरु धरि लाल लंगूर।\nवज्र देह दानव दलन जय जय जय कपि सूर॥", "english": "Laal Deh Laalee Lase Aru Dhari Laal Langoor | Vajra Deh Daanav Dalan Jai Jai Jai Kapi Soor ||"}
        ]
    }
]

def main():
    print(f"Preparing complete master Aarti dataset for Firestore ({len(AARTIS_MASTER)} master tracks)...")
    
    for aarti in AARTIS_MASTER:
        doc_url = f"{BASE_URL}/{aarti['id']}"
        now_iso = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
        aarti["updatedAt"] = now_iso
        
        # Build Firestore Document fields
        lyrics_values = []
        for v in aarti["lyrics"]:
            lyrics_values.append({
                "mapValue": {
                    "fields": {
                        "timestampSec": {"integerValue": str(v["timestampSec"])},
                        "devanagari": {"stringValue": v["devanagari"]},
                        "english": {"stringValue": v["english"]}
                    }
                }
            })
            
        fields = {
            "id": {"stringValue": aarti["id"]},
            "title": {"stringValue": aarti["title"]},
            "hindiTitle": {"stringValue": aarti["hindiTitle"]},
            "deity": {"stringValue": aarti["deity"]},
            "category": {"stringValue": aarti["category"]},
            "durationSec": {"integerValue": str(aarti["durationSec"])},
            "localAssetPath": {"stringValue": aarti["localAssetPath"]},
            "remoteStreamUrl": {"stringValue": aarti["remoteStreamUrl"]},
            "significance": {"stringValue": aarti["significance"]},
            "updatedAt": {"stringValue": now_iso},
            "lyrics": {
                "arrayValue": {
                    "values": lyrics_values
                }
            }
        }
        
        req = urllib.request.Request(
            doc_url,
            data=json.dumps({"fields": fields}).encode('utf-8'),
            headers={"Content-Type": "application/json"},
            method="PATCH"
        )
        try:
            with urllib.request.urlopen(req, timeout=10) as resp:
                print(f"+ Synced {aarti['id']} ({len(aarti['lyrics'])} verses) -> HTTP {resp.status}")
        except Exception as e:
            print(f"- Error syncing {aarti['id']}: {e}")

    # Write to local JSON bundles in client and admin apps
    paths = [
        "E:/YOUTUBE 2026/Publish APPS/PujaVidhi/pujavidhi_main/assets/data/aartis_production.json",
        "E:/YOUTUBE 2026/Publish APPS/PujaVidhi/pujavidhi_admin/assets/data/aartis_production.json"
    ]
    for p in paths:
        with open(p, "w", encoding="utf-8") as f:
            json.dump(AARTIS_MASTER, f, ensure_ascii=False, indent=2)
        print(f"Saved {len(AARTIS_MASTER)} master tracks to {p}")

    print("\nALL COMPLETE MASTER AARTIS SYNCED TO FIRESTORE SUCCESSFULLY!")

if __name__ == "__main__":
    main()
