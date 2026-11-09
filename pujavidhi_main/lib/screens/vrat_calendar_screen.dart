import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../core/app_theme.dart';
import '../models/vrat_model.dart';
import '../providers/vrat_provider.dart';

class VratCalendarScreen extends StatelessWidget {
  const VratCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vratProv = Provider.of<VratProvider>(context);
    final vrats = vratProv.vrats;

    final filterOptions = ['All', 'Ekadashi', 'Pradosh', 'Chaturthi', 'Purnima', 'Somwar'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Vrat & Upvas Calendar",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: filterOptions.map((f) {
                final isSelected = vratProv.selectedFilter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(f),
                    selected: isSelected,
                    selectedColor: AppTheme.sacredMaroon.withValues(alpha: 0.2),
                    checkmarkColor: AppTheme.sacredMaroon,
                    labelStyle: GoogleFonts.poppins(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppTheme.sacredMaroon : (isDark ? Colors.white70 : Colors.black87),
                    ),
                    onSelected: (_) => vratProv.setFilter(f),
                  ),
                );
              }).toList(),
            ),
          ),

          // Vrats List
          Expanded(
            child: vrats.isEmpty
                ? Center(
                    child: Text(
                      "No vrats found for this category",
                      style: GoogleFonts.poppins(color: AppTheme.textMuted),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: vrats.length,
                    itemBuilder: (context, idx) {
                      final item = vrats[idx];
                      return _buildVratCard(context, item, isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildVratCard(BuildContext context, VratItem item, bool isDark) {
    final formattedDate = DateFormat('EEEE, d MMMM yyyy').format(item.date);

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppTheme.divineGold.withValues(alpha: 0.3)),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.sacredMaroon.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.type.toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.sacredMaroon,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Text(
                  formattedDate,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              item.name,
              style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              item.hindiName,
              style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.marigold, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.favorite_outline, size: 14, color: AppTheme.divineGold),
                const SizedBox(width: 6),
                Text(
                  item.deity,
                  style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Parana Timing Box
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer_outlined, size: 16, color: Colors.amber),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Parana / Timing: ${item.paranaTiming}",
                      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item.significance,
              style: GoogleFonts.poppins(fontSize: 12, height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showKathaDialog(context, item, isDark),
                icon: const Icon(Icons.menu_book_rounded, size: 16, color: AppTheme.sacredMaroon),
                label: Text(
                  "Read Vrat Katha & Fasting Rules",
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.sacredMaroon),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.sacredMaroon),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showKathaDialog(BuildContext context, VratItem item, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: isDark ? AppTheme.templeCardDark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(item.hindiName, style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.marigold)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const Divider(height: 24),
              // Parana Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.sacredMaroon.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.sacredMaroon.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.alarm_on_rounded, color: AppTheme.sacredMaroon),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Parana Window: ${item.paranaTiming}",
                        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.sacredMaroon),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text(
                "Fasting Rules & Guidelines",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...item.rules.map((rule) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("• ", style: TextStyle(color: AppTheme.divineGold, fontSize: 16)),
                        Expanded(child: Text(rule, style: GoogleFonts.poppins(fontSize: 13))),
                      ],
                    ),
                  )),
              const SizedBox(height: 20),
              Text(
                item.kathaTitle,
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.sacredMaroon),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? Colors.black26 : const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.3)),
                ),
                child: Text(
                  item.kathaContent,
                  style: GoogleFonts.poppins(fontSize: 13.5, height: 1.6),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
