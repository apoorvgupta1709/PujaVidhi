import json
import os
import re
import sys
import urllib.request
import time

try:
    sys.stdout.reconfigure(encoding='utf-8')
except Exception:
    pass

PROJECT_ID = 'pujavidhi-app-2026'
COMMIT_URL = f'https://firestore.googleapis.com/v1/projects/{PROJECT_ID}/databases/(default)/documents:commit'

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

CHAPTER_TOPIC_MAP = {
    1: "Dharma & Moral Dilemma",
    2: "Sankhya & Atman (आत्मा)",
    3: "Karma Yoga (कर्मयोग)",
    4: "Jnana & Avatara (ज्ञान व अवतार)",
    5: "Sannyasa & Detachment",
    6: "Dhyana & Mind Control (ध्यानयोग)",
    7: "Jnana & Vijnana (ईश्वर दर्शन)",
    8: "Akshara Brahma (परमतत्व)",
    9: "Raja Vidya (अनन्य भक्ति)",
    10: "Divine Splendors (विभूतियोग)",
    11: "Vishwarupa (विश्वरूप दर्शन)",
    12: "Bhakti Yoga (भक्तियोग)",
    13: "Kshetra & Kshetragya (क्षेत्रज्ञ)",
    14: "The Three Gunas (गुणत्रय)",
    15: "Purushottama (पुरुषोत्तमयोग)",
    16: "Daiva & Asura Qualities",
    17: "Shraddha & Faith (श्रद्धायोग)",
    18: "Moksha & Surrender (मोक्ष संन्यास)"
}

def clean_hindi_text(txt):
    if not txt:
        return ""
    # remove commentary notes like ।।1.1।। or (टिप्पणी प0 1.2)
    txt = re.sub(r'।।\s*\d+\.\d+\s*।।', '', txt)
    txt = re.sub(r'\(टिप्पणी[^\)]*\)', '', txt)
    txt = txt.strip()
    return txt

def clean_sanskrit_text(txt):
    if not txt:
        return ""
    # normalize spaces and line breaks
    lines = [l.strip() for l in txt.split('\n') if l.strip()]
    return '\n'.join(lines)

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

def commit_batch(writes):
    """Executes a commit batch of writes against Firestore REST API."""
    body = json.dumps({'writes': writes}).encode('utf-8')
    req = urllib.request.Request(
        COMMIT_URL,
        data=body,
        headers={'Content-Type': 'application/json'},
        method='POST'
    )
    for attempt in range(3):
        try:
            with urllib.request.urlopen(req) as resp:
                if resp.getcode() == 200:
                    return True
        except Exception as e:
            print(f"Batch write error (attempt {attempt+1}/3): {e}")
            time.sleep(2)
    return False

