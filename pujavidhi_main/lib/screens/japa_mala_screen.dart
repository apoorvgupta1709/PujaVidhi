import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../core/app_theme.dart';
import '../providers/japa_provider.dart';
import '../providers/app_provider.dart';

class JapaMalaScreen extends StatelessWidget {
  const JapaMalaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final japaProv = Provider.of<JapaProvider>(context);
    final appProv = Provider.of<AppProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("108 Digital Japa Mala"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: "Japa Sadhana History",
            onPressed: () => _showHistoryModal(context, japaProv),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: "Reset Mala",
            onPressed: () => _confirmReset(context, japaProv),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              // Mantra Selection Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.templeCardDark : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.5)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: japaProv.selectedMantra,
                    icon: const Icon(Icons.arrow_drop_down, color: AppTheme.marigold),
                    items: japaProv.availableMantras.map((m) {
                      return DropdownMenuItem(
                        value: m,
                        child: Text(
                          m,
                          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) japaProv.setSelectedMantra(val);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Round Status Pills
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatPill("Completed Malas", "${japaProv.completedRounds}", AppTheme.sacredMaroon),
                  _buildStatPill("Target Malas", "${japaProv.targetRounds}", AppTheme.marigold),
                  _buildStatPill("Total Chants", "${japaProv.completedRounds * 108 + japaProv.currentBead}", Colors.green),
                ],
              ),

              const Spacer(),

              // Circular 108-Bead Mala Widget
              Center(
                child: SizedBox(
                  width: 260,
                  height: 260,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Circular bead track
                      CustomPaint(
                        size: const Size(260, 260),
                        painter: _MalaTrackPainter(
                          currentBead: japaProv.currentBead,
                          totalBeads: 108,
                          activeColor: AppTheme.divineGold,
                          inactiveColor: isDark ? const Color(0xFF4A1012) : const Color(0xFFFFE0B2),
                        ),
                      ),

                      // Center Counter & Info
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${japaProv.currentBead}",
                            style: GoogleFonts.poppins(
                              fontSize: 54,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.sacredMaroon,
                              height: 1.0,
                            ),
                          ),
                          Text(
                            "of 108 Beads",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: AppTheme.textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.marigold.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "Mala ${japaProv.completedRounds + 1}",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.marigold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Giant Tactile Chant Button
              GestureDetector(
                onTap: () {
                  japaProv.countNextBead(
                    isProUser: appProv.isProUser,
                    context: context,
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.sacredMaroon, Color(0xFFB71C1C)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.sacredMaroon.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.touch_app_rounded, color: AppTheme.divineGold, size: 28),
                        const SizedBox(width: 12),
                        Text(
                          "TAP TO CHANT BEAD",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatPill(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(value, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: GoogleFonts.poppins(fontSize: 10, color: AppTheme.textMuted)),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context, JapaProvider prov) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Reset Mala Counter?"),
        content: const Text("This will reset your current round's bead count back to 0. Completed malas will remain saved."),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              prov.resetCounter();
              Navigator.of(ctx).pop();
            },
            child: const Text("Reset"),
          ),
        ],
      ),
    );
  }

  void _showHistoryModal(BuildContext context, JapaProvider prov) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollController) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Japa Sadhana History",
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (prov.history.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text("No completed malas yet. Begin your sacred chants today!"),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: prov.history.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final item = prov.history[i];
                      final dateStr = DateFormat('d MMM yyyy • h:mm a').format(item.timestamp);
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: AppTheme.sacredMaroon,
                          child: Icon(Icons.check, color: AppTheme.divineGold, size: 18),
                        ),
                        title: Text(item.mantraName, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                        subtitle: Text(dateStr, style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.textMuted)),
                        trailing: Text(
                          "108 Beads",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppTheme.marigold),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MalaTrackPainter extends CustomPainter {
  final int currentBead;
  final int totalBeads;
  final Color activeColor;
  final Color inactiveColor;

  _MalaTrackPainter({
    required this.currentBead,
    required this.totalBeads,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = size.width / 2 - 14;

    // Draw 36 representative visual beads around the perimeter
    const visualBeadCount = 36;
    final activeThreshold = (currentBead / totalBeads * visualBeadCount).round();

    for (int i = 0; i < visualBeadCount; i++) {
      // Start from top (-pi/2)
      final angle = -math.pi / 2 + (2 * math.pi / visualBeadCount) * i;
      final bx = cx + radius * math.cos(angle);
      final by = cy + radius * math.sin(angle);

      final isMeruBead = i == 0;
      final isActive = i < activeThreshold;

      final paint = Paint()
        ..color = isMeruBead
            ? AppTheme.sacredMaroon
            : (isActive ? activeColor : inactiveColor)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(bx, by), isMeruBead ? 8.0 : 5.0, paint);

      if (isActive && !isMeruBead) {
        final outlinePaint = Paint()
          ..color = AppTheme.marigold
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;
        canvas.drawCircle(Offset(bx, by), 5.5, outlinePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MalaTrackPainter oldDelegate) {
    return oldDelegate.currentBead != currentBead;
  }
}
