import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'core/error_boundary.dart';
import 'services/storage_service.dart';
import 'services/admob_service.dart';
import 'services/firebase_sync_service.dart';
import 'providers/app_provider.dart';
import 'providers/panchang_provider.dart';
import 'providers/vidhi_provider.dart';
import 'providers/audio_provider.dart';
import 'providers/japa_provider.dart';
import 'providers/ishta_devta_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/vrat_provider.dart';
import 'services/localization_service.dart';
import 'screens/home_screen.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Production error logging: intercept all Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('PujaVidhi Framework Error: ${details.exceptionAsString()}');
    };

    // Intercept platform and asynchronous unhandled errors
    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint('PujaVidhi Platform Error: $error\n$stack');
      return true; // handled, prevent process crash
    };

    // Custom Error Boundary (Checklist Item 8: No red unhandled exception screens)
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return CustomErrorBoundary(errorDetails: details);
    };

    // Initialize Persistent Local Storage
    try {
      await StorageService.init();
    } catch (e) {
      debugPrint('Storage init notice: $e');
    }

    // Render app UI immediately without blocking
    runApp(const PujaVidhiApp());

    // Safely initialize AdMob asynchronously without blocking launch
    try {
      unawaited(AdMobService.initialize());
    } catch (e) {
      debugPrint('AdMob startup notice: $e');
    }

    // Safely sync latest Aartis, Vidhis, and Remote Config from Firebase Firestore
    try {
      unawaited(FirebaseSyncService.syncAll());
    } catch (e) {
      debugPrint('Firebase sync startup notice: $e');
    }
  }, (error, stack) {
    debugPrint('PujaVidhi Zone Error: $error\n$stack');
  });
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
        ChangeNotifierProvider(create: (_) => LocalizationService()),
        ChangeNotifierProvider(create: (_) => IshtaDevtaProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => VratProvider()),
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
