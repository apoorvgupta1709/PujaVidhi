import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'core/error_boundary.dart';
import 'services/storage_service.dart';
import 'services/admob_service.dart';
import 'providers/app_provider.dart';
import 'providers/panchang_provider.dart';
import 'providers/vidhi_provider.dart';
import 'providers/audio_provider.dart';
import 'providers/japa_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Custom Error Boundary (Checklist Item 8: No red unhandled exception screens)
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return CustomErrorBoundary(errorDetails: details);
  };

  // Initialize Persistent Local Storage
  await StorageService.init();

  // Initialize Google Mobile Ads Engine
  await AdMobService.initialize();

  runApp(const PujaVidhiApp());
}

class PujaVidhiApp extends StatelessWidget {
  const PujaVidhiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => PanchangProvider()),
        ChangeNotifierProvider(create: (_) => VidhiProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
        ChangeNotifierProvider(create: (_) => JapaProvider()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, appProv, _) {
          return MaterialApp(
            title: 'PujaVidhi',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appProv.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