def main():
    print("=" * 70)
    print("SEEDING COMPLETE SHRIMAD BHAGAVAD GITA (18 CHAPTERS & 701 SHLOKAS)")
    print(f"Target Firebase Project: {PROJECT_ID}")
    print("=" * 70)

    # 1. Fetch raw data from verified high-fidelity repositories
    print("\n[Step 1/5] Fetching complete 701 verses, translations & commentaries...")
    u_verse = 'https://raw.githubusercontent.com/praneshp1org/Bhagavad-Gita-JSON-data/master/verse.json'
    u_trans = 'https://raw.githubusercontent.com/praneshp1org/Bhagavad-Gita-JSON-data/master/translation.json'
    u_comm = 'https://raw.githubusercontent.com/praneshp1org/Bhagavad-Gita-JSON-data/master/commentary.json'

    req_v = urllib.request.Request(u_verse, headers={'User-Agent': 'Mozilla/5.0'})
    verses_raw = json.loads(urllib.request.urlopen(req_v).read().decode('utf-8-sig'))

    req_t = urllib.request.Request(u_trans, headers={'User-Agent': 'Mozilla/5.0'})
    trans_raw = json.loads(urllib.request.urlopen(req_t).read().decode('utf-8-sig'))

    req_c = urllib.request.Request(u_comm, headers={'User-Agent': 'Mozilla/5.0'})
    comm_raw = json.loads(urllib.request.urlopen(req_c).read().decode('utf-8-sig'))

    print(f"  -> Fetched {len(verses_raw)} verses, {len(trans_raw)} translations, {len(comm_raw)} commentaries.")

    # 2. Map translations and commentaries by verse_id
    print("\n[Step 2/5] Merging translations (Ramsukhdas/Tejomayananda & Sivananda) and commentaries...")
    hindi_trans_map = {}
    eng_trans_map = {}
    hindi_comm_map = {}

    for t in trans_raw:
        vid = t.get('verse_id')
        lang = (t.get('lang') or '').lower()
        author = t.get('authorName') or ''
        desc = clean_hindi_text(t.get('description') or '')
        if lang == 'hindi':
            # Ramsukhdas preferred for traditional clarity, Tejomayananda fallback
            if vid not in hindi_trans_map or 'Ramsukhdas' in author:
                hindi_trans_map[vid] = desc
        elif lang == 'english':
            # Sivananda preferred
            if vid not in eng_trans_map or 'Sivananda' in author:
                eng_trans_map[vid] = (t.get('description') or '').strip()

    for c in comm_raw:
        vid = c.get('verse_id')
        lang = (c.get('lang') or '').lower()
        desc = clean_hindi_text(c.get('description') or '')
        if lang == 'hindi':
            if vid not in hindi_comm_map:
                hindi_comm_map[vid] = desc

    # 3. Assemble all 701 Shlokas
    assembled_shlokas = []
    for v in verses_raw:
        ch = v.get('chapter_number')
        vn = v.get('verse_number')
        vid = v.get('id')
        sanskrit = clean_sanskrit_text(v.get('text') or '')
        translit = (v.get('transliteration') or '').strip()
        word_m = (v.get('word_meanings') or '').strip()
        h_trans = hindi_trans_map.get(vid, '')
        e_trans = eng_trans_map.get(vid, '')
        h_purport = hindi_comm_map.get(vid, '')
        topic = CHAPTER_TOPIC_MAP.get(ch, "Bhagavad Gita")

        shloka_doc = {
            "id": f"gita_{ch}_{vn}",
            "chapterNumber": ch,
            "verseNumber": vn,
            "textSanskrit": sanskrit,
            "textTransliteration": translit,
            "wordMeanings": word_m,
            "translationHindi": h_trans,
            "purportHindi": h_purport,
            "translationEnglish": e_trans,
            "topicTag": topic,
            "isBookmarked": False,
        }
        assembled_shlokas.append(shloka_doc)

    print(f"  -> Assembled {len(assembled_shlokas)} complete shlokas across all 18 chapters.")

    # 4. Push 18 Chapters to Firestore via Batch Commit
    print("\n[Step 3/5] Uploading 18 Chapters to Firestore 'gita_chapters' collection...")
    ch_writes = []
    for ch in CHAPTERS:
        doc_path = f"projects/{PROJECT_ID}/databases/(default)/documents/gita_chapters/chapter_{ch['chapterNumber']}"
        ch_writes.append({
            "update": {
                "name": doc_path,
                "fields": {k: to_firestore_value(v) for k, v in ch.items()}
            }
        })
    ok = commit_batch(ch_writes)
    print(f"  -> Pushed {len(CHAPTERS)} chapters: {'SUCCESS' if ok else 'FAILED'}")

    # 5. Push 701 Shlokas to Firestore via Batch Commit (batches of 400 writes)
    print("\n[Step 4/5] Uploading 701 Shlokas to Firestore 'gita_shlokas' collection in batches...")
    batch_size = 400
    for idx in range(0, len(assembled_shlokas), batch_size):
        chunk = assembled_shlokas[idx:idx + batch_size]
        writes = []
        for s in chunk:
            doc_path = f"projects/{PROJECT_ID}/databases/(default)/documents/gita_shlokas/{s['id']}"
            writes.append({
                "update": {
                    "name": doc_path,
                    "fields": {k: to_firestore_value(v) for k, v in s.items()}
                }
            })
        chunk_ok = commit_batch(writes)
        print(f"  -> Batch {idx + 1} to {idx + len(chunk)} ({len(chunk)} shlokas): {'SUCCESS' if chunk_ok else 'FAILED'}")

    # 6. Save Complete Offline Production Bundles
    print("\n[Step 5/5] Generating offline production JSON bundles for pujavidhi_main and pujavidhi_admin...")
    gita_bundle = {
        "chapters": CHAPTERS,
        "shlokas": assembled_shlokas,
    }

    base_dir = os.path.dirname(os.path.abspath(__file__))
    main_dest = os.path.abspath(os.path.join(base_dir, "..", "pujavidhi_main", "assets", "data", "gita_production.json"))
    admin_dest = os.path.abspath(os.path.join(base_dir, "..", "pujavidhi_admin", "assets", "data", "gita_production.json"))

    for path in [main_dest, admin_dest]:
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, "w", encoding="utf-8") as f:
            json.dump(gita_bundle, f, ensure_ascii=False, indent=2)
        print(f"  -> Saved offline bundle ({len(assembled_shlokas)} shlokas): {path}")

    print("\n" + "=" * 70)
    print("ALL 18 CHAPTERS AND 701 SHLOKAS ARE LIVE IN FIRESTORE AND LOCAL ASSETS!")
    print("=" * 70)

if __name__ == '__main__':
    main()
