import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'data/tracks.dart';
import 'providers/favorites_provider.dart';
import 'providers/playback_provider.dart';
import 'router/app_router.dart';
import 'services/audio_player_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.example.music_player_app.channel.audio',
    androidNotificationChannelName: 'Music Playback',
    androidNotificationOngoing: true,
  );

  final service = AudioPlayerService();
  final playback = PlaybackProvider(service, tracks);
  await playback.init();

  final favorites = FavoritesProvider();
  await favorites.load();

  runApp(MyApp(
    playbackProvider: playback,
    favoritesProvider: favorites,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.playbackProvider,
    required this.favoritesProvider,
  });

  final PlaybackProvider playbackProvider;
  final FavoritesProvider favoritesProvider;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PlaybackProvider>.value(value: playbackProvider),
        ChangeNotifierProvider<FavoritesProvider>.value(
          value: favoritesProvider,
        ),
      ],
      child: MaterialApp.router(
        title: 'Music Player',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.montserratTextTheme(),
          fontFamily: GoogleFonts.montserrat().fontFamily,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}


