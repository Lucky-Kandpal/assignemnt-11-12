import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/track.dart';

class TrackListItem extends StatelessWidget {
  const TrackListItem({
    super.key,
    required this.track,
    this.onTap,
    this.onMenuTap,
    this.trailing,
  });

  final Track track;
  final VoidCallback? onTap;
  final VoidCallback? onMenuTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark ||
        MediaQuery.of(context).platformBrightness == Brightness.dark ||
        Theme.of(context).scaffoldBackgroundColor.value == 0xFF1F1F1F;
    
    return Container(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            track.imagePath,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 60,
                height: 60,
                color: Colors.grey.shade800,
                child: const Icon(Icons.music_note, color: Colors.white),
              );
            },
          ),
        ),
        title: Text(
          track.title,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${track.category} Song',
            style: GoogleFonts.montserrat(
              color: isDarkTheme ? Colors.grey.shade400 : Colors.grey.shade600,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        trailing: trailing ??
            IconButton(
              icon: Icon(
                Icons.more_vert,
                color:  Colors.white ,
              ),
              onPressed: onMenuTap,
            ),
        onTap: onTap,
      ),
    );
  }
}

