import 'package:flutter/material.dart';

InputDecoration myInputDecoration(String labelText) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    labelText: labelText,
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(25)),
    ),
  );
}
