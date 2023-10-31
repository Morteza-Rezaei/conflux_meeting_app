import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SuggestDateScreen extends StatefulWidget {
  const SuggestDateScreen({super.key});

  @override
  State<SuggestDateScreen> createState() => _SuggestDateScreenState();
}

final formatter = DateFormat.yMd();

class _SuggestDateScreenState extends State<SuggestDateScreen> {
  DateTime? _selectedDate;
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toplantı Tarihleri Oluştur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // toplantı konusu
            const TextField(
              decoration: InputDecoration(
                labelText: 'Toplantı Konusu',
              ),
            ),

            // toplantı açıklaması
            TextField(
              decoration: InputDecoration(
                labelText: 'Toplantı Açıklaması',
              ),
            ),

            // toplantı için olası tarihler
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _selectedDate == null
                      ? 'No date selected'
                      : formatter.format(_selectedDate!),
                ),
                IconButton(
                  onPressed: _presentDatePicker,
                  icon: const Icon(Icons.calendar_month),
                ),
              ],
            ),

            // gönder butonu
          ],
        ),
      ),
    );
  }
}
