# 🪔 PujaVidhi - Sanatan Vedic Rituals, Panchang & Devotion Suite

> **Universal Source of Truth for PujaVidhi Spiritual App Suite**  
> Built strictly adhering to the Master Production Guidelines.  
> **Signature Attribution**: *Made with ❤️ by Apoorv* (Embedded across Settings screen)

---

## 1. Project Directory Architecture

```text
E:\YOUTUBE 2026\Publish APPS\PujaVidhi\
├── pujavidhi_main\                         <-- Client App (Play Store & App Store)
│   ├── android\                             # Package: com.apoorv.pujavidhi
│   ├── ios\                                 # Bundle ID: com.apoorv.pujavidhi
│   ├── lib\                                 # Saffron/Gold Devotional UI, Panchang, Japa, Audio Engine
│   │   ├── core\                            # Themes, Constants, AdMob Manager, Sound FX
│   │   ├── models\                          # Vidhi, Aarti, Panchang, Japa, Monetization
│   │   ├── services\                        # Audio player, Razorpay, AdMob, Local Storage
│   │   ├── providers\                       # AppState, PrimeEntitlement, JapaState, PanchangState
│   │   └── screens\                         # Home, Panchang, VidhiDetail, AudioPlayer, JapaMala, CardMaker, Settings
│   ├── publish\                             # All publishing-related assets & build outputs
│   │   ├── icons\                           # 512x512 Play Store icon, iOS 1024x1024 app icon
│   │   ├── graphics\                        # 1024x500 Feature graphic, promo banners
│   │   ├── screenshots\                     # Phone & Tablet store preview screenshots
│   │   ├── store_listing\                   # Title, short description, full description, privacy policy doc
│   │   └── builds\                          # Output APKs (.apk) and App Bundles (.aab)
│   ├── firestore.rules                      # Production-locked client security rules
│   └── pubspec.yaml
│
├── pujavidhi_admin\                        <-- Admin App (Operator & Control Dashboard)
│   ├── android\                             # Package: com.apoorv.pujavidhi.admin
│   ├── ios\                                 # Bundle ID: com.apoorv.pujavidhi.admin
│   ├── web\                                 # Web/Desktop Admin Console
│   ├── lib\                                 # Festival CMS, Media Uploader, Notification Broadcaster, Monetization Controls
│   └── pubspec.yaml
│
└── README.md                                # High-level architecture & synchronization protocol
```

---

## 2. Decoupled Core Applications

### A. Main Client App (`pujavidhi_main`)
- **Package Identifier**: `com.apoorv.pujavidhi`
- **Daily Panchang & Shubh Muhurat**: Accurate Rahu Kaal, Choghadiya, Tithi, Sunrise & Sunset calculations.
- **Puja Vidhi & Rituals**: Step-by-step guides with sankalp, mantra recitation, samagri checklists, and regional pujas (Chhath, Pongal, Durga Puja, Diwali, Satyanarayan, Shiva Abhishek).
- **Aarti & Chalisa Player**: High-definition audio, synchronized dual-script lyrics (Hindi/English), virtual temple bell and shankh sound effects, loop & offline playback.
- **108-Bead Digital Japa Mala**: Interactive circular mala counter with realistic haptic vibration, bead audio click, round history, and statistics.
- **Customizable Devotional Image Cards**: Create custom festival greetings & suvichar with family name (*"From: Sharma Family"*), deity frames, and direct WhatsApp / Instagram export.
- **Monetization Engine**:
  - AdMob (Banner on Panchang/Aarti, Interstitial after Japa round / puja chapter, Rewarded for watermark removal & offline downloads).
  - Razorpay Lifetime "Bhakt Prime Pass" (₹99 - ₹149) for 100% ad-free experience, unlimited downloads, and cloud sync.

### B. Admin Dashboard App (`pujavidhi_admin`)
- **Package Identifier**: `com.apoorv.pujavidhi.admin`
- **Festival & Ritual CMS**: Add new dates, regional rituals, and checklist items dynamically.
- **Audio & Media Manager**: Upload and manage high-definition audio aartis and wallpapers.
- **Daily 6:00 AM Notification Broadcaster**: Compose and schedule auspicious morning alerts.
- **Monetization & Remote Config**: Instant AdMob kill-switch, frequency slider, and Bhakt Prime Pass pricing adjustments.

---

## 3. Universal Attribution Requirement
- Embedded in **Settings** screen:
  > **`v1.0.0 • Made with ❤️ by Apoorv`**

---

## 4. Production Checklist Status
- [x] 1. Unique App Identity & Package Naming (`com.apoorv.pujavidhi` & `com.apoorv.pujavidhi.admin`)
- [x] 2. Production-hardened Firestore Security Rules (`firestore.rules`)
- [x] 3. Standard `publish/` Directory Layout
- [ ] 4. High-Res Store Assets & App Icons in `publish/`
- [ ] 5. Client App Devotional UI & Audio Engine Implementation
- [ ] 6. Admin Control Dashboard Implementation
- [ ] 7. AdMob & Razorpay Monetization Wiring
- [ ] 8. Production Release Builds (.apk & .aab) in `publish/builds/`
