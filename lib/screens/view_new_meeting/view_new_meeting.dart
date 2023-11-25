import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewNewMeetingScreen extends StatefulWidget {
  const ViewNewMeetingScreen({super.key});

  @override
  State<ViewNewMeetingScreen> createState() => _ViewNewMeetingScreenState();
}

final dateFormatter = DateFormat.yMd();
final timeFormatter = DateFormat.jm();

class _ViewNewMeetingScreenState extends State<ViewNewMeetingScreen> {
  Future<Map<String, dynamic>> fetchMeetingData() async {
    final url = Uri.https(
        'conflux-meeting-app-default-rtdb.firebaseio.com', 'new-meeting.json');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchMeetingData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final meetingData = snapshot.data;
            var participants = meetingData?['participants'];
            var meetingDate = meetingData?['MeetingDate'];
            var meetingDurationMinutes = meetingData?['meetingDurationMinutes'];

            return Scaffold(
              appBar: AppBar(
                title: const Text('Toplantı bilgileri'),
              ),
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context)
                              .colorScheme
                              .secondaryContainer
                              .withOpacity(0.2),
                        ),
                        child: Column(
                          children: [
                            // olası toplantı başlığı
                            Text(
                              meetingData?['mTitle'] ?? '',
                              style: GoogleFonts.montserrat(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // oluşan topalantı açıklaması

                            SizedBox(
                              height: 80,
                              child: SingleChildScrollView(
                                child: Text(
                                  meetingData?['mDescription'] ?? '',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // toplantı süresi

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context)
                              .colorScheme
                              .secondaryContainer
                              .withOpacity(0.2),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Toplantı süresi (dakika): ',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                meetingDurationMinutes.toString(),
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // katılımcılar
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context)
                              .colorScheme
                              .secondaryContainer
                              .withOpacity(0.2),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Katılımcılar: ',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                participants.join(', '),
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // toplantı tarihi
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context)
                              .colorScheme
                              .secondaryContainer
                              .withOpacity(0.2),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Toplantı Tarihi: ',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${dateFormatter.format(DateTime.parse(meetingDate))}   ${timeFormatter.format(DateTime.parse(meetingDate))}',
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // google takvimine ekle butonu

                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                            icon: const Icon(Icons.event_rounded),
                            onPressed: () {
                              final event = Event(
                                title: meetingData?['mTitle'],
                                description: meetingData?['mDescription'],
                                startDate: DateTime.parse(meetingDate),
                                endDate: DateTime.parse(meetingDate).add(
                                    Duration(minutes: meetingDurationMinutes)),
                              );
                              Add2Calendar.addEvent2Cal(event);
                            },
                            label: const Text('Google Takvimine Ekle')),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
