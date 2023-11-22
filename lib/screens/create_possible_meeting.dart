import 'dart:convert';

import 'package:conflux_meeting_app/provider.dart';
import 'package:conflux_meeting_app/widgets/styles.dart';
import 'package:conflux_meeting_app/widgets/text_and_textfields.dart';
import 'package:conflux_meeting_app/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class CreatePossibleMeetingScreen extends StatefulWidget {
  const CreatePossibleMeetingScreen({super.key});

  @override
  State<CreatePossibleMeetingScreen> createState() =>
      _CreatePossibleMeetingScreenState();
}

final dateFormatter = DateFormat.yMd();
final timeFormatter = DateFormat.jm();

class _CreatePossibleMeetingScreenState
    extends State<CreatePossibleMeetingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _participantsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final possibleMeetingData = Provider.of<PossibleMeetingData>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Olası toplantı oluştur'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                final isValid = _formKey.currentState!.validate();
                if (!isValid) {
                  return;
                }

                if (possibleMeetingData.participants.isEmpty ||
                    possibleMeetingData.possibleMeetingDates.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Lütfen en az bir katılımcı ve bir tarih ekleyiniz')),
                  );
                  return;
                }

                _formKey.currentState!.save();

                String password = Utils.generatePassword();
                possibleMeetingData.setMMeetingEnteringPassword(password);

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
                                  text: possibleMeetingData.mTitle,
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
                                  text: possibleMeetingData.mDescription,
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
                                  text: possibleMeetingData
                                      .mMeetingEnteringPassword,
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            child: const Text('iptal'),
                            onPressed: () {
                              _formKey.currentState!.reset();
                              possibleMeetingData.clear();
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            child: const Text('tamam'),
                            onPressed: () async {
                              _formKey.currentState!.save();
                              final url = Uri.https(
                                  'conflux-meeting-app-default-rtdb.firebaseio.com',
                                  'possible-meetings.json');

                              // Check if the meeting data already exists
                              var checkResponse = await http.get(url);
                              var existingData =
                                  json.decode(checkResponse.body);

                              // Prepare the data to be sent
                              var data = json.encode({
                                'mTitle': possibleMeetingData.mTitle,
                                'mDescription':
                                    possibleMeetingData.mDescription,
                                'mMeetingEnteringPassword': possibleMeetingData
                                    .mMeetingEnteringPassword,
                                'meetingDurationMinutes':
                                    possibleMeetingData.meetingDurationMinutes,
                                'participants':
                                    possibleMeetingData.participants.toList(),
                                'possibleMeetingDates': possibleMeetingData
                                    .possibleMeetingDates
                                    .map((e) => e.toIso8601String())
                                    .toList(),
                              });

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
                            },
                          ),
                        ],
                      );
                    });
                // ).then((_) {
                //   Navigator.of(context).pop();
                // });
              },
              icon: const Icon(Icons.send_rounded),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),
                // toplanı başlığı
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
                      possibleMeetingData.setMTitle(newValue!);
                    },
                  ),
                ),

                const SizedBox(height: 15),

                // toplantı açıklaması
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
                    possibleMeetingData.setMDescription(newValue!);
                  },
                ),

                const SizedBox(height: 15),

                // toplantı süresi ekle
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
                      possibleMeetingData
                          .setMeetingDurationMinutes(int.parse(newValue!));
                    },
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Katılımcılar
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
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
                                                if (_participantsController
                                                    .text.isEmpty) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Lütfen katılımcı adını giriniz'),
                                                    ),
                                                  );
                                                }
                                                if (possibleMeetingData
                                                    .participants
                                                    .contains(
                                                        _participantsController
                                                            .text)) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Bu katılımcı zaten ekli'),
                                                    ),
                                                  );
                                                  return;
                                                }
                                                if (_participantsController
                                                    .text.isNotEmpty) {
                                                  setState(() {
                                                    possibleMeetingData
                                                        .addParticipant(
                                                            _participantsController
                                                                .text);
                                                    _participantsController
                                                        .clear();
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
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer
                                  .withOpacity(0.2),
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  possibleMeetingData.participants.length,
                              itemBuilder: (context, index) {
                                return Container(
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
                                    title: Text(possibleMeetingData
                                        .participants[index]),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          possibleMeetingData.participants
                                              .removeAt(index);
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    // Tarhiler
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate:
                                          DateTime(DateTime.now().year, 12, 31),
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
                                          if (possibleMeetingData
                                              .possibleMeetingDates
                                              .contains(dateTime)) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content:
                                                    Text('Bu Tarih zaten ekli'),
                                              ),
                                            );
                                            return;
                                          }
                                          possibleMeetingData
                                              .addPossibleMeetingDate(dateTime);
                                        });
                                      });
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.calendar_today,
                                    size: 20,
                                  ),
                                  label: const Text(
                                    'olası tarhileri ekle',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer
                                  .withOpacity(0.2),
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: possibleMeetingData
                                  .possibleMeetingDates.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.only(
                                      left: 10,
                                      right: 0,
                                      top: 0,
                                      bottom: 0,
                                    ),
                                    dense: true,
                                    title: Text(dateFormatter.format(
                                        possibleMeetingData
                                            .possibleMeetingDates[index])),
                                    subtitle: Text(timeFormatter.format(
                                        possibleMeetingData
                                            .possibleMeetingDates[index])),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          possibleMeetingData
                                              .possibleMeetingDates
                                              .removeAt(index);
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
