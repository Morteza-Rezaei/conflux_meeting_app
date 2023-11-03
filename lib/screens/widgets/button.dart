import 'package:flutter/material.dart';

class MyHomeElevatedButton extends StatelessWidget {
  const MyHomeElevatedButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    Key? key,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Icon icon;
  final Text label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: label,
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 30),
          ),
          alignment: Alignment.center,
          fixedSize: MaterialStateProperty.all(const Size(300, 80)),
        ),
      ),
    );
  }
}
