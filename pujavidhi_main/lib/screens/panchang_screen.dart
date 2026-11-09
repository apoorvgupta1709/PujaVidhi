import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../core/app_theme.dart';
import '../models/panchang_model.dart';
import '../providers/panchang_provider.dart';
import '../providers/app_provider.dart';
import '../widgets/ad_banner_widget.dart';

class PanchangScreen extends StatelessWidget {
  const PanchangScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final panchangProv = Provider.of<PanchangProvider>(context);
    final appProv = Provider.of<AppProvider>(context);
    final data = panchangProv.panchangData;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Vedic Panchang"),
          actions: [
            IconButton(
              icon: const Icon(Icons.today_outlined),
              tooltip: "Go to Today",
              onPressed: () => panchangProv.goToToday(),
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today_outlined),
              tooltip: "Pick Date",
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: panchangProv.selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  panchangProv.selectDate(picked);
                }
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Date Navigator Header
            Container(
              color: isDark ? AppTheme.templeCardDark : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    onPressed: () => panchangProv.previousDay(),
                  ),
                  Column(
                    children: [
                      Text(
                        DateFormat('EEEE, d MMM yyyy').format(panchangProv.selectedDate),
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${data.paksha} • ${data.tithi}",
                        style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.marigold, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 18),
                    onPressed: () => panchangProv.nextDay(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Tab Bar for Overview and Choghadiya
            TabBar(
              labelColor: AppTheme.sacredMaroon,
              unselectedLabelColor: AppTheme.textMuted,
              indicatorColor: AppTheme.sacredMaroon,
              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: const [
                Tab(text: "Panchang & Muhurat"),
                Tab(text: "Choghadiya Muhurat"),
              ],
            ),

            // Content
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: Panchang & Muhurat
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Shubh Abhijit Muhurat Card (Gold)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.stars_rounded, color: Colors.white, size: 36),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Shubh Abhijit Muhurat",
                                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    Text(
                                      data.abhijitMuhurat,
                                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                                    ),
                                    Text(
                                      "Ideal for all auspicious beginnings & purchases",
                                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Rahu Kaal Alert Card (Dark Vermillion)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC62828).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFC62828).withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded, color: Color(0xFFC62828), size: 28),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Rahu Kaal (Avoid Inauspicious Starts)",
                                      style: GoogleFonts.poppins(color: const Color(0xFFC62828), fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                    Text(
                                      data.rahuKaal,
                                      style: GoogleFonts.poppins(color: const Color(0xFFC62828), fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Detailed Astro Grid
                        Text(
                          "Planetary & Tithi Details",
                          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        _buildInfoRow("Tithi", "${data.tithi} (${data.paksha})"),
                        _buildInfoRow("Nakshatra", data.nakshatra),
                        _buildInfoRow("Yoga", data.yoga),
                        _buildInfoRow("Karana", data.karana),
                        _buildInfoRow("Sunrise", data.sunrise),
                        _buildInfoRow("Sunset", data.sunset),
                        _buildInfoRow("Moonrise", data.moonrise),
                        _buildInfoRow("Yamaganda", data.yamaganda),
                        _buildInfoRow("Gulika Kaal", data.gulikaKaal),
                      ],
                    ),
                  ),

                  // Tab 2: Choghadiya
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Day Choghadiya (सूर्योदय से सूर्यास्त)",
                          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.marigold),
                        ),
                        const SizedBox(height: 8),
                        ...data.dayChoghadiya.map((slot) => _buildChoghadiyaCard(slot)),
                        const SizedBox(height: 18),
                        Text(
                          "Night Choghadiya (सूर्यास्त से सूर्योदय)",
                          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.sacredMaroon),
                        ),
                        const SizedBox(height: 8),
                        ...data.nightChoghadiya.map((slot) => _buildChoghadiyaCard(slot)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom AdMob Banner (Suppressed for Bhakt Prime users)
            if (!appProv.isProUser) const AdBannerWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.textMuted)),
          Text(value, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildChoghadiyaCard(ChoghadiyaSlot slot) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: slot.isAuspicious
            ? Colors.green.withValues(alpha: 0.08)
            : Colors.red.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: slot.isAuspicious
              ? Colors.green.withValues(alpha: 0.3)
              : Colors.red.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                slot.isAuspicious ? Icons.check_circle_outline : Icons.cancel_outlined,
                color: slot.isAuspicious ? Colors.green : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(slot.name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(slot.nature, style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.textMuted)),
                ],
              ),
            ],
          ),
          Text(
            slot.timing,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
