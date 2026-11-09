import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/vidhi_provider.dart';
import 'vidhi_detail_screen.dart';

class VidhiListScreen extends StatelessWidget {
  const VidhiListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vidhiProv = Provider.of<VidhiProvider>(context);
    final categories = ["All", "Chhath", "Pongal", "Navratri", "Shivratri", "Purnima"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Vedic Puja Vidhis"),
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: categories.map((cat) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(cat),
                    selected: false,
                    onSelected: (_) => vidhiProv.filterCategory(cat),
                    selectedColor: AppTheme.divineGold.withValues(alpha: 0.3),
                    checkmarkColor: AppTheme.sacredMaroon,
                  ),
                );
              }).toList(),
            ),
          ),

          // Vidhi List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: vidhiProv.vidhis.length,
              itemBuilder: (context, i) {
                final vidhi = vidhiProv.vidhis[i];
                final readyItems = vidhi.samagriList.where((s) => s.isChecked).length;

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => VidhiDetailScreen(vidhi: vidhi)),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.divineGold.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.6)),
                                ),
                                child: Text(
                                  vidhi.regionalTag,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.marigold,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.timer_outlined, size: 14, color: AppTheme.textMuted),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${vidhi.estimatedMinutes} mins",
                                    style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textMuted),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            vidhi.title,
                            style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            vidhi.significance,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.textMuted),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Samagri: $readyItems/${vidhi.samagriList.length} ready",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: readyItems == vidhi.samagriList.length
                                      ? Colors.green
                                      : AppTheme.marigold,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Begin Vidhi",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.sacredMaroon,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.arrow_forward, size: 14, color: AppTheme.sacredMaroon),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
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
}
