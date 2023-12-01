import 'package:conflux_meeting_app/provider.dart';
import 'package:conflux_meeting_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'color_schemes.g.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PossibleMeetingData()),
        ChangeNotifierProvider(create: (context) => UsernameProvider()),
        ChangeNotifierProvider(create: (context) => UserMeetingDatesProvider()),
        ChangeNotifierProvider(create: (context) => NewMeetingData()),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('tr', 'TR'),
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        home: const Home(),
      ),
    );
  }
}
