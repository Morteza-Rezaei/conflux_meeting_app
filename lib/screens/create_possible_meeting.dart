import 'package:conflux_meeting_app/screens/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  final List<String> participants = [];
  final TextEditingController _participantsController = TextEditingController();

  final List<DateTime> possibleMeetingDates = [];

  var _mTitle = '';
  var _mDescription = '';
  var _mMeetingEnteringPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Olası toplantı oluştur'),
        centerTitle: true,
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
                                child: ElevatedButton(
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
                                                setState(() {
                                                  participants.add(
                                                      _participantsController
                                                          .text);
                                                  _participantsController
                                                      .clear();
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Text('Katılımcı ekle'),
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
                            height: 250,
                            child: ListView.builder(
                              itemCount: participants.length,
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
                                child: ElevatedButton(
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
                                          possibleMeetingDates.add(dateTime);
                                        });
                                      });
                                    });
                                  },
                                  child: const Text(
                                    'olası tarhileri ekle',
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
                            height: 250,
                            child: ListView.builder(
                              itemCount: possibleMeetingDates.length,
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
                                    title: Text(dateFormatter
                                        .format(possibleMeetingDates[index])),
                                    subtitle: Text(timeFormatter
                                        .format(possibleMeetingDates[index])),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          possibleMeetingDates.removeAt(index);
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

                // Olası toplantıyı oluştur
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    final isValid = _formKey.currentState!.validate();
                    if (!isValid) {
                      return;
                    }

                    if (participants.isEmpty || possibleMeetingDates.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Lütfen en az bir katılımcı ve bir tarih ekleyiniz')),
                      );
                      return;
                    }

                    _formKey.currentState!.save();

                    debugPrint(
                        '$_mTitle, $_mDescription, $_mMeetingEnteringPassword, $participants, $possibleMeetingDates');
                    Navigator.of(context).pop();
                  },
                  child: const Text('Olası toplantıyı oluştur'),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
