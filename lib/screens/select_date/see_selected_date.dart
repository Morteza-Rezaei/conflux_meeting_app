import 'package:conflux_meeting_app/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeeSelectedDateScreen extends StatelessWidget {
  final List<DateTime>? selectedDates;
  const SeeSelectedDateScreen({
    super.key,
    required this.selectedMeeting,
    this.selectedDates,
  });

  final Meeting selectedMeeting;

  @override
  Widget build(BuildContext context) {
    final username =
        Provider.of<UsernameProvider>(context, listen: false).username;
    final userSelectedDates = Provider.of<UserMeetingDatesProvider>(context);
    final dates = userSelectedDates.getDates(username);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                  itemCount: dates?.length ?? 0,
                  itemBuilder: (context, index) {
                    final date = dates![index];
                    return ListTile(
                      title: Text(date.toString()),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
