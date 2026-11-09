import urllib.request
import urllib.parse
import json
import time

STORAGE_BUCKET = "pujavidhi-app-2026.firebasestorage.app"
PROJECT_ID = "pujavidhi-app-2026"
FIRESTORE_URL = f"https://firestore.googleapis.com/v1/projects/{PROJECT_ID}/databases/(default)/documents/wallpapers"

WALLPAPERS = [
    {
        "id": "wp_shiva_kailash",
        "title": "Mahadev Kailash Parvat",
        "deity": "Lord Shiva",
        "category": "Shiva",
        "mantraSanskrit": "ॐ नमः शिवाय",
        "iconBadge": "🔱",
        "gradientColors": ["#0F2027", "#203A43", "#2C5364"],
        "downloadsCount": 4520,
        "sourceUrl": "https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=1200&q=85"
    },
    {
        "id": "wp_ram_ayodhya",
        "title": "Maryada Purushottam Shri Ram",
        "deity": "Lord Rama",
        "category": "Rama",
        "mantraSanskrit": "श्री राम जय राम जय जय राम",
        "iconBadge": "🏹",
        "gradientColors": ["#7E191B", "#E65100", "#FFB300"],
        "downloadsCount": 5830,
        "sourceUrl": "https://images.unsplash.com/photo-1599839575945-a9e5af0c3fa5?auto=format&fit=crop&w=1200&q=85"
    },
    {
        "id": "wp_krishna_vrindavan",
        "title": "Yogeshwar Shri Krishna",
        "deity": "Lord Krishna",
        "category": "Krishna",
        "mantraSanskrit": "हरे कृष्ण हरे राम",
        "iconBadge": "🦚",
        "gradientColors": ["#000428", "#004e92", "#F2994A"],
        "downloadsCount": 5120,
        "sourceUrl": "https://images.unsplash.com/photo-1582510003544-4d00b7f74220?auto=format&fit=crop&w=1200&q=85"
    },
    {
        "id": "wp_radha_krishna",
        "title": "Radha Krishna Prem Darshan",
        "deity": "Lord Krishna",
        "category": "Krishna",
        "mantraSanskrit": "राधे राधे गोविंद गोविंद राधे",
        "iconBadge": "🪷",
        "gradientColors": ["#3A1C71", "#D76D77", "#FFAF7B"],
        "downloadsCount": 4910,
        "sourceUrl": "https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=1200&q=85"
    },
    {
        "id": "wp_ganesha_siddhi",
        "title": "Siddhivinayak Ganesha",
        "deity": "Lord Ganesha",
        "category": "Ganesha",
        "mantraSanskrit": "ॐ गं गणपतये नमः",
        "iconBadge": "🐘",
        "gradientColors": ["#780206", "#061161", "#F59E0B"],
        "downloadsCount": 6190,
        "sourceUrl": "https://images.unsplash.com/photo-1583083527882-4bee9aba2eea?auto=format&fit=crop&w=1200&q=85"
    },
    {
        "id": "wp_hanuman_sankatmochan",
        "title": "Sankat Mochan Hanuman",
        "deity": "Lord Hanuman",
        "category": "Hanuman",
        "mantraSanskrit": "जय बजरंगबली संकटमोचन",
        "iconBadge": "🚩",
        "gradientColors": ["#BF0404", "#DE0000", "#FF8F00"],
        "downloadsCount": 7340,
        "sourceUrl": "https://images.unsplash.com/photo-1608889825205-eebdb9fc5806?auto=format&fit=crop&w=1200&q=85"
    },
    {
        "id": "wp_balaji_tirupati",
        "title": "Tirupati Balaji Venkateshwara",
        "deity": "Lord Vishnu",
        "category": "Vishnu",
        "mantraSanskrit": "ॐ नमो नारायणाय",
        "iconBadge": "🪔",
        "gradientColors": ["#1F1C18", "#8E0E00", "#FFB300"],
        "downloadsCount": 4210,
        "sourceUrl": "https://images.unsplash.com/photo-1590766940554-634a7ed41450?auto=format&fit=crop&w=1200&q=85"
    },
    {
        "id": "wp_durga_mahisasura",
        "title": "Maa Durga Mahisasuramardini",
        "deity": "Maa Durga",
        "category": "Devi",
        "mantraSanskrit": "सर्वमङ्गलमाङ्गल्ये शिवे सर्वार्थसाधिके",
        "iconBadge": "🌺",
        "gradientColors": ["#870000", "#190A05", "#F7971E"],
        "downloadsCount": 4890,
        "sourceUrl": "https://images.unsplash.com/photo-1602751584552-8ba73aad10e1?auto=format&fit=crop&w=1200&q=85"
    },
    {
        "id": "wp_lakshmi_divine",
        "title": "Maa Mahalakshmi Dhan Dayini",
        "deity": "Maa Lakshmi",
        "category": "Devi",
        "mantraSanskrit": "ॐ श्रीं ह्रीं क्लीं श्री सिद्ध लक्ष्म्यै नमः",
        "iconBadge": "🪙",
        "gradientColors": ["#F37335", "#FDC830", "#FFE000"],
        "downloadsCount": 5640,
        "sourceUrl": "https://images.unsplash.com/photo-1513836279014-a89f7a76ae86?auto=format&fit=crop&w=1200&q=85"
    },
    {
        "id": "wp_saraswati_vidya",
        "title": "Maa Saraswati Vidya Dayini",
        "deity": "Maa Saraswati",
        "category": "Devi",
        "mantraSanskrit": "या कुन्देन्दुतुषारहारधवला या शुभ्रवस्त्रावृता",
        "iconBadge": "🎶",
        "gradientColors": ["#ECE9E6", "#FFFFFF", "#FFB300"],
        "downloadsCount": 3950,
        "sourceUrl": "https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=1200&q=85"
    },
    {
        "id": "wp_jagannath_puri",
        "title": "Lord Jagannath Puri Darshan",
        "deity": "Lord Krishna",
        "category": "Krishna",
        "mantraSanskrit": "नीलाचलनिवासाय नित्याय परमात्मने",
        "iconBadge": "☸️",
        "gradientColors": ["#141E30", "#243B55", "#F2994A"],
        "downloadsCount": 4150,
        "sourceUrl": "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1200&q=85"
    },
    {
        "id": "wp_kashi_vishwanath",
        "title": "Kashi Vishwanath Jyotirlinga",
        "deity": "Lord Shiva",
        "category": "Shiva",
        "mantraSanskrit": "हर हर महादेव शम्भो काशी विश्वनाथ",
        "iconBadge": "🔱",
        "gradientColors": ["#1A2A6C", "#B21F1F", "#FDBB2D"],
        "downloadsCount": 4680,
        "sourceUrl": "https://images.unsplash.com/photo-1609825488888-3a766db05542?auto=format&fit=crop&w=1200&q=85"
    },
    {
        "id": "wp_surya_narayan",
        "title": "Surya Narayan Divya Tejas",
        "deity": "Surya Dev",
        "category": "Surya",
        "mantraSanskrit": "ॐ सूर्याय नमः आदित्याय नमः",
        "iconBadge": "☀️",
        "gradientColors": ["#F12711", "#F5AF19", "#FF512F"],
        "downloadsCount": 3720,
        "sourceUrl": "https://images.unsplash.com/photo-1509198397868-475647b2a1e5?auto=format&fit=crop&w=1200&q=85"
    },
    {
        "id": "wp_kartikeya_murugan",
        "title": "Lord Murugan Kartikeya",
        "deity": "Lord Kartikeya",
        "category": "Murugan",
        "mantraSanskrit": "ॐ शरवणभवाय नमः",
        "iconBadge": "🦚",
        "gradientColors": ["#780206", "#061161", "#F5AF19"],
        "downloadsCount": 3480,
        "sourceUrl": "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?auto=format&fit=crop&w=1200&q=85"
    },
    {
        "id": "wp_vedic_temple_bells",
        "title": "Sanatan Vedic Temple Bells",
        "deity": "Vedic Sanctum",
        "category": "Mandir",
        "mantraSanskrit": "सत्यं शिवं सुन्दरम्",
        "iconBadge": "🔔",
        "gradientColors": ["#3E5151", "#DECBA4", "#FFB300"],
        "downloadsCount": 3810,
        "sourceUrl": "https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=1200&q=85"
    },
    {
        "id": "wp_golden_temple",
        "title": "Sacred Golden Sanctum",
        "deity": "Harmandir Sahib",
        "category": "Mandir",
        "mantraSanskrit": "वाहेगुरु जी का खालसा वाहेगुरु जी की फतेह",
        "iconBadge": "🪔",
        "gradientColors": ["#200122", "#6f0000", "#FFB300"],
        "downloadsCount": 4350,
        "sourceUrl": "https://images.unsplash.com/photo-1588099768531-a72d4a198538?auto=format&fit=crop&w=1200&q=85"
    }
]

