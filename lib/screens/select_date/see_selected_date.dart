import 'package:conflux_meeting_app/provider.dart';
import 'package:flutter/material.dart';

class SeeSelectedDateScreen extends StatelessWidget {
  const SeeSelectedDateScreen({super.key, required this.selectedMeeting});

  final Meeting selectedMeeting;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('seçilen tarihler burada gösterilecek'),
      ),
    );
  }
}
