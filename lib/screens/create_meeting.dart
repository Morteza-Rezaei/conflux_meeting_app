import 'package:conflux_meeting_app/provider.dart';
import 'package:conflux_meeting_app/widgets/styles.dart';
import 'package:conflux_meeting_app/widgets/text_and_textfields.dart';
import 'package:conflux_meeting_app/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:table_calendar/table_calendar.dart';

class CreateMeetingScreen extends StatefulWidget {
  const CreateMeetingScreen({super.key});

  @override
  State<CreateMeetingScreen> createState() => _CreateMeetingScreenState();
}

final dateFormatter = DateFormat.yMd();
final timeFormatter = DateFormat.jm();

class _CreateMeetingScreenState extends State<CreateMeetingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _participantsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final newMeetingData = Provider.of<NewMeetingData>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Toplantı Oluştur'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.send_rounded),
              onPressed: () {
                final isValid = _formKey.currentState!.validate();
                if (!isValid) {
                  return;
                }

                if (newMeetingData.meetingDate == null ||
                    newMeetingData.participants.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Lütfen en az bir katılımcı ve bir tarih ekleyiniz'),
                    ),
                  );
                  return;
                }

                _formKey.currentState!.save();

                String password = Utils.generatePassword();
                newMeetingData.setMMeetingEnteringPassword(password);

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.all(10),
                      title: const Text('Toplantı oluşturulacak'),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer
                                    .withOpacity(1),
                              ),
                              child: ConfirmationMeetingRow(
                                icon: Icons.event_rounded,
                                title: 'Başlık:  ',
                                text: newMeetingData.mTitle,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer
                                    .withOpacity(1),
                              ),
                              child: ConfirmationMeetingRow(
                                icon: Icons.description_rounded,
                                title: 'Açıklama:  ',
                                text: newMeetingData.mDescription,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer
                                    .withOpacity(1),
                              ),
                              child: ConfirmationMeetingRow(
                                icon: Icons.key_rounded,
                                title: 'Şifre:  ',
                                text: newMeetingData.mMeetingEnteringPassword,
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          child: const Text('iptal'),
                          onPressed: () {
                            newMeetingData.clear();
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          child: const Text('tamam'),
                          onPressed: () async {
                            final url = Uri.https(
                                'conflux-meeting-app-default-rtdb.firebaseio.com',
                                'new-meeting.json');

                            // Check if the meeting data already exists
                            var checkResponse = await http.get(url);
                            var existingData = json.decode(checkResponse.body);

                            // Prepare the data to be sent
                            var data = json.encode({
                              'mTitle': newMeetingData.mTitle,
                              'mDescription': newMeetingData.mDescription,
                              'mMeetingEnteringPassword':
                                  newMeetingData.mMeetingEnteringPassword,
                              'meetingDurationMinutes':
                                  newMeetingData.meetingDurationMinutes,
                              'participants':
                                  newMeetingData.participants.toList(),
                              'MeetingDate':
                                  newMeetingData.meetingDate!.toIso8601String(),
                            });

                            // ignore: prefer_typing_uninitialized_variables
                            var response;
                            if (existingData != null) {
                              // If the meeting data exists, make a PUT request to update it
                              response = await http.put(
                                url,
                                headers: {'Content-Type': 'application/json'},
                                body: data,
                              );
                            } else {
                              // If the meeting data doesn't exist, make a POST request to create it
                              response = await http.post(
                                url,
                                headers: {'Content-Type': 'application/json'},
                                body: data,
                              );
                            }

                            if (response.statusCode == 200) {
                              // Request successful, handle the response if needed.
                            } else {
                              // Request failed, handle the error.
                            }

                            newMeetingData.clear();

                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                ).then((_) {
                  Navigator.of(context).pop();
                });
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // meeting title
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    decoration: myInputDecoration('Toplantı başlığı'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen toplantı başlığını giriniz';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      newMeetingData.setMTitle(newValue!);
                    },
                  ),
                ),

                const SizedBox(height: 8),

                // meeting description
                TextFormField(
                  maxLines: 4,
                  decoration: myInputDecoration('Toplantı açıklaması'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen toplantı açıklamasını giriniz';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    newMeetingData.setMDescription(newValue!);
                  },
                ),

                const SizedBox(height: 8),

                // meeting duration
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: myInputDecoration('Toplantı süresi (dakika)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen toplantı süresini giriniz';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Lütfen geçerli bir sayı giriniz';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      newMeetingData
                          .setMeetingDurationMinutes(int.parse(newValue!));
                    },
                  ),
                ),

                const SizedBox(height: 10),

                TableCalendar(
                  locale: 'tr_TR',
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiaryContainer,
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
                    return newMeetingData.meetingDate != null &&
                        isSameDay(newMeetingData.meetingDate!, day);
                  },
                  eventLoader: (day) {
                    return newMeetingData.meetingDate != null &&
                            isSameDay(newMeetingData.meetingDate!, day)
                        ? [day]
                        : [];
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    ).then(
                      (pickedTime) {
                        if (pickedTime == null) {
                          return;
                        }

                        setState(() {
                          final dateTime = DateTime(
                            selectedDay.year,
                            selectedDay.month,
                            selectedDay.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );

                          newMeetingData.setMeetingDate(dateTime);
                        });
                      },
                    );
                  },
                ),

                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text(
                    'Seçilen tarih :',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),

                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context)
                        .colorScheme
                        .secondaryContainer
                        .withOpacity(0.2),
                  ),
                  child: newMeetingData.meetingDate == null
                      ? const Center(child: Text('Lütfen bir tarih seçiniz'))
                      : Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.only(
                              left: 10,
                              right: 0,
                              top: 0,
                              bottom: 0,
                            ),
                            dense: true,
                            title: Text(dateFormatter
                                .format(newMeetingData.meetingDate!)),
                            subtitle: Text(timeFormatter
                                .format(newMeetingData.meetingDate!)),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  newMeetingData.setMeetingDate(null);
                                });
                              },
                            ),
                          ),
                        ),
                ),

                const SizedBox(height: 8),

                TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Katılımcı Ekle'),
                          content: TextField(
                            controller: _participantsController,
                            decoration: const InputDecoration(
                              labelText: 'Katılımcı adı',
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text('İptal'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Ekle'),
                              onPressed: () {
                                if (_participantsController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Lütfen katılımcı adını giriniz'),
                                    ),
                                  );
                                }
                                if (newMeetingData.participants
                                    .contains(_participantsController.text)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Bu katılımcı zaten ekli'),
                                    ),
                                  );
                                  return;
                                }
                                if (_participantsController.text.isNotEmpty) {
                                  setState(() {
                                    newMeetingData.addParticipant(
                                        _participantsController.text);
                                    _participantsController.clear();
                                  });
                                }

                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.person_add,
                    size: 20,
                  ),
                  label: const Text(
                    'Katılımcı ekle',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context)
                        .colorScheme
                        .secondaryContainer
                        .withOpacity(0.2),
                  ),
                  child: newMeetingData.participants.isEmpty
                      ? const Center(
                          child: Text(
                          'Lütfen en az bir katılımcı ekleyiniz',
                        ))
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: newMeetingData.participants.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 190,
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer),
                              child: ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.only(
                                  left: 10,
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                ),
                                title: Text(
                                  newMeetingData.participants[index],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      newMeetingData.participants
                                          .removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
