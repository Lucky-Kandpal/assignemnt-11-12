import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';

import '../providers/favorites_provider.dart';
import '../providers/playback_provider.dart';

class FullPlayerScreen extends StatelessWidget {
  const FullPlayerScreen({super.key});

  String _format(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = d.inHours > 0 ? '${d.inHours}:' : '';
    return '$hours$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PlaybackProvider, FavoritesProvider>(
      builder: (context, playback, favorites, _) {
        final track = playback.currentTrack;
        if (track == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('No track selected')),
          );
        }
        final isFavorite = favorites.isFavorite(track.id);
        final duration = playback.duration;
        final position = playback.position;
        final size = MediaQuery.of(context).size;

        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                "assets/images/bg-player.png",
                fit: BoxFit.cover,
              ),
              Container(color: Colors.black.withOpacity(0.12)),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: size.height * 0.65,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
Color(0x00613EEA),
                        Color(0xCC613EEA),
                        Color(0xFF0C0A1F),                      ],
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade700,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                              border: Border.all(color: Colors.black.withOpacity(0.6)),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white,),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  track.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 28,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  track.artist,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.85),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.12),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withOpacity(0.35)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: Colors.white,
                              ),
                              onPressed: () => favorites.toggleFavorite(track.id),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: Colors.white24,
                          thumbColor: Colors.white,
                        ),
                        child: Slider(
                          min: 0,
                          max: (duration.inMilliseconds == 0 ? 1 : duration.inMilliseconds).toDouble(),
                          value: position.inMilliseconds
                              .clamp(0, duration.inMilliseconds == 0 ? 1 : duration.inMilliseconds)
                              .toDouble(),
                          onChanged: (value) => playback.seek(Duration(milliseconds: value.toInt())),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _format(position),
                            style: TextStyle(color: Colors.white.withOpacity(0.75)),
                          ),
                          Text(
                            _format(duration),
                            style: TextStyle(color: Colors.white.withOpacity(0.75)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 26),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _ControlButton(
                            icon: Icons.skip_previous,
                            onTap: playback.hasPrevious ? playback.previous : null,
                          ),
                          _ControlButton(
                            icon: playback.isPlaying ? Icons.pause : Icons.play_arrow,
                            onTap: playback.togglePlayPause,
                            isPrimary: true,
                          ),
                          _ControlButton(
                            icon: Icons.skip_next,
                            onTap: playback.hasNext ? playback.next : null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final double size = isPrimary ? 72 : 56;
    final Color bg = isPrimary ? Colors.white.withOpacity(0.18) : Colors.white.withOpacity(0.12);

    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: isPrimary ? 32 : 26,
        ),
      ),
    );
  }
}
