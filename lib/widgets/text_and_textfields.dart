import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConfirmationMeetingRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const ConfirmationMeetingRow(
      {super.key, required this.icon, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 5),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            text,
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ),
        IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text)).then((value) =>
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text('${title.replaceAll(':', '')} Kopyalandı'))));
            },
            icon: const Icon(Icons.copy_rounded)),
      ],
    );
  }
}
