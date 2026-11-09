import 'package:flutter/material.dart';
import '../models/admin_models.dart';

class AdminProvider with ChangeNotifier {
  final List<FestivalVidhiEntry> _vidhis = [
    FestivalVidhiEntry(
      id: "vidhi_chhath",
      title: "Chhath Mahaparva Vidhi",
      deity: "Bhagwan Surya & Chhathi Maiya",
      festivalDate: "Kartik Shukla Shashthi",
      regionalTag: "Bihar & UP (Chhath)",
      estimatedMinutes: 45,
      samagriItems: ["Bamboo Soop", "Daura", "Thekua", "Sugarcane", "Raw Milk", "Diyas"],
    ),
    FestivalVidhiEntry(
      id: "vidhi_pongal",
      title: "Thai Pongal & Surya Pongal",
      deity: "Surya Bhagwan",
      festivalDate: "14 January",
      regionalTag: "Tamil Nadu (Pongal)",
      estimatedMinutes: 35,
      samagriItems: ["Clay Pot with Turmeric", "New Harvest Rice", "Jaggery", "Ghee", "Sugarcane"],
    ),
    FestivalVidhiEntry(
      id: "vidhi_durga",
      title: "Maa Durga Ghatasthapana",
      deity: "Maa Durga",
      festivalDate: "Ashwin Shukla Pratipada",
      regionalTag: "Bengal & Pan-India",
      estimatedMinutes: 50,
      samagriItems: ["Kalash", "Coconut", "Red Cloth", "Hibiscus Flowers", "Sapta Dhanya"],
    ),
  ];

  final List<MediaUploadItem> _mediaList = [
    MediaUploadItem(
      id: "media_1",
      title: "Jai Ganesh Deva (Studio HD)",
      category: "Aarti",
      mediaType: "Audio (MP3)",
      fileUrl: "gs://pujavidhi-storage/aartis/jai_ganesh_deva.mp3",
      sizeMB: 6.4,
      status: "Uploaded",
    ),
    MediaUploadItem(
      id: "media_2",
      title: "Shri Hanuman Chalisa (Sanskrit Vedic)",
      category: "Chalisa",
      mediaType: "Audio (MP3)",
      fileUrl: "gs://pujavidhi-storage/chalisas/hanuman_chalisa.mp3",
      sizeMB: 12.8,
      status: "Uploaded",
    ),
    MediaUploadItem(
      id: "media_3",
      title: "Golden Temple Diya 4K Wallpaper",
      category: "Wallpaper",
      mediaType: "Image (PNG)",
      fileUrl: "gs://pujavidhi-storage/wallpapers/temple_diya_4k.png",
      sizeMB: 3.2,
      status: "Uploaded",
    ),
  ];

  final List<NotificationBroadcast> _broadcasts = [
    NotificationBroadcast(
      id: "notif_1",
      title: "🌅 Shubh Prabhat! Aaj Ka Shubh Muhurat",
      message: "Abhijit Muhurat: 11:43 AM - 12:28 PM. Begin your morning sadhana with Jai Ganesh Aarti.",
      scheduledTime: "06:00 AM Daily",
      muhuratDetail: "Abhijit Muhurat & Shukla Ekadashi",
      isScheduled: true,
    ),
    NotificationBroadcast(
      id: "notif_2",
      title: "🪔 Dev Deepawali Special Notification",
      message: "Devote today to Kartik Purnima Deepdaan. Check the complete step-by-step puja vidhi.",
      scheduledTime: "06:00 AM Festive Alert",
      muhuratDetail: "Pradosh Kaal Muhurat: 05:32 PM",
      isScheduled: true,
    ),
  ];

  final AdminMonetizationConfig _monetization = AdminMonetizationConfig();

  List<FestivalVidhiEntry> get vidhis => _vidhis;
  List<MediaUploadItem> get mediaList => _mediaList;
  List<NotificationBroadcast> get broadcasts => _broadcasts;
  AdminMonetizationConfig get monetization => _monetization;

  void addVidhi(FestivalVidhiEntry entry) {
    _vidhis.add(entry);
    notifyListeners();
  }

  void addMedia(MediaUploadItem item) {
    _mediaList.add(item);
    notifyListeners();
  }

  void addBroadcast(NotificationBroadcast broadcast) {
    _broadcasts.add(broadcast);
    notifyListeners();
  }

  void toggleAds(bool enabled) {
    _monetization.adsEnabled = enabled;
    notifyListeners();
  }

  void setAdFrequency(int interval) {
    _monetization.adFrequencyInterval = interval;
    notifyListeners();
  }

  void setPrimePassPrice(int price) {
    _monetization.passPriceINR = price;
    notifyListeners();
  }

  void setFestiveBanner(String banner) {
    _monetization.festiveBanner = banner;
    notifyListeners();
  }
}
