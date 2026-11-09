import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_theme.dart';

class CustomErrorBoundary extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const CustomErrorBoundary({super.key, required this.errorDetails});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.warmCream,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppTheme.sacredMaroon.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: AppTheme.sacredMaroon,
                  size: 44,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                "Shanti & Patience",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.sacredMaroon,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "A momentary disturbance occurred. Please return to your sacred practice.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppTheme.textMuted,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate back or reload safe state
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
                icon: const Icon(Icons.refresh, color: AppTheme.divineGold),
                label: const Text("Return Home"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
