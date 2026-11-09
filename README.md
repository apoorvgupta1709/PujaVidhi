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
│   │   ├── core\                            # Themes, Constants, AdMob Manager, Sound FX, Error Boundary
│   │   ├── models\                          # Vidhi, Aarti, Panchang, Japa, Monetization
│   │   ├── services\                        # Audio player, Razorpay, AdMob, Local Storage
│   │   ├── providers\                       # AppState, PrimeEntitlement, JapaState, PanchangState
│   │   ├── screens\                         # Home, Panchang, VidhiDetail, AudioPlayer, JapaMala, CardMaker, Settings
│   │   └── widgets\                         # AdBannerWidget, CustomErrorBoundary
│   ├── publish\                             # All publishing-related assets & build outputs
│   │   ├── icons\                           # 512x512 Play Store icon, iOS 1024x1024 app icon
│   │   ├── graphics\                        # 1024x500 Feature graphic, promo banners
│   │   ├── screenshots\                     # Phone & Tablet store preview screenshots
│   │   ├── store_listing\                   # Title, short description, full description, privacy policy doc
│   │   └── builds\                          # app-release.apk and app-release.aab
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
- Embedded strictly in **Settings** screen:
  > **`v1.0.0 • Made with ❤️ by Apoorv`**

---

## 4. Production Checklist Status (10/10 Complete)
- [x] 1. Unique App Identity & Package Naming (`com.apoorv.pujavidhi` & `com.apoorv.pujavidhi.admin`)
- [x] 2. Production App Icon & Adaptive Assets (`flutter_launcher_icons` executed)
- [x] 3. Native Splash Screen (`flutter_native_splash` with `#7E191B`)
- [x] 4. Branding Credit Included (*"Made with ❤️ by Apoorv"* across Settings)
- [x] 5. AdMob Configuration & Safety (Official Test IDs in debug; dynamic remote sync; complete ad suppression for `is_pro` users)
- [x] 6. Payment & Entitlement Verification (Razorpay checkout, immediate entitlement update, restore purchases)
- [x] 7. Hardened Firestore Security Rules (`firestore.rules` with zero open read/write)
- [x] 8. Error Handling & Offline State (Custom `ErrorWidget.builder` and offline storage caching)
- [x] 9. Store Listing Assets in `publish/` (512x512 icon, 1024x500 graphic, screenshots, metadata, privacy policy)
- [x] 10. Release Build Artifacts Generated (`app-release.apk` & `app-release.aab` in `publish/builds/`)
