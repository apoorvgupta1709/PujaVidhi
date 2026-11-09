import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/admin_theme.dart';
import '../models/admin_models.dart';
import '../services/admin_provider.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final adminProv = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.temple_hindu_rounded, color: AdminTheme.accentGold),
            const SizedBox(width: 10),
            Text(
              "PujaVidhi Operator Control Console",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AdminTheme.accentGold.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AdminTheme.accentGold.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.cloud_done, size: 16, color: Colors.greenAccent),
                const SizedBox(width: 6),
                Text(
                  "Firebase Connected",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          // Navigation Rail / Sidebar
          NavigationRail(
            selectedIndex: _selectedNavIndex,
            onDestinationSelected: (idx) => setState(() => _selectedNavIndex = idx),
            backgroundColor: AdminTheme.sidebarColor,
            selectedIconTheme: const IconThemeData(color: AdminTheme.accentGold),
            unselectedIconTheme: const IconThemeData(color: Colors.white54),
            selectedLabelTextStyle: GoogleFonts.poppins(color: AdminTheme.accentGold, fontWeight: FontWeight.bold, fontSize: 12),
            unselectedLabelTextStyle: GoogleFonts.poppins(color: Colors.white54, fontSize: 11),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.auto_stories_outlined),
                selectedIcon: Icon(Icons.auto_stories),
                label: Text("Rituals CMS"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.cloud_upload_outlined),
                selectedIcon: Icon(Icons.cloud_upload),
                label: Text("Media Uploader"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.notifications_active_outlined),
                selectedIcon: Icon(Icons.notifications_active),
                label: Text("Broadcaster"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.monetization_on_outlined),
                selectedIcon: Icon(Icons.monetization_on),
                label: Text("Monetization"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text("Settings"),
              ),
            ],
          ),

          const VerticalDivider(thickness: 1, width: 1),

          // Main Screen Area
          Expanded(
            child: _buildSelectedTab(adminProv),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedTab(AdminProvider adminProv) {
    switch (_selectedNavIndex) {
      case 0:
        return _buildRitualsCms(adminProv);
      case 1:
        return _buildMediaUploader(adminProv);
      case 2:
        return _buildNotificationBroadcaster(adminProv);
      case 3:
        return _buildMonetizationDashboard(adminProv);
      case 4:
      default:
        return _buildAdminSettings();
    }
  }

  // 1. Festival & Ritual CMS
  Widget _buildRitualsCms(AdminProvider prov) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Festival & Ritual CMS", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text("Manage Vedic rituals, regional puja guides, and samagri checklists", style: GoogleFonts.poppins(fontSize: 13, color: AdminTheme.textMuted)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddVidhiDialog(prov),
                style: ElevatedButton.styleFrom(backgroundColor: AdminTheme.primaryMaroon),
                icon: const Icon(Icons.add, color: AdminTheme.accentGold),
                label: Text("Add New Vidhi", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: prov.vidhis.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final v = prov.vidhis[i];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AdminTheme.primaryMaroon,
                    child: Icon(Icons.temple_hindu, color: AdminTheme.accentGold, size: 20),
                  ),
                  title: Text(v.title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)),
                  subtitle: Text("${v.regionalTag} • ${v.deity} • ${v.estimatedMinutes} mins\nSamagri: ${v.samagriItems.join(', ')}", style: GoogleFonts.poppins(fontSize: 12)),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit_outlined, color: Colors.blue), onPressed: () {}),
                      IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () {}),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 2. Audio & Media Uploader
  Widget _buildMediaUploader(AdminProvider prov) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Audio & Media Uploader", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text("Upload HD audio aartis, chalisas, and 4K wallpapers to Firebase Storage", style: GoogleFonts.poppins(fontSize: 13, color: AdminTheme.textMuted)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showUploadDialog(prov),
                style: ElevatedButton.styleFrom(backgroundColor: AdminTheme.primaryMaroon),
                icon: const Icon(Icons.file_upload_outlined, color: AdminTheme.accentGold),
                label: Text("Upload Media Track", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: prov.mediaList.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final m = prov.mediaList[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AdminTheme.accentGold.withValues(alpha: 0.2),
                    child: Icon(
                      m.mediaType.contains("Audio") ? Icons.audiotrack : Icons.image,
                      color: AdminTheme.primaryMaroon,
                    ),
                  ),
                  title: Text(m.title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text("${m.category} • ${m.mediaType} • ${m.sizeMB} MB\n${m.fileUrl}", style: GoogleFonts.poppins(fontSize: 12)),
                  isThreeLine: true,
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      m.status,
                      style: GoogleFonts.poppins(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 3. Daily Morning Notification Broadcaster
  Widget _buildNotificationBroadcaster(AdminProvider prov) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Morning Push Notification Broadcaster", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text("Schedule daily 6:00 AM push alerts with Shubh Muhurat and morning Suvichar", style: GoogleFonts.poppins(fontSize: 13, color: AdminTheme.textMuted)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showBroadcastDialog(prov),
                style: ElevatedButton.styleFrom(backgroundColor: AdminTheme.primaryMaroon),
                icon: const Icon(Icons.send_rounded, color: AdminTheme.accentGold),
                label: Text("Schedule Broadcast", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...prov.broadcasts.map((b) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.alarm_on, color: AdminTheme.accentGold, size: 28),
              title: Text(b.title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)),
              subtitle: Text("${b.message}\nTiming: ${b.scheduledTime} • Info: ${b.muhuratDetail}", style: GoogleFonts.poppins(fontSize: 12)),
              isThreeLine: true,
              trailing: Switch(
                value: b.isScheduled,
                activeThumbColor: AdminTheme.accentGold,
                onChanged: (val) {
                  setState(() => b.isScheduled = val);
                },
              ),
            ),
          )),
        ],
      ),
    );
  }

  // 4. Monetization & Paywall Dashboard
  Widget _buildMonetizationDashboard(AdminProvider prov) {
    final mon = prov.monetization;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Monetization & Paywall Controls", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
          Text("Live remote control over AdMob units, interstitial intervals, and Razorpay pricing", style: GoogleFonts.poppins(fontSize: 13, color: AdminTheme.textMuted)),
          const SizedBox(height: 20),

          // AdMob Master Kill-Switch
          Card(
            child: SwitchListTile(
              secondary: Icon(Icons.shield_outlined, color: mon.adsEnabled ? Colors.green : Colors.red, size: 30),
              title: Text("AdMob Master Traffic Switch", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)),
              subtitle: Text(
                mon.adsEnabled ? "AdMob is ACTIVE across client apps" : "PAUSED: All ads suppressed app-wide immediately",
                style: GoogleFonts.poppins(fontSize: 12),
              ),
              value: mon.adsEnabled,
              activeThumbColor: Colors.green,
              onChanged: (val) => prov.toggleAds(val),
            ),
          ),

          const SizedBox(height: 16),

          // Interstitial Ad Frequency Slider
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Interstitial Ad Frequency Interval", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text("Display interstitial ad after every N completed Japa rounds or Puja chapters (Current: ${mon.adFrequencyInterval})", style: GoogleFonts.poppins(fontSize: 12, color: AdminTheme.textMuted)),
                  Slider(
                    value: mon.adFrequencyInterval.toDouble(),
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: "${mon.adFrequencyInterval} events",
                    activeColor: AdminTheme.primaryMaroon,
                    onChanged: (val) => prov.setAdFrequency(val.toInt()),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Dynamic Bhakt Prime Pass Pricing
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Bhakt Prime Pass Dynamic Pricing (Razorpay)", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text("Instantly toggle between base price and festive promotional price without app store updates", style: GoogleFonts.poppins(fontSize: 12, color: AdminTheme.textMuted)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text("₹99 (33% Festive Discount)"),
                        selected: mon.passPriceINR == 99,
                        selectedColor: AdminTheme.accentGold.withValues(alpha: 0.3),
                        onSelected: (_) => prov.setPrimePassPrice(99),
                      ),
                      const SizedBox(width: 12),
                      ChoiceChip(
                        label: const Text("₹149 (Standard Regular Price)"),
                        selected: mon.passPriceINR == 149,
                        selectedColor: AdminTheme.accentGold.withValues(alpha: 0.3),
                        onSelected: (_) => prov.setPrimePassPrice(149),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 5. Admin Settings
  Widget _buildAdminSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Admin Settings & About", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.admin_panel_settings, color: AdminTheme.primaryMaroon),
              title: Text("Operator Identity", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              subtitle: const Text("apoorv_admin_master_uid • Full CMS Write Access"),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AdminTheme.accentGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AdminTheme.accentGold.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    "v1.0.0 • Made with ❤️ by Apoorv",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AdminTheme.primaryMaroon,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "PujaVidhi Operator Control Dashboard",
                  style: GoogleFonts.poppins(fontSize: 11, color: AdminTheme.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddVidhiDialog(AdminProvider prov) {
    final titleCtrl = TextEditingController();
    final deityCtrl = TextEditingController();
    final regionCtrl = TextEditingController(text: "Regional Special");

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add New Festival / Vidhi"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Festival / Vidhi Name")),
            TextField(controller: deityCtrl, decoration: const InputDecoration(labelText: "Primary Deity")),
            TextField(controller: regionCtrl, decoration: const InputDecoration(labelText: "Regional Tag (e.g. Chhath, Pongal)")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isNotEmpty) {
                prov.addVidhi(FestivalVidhiEntry(
                  id: "vidhi_${DateTime.now().millisecondsSinceEpoch}",
                  title: titleCtrl.text,
                  deity: deityCtrl.text,
                  festivalDate: "Upcoming Tithi",
                  regionalTag: regionCtrl.text,
                  estimatedMinutes: 30,
                  samagriItems: ["Gangajal", "Diya", "Roli", "Akshat"],
                ));
              }
              Navigator.of(ctx).pop();
            },
            child: const Text("Save Vidhi"),
          ),
        ],
      ),
    );
  }

  void _showUploadDialog(AdminProvider prov) {
    final nameCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Upload Audio / Wallpaper"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Track / Wallpaper Title")),
            const SizedBox(height: 10),
            const Text("File upload will store to Firebase Storage bucket gs://pujavidhi-storage/"),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                prov.addMedia(MediaUploadItem(
                  id: "media_${DateTime.now().millisecondsSinceEpoch}",
                  title: nameCtrl.text,
                  category: "Aarti",
                  mediaType: "Audio (MP3)",
                  fileUrl: "gs://pujavidhi-storage/aartis/new_track.mp3",
                  sizeMB: 5.5,
                  status: "Uploaded",
                ));
              }
              Navigator.of(ctx).pop();
            },
            child: const Text("Upload"),
          ),
        ],
      ),
    );
  }

  void _showBroadcastDialog(AdminProvider prov) {
    final titleCtrl = TextEditingController(text: "🌅 Shubh Prabhat! Aaj Ka Shubh Muhurat");
    final msgCtrl = TextEditingController(text: "Abhijit Muhurat: 11:45 AM - 12:35 PM. May your day be blessed.");

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Schedule Morning Broadcast"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Notification Title")),
            TextField(controller: msgCtrl, decoration: const InputDecoration(labelText: "Message Body")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              prov.addBroadcast(NotificationBroadcast(
                id: "notif_${DateTime.now().millisecondsSinceEpoch}",
                title: titleCtrl.text,
                message: msgCtrl.text,
                scheduledTime: "06:00 AM Daily",
                muhuratDetail: "Scheduled via FCM",
                isScheduled: true,
              ));
              Navigator.of(ctx).pop();
            },
            child: const Text("Schedule 6:00 AM"),
          ),
        ],
      ),
    );
  }
}
