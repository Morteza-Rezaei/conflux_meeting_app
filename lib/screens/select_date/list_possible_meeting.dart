import 'package:conflux_meeting_app/screens/select_date/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conflux_meeting_app/provider.dart'; // Import your MeetingData provider

class ListPossibleMeetingScreen extends StatefulWidget {
  const ListPossibleMeetingScreen({super.key});

  @override
  State<ListPossibleMeetingScreen> createState() =>
      _ListPossibleMeetingScreenState();
}

class _ListPossibleMeetingScreenState extends State<ListPossibleMeetingScreen> {
  @override
  Widget build(BuildContext context) {
    final toplantiB = Provider.of<MeetingData>(
        context); // Get MeetingData instance from Provider

    return Scaffold(
      appBar: AppBar(
        title: const Text('Olası Toplantılar'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context)
                .colorScheme
                .secondaryContainer
                .withOpacity(0.2),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: toplantiB.meetings.length,
            itemBuilder: (context, index) {
              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.primaryContainer),
                child: ListTile(
                  leading: const Icon(Icons.calendar_month_rounded),
                  title: Text(toplantiB.meetings[index].mTitle),
                  subtitle: Text(toplantiB.meetings[index].mDescription),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => AuthScreen(
                              selectedMeeting: toplantiB.meetings[index])),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
