import 'package:conflux_meeting_app/provider.dart';
import 'package:conflux_meeting_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'color_schemes.g.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MeetingData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        home: const Home(),
      ),
    );
  }
}
