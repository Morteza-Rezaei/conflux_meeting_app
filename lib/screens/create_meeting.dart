import 'package:conflux_meeting_app/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateMeetingScreen extends StatefulWidget {
  const CreateMeetingScreen({super.key});

  @override
  State<CreateMeetingScreen> createState() => _CreateMeetingScreenState();
}

final dateFormatter = DateFormat.yMd();
final timeFormatter = DateFormat.jm();

class _CreateMeetingScreenState extends State<CreateMeetingScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<String> participants = [];
  final TextEditingController _participantsController = TextEditingController();

  DateTime? meetingDate;

  var _mTitle = '';
  var _mDescription = '';
  var _mMeetingEnteringPassword = '';

  @override
  Widget build(BuildContext context) {
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

                if (participants.isEmpty || meetingDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Lütfen en az bir katılımcı ve bir tarih ekleyiniz')),
                  );
                  return;
                }

                _formKey.currentState!.save();

                debugPrint(
                    '$_mTitle, $_mDescription, $_mMeetingEnteringPassword, $participants, $meetingDate');
                Navigator.of(context).pop();
              },
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
                      _mTitle = newValue!;
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
                    _mDescription = newValue!;
                  },
                ),

                const SizedBox(height: 15),

                // Parola ekle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    decoration: myInputDecoration('Toplantı parolası'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen toplantı giriş şifresini giriniz';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _mMeetingEnteringPassword = newValue!;
                    },
                  ),
                ),

                const SizedBox(height: 30),

                // tarih ve zamanı ekle
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
                          meetingDate = dateTime;
                        });
                      });
                    });
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: const Text(
                    'Tarih ve zaman ekle',
                  ),
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
                  width: 300,
                  child: meetingDate != null
                      ? ListTile(
                          contentPadding: const EdgeInsets.only(
                            left: 10,
                            right: 0,
                            top: 0,
                            bottom: 0,
                          ),
                          dense: true,
                          title: Text(dateFormatter.format(meetingDate!)),
                          subtitle: Text(timeFormatter.format(meetingDate!)),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                meetingDate = null;
                              });
                            },
                          ),
                        )
                      : Container(),
                ),

                const SizedBox(height: 15),

                // katılımcı ekle
                ElevatedButton.icon(
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
                                if (participants
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
                                    participants
                                        .add(_participantsController.text);
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
                  icon: const Icon(Icons.person_add),
                  label: const Text('Katılımcı ekle'),
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
                  width: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: participants.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color:
                                Theme.of(context).colorScheme.primaryContainer),
                        child: ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.only(
                            left: 10,
                            right: 0,
                            top: 0,
                            bottom: 0,
                          ),
                          title: Text(participants[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                participants.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
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
