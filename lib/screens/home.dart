import 'package:conflux_meeting_app/screens/create_meeting.dart';
import 'package:conflux_meeting_app/screens/select_date.dart';
import 'package:conflux_meeting_app/screens/suggest_date.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
              child: Image.asset(
                'assets/conflux_logo.png',
                width: 300,
                fit: BoxFit.contain,
              ),
            ),

            // Welcome text
            Text(
              'Welcome',
              style: GoogleFonts.niconne(
                fontSize: 50,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),

            const SizedBox(height: 30),

            // btn Toplantı Tarihleri Oluştur
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SuggestDateScreen()),
                );
              },
              icon: const Icon(Icons.calendar_today),
              label: const Text('Toplantı Tarihleri Oluştur'),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 30),
                ),
                alignment: Alignment.centerLeft,
                fixedSize: MaterialStateProperty.all(const Size(300, 60)),
              ),
            ),

            const SizedBox(height: 10),

            // btn Uygunluk Durumu Bildir
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectDateScreen()),
                );
              },
              icon: const Icon(Icons.touch_app),
              label: const Text('Uygunluk Durumu Bildir'),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 30),
                ),
                alignment: Alignment.centerLeft,
                fixedSize: MaterialStateProperty.all(const Size(300, 60)),
              ),
            ),

            const SizedBox(height: 10),

            // btn Toplantıyı Oluştur
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateMeetingScreen()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Toplantıyı Oluştur'),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 30),
                ),
                alignment: Alignment.centerLeft,
                fixedSize: MaterialStateProperty.all(const Size(300, 60)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
