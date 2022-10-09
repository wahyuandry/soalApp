import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latihan_soal/constants/r.dart';
import 'package:latihan_soal/helpers/user_email.dart';
import 'package:latihan_soal/models/network_response.dart';
import 'package:latihan_soal/view/login_page.dart';
import 'package:latihan_soal/view/main_page.dart';
import 'package:latihan_soal/view/register_page.dart';

import '../repository/auth_api.dart';
import '../models/user_by_email.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String route = "splash_screen";

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 5), () async {
      final user = UserEmail.getUserEmail();

      if (user != null) {
        final dataUser = await AuthApi().getUserByEmail();
        if (dataUser.status == Status.success) {
          final data = UserByEmail.fromJson(dataUser.data!);
          if (data.status == 1) {
            Navigator.of(context).pushNamed(MainPage.route);
          } else {
            Navigator.of(context).pushNamed(RegisterPage.route);
          }
        }
      } else {
        Navigator.of(context).pushReplacementNamed(LoginPage.route);
      }
    });

    return Scaffold(
      backgroundColor: R.colors.primary,
      body: Center(
        child: Image.asset(R.assets.icSplash),
      ),
    );
  }
}
