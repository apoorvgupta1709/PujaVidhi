import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_theme.dart';

class VirtualDiyaScreen extends StatefulWidget {
  const VirtualDiyaScreen({super.key});

  @override
  State<VirtualDiyaScreen> createState() => _VirtualDiyaScreenState();
}

class _VirtualDiyaScreenState extends State<VirtualDiyaScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _flameController;
  late Animation<double> _flameAnimation;
  int _petalsCount = 0;
  bool _isLit = true;
  String _sankalpText = "May peace, health, and spiritual light bless my family.";

  @override
  void initState() {
    super.initState();
    _flameController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _flameAnimation = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _flameController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _flameController.dispose();
    super.dispose();
  }

  void _offerFlowers() {
    setState(() {
      _petalsCount += 5;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("🌸 Sacred flowers offered at the altar with devotion!"),
        duration: Duration(seconds: 1),
        backgroundColor: AppTheme.sacredMaroon,
      ),
    );
  }

  void _editSankalp() {
    final ctrl = TextEditingController(text: _sankalpText);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Dedicate Your Sankalp", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: ctrl,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: "Enter your personal prayer, family sankalp, or wish...",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() => _sankalpText = ctrl.text.trim());
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.sacredMaroon),
            child: const Text("Set Sankalp", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0B09),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Akhand Jyoti • Virtual Diya",
          style: GoogleFonts.poppins(color: AppTheme.divineGold, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: AppTheme.divineGold),
        actions: [
          IconButton(
            icon: Icon(_isLit ? Icons.lightbulb : Icons.lightbulb_outline, color: AppTheme.divineGold),
            tooltip: _isLit ? "Extinguish" : "Kindle Light",
            onPressed: () => setState(() => _isLit = !_isLit),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Golden Aura Glow
          if (_isLit)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.22,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withValues(alpha: 0.25),
                        blurRadius: 100,
                        spreadRadius: 40,
                      ),
                      BoxShadow(
                        color: Colors.deepOrange.withValues(alpha: 0.15),
                        blurRadius: 140,
                        spreadRadius: 60,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Main Diya & Flame Canvas
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Sankalp Display Banner
                GestureDetector(
                  onTap: _editSankalp,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: AppTheme.divineGold, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Devotee's Sankalp (Tap to Edit)",
                                style: GoogleFonts.poppins(color: AppTheme.marigold, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _sankalpText,
                                style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.edit_outlined, color: Colors.white54, size: 16),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Animated Diya & Flame
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isLit)
                        AnimatedBuilder(
                          animation: _flameAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scaleY: _flameAnimation.value,
                              scaleX: 2.0 - _flameAnimation.value,
                              child: CustomPaint(
                                size: const Size(60, 90),
                                painter: _FlamePainter(),
                              ),
                            );
                          },
                        )
                      else
                        const SizedBox(height: 90),

                      // Clay Diya Base
                      CustomPaint(
                        size: const Size(190, 70),
                        painter: _ClayDiyaPainter(),
                      ),

                      const SizedBox(height: 14),

                      // Petals count tag
                      if (_petalsCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "🌸 $_petalsCount flowers offered",
                            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),

                const Spacer(),

                // Action Controls (Offer Flowers, Edit Sankalp)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _offerFlowers,
                          icon: const Text("🌸", style: TextStyle(fontSize: 18)),
                          label: Text(
                            "Offer Flowers",
                            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF991B1B),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _editSankalp,
                          icon: const Icon(Icons.edit_note, color: AppTheme.divineGold),
                          label: Text(
                            "Edit Sankalp",
                            style: GoogleFonts.poppins(color: AppTheme.divineGold, fontWeight: FontWeight.bold),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppTheme.divineGold),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FlamePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(size.width * 0.5, 0); // Top tip
    path.quadraticBezierTo(size.width * 0.95, size.height * 0.55, size.width * 0.65, size.height);
    path.lineTo(size.width * 0.35, size.height);
    path.quadraticBezierTo(size.width * 0.05, size.height * 0.55, size.width * 0.5, 0);
    path.close();

    // Outer flame gradient
    final outerPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFFFFBEB), Color(0xFFFBBF24), Color(0xFFF97316), Colors.transparent],
        stops: [0.1, 0.45, 0.85, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, outerPaint);

    // Inner bright white/yellow core
    final innerPath = Path();
    innerPath.moveTo(size.width * 0.5, size.height * 0.3);
    innerPath.quadraticBezierTo(size.width * 0.75, size.height * 0.65, size.width * 0.55, size.height * 0.95);
    innerPath.lineTo(size.width * 0.45, size.height * 0.95);
    innerPath.quadraticBezierTo(size.width * 0.25, size.height * 0.65, size.width * 0.5, size.height * 0.3);
    innerPath.close();

    final innerPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Colors.white, Color(0xFFFEF08A)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(innerPath, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _ClayDiyaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Clay Diya bowl path
    final path = Path();
    path.moveTo(w * 0.1, h * 0.25);
    path.quadraticBezierTo(w * 0.05, h * 0.85, w * 0.5, h * 0.9);
    path.quadraticBezierTo(w * 0.95, h * 0.85, w * 0.9, h * 0.25);
    path.quadraticBezierTo(w * 0.5, h * 0.1, w * 0.1, h * 0.25);
    path.close();

    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF854D0E), Color(0xFF78350F), Color(0xFF451A03)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(path, paint);

    // Diya rim highlight
    final rimPaint = Paint()
      ..color = const Color(0xFFB45309)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.5, h * 0.25), width: w * 0.82, height: h * 0.32), rimPaint);

    // Pure Ghee liquid layer inside diya
    final gheePaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFFDE047), Color(0xFFCA8A04)],
      ).createShader(Rect.fromCenter(center: Offset(w * 0.5, h * 0.26), width: w * 0.6, height: h * 0.2));

    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.5, h * 0.26), width: w * 0.65, height: h * 0.18), gheePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
