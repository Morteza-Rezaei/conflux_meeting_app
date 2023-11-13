import 'package:conflux_meeting_app/provider.dart';
import 'package:conflux_meeting_app/screens/select_date/see_selected_date.dart';
import 'package:conflux_meeting_app/screens/select_date/select_meeting_date.dart';
import 'package:conflux_meeting_app/widgets/button.dart';
import 'package:flutter/material.dart';

class SelectSectionScreen extends StatelessWidget {
  const SelectSectionScreen({super.key, required this.selectedMeeting});

  final Meeting selectedMeeting;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyHomeElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectMeetingDateScreen(
                            selectedMeeting: selectedMeeting,
                          )),
                );
              },
              icon: const Icon(Icons.calendar_today),
              label: const Text('Size uygun olan tarihleri seçin'),
            ),
            const SizedBox(height: 15),
            MyHomeElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SeeSelectedDateScreen(
                            selectedMeeting: selectedMeeting,
                          )),
                );
              },
              icon: const Icon(Icons.calendar_today),
              label: const Text('Seçilen tarihleri göster'),
            ),
          ],
        ),
      ),
    );
  }
}
