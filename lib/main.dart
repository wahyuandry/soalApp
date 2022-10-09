import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latihan_soal/constants/r.dart';
import 'package:latihan_soal/view/login_page.dart';
import 'package:latihan_soal/view/main/latihan_soal/mapel_page.dart';
import 'package:latihan_soal/view/main/latihan_soal/paket_soal_page.dart';
import 'package:latihan_soal/view/register_page.dart';
import 'package:latihan_soal/view/splash_screen.dart';

import 'view/main_page.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Latihan Soal',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: R.colors.primary,
        ),
        primarySwatch: Colors.blue,
      ),
      // home: const SplashScreen(),
      initialRoute: "/",
      routes: {
        "/": (context) => const SplashScreen(),
        LoginPage.route: (context) => const LoginPage(),
        RegisterPage.route: (context) => const RegisterPage(),
        MainPage.route: (context) => const MainPage(),
        // MapelPage.route: (context) => const MapelPage(),
        // PaketSoalPage.route: (context) => const PaketSoalPage(),
      },
    );
  }
}
