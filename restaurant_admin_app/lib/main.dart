import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:restaurant_admin_app/data/localization/app_localization.dart';
import 'package:restaurant_admin_app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const url = 'https://jnxmzltgmwxgsuxlqusu.supabase.co';
const anonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpueG16bHRnbXd4Z3N1eGxxdXN1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk5Njk3NjcsImV4cCI6MjA3NTU0NTc2N30.6GxwiRbOiYbndb2Wnlej42bCY99rm5mR8nauf0-NQaM';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Supabase.initialize(url: url, anonKey: anonKey);

  // Initialize shared preferences for locale persistence
  final prefs = await SharedPreferences.getInstance();
  final savedLocale = prefs.getString('locale') ?? 'en';

  runApp(MyApp(savedLocale: savedLocale));
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  final String savedLocale;

  const MyApp({super.key, required this.savedLocale});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant Admin',
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      translations: AppLocalization(),
      locale: Locale(savedLocale),
      fallbackLocale: const Locale('en'),
      theme: ThemeData(
        primaryColor: Colors.orangeAccent,
        appBarTheme: const AppBarTheme(color: Colors.white, elevation: 3),
      ),
    );
  }
}

// Helper class to manage locale persistence
class LocaleManager {
  static Future<void> saveLocale(String localeCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', localeCode);
    Get.updateLocale(Locale(localeCode));
  }

  static Future<String> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('locale') ?? 'en';
  }

  static Future<void> toggleLocale() async {
    final currentLocale = await getLocale();
    final newLocale = currentLocale == 'en' ? 'ar' : 'en';
    await saveLocale(newLocale);
  }
}
