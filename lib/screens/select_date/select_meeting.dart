import 'package:conflux_meeting_app/provider.dart';
import 'package:flutter/material.dart';

class SelectMeetingScreen extends StatefulWidget {
  final Meeting selectedMeeting;
  const SelectMeetingScreen({super.key, required this.selectedMeeting});

  @override
  State<SelectMeetingScreen> createState() => _SelectMeetingScreenState();
}

class _SelectMeetingScreenState extends State<SelectMeetingScreen> {
  List<bool> _selectedDates = [];

  @override
  void initState() {
    super.initState();
    _selectedDates = List.generate(
        widget.selectedMeeting.possibleMeetingDates.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedMeeting.mTitle),
      ),
      body: Column(
        children: [
          for (var meeting in widget.selectedMeeting.possibleMeetingDates)
            CheckboxListTile(
              title: Text(meeting.toString()),
              value: _selectedDates[
                  widget.selectedMeeting.possibleMeetingDates.indexOf(meeting)],
              onChanged: (bool? value) {
                setState(() {
                  _selectedDates[widget.selectedMeeting.possibleMeetingDates
                      .indexOf(meeting)] = value!;
                });
              },
            ),
        ],
      ),
    );
  }
}
