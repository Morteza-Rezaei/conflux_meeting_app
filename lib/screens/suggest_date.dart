import 'package:flutter/material.dart';

class SuggestDateScreen extends StatefulWidget {
  const SuggestDateScreen({super.key});

  @override
  State<SuggestDateScreen> createState() => _SuggestDateScreenState();
}

class _SuggestDateScreenState extends State<SuggestDateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suggest Meeting Dates'),
      ),
    );
  }
}
