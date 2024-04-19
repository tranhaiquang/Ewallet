import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:EWallet/main_page.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid ? await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyAEIvvJF1mjkUpSUlsABBriYVsSlfE0yvk',
          appId: '1:437920967769:android:0140defc6ff2004c649548',
          messagingSenderId: '437920967769',
          projectId: 'ewallet-7295e')
  ) : await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

