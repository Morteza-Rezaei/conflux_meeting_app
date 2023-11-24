import 'package:conflux_meeting_app/screens/create_meeting.dart';
import 'package:conflux_meeting_app/screens/select_date/auth.dart';
import 'package:conflux_meeting_app/screens/create_possible_meeting.dart';
import 'package:conflux_meeting_app/screens/view_new_meeting/auth.dart';
import 'package:conflux_meeting_app/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo image
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Image.asset(
                  'assets/conflux_logo.png',
                  fit: BoxFit.contain,
                  width: 280,
                ),
              ),

              // Welcome text
              Text(
                'Hoşgeldiniz!',
                style: GoogleFonts.dancingScript(
                  fontSize: 50,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),

              const SizedBox(height: 30),

              MyHomeElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const CreatePossibleMeetingScreen()),
                    );
                  },
                  icon: const Icon(Icons.calendar_month_rounded),
                  label: const Text('Olası Toplantı Oluştur')),

              MyHomeElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelectDateAuthScreen()),
                  );
                },
                icon: const Icon(Icons.touch_app),
                label: const Text('Olası Toplantıyı Görüntüle'),
              ),

              MyHomeElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateMeetingScreen()),
                  );
                },
                icon: const Icon(Icons.event_rounded),
                label: const Text('Toplantı Oluştur'),
              ),

              MyHomeElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewNewMeetingAuthScreen()),
                  );
                },
                icon: const Icon(Icons.event_available_rounded),
                label: const Text('Toplantıyı Görüntüle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
