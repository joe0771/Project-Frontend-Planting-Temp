import 'package:flutter/material.dart';

class ButtonLogoutScreen extends StatelessWidget {
  const ButtonLogoutScreen({Key? key, required this.onPressed, required this.heroTag}) : super(key: key);

  final VoidCallback onPressed;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: 80.0,
        width: 80.0,
        child: FloatingActionButton(
          heroTag: heroTag,
          backgroundColor: Colors.red,
          onPressed: onPressed,
          child: const Icon(
            Icons.power_settings_new_rounded,
            size: 60.0,
          ),
        ),
      ),
    );
  }
}