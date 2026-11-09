import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/admin_theme.dart';
import 'services/admin_provider.dart';
import 'screens/dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PujaVidhiAdminApp());
}

class PujaVidhiAdminApp extends StatelessWidget {
  const PujaVidhiAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: MaterialApp(
        title: 'PujaVidhi Operator Console',
        debugShowCheckedModeBanner: false,
        theme: AdminTheme.theme,
        home: const AdminDashboardScreen(),
      ),
    );
  }
}
