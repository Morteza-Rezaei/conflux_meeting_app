import 'package:conflux_meeting_app/provider.dart';
import 'package:conflux_meeting_app/screens/select_date/select_section.dart';
import 'package:conflux_meeting_app/screens/splash.dart';
import 'package:conflux_meeting_app/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SelectDateAuthScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SelectDateAuthScreen({super.key});

  Future<Map<String, dynamic>> fetchMeetingData() async {
    final url = Uri.https('conflux-meeting-app-default-rtdb.firebaseio.com',
        'possible-meetings.json');
    // Make a GET request to fetch the meeting data
    var response = await http.get(url);

    // Decode the response
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchMeetingData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var meetingData = snapshot.data;
          var participants = meetingData?['participants'];
          var password = meetingData?['mMeetingEnteringPassword'];
          return Scaffold(
            appBar: AppBar(
              title: const Text('Katılımcı Girişi'),
            ),
            body: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 80),
                        child: Image.asset(
                          'assets/conflux_logo2.png',
                          fit: BoxFit.contain,
                          width: 200,
                        ),
                      ),
                      // informative text
                      Text(
                        'Katılımcı adı ve toplantı parolasını giriniz',
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      // username input
                      TextFormField(
                        controller: _usernameController,
                        decoration: myInputDecoration('Katılımcı Adı'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lutfen kullanici adınızı giriniz';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // password input
                      TextFormField(
                        controller: _passwordController,
                        decoration: myInputDecoration('Toplantı Parolası'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lutfen toplantı parolasını giriniz';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      // submit button
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (participants
                                    .contains(_usernameController.text) &&
                                password == _passwordController.text) {
                              // save username to provider
                              Provider.of<UsernameProvider>(context,
                                      listen: false)
                                  .setUsername(_usernameController.text);

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SelectSectionScreen(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Katılımcı adı veya parola hatalı!')),
                              );
                            }
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
