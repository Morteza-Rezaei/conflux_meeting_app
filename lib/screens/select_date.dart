import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conflux_meeting_app/provider.dart'; // Import your MeetingData provider

class SelectDateScreen extends StatefulWidget {
  const SelectDateScreen({super.key});

  @override
  State<SelectDateScreen> createState() => _SelectDateScreenState();
}

class _SelectDateScreenState extends State<SelectDateScreen> {
  @override
  Widget build(BuildContext context) {
    final toplantiB = Provider.of<MeetingData>(
        context); // Get MeetingData instance from Provider

    return Scaffold(
      body: Center(
          child: Text(
              '${toplantiB.mTitle} - ${toplantiB.mDescription} - ${toplantiB.mMeetingEnteringPassword} - ${toplantiB.participants} - ${toplantiB.possibleMeetingDates}')),
    );
  }
}
