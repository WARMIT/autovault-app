import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'state/car_store.dart';
import 'theme/app_theme.dart';
import 'screens/main_layout.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set immersive status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  runApp(const AutoVaultApp());
}

class AutoVaultApp extends StatefulWidget {
  const AutoVaultApp({Key? key}) : super(key: key);

  @override
  State<AutoVaultApp> createState() => _AutoVaultAppState();
}

class _AutoVaultAppState extends State<AutoVaultApp> {
  final CarStore _carStore = CarStore();

  @override
  void dispose() {
    _carStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CarStoreProvider(
      store: _carStore,
      child: AnimatedBuilder(
        animation: _carStore,
        builder: (context, _) {
          return MaterialApp(
            title: 'AutoVault - Car Marketplace',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _carStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const MainLayout(),
          );
        },
      ),
    );
  }
}
