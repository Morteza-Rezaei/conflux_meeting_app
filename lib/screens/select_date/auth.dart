import 'package:conflux_meeting_app/provider.dart';
import 'package:conflux_meeting_app/screens/select_date/select_section.dart';
import 'package:conflux_meeting_app/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final possibleMeetingData = Provider.of<PossibleMeetingData>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katılımcı Girişi'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Katılımcı adı ve toplantı parolasını giriniz',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
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
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (possibleMeetingData.participants
                            .contains(_usernameController.text) &&
                        possibleMeetingData.mMeetingEnteringPassword ==
                            _passwordController.text) {
                      // kullanıcı adını kaydetme
                      Provider.of<UsernameProvider>(context, listen: false)
                          .setUsername(_usernameController.text);

                      final username =
                          Provider.of<UsernameProvider>(context, listen: false)
                              .username;

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SelectSectionScreen(),
                        ),
                      );

                      debugPrint('username: $username');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Katılımcı adı veya parola hatalı!')),
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
    );
  }
}
