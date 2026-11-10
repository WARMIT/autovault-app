import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'state/car_store.dart';
import 'theme/app_theme.dart';
import 'screens/main_layout.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set modern status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  runApp(const AllSellApp());
}

class AllSellApp extends StatefulWidget {
  const AllSellApp({Key? key}) : super(key: key);

  @override
  State<AllSellApp> createState() => _AllSellAppState();
}

class _AllSellAppState extends State<AllSellApp> {
  final CarStore _store = CarStore();

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CarStoreProvider(
      store: _store,
      child: AnimatedBuilder(
        animation: _store,
        builder: (context, _) {
          return MaterialApp(
            title: 'ALLSELL - Connect & Simplify',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _store.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const MainLayout(),
          );
        },
      ),
    );
  }
}
