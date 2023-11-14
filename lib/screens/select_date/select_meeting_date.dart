import 'package:conflux_meeting_app/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SelectMeetingDateScreen extends StatefulWidget {
  final Meeting selectedMeeting;
  const SelectMeetingDateScreen({super.key, required this.selectedMeeting});

  @override
  State<SelectMeetingDateScreen> createState() =>
      _SelectMeetingDateScreenState();
}

final dateFormatter = DateFormat.yMd();
final timeFormatter = DateFormat.jm();

class _SelectMeetingDateScreenState extends State<SelectMeetingDateScreen> {
  DateTime? meetingDateSelectedFromUser;

  List<bool> _selectedDates = [];

  @override
  void initState() {
    super.initState();
    _selectedDates = List.generate(
        widget.selectedMeeting.possibleMeetingDates.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    final username = Provider.of<UsernameProvider>(context);
    final userMeetingDates = Provider.of<UserMeetingDatesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Olası toplantı bilgileri'),
        actions: [
          // kaudet buttonu
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                if (meetingDateSelectedFromUser == null &&
                    !_selectedDates.contains(true)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Lütfen bir tarih seçiniz',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                  return;
                }

                List<DateTime> dates = [];

                if (meetingDateSelectedFromUser != null) {
                  dates.add(meetingDateSelectedFromUser!);
                }

                for (int i = 0; i < _selectedDates.length; i++) {
                  if (_selectedDates[i]) {
                    dates.add(widget.selectedMeeting.possibleMeetingDates[i]);
                  }
                }

                userMeetingDates.addDates(username.username, dates);

                print(userMeetingDates.userDates);
              },
              icon: const Icon(Icons.send_rounded),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                    // oluşan toplantı başlığı
                    Text(
                      widget.selectedMeeting.mTitle,
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
                          widget.selectedMeeting.mDescription,
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

              // katılımcılar
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        widget.selectedMeeting.participants.join(', '),
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

              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context)
                      .colorScheme
                      .secondaryContainer
                      .withOpacity(0.2),
                ),
                child: Column(
                  children: [
                    Text(
                      'Lütfen size en uygun olan tarihleri seçiniz:',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    // lütfen size uygun olan tarihleri seçiniz yazısı
                    for (var meeting
                        in widget.selectedMeeting.possibleMeetingDates)
                      CheckboxListTile(
                        title: Text(meeting.toString()),
                        value: _selectedDates[widget
                            .selectedMeeting.possibleMeetingDates
                            .indexOf(meeting)],
                        onChanged: (bool? value) {
                          setState(() {
                            _selectedDates[widget
                                .selectedMeeting.possibleMeetingDates
                                .indexOf(meeting)] = value!;
                          });
                        },
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // veya müsaitseniz tarih seçiniz yazısı
              ElevatedButton.icon(
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year, 12, 31),
                  ).then((pickedDate) {
                    if (pickedDate == null) {
                      return;
                    }
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    ).then((pickedTime) {
                      if (pickedTime == null) {
                        return;
                      }
                      setState(() {
                        final dateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        meetingDateSelectedFromUser = dateTime;
                      });
                    });
                  });
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text('Veya uygun tarih seçiniz'),
              ),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context)
                      .colorScheme
                      .secondaryContainer
                      .withOpacity(0.2),
                ),
                child: meetingDateSelectedFromUser != null
                    ? ListTile(
                        contentPadding: const EdgeInsets.only(
                          left: 20,
                          right: 0,
                          top: 0,
                          bottom: 0,
                        ),
                        title: Text(
                          dateFormatter.format(meetingDateSelectedFromUser!),
                        ),
                        subtitle: Text(
                          timeFormatter.format(meetingDateSelectedFromUser!),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              meetingDateSelectedFromUser = null;
                            });
                          },
                        ),
                      )
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
