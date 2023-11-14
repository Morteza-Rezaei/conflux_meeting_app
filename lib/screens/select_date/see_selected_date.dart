import 'package:conflux_meeting_app/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SeeSelectedDateScreen extends StatelessWidget {
  const SeeSelectedDateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat.yMd();

    final userMeetingDates = Provider.of<UserMeetingDatesProvider>(context);
    Map<String, List<DateTime>> allUserDates = userMeetingDates.userDates;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seçilen Tarihler'),
      ),
      body: ListView.builder(
        itemCount: allUserDates.keys.length,
        itemBuilder: (context, index) {
          String username = allUserDates.keys.elementAt(index);
          List<DateTime> dates = allUserDates[username]!;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(username),
              Column(
                children: dates
                    .map((date) => Text(dateFormatter.format(date)))
                    .toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
