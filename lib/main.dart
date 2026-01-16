import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inventur_mde/core/providers/index.dart';
import 'package:inventur_mde/data/services/api_service.dart';
import 'package:inventur_mde/presentation/pages/index.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PersonalProvider(ApiService())),
        ChangeNotifierProvider(
          create: (context) => ScanProvider(ApiService())),
        ChangeNotifierProvider(
          create: (context) => InventurProvider(ApiService())),  
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lager MDE',
      home: LoginPage(),
    );
  }
}
