import json
import os
import sys
import urllib.request
import time

try:
    sys.stdout.reconfigure(encoding='utf-8')
except Exception:
    pass

PROJECT_ID = 'pujavidhi-app-2026'
COMMIT_URL = f'https://firestore.googleapis.com/v1/projects/{PROJECT_ID}/databases/(default)/documents:commit'

WALLPAPERS = [
    {
        "id": "wp_mahadev_kailash",
        "title": "Mahadev Shiva Kailash",
        "deity": "Lord Shiva",
        "imageUrl": "https://images.unsplash.com/photo-1545063914-a1a6ec821c88?auto=format&fit=crop&w=1400&q=85",
        "thumbnail": "https://images.unsplash.com/photo-1545063914-a1a6ec821c88?auto=format&fit=crop&w=400&q=80",
        "mantraSanskrit": "कर्पूरगौरं करुणावतारं संसारसारम् भुजगेन्द्रहारम्। सदावसन्तं हृदयारविन्दे भवं भवानीसहितं नमामि॥",
        "quoteEnglish": "Om Namah Shivaya. May Lord Shiva bestow ultimate peace, wisdom, and inner strength.",
        "gradientColors": ["#0F172A", "#1E293B", "#38BDF8"],
        "iconBadge": "🔱",
        "isFeatured": True,
        "is4k": True,
        "downloadsCount": 1840,
        "category": "Shiva"
    },
    {
        "id": "wp_ram_ayodhya",
        "title": "Shri Ram Ayodhya Dham",
        "deity": "Shri Ram",
        "imageUrl": "https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?auto=format&fit=crop&w=1400&q=85",
        "thumbnail": "https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?auto=format&fit=crop&w=400&q=80",
        "mantraSanskrit": "रामो राजमणिः सदा विजयते रामं रमेशं भजे। रामेणाभिहता निशाचरचमू रामाय तस्मै नमः॥",
        "quoteEnglish": "Jai Shri Ram. Maryada Purushottam Bhagwan Ram radiates righteousness and supreme courage.",
        "gradientColors": ["#78350F", "#B45309", "#F59E0B"],
        "iconBadge": "🏹",
        "isFeatured": True,
        "is4k": True,
        "downloadsCount": 2450,
        "category": "Ram"
    },
    {
        "id": "wp_krishna_vrindavan",
        "title": "Yogeshwar Shri Krishna",
        "deity": "Shri Krishna",
        "imageUrl": "https://images.unsplash.com/photo-1606293926075-69a00dbfde81?auto=format&fit=crop&w=1400&q=85",
        "thumbnail": "https://images.unsplash.com/photo-1606293926075-69a00dbfde81?auto=format&fit=crop&w=400&q=80",
        "mantraSanskrit": "कस्तूरीतिलकं ललाटपटले वक्षःस्थले कौस्तुभं नासाग्रे वरमौक्तिकं करतले वेणुं करे कङ्कणम्॥",
        "quoteEnglish": "Radhe Krishna. In every note of His divine flute lies eternal bliss and boundless compassion.",
        "gradientColors": ["#1E1B4B", "#312E81", "#6366F1"],
        "iconBadge": "🪶",
        "isFeatured": True,
        "is4k": True,
        "downloadsCount": 2190,
        "category": "Krishna"
    },
    {
        "id": "wp_ganesha_siddhivinayak",
        "title": "Siddhivinayak Ganpati Bappa",
        "deity": "Bhagwan Ganesha",
        "imageUrl": "https://images.unsplash.com/photo-1620766182966-c6eb5ed2b788?auto=format&fit=crop&w=1400&q=85",
        "thumbnail": "https://images.unsplash.com/photo-1620766182966-c6eb5ed2b788?auto=format&fit=crop&w=400&q=80",
        "mantraSanskrit": "वक्रतुण्ड महाकाय सूर्यकोटि समप्रभ। निर्विघ्नं कुरु मे देव सर्वकार्येषु सर्वदा॥",
        "quoteEnglish": "Ganpati Bappa Morya. May Vighnaharta Ganesha remove all obstacles and bless with prosperity.",
        "gradientColors": ["#831843", "#9D174D", "#F43F5E"],
        "iconBadge": "🐘",
        "isFeatured": True,
        "is4k": True,
        "downloadsCount": 3120,
        "category": "Ganesha"
    },
    {
        "id": "wp_hanuman_sankatmochan",
        "title": "Sankat Mochan Mahabali Hanuman",
        "deity": "Hanuman Ji",
        "imageUrl": "https://images.unsplash.com/photo-1610484826967-09c5720778c7?auto=format&fit=crop&w=1400&q=85",
        "thumbnail": "https://images.unsplash.com/photo-1610484826967-09c5720778c7?auto=format&fit=crop&w=400&q=80",
        "mantraSanskrit": "अतुलितबलधामं हेमशैलाभदेहं दनुजवनकृशानुं ज्ञानिनामग्रगण्यम्। सकलगुणनिधानं वानराणामधीशम्॥",
        "quoteEnglish": "Jai Bajrangbali. The supreme epitome of devotion, valor, fearlessness and selfless service.",
        "gradientColors": ["#9A3412", "#C2410C", "#EA580C"],
        "iconBadge": "🚩",
        "isFeatured": True,
        "is4k": True,
        "downloadsCount": 2840,
        "category": "Hanuman"
    },
    {
        "id": "wp_kashi_vishwanath",
        "title": "Kashi Vishwanath Maha Aarti",
        "deity": "Lord Shiva",
        "imageUrl": "https://images.unsplash.com/photo-1567157577867-05ccb1388e66?auto=format&fit=crop&w=1400&q=85",
        "thumbnail": "https://images.unsplash.com/photo-1567157577867-05ccb1388e66?auto=format&fit=crop&w=400&q=80",
        "mantraSanskrit": "वाराणसी पुरपतेर्विशालनेत्रं, नमामि विश्वनाथं शशिशेखरं च॥",
        "quoteEnglish": "Har Har Mahadev. In the eternal ancient holy city of Varanasi, Lord Shiva bestows Moksha.",
        "gradientColors": ["#312E81", "#4338CA", "#6366F1"],
        "iconBadge": "🪔",
        "isFeatured": True,
        "is4k": True,
        "downloadsCount": 1780,
        "category": "Shiva"
    },
    {
        "id": "wp_tirupati_balaji",
        "title": "Tirumala Venkateswara Balaji",
        "deity": "Tirupati Balaji",
        "imageUrl": "https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=1400&q=85",
        "thumbnail": "https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=400&q=80",
        "mantraSanskrit": "वेङ्कटाद्रिसमं स्थानं ब्रह्माण्डे नास्ति किञ्चन। वेङ्कटेशसमो देवो न भूतो न भविष्यति॥",
        "quoteEnglish": "Govinda Hari Govinda. May the Supreme Lord of the Seven Hills grant eternal blessings.",
        "gradientColors": ["#581C87", "#7E22CE", "#A855F7"],
        "iconBadge": "🪷",
        "isFeatured": True,
        "is4k": True,
        "downloadsCount": 1950,
        "category": "Vishnu"
    },
    {
        "id": "wp_maa_durga_shakti",
        "title": "Maa Durga Bhavani Shakti",
        "deity": "Maa Durga",
        "imageUrl": "https://images.unsplash.com/photo-1582510003544-4d00b7f74220?auto=format&fit=crop&w=1400&q=85",
        "thumbnail": "https://images.unsplash.com/photo-1582510003544-4d00b7f74220?auto=format&fit=crop&w=400&q=80",
        "mantraSanskrit": "सर्वमङ्गलमाङ्गल्ये शिवे सर्वार्थसाधिके। शरण्ये त्र्यम्बके गौरि नारायणि नमोऽस्तु ते॥",
        "quoteEnglish": "Jai Mata Di. The supreme divine feminine energy that protects the universe from darkness.",
        "gradientColors": ["#881337", "#9F1239", "#BE123C"],
        "iconBadge": "🌺",
        "isFeatured": True,
        "is4k": True,
        "downloadsCount": 2640,
        "category": "Devi"
    },
    {
        "id": "wp_maa_lakshmi_diwali",
        "title": "Maa Mahalakshmi Dhan Vaibhav",
        "deity": "Maa Lakshmi",
        "imageUrl": "https://images.unsplash.com/photo-1605371924599-2d0365da1ae0?auto=format&fit=crop&w=1400&q=85",
        "thumbnail": "https://images.unsplash.com/photo-1605371924599-2d0365da1ae0?auto=format&fit=crop&w=400&q=80",
        "mantraSanskrit": "ॐ श्रीं ह्रीं श्रीं कमले कमलालये प्रसीद प्रसीद श्रीं ह्रीं श्रीं ॐ महालक्ष्म्यै नमः॥",
        "quoteEnglish": "Shubh Labh. May Goddess Lakshmi bless your home with unending abundance, purity, and peace.",
        "gradientColors": ["#713F12", "#A16207", "#EAB308"],
        "iconBadge": "🪙",
        "isFeatured": True,
        "is4k": True,
        "downloadsCount": 2310,
        "category": "Devi"
    },
    {
        "id": "wp_golden_temple_darshan",
        "title": "Sacred Golden Sanctum Darshan",
        "deity": "All Deities",
        "imageUrl": "https://images.unsplash.com/photo-1604079628040-94301bb21b91?auto=format&fit=crop&w=1400&q=85",
        "thumbnail": "https://images.unsplash.com/photo-1604079628040-94301bb21b91?auto=format&fit=crop&w=400&q=80",
        "mantraSanskrit": "ॐ द्यौः शान्तिरन्तरिक्षं शान्तिः पृथिवी शान्तिरापः शान्तिरोषधयः शान्तिः॥",
        "quoteEnglish": "Om Shanti. Experience the serene golden reflection of divine spiritual sanctuary.",
        "gradientColors": ["#451A03", "#78350F", "#B45309"],
        "iconBadge": "✨",
        "isFeatured": False,
        "is4k": True,
        "downloadsCount": 1420,
        "category": "General"
    },
    {
        "id": "wp_surya_narayan",
        "title": "Bhagwan Surya Narayan",
        "deity": "Surya Dev",
        "imageUrl": "https://images.unsplash.com/photo-1599839575945-a9e5af0c3fa5?auto=format&fit=crop&w=1400&q=85",
        "thumbnail": "https://images.unsplash.com/photo-1599839575945-a9e5af0c3fa5?auto=format&fit=crop&w=400&q=80",
        "mantraSanskrit": "ॐ आदित्याय विद्महे मार्तण्डाय धीमहि तन्नः सूर्यः प्रचोदयात्॥",
        "quoteEnglish": "Salutations to the Sun God, the supreme source of life, energy, health and illumination.",
        "gradientColors": ["#7C2D12", "#C2410C", "#FB923C"],
        "iconBadge": "☀️",
        "isFeatured": False,
        "is4k": True,
        "downloadsCount": 1150,
        "category": "Surya"
    },
    {
        "id": "wp_vedic_bells_aaradhana",
        "title": "Sacred Mandir Bells Aaradhana",
        "deity": "All Deities",
        "imageUrl": "https://images.unsplash.com/photo-1616423640778-28d1b53229bd?auto=format&fit=crop&w=1400&q=85",
        "thumbnail": "https://images.unsplash.com/photo-1616423640778-28d1b53229bd?auto=format&fit=crop&w=400&q=80",
        "mantraSanskrit": "आगमार्थं तु देवानां गमनार्थं तु रक्षसाम्। कुर्वे घण्टारवं तत्र देवताह्वानलक्षणम्॥",
        "quoteEnglish": "The resonating chime of temple bells awakens positive cosmic vibrations within the soul.",
        "gradientColors": ["#1C1917", "#292524", "#78716C"],
        "iconBadge": "🔔",
        "isFeatured": False,
        "is4k": True,
        "downloadsCount": 1390,
        "category": "General"
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

def commit_batch(writes):
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
    print("=" * 65)
    print("SEEDING 4K HD GOD WALLPAPERS TO FIRESTORE (pujavidhi-app-2026)")
    print("=" * 65)

    writes = []
    for wp in WALLPAPERS:
        doc_path = f"projects/{PROJECT_ID}/databases/(default)/documents/wallpapers/{wp['id']}"
        writes.append({
            "update": {
                "name": doc_path,
                "fields": {k: to_firestore_value(v) for k, v in wp.items()}
            }
        })

    ok = commit_batch(writes)
    print(f"Pushed {len(WALLPAPERS)} wallpapers to Firestore 'wallpapers': {'SUCCESS' if ok else 'FAILED'}")

    # Save to local offline assets
    base_dir = os.path.dirname(os.path.abspath(__file__))
    main_dest = os.path.abspath(os.path.join(base_dir, "..", "pujavidhi_main", "assets", "data", "wallpapers_production.json"))
    admin_dest = os.path.abspath(os.path.join(base_dir, "..", "pujavidhi_admin", "assets", "data", "wallpapers_production.json"))

    for path in [main_dest, admin_dest]:
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, "w", encoding="utf-8") as f:
            json.dump(WALLPAPERS, f, ensure_ascii=False, indent=2)
        print(f"Saved local bundle: {path}")

    print("\nAll 4K God Wallpapers are live in Firestore and cached locally for Studio & Gallery!")

if __name__ == '__main__':
    main()
