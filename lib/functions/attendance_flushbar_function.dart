import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:militarymessenger/pages/attendance_page.dart';
import 'package:militarymessenger/controllers/state_controllers.dart';

class AttendanceFlushbarFunction {
  final StateController _stateController = Get.put(StateController());
  
  void showAttendanceNotif(BuildContext context, bool error, String? type, String title, String message) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      titleText: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
        ),
      ),
      messageText: Padding(
        padding: const EdgeInsets.only(
          left: 0.0,
        ),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 13.0,
          ),
        ),
      ),
      icon: Padding(
        padding: const EdgeInsets.only(
          left: 4,
        ),
        child: Icon(
          error == false ? type == 'in' ? Icons.login_rounded : Icons.logout_rounded : Icons.error_rounded,
          size: 28.0,
          color: error == false ? type == 'in' ? Colors.blue : Colors.grey : Colors.red,
        ),
      ),
      leftBarIndicatorColor: error == false ? type == 'in' ? Colors.blue : Colors.grey : Colors.red,
      padding: const EdgeInsets.only(
        top: 11.0,
        bottom: 14.0,
      ),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(5),
      backgroundColor: Theme.of(context).cardColor,
      boxShadows: const [
        BoxShadow(
          color: Colors.black26,
          offset: Offset(0.0, 2.5), 
          blurRadius: 3.0,
        ),
      ],
      duration: const Duration(seconds: 5),
      onTap: (Flushbar<dynamic> flushbar) {
        if (error == false && _stateController.inAttendance.value == false) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AttendancePage()),
          );
        }

        flushbar.dismiss(true);
      },
    ).show(context);
  }

  void showAttendanceError(BuildContext context, String title, String message) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      titleText: const Text(
        'Info',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
        ),
      ),
      messageText: Padding(
        padding: const EdgeInsets.only(
          left: 0.0,
        ),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 13.0,
          ),
        ),
      ),
      icon: const Padding(
        padding: EdgeInsets.only(
          left: 4,
        ),
        child: Icon(
          Icons.info,
          size: 28.0,
          color: Colors.blue,
        ),
      ),
      padding: const EdgeInsets.only(
        top: 11.0,
        bottom: 14.0,
      ),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(5),
      backgroundColor: Theme.of(context).cardColor,
      boxShadows: const [
        BoxShadow(
          color: Colors.black26,
          offset: Offset(0.0, 2.5), 
          blurRadius: 3.0,
        ),
      ],
      duration: const Duration(seconds: 5),
      onTap: (Flushbar<dynamic> flushbar) {
        if (_stateController.inAttendance.value == false) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AttendancePage()),
          );
        }

        flushbar.dismiss(true);
      },
    ).show(context);
  }
}