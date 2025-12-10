import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/tracks.dart';
import '../providers/playback_provider.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/track_list_item.dart';
import '../models/track.dart';

import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),

      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                            const _HeaderCard(),

                  const SizedBox(height: 25),
                  BannerCarousel(
                    bannerItems: [
                      'assets/images/Banner_1.png',
                      'assets/images/Banner_1.png',
                      'assets/images/Banner_1.png',
                      'assets/images/Banner_1.png',
                    ],
                  ),
                  const SizedBox(height: 14),
           Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Text(
    'Quick Picks',
    style: GoogleFonts.montserrat(
      fontSize: 22,
      fontWeight: FontWeight.w700,
    ),
  ),
),

const SizedBox(height: 16),
SizedBox(
  height: 150,
  child: ListView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.only(left: 16, right: 16),
    children: const [
      QuickPickCard(
        title: "Explore by Age",
        iconPath: "assets/images/first_image.png",
        bgPath: "assets/images/quick_bg.png",
      ),
      SizedBox(width: 14),
      QuickPickCard(
        title: "Themes",
        iconPath: "assets/images/second_themes.png",
        bgPath: "assets/images/quick_bg.png",
      ),
      SizedBox(width: 14),
      QuickPickCard(
        title: "Books",
        iconPath: "assets/images/third_book.png",
        bgPath: "assets/images/quick_bg.png",
      ),
      SizedBox(width: 16),
    ],
  ),
),

SizedBox(height: 16),
                  BannerCarousel(
                    bannerItems: [
                      'assets/images/banner_2.png',
                    ],
                  ),


SizedBox(height: 40),
               
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class QuickPickCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final String bgPath;

  const QuickPickCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.bgPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: AssetImage(bgPath),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            height: 70,
            width: 70,
            fit: BoxFit.contain,
          ),

          const SizedBox(height: 20),

          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}



class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 34),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF7A4DFF),
            Color(0xFF5B2FEA),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        image: const DecorationImage(
          image: AssetImage('assets/images/bg-purple-decoration.png'),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          opacity: 0.10,
        ),

        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),

        boxShadow: [
          BoxShadow(
            color: Color(0xFF4D2EBE).withOpacity(0.25),
            blurRadius: 22,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/app_logo.png',
                  height: 28,
                  fit: BoxFit.contain,
                ),
                const Spacer(),
                const Icon(Icons.qr_code_scanner, color: Colors.white, size: 22),
                const SizedBox(width: 18),
                const Icon(Icons.notifications_none, color: Colors.white, size: 22),
                const SizedBox(width: 18),
Stack(
  clipBehavior: Clip.none,
  children: [
    const Icon(
      Icons.shopping_cart_outlined,
      color: Colors.white,
      size: 22,
    ),

    Positioned(
      right: -3,
      top: -3,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          color: Color(0xFFFF3B30),
          shape: BoxShape.circle,
        ),
        constraints: const BoxConstraints(
          minWidth: 14,
          minHeight: 14,
        ),
        child: const Center(
          child: Text(
            "1",
            style: TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              height: 1.0,
            ),
          ),
        ),
      ),
    ),
  ],
)
              ],
            ),
        
            const SizedBox(height: 26),
        
           const Text.rich(
  TextSpan(
    text: "Hello, ",
    style: TextStyle(
      color: Colors.white,
      fontSize: 25,
      height: 1.1,
      letterSpacing: 0.2,
    ),
    children: [
      TextSpan(
        text: "Kapoor Family!",
        style: TextStyle(
          fontWeight: FontWeight.w900,
        ),
      ),
      TextSpan(text: "👋"),
    ],
  ),
),

        
            const SizedBox(height: 13),
        
           Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const Text(
      "📅",
      style: TextStyle(fontSize: 18),
    ),
    const SizedBox(width: 8),

    Expanded(
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "Aarav’s birthday is in 5 day!\n",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
            TextSpan(
              text: "Let’s plan something special",
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 15,
                fontWeight: FontWeight.w400,
                height: 1.35,
              ),
            )
          ],
        ),
      ),
    ),
  ],
),

        
            const SizedBox(height: 24),
        
            const _SearchBar(),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),

        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB69AFF).withOpacity(0.6),
            blurRadius: 18,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: TextField(
        enabled: false,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade700),

          hintText: "Search for gifts, games, flashcards...",
          hintStyle: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 15,
          ),

          contentPadding: const EdgeInsets.symmetric(vertical: 16),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: Colors.white, width: 3),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: Colors.white, width: 3),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}


class _QuickPickCard extends StatelessWidget {
  const _QuickPickCard({required this.track});
  final Track track;

  @override
  Widget build(BuildContext context) {
    final playback = context.read<PlaybackProvider>();
    return GestureDetector(
      onTap: () => playback.playTrack(track),
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                track.imagePath,
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              track.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              track.category,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