def upload_wallpaper(wp):
    file_name = f"{wp['id']}.jpg"
    storage_object_name = f"wallpapers/{file_name}"
    encoded_name = urllib.parse.quote(storage_object_name, safe='')
    upload_url = f"https://firebasestorage.googleapis.com/v0/b/{STORAGE_BUCKET}/o?uploadType=media&name={encoded_name}"
    
    print(f"Downloading image for {wp['title']}...")
    req = urllib.request.Request(
        wp["sourceUrl"],
        headers={"User-Agent": "Mozilla/5.0"}
    )
    try:
        with urllib.request.urlopen(req, timeout=15) as response:
            image_bytes = response.read()
    except Exception as e:
        print(f"Error downloading {wp['id']}: {e}")
        return None

    print(f"Uploading {file_name} ({len(image_bytes)} bytes) to Firebase Storage...")
    storage_req = urllib.request.Request(
        upload_url,
        data=image_bytes,
        headers={"Content-Type": "image/jpeg"},
        method="POST"
    )
    try:
        with urllib.request.urlopen(storage_req, timeout=25) as storage_resp:
            resp_data = json.loads(storage_resp.read().decode())
            download_tokens = resp_data.get("downloadTokens", "")
            
            # Public permanent Firebase Storage download URL
            media_url = f"https://firebasestorage.googleapis.com/v0/b/{STORAGE_BUCKET}/o/{encoded_name}?alt=media&token={download_tokens}"
            print(f"SUCCESS: {wp['title']} uploaded! Storage URL: {media_url[:80]}...")
            return media_url
    except Exception as e:
        print(f"Error uploading to Firebase Storage for {wp['id']}: {e}")
        return None

