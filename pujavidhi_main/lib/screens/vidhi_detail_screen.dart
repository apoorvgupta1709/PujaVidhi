import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../models/vidhi_model.dart';
import '../providers/vidhi_provider.dart';
import '../providers/app_provider.dart';
import '../services/admob_service.dart';
import '../core/sound_service.dart';

class VidhiDetailScreen extends StatelessWidget {
  final PujaVidhi vidhi;

  const VidhiDetailScreen({super.key, required this.vidhi});

  @override
  Widget build(BuildContext context) {
    final vidhiProv = Provider.of<VidhiProvider>(context);
    final appProv = Provider.of<AppProvider>(context);
    final readyCount = vidhi.samagriList.where((s) => s.isChecked).length;
    final totalSamagri = vidhi.samagriList.length;
    final progress = totalSamagri > 0 ? readyCount / totalSamagri : 0.0;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(vidhi.title),
          bottom: TabBar(
            labelColor: AppTheme.divineGold,
            unselectedLabelColor: Colors.white70,
            indicatorColor: AppTheme.divineGold,
            tabs: [
              const Tab(text: "Puja Steps & Mantras"),
              Tab(text: "Samagri ($readyCount/$totalSamagri)"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Steps & Mantras
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sankalp Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.sacredMaroon.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.6)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "पवित्र संकल्प (Sacred Vow)",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.sacredMaroon,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.notifications_active_outlined, color: AppTheme.marigold),
                              tooltip: "Sound Bell",
                              onPressed: () => SoundService.playTempleBell(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          vidhi.sankalpText,
                          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, height: 1.5),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  Text(
                    "Step-by-Step Puja Vidhi",
                    style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  ...vidhi.steps.map((step) => _buildStepCard(context, step)),

                  const SizedBox(height: 24),
                  // Complete Puja Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Interstitial ad trigger after completing a puja chapter
                        AdMobService.showInterstitialIfAllowed(
                          isProUser: appProv.isProUser,
                          onDismissed: () {
                            _showCompletionDialog(context);
                          },
                        );
                      },
                      icon: const Icon(Icons.celebration_rounded, color: AppTheme.divineGold),
                      label: Text(
                        "Complete Puja & Seek Blessings",
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),

            // Tab 2: Samagri Checklist
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: AppTheme.divineGold.withValues(alpha: 0.1),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Samagri Prepared: $readyCount of $totalSamagri",
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            const SizedBox(height: 6),
                            LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey.withValues(alpha: 0.2),
                              color: AppTheme.marigold,
                              minHeight: 6,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: vidhi.samagriList.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final item = vidhi.samagriList[i];
                      return CheckboxListTile(
                        value: item.isChecked,
                        activeColor: AppTheme.sacredMaroon,
                        title: Text(
                          item.name,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            decoration: item.isChecked ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: Text(
                          "${item.category} • ${item.quantity}",
                          style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textMuted),
                        ),
                        onChanged: (_) {
                          vidhiProv.toggleSamagriItem(vidhi, i);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard(BuildContext context, PujaStep step) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppTheme.sacredMaroon,
                  child: Text(
                    "${step.stepNumber}",
                    style: const TextStyle(color: AppTheme.divineGold, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    step.title,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Mantra Sanskrit
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.divineGold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.mantraSanskrit,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.sacredMaroon,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    step.mantraTransliteration,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Meaning: ${step.meaning}",
              style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.touch_app_outlined, size: 16, color: AppTheme.marigold),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    step.actionInstruction,
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.stars_rounded, color: AppTheme.divineGold, size: 28),
            const SizedBox(width: 8),
            Text("Puja Sampanna!", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Text(
          "May the divine blessings of ${vidhi.deity} bring health, prosperity, and peace to your entire family. Har Har Mahadev!",
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: Text("Shanti Shanti Shanti", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppTheme.sacredMaroon)),
          ),
        ],
      ),
    );
  }
}
