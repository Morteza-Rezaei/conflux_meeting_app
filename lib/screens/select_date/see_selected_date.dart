import 'package:conflux_meeting_app/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SeeSelectedDateScreen extends StatelessWidget {
  const SeeSelectedDateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat.yMd().add_jm();

    final userMeetingDates = Provider.of<UserMeetingDatesProvider>(context);
    Map<String, List<DateTime>> allUserDates = userMeetingDates.userDates;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seçilen Tarihler'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      'Katılımcı adı',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
                  Expanded(
                      child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      'Seçtiği tarihler',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
                ],
              ),
              ...allUserDates.keys.map((username) {
                List<DateTime> dates = allUserDates[username]!;
                return Card(
                  color: Theme.of(context)
                      .colorScheme
                      .secondaryContainer
                      .withOpacity(1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Text(
                          username,
                          style: GoogleFonts.montserrat(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        )),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: dates
                                .map((date) => Text(dateFormatter.format(date)))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
