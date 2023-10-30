import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo image
            Image.asset('assets/conflux_logo.png', width: 300),

            // Welcome text

            // btn Toplantı Tarihleri Oluştur

            // btn Uygunluk Durumu Bildir

            // btn Toplantıyı Oluştur
          ],
        ),
      ),
    );
  }
}
