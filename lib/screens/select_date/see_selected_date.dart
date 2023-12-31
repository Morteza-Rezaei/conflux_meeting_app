import 'package:conflux_meeting_app/provider.dart';
import 'package:conflux_meeting_app/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class SeeSelectedDateScreen extends StatelessWidget {
  const SeeSelectedDateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat.yMd().add_jm();

    final userMeetingDates = Provider.of<UserMeetingDatesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seçilen Tarihler'),
      ),
      body: FutureBuilder<Map<String, List<DateTime>>>(
        future: userMeetingDates.fetchUserDates(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          } else if (snapshot.hasError) {
            return const Center(child: Text('An error occurred!'));
          } else {
            Map<String, List<DateTime>> allUserDates = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TableCalendar(
                      locale: 'tr_TR',
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      calendarStyle: CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.tertiaryContainer,
                          shape: BoxShape.circle,
                        ),
                        selectedTextStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        todayDecoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        weekendTextStyle: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      calendarFormat: CalendarFormat.twoWeeks,
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(const Duration(days: 365)),
                      focusedDay: DateTime.now(),
                      selectedDayPredicate: (day) {
                        // Format the date to yMd format to compare with the same format in allUserDates
                        String formattedDay =
                            DateFormat('yyyy-MM-dd').format(day);

                        // Check if the formatted date exists in the allUserDates map
                        return allUserDates.values
                            .expand((i) => i)
                            .map((e) => DateFormat('yyyy-MM-dd').format(e))
                            .contains(formattedDay);
                      },
                      eventLoader: (day) {
                        // Format the date to yMd format to compare with the same format in allUserDates
                        String formattedDay =
                            DateFormat('yyyy-MM-dd').format(day);

                        // Check if the formatted date exists in the allUserDates map
                        var selectedDates = allUserDates.values
                            .expand((i) => i)
                            .where((date) =>
                                DateFormat('yyyy-MM-dd').format(date) ==
                                formattedDay)
                            .toList();

                        return selectedDates;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
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
                                      .map((date) =>
                                          Text(dateFormatter.format(date)))
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
            );
          }
        },
      ),
    );
  }
}
