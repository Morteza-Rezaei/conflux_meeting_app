import 'package:conflux_meeting_app/provider.dart';
import 'package:conflux_meeting_app/screens/select_date/see_selected_date.dart';
import 'package:conflux_meeting_app/screens/select_date/select_meeting_date.dart';
import 'package:conflux_meeting_app/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectSectionScreen extends StatelessWidget {
  const SelectSectionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final possibleMeetingData = Provider.of<PossibleMeetingData>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(possibleMeetingData.mTitle),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 80),
                child: Image.asset(
                  'assets/conflux_logo2.png',
                  fit: BoxFit.contain,
                  width: 200,
                ),
              ),
              MyHomeElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SelectMeetingDateScreen()),
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
                        builder: (context) => const SeeSelectedDateScreen()),
                  );
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text('Seçilen tarihleri göster'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
