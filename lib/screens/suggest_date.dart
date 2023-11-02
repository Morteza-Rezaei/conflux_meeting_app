import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SuggestDateScreen extends StatefulWidget {
  const SuggestDateScreen({super.key});

  @override
  State<SuggestDateScreen> createState() => _SuggestDateScreenState();
}

final formatter = DateFormat.yMd();

class _SuggestDateScreenState extends State<SuggestDateScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<String> participants = [];
  final TextEditingController _dateController = TextEditingController();

  var _mTitle = '';
  var _mDescription = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Olası toplantı oluştur'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // meeting title
                TextFormField(
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    labelText: 'Toplantı başlığı',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                  ),
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

                const SizedBox(height: 10),

                // meeting description
                TextFormField(
                  maxLines: 2,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    labelText: 'Toplantı açıklaması',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                  ),
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

                const SizedBox(height: 10),

                // to add participants to the meeting
                TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    labelText: 'katılımcılar',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      participants.add(_dateController.text);
                      _dateController.clear();
                    });
                  },
                  child: const Text('katılımcı ekle'),
                ),

                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey[300],
                    ),
                    height: 200,
                    child: ListView.builder(
                      itemCount: participants.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey[400],
                          ),
                          child: ListTile(
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
                    )),

                // submit button
                ElevatedButton(
                  onPressed: () {
                    final isValid = _formKey.currentState!.validate();
                    if (!isValid) {
                      return;
                    }
                    _formKey.currentState!.save();
                    debugPrint('$_mTitle, $_mDescription');
                  },
                  child: const Text('Olası toplantıyı göster'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
