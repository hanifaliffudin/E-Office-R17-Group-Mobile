 import 'package:flutter/material.dart';

void locationPermissionDialog(BuildContext context, Function denyOnPressed, Function acceptOnPressed) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        'Access Permission',
        textAlign: TextAlign.center,
      ),
      content: const Text(
        'R17 eOffice collects location data to enable Attendance even when the apps is closed or not in use.',
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () => denyOnPressed(),
              child: const Text(
                'Deny',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            TextButton(
              onPressed: () => acceptOnPressed(),
              child: const Text(
                'Accept',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}