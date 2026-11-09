import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../models/audio_track_model.dart';
import '../providers/audio_provider.dart';
import '../providers/app_provider.dart';
import '../widgets/ad_banner_widget.dart';

class AudioPlayerScreen extends StatelessWidget {
  final AudioTrack track;

  const AudioPlayerScreen({super.key, required this.track});

  String _formatDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return "$m:${s.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final audioProv = Provider.of<AudioProvider>(context);
    final appProv = Provider.of<AppProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activeTrack = audioProv.activeTrack ?? track;
    final isPlaying = audioProv.isPlaying;
    final pos = audioProv.position;
    final dur = audioProv.duration.inSeconds > 0
        ? audioProv.duration
        : Duration(seconds: activeTrack.durationSec);

    return Scaffold(
      appBar: AppBar(
        title: Text(activeTrack.title),
        actions: [
          IconButton(
            icon: Icon(
              activeTrack.isDownloaded ? Icons.download_done_rounded : Icons.download_rounded,
              color: activeTrack.isDownloaded ? Colors.green : AppTheme.divineGold,
            ),
            tooltip: activeTrack.isDownloaded ? "Downloaded Offline" : "Download Offline (Ad / Prime)",
            onPressed: () {
              if (activeTrack.isDownloaded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Track is already downloaded for offline devotion.")),
                );
              } else {
                audioProv.downloadTrackOffline(
                  track: activeTrack,
                  isProUser: appProv.isProUser,
                  context: context,
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // Sacred Mandala & Deity Emblem
                  Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [AppTheme.divineGold, AppTheme.sacredMaroon],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.marigold.withValues(alpha: 0.35),
                            blurRadius: 20,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.wb_sunny_rounded,
                          size: 75,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    activeTrack.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${activeTrack.deity} • ${activeTrack.category}",
                    style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.marigold, fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(height: 18),

                  // Interactive Virtual Temple Sound Effects (Bell & Shankh)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.templeCardDark : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => audioProv.playBell(),
                          icon: const Icon(Icons.notifications_active, color: AppTheme.marigold),
                          label: Text(
                            "Ring Bell",
                            style: GoogleFonts.poppins(color: AppTheme.marigold, fontWeight: FontWeight.bold),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppTheme.marigold),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => audioProv.playShankh(),
                          icon: const Icon(Icons.volume_up, color: AppTheme.sacredMaroon),
                          label: Text(
                            "Blow Shankh",
                            style: GoogleFonts.poppins(color: AppTheme.sacredMaroon, fontWeight: FontWeight.bold),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppTheme.sacredMaroon),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Synced Dual-Script Lyrics Viewer
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2C0A0D) : const Color(0xFFFFF7EB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Synchronized Lyrics",
                              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textMuted),
                            ),
                            const Icon(Icons.lyrics_outlined, size: 18, color: AppTheme.marigold),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...activeTrack.lyrics.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final lyric = entry.value;
                          final isCurrent = idx == audioProv.activeLyricIndex;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isCurrent
                                  ? AppTheme.divineGold.withValues(alpha: 0.25)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: isCurrent
                                  ? Border.all(color: AppTheme.divineGold)
                                  : null,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lyric.devanagari,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                                    color: isCurrent ? AppTheme.sacredMaroon : (isDark ? AppTheme.textLight : AppTheme.textDark),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  lyric.english,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    color: isCurrent ? AppTheme.marigold : AppTheme.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Seek Slider
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppTheme.sacredMaroon,
                      thumbColor: AppTheme.divineGold,
                      inactiveTrackColor: Colors.grey.withValues(alpha: 0.3),
                    ),
                    child: Slider(
                      min: 0,
                      max: dur.inSeconds.toDouble(),
                      value: pos.inSeconds.toDouble().clamp(0, dur.inSeconds.toDouble()),
                      onChanged: (val) {
                        audioProv.seek(Duration(seconds: val.toInt()));
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(pos), style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textMuted)),
                        Text(_formatDuration(dur), style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textMuted)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Player Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.repeat_rounded,
                          color: audioProv.isLooping ? AppTheme.marigold : AppTheme.textMuted,
                          size: 26,
                        ),
                        tooltip: "Loop Aarti",
                        onPressed: () => audioProv.toggleLoop(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.replay_10_rounded, size: 30),
                        onPressed: () {
                          final newSec = (pos.inSeconds - 10).clamp(0, dur.inSeconds);
                          audioProv.seek(Duration(seconds: newSec));
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          if (audioProv.activeTrack?.id != activeTrack.id) {
                            audioProv.playTrack(activeTrack);
                          } else {
                            audioProv.togglePlayPause();
                          }
                        },
                        child: Container(
                          width: 68,
                          height: 68,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.sacredMaroon,
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3)),
                            ],
                          ),
                          child: Icon(
                            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            size: 40,
                            color: AppTheme.divineGold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.forward_10_rounded, size: 30),
                        onPressed: () {
                          final newSec = (pos.inSeconds + 10).clamp(0, dur.inSeconds);
                          audioProv.seek(Duration(seconds: newSec));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.queue_music_rounded, size: 26),
                        onPressed: () => _showPlaylistModal(context, audioProv),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Bottom AdMob Banner
          if (!appProv.isProUser) const AdBannerWidget(),
        ],
      ),
    );
  }

  void _showPlaylistModal(BuildContext context, AudioProvider prov) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Devotional Playlist", style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...prov.tracks.map((t) => ListTile(
              leading: const Icon(Icons.music_note, color: AppTheme.marigold),
              title: Text(t.title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              subtitle: Text(t.deity, style: GoogleFonts.poppins(fontSize: 12)),
              onTap: () {
                prov.playTrack(t);
                Navigator.of(ctx).pop();
              },
            )),
          ],
        ),
      ),
    );
  }
}