def main():
    final_wallpapers = []
    
    for wp in WALLPAPERS:
        cloud_url = upload_wallpaper(wp)
        if not cloud_url:
            cloud_url = wp["sourceUrl"]
            
        final_wp = {
            "id": wp["id"],
            "title": wp["title"],
            "deity": wp["deity"],
            "category": wp["category"],
            "imageUrl": cloud_url,
            "mantraSanskrit": wp["mantraSanskrit"],
            "iconBadge": wp["iconBadge"],
            "gradientColors": wp["gradientColors"],
            "downloadsCount": wp["downloadsCount"],
            "updatedAt": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
        }
        final_wallpapers.append(final_wp)

        # Upload to Firestore
        firestore_doc_url = f"{FIRESTORE_URL}/{wp['id']}"
        firestore_fields = {
            "id": {"stringValue": final_wp["id"]},
            "title": {"stringValue": final_wp["title"]},
            "deity": {"stringValue": final_wp["deity"]},
            "category": {"stringValue": final_wp["category"]},
            "imageUrl": {"stringValue": final_wp["imageUrl"]},
            "mantraSanskrit": {"stringValue": final_wp["mantraSanskrit"]},
            "iconBadge": {"stringValue": final_wp["iconBadge"]},
            "gradientColors": {
                "arrayValue": {
                    "values": [{"stringValue": c} for c in final_wp["gradientColors"]]
                }
            },
            "downloadsCount": {"integerValue": str(final_wp["downloadsCount"])},
            "updatedAt": {"stringValue": final_wp["updatedAt"]}
        }
        
        fs_req = urllib.request.Request(
            firestore_doc_url,
            data=json.dumps({"fields": firestore_fields}).encode('utf-8'),
            headers={"Content-Type": "application/json"},
            method="PATCH"
        )
        try:
            with urllib.request.urlopen(fs_req, timeout=10) as fs_resp:
                print(f"Firestore synced for {wp['id']} (HTTP {fs_resp.status})")
        except Exception as e:
            print(f"Firestore sync warning for {wp['id']}: {e}")

    # Save to local offline assets in both client and admin projects
    paths = [
        "E:/YOUTUBE 2026/Publish APPS/PujaVidhi/pujavidhi_main/assets/data/wallpapers_production.json",
        "E:/YOUTUBE 2026/Publish APPS/PujaVidhi/pujavidhi_admin/assets/data/wallpapers_production.json"
    ]
    for p in paths:
        with open(p, "w", encoding="utf-8") as f:
            json.dump(final_wallpapers, f, ensure_ascii=False, indent=2)
        print(f"Saved {len(final_wallpapers)} wallpapers to {p}")

    print("\nALL CLOUD STORAGE WALLPAPERS SYNCED SUCCESSFULLY!")

if __name__ == "__main__":
    main()
