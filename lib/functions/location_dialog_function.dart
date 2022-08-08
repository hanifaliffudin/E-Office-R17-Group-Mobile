 import 'package:flutter/material.dart';

class LocationDialogFunction {
  void locationPermissionDialog(BuildContext context, Function denyOnPressed, Function acceptOnPressed) {
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          titlePadding: const EdgeInsets.only(
            top: 23.0,
            right: 25.0,
            left: 25.0,
            bottom: 0.0,
          ),
          contentPadding: const EdgeInsets.only(
            top: 24.0,
            right: 25.0,
            left: 25.0,
            bottom: 7.0,
          ),
          actionsPadding: const EdgeInsets.only(bottom: 7.0),
          title: const Text(
            'Access Permission',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            '"R17 eOffice" collect location data to enable feature "Attendance" to detect user attendance in the approved perimeter. Feature "Attendance" will collect location data even when the app is closed or not in use.',
          ),
          // content: Container(
          //   child: RichText(
          //     text: const TextSpan(
          //       children: [
          //         TextSpan(
          //           text: 'R17 eOffice ',
          //           style: TextStyle(
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //         TextSpan(
          //           text: 'collect location data to enable feature',
          //         ),
          //         TextSpan(
          //           text: 'Attendance ',
          //           style: TextStyle(
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //         TextSpan(
          //           text: 'to detect user attendance in the approved perimeter. Feature'
          //         ),
          //         TextSpan(
          //           text: 'Attendance',
          //           style: TextStyle(
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //         TextSpan(
          //           text: 'will collect location data even when the app is closed or not in use.',
          //         )
          //       ]
          //     ),
          //   ),
          // ),
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
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void locAttOffDialog(BuildContext context, Function denyOnPressed, Function acceptOnPressed) {
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          titlePadding: const EdgeInsets.only(
            top: 23.0,
            right: 25.0,
            left: 25.0,
            bottom: 0.0,
          ),
          contentPadding: const EdgeInsets.only(
            top: 23.0,
            right: 25.0,
            left: 25.0,
            bottom: 7.0,
          ),
          actionsPadding: const EdgeInsets.only(bottom: 7.0),
          title: const Text(
            'Warning',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'R17 eOffice will stop collecting your location and will not able to use feature Attendance then you will be check out automatically.',
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
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}