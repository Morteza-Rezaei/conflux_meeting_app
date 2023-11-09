import 'package:conflux_meeting_app/provider.dart';
import 'package:conflux_meeting_app/screens/select_date/select_meeting.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Meeting selectedMeeting;

  AuthScreen({required this.selectedMeeting, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (selectedMeeting.participants
                          .contains(_usernameController.text) &&
                      selectedMeeting.mMeetingEnteringPassword ==
                          _passwordController.text) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => SelectMeetingScreen(
                                selectedMeeting: selectedMeeting,
                              )),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Invalid username or password')),
                    );
                  }
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
