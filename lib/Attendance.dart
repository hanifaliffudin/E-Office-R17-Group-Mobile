import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:militarymessenger/controllers/state_controllers.dart';
import 'package:militarymessenger/functions/permission_dialog_function.dart';
import 'package:militarymessenger/models/AttendanceModel.dart';
import 'package:militarymessenger/objectbox.g.dart';
import 'package:militarymessenger/utils/sp_util.dart';
import 'main.dart' as mains;
import 'Home.dart' as homes;

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final StateController _stateController = Get.put(StateController());
  List<AttendanceModel> _attedanceList = [];

  @override
  void initState() {
    super.initState();
    
    _stateController.changeInAttendance(true);
  }

  @override
  void dispose() {
    _stateController.changeInAttendance(false);

    super.dispose();
  }

  void _activeOnChange(bool value) async {
    if (value) {
      locationPermissionDialog(
        context, 
        () async {
          Navigator.of(context).pop();
          await SpUtil.instance.setBoolValue('locationPermission', false);
          _stateController.locationPermission(false);
        }, 
        () async {
          Navigator.of(context).pop();
          await SpUtil.instance.setBoolValue('locationPermission', true);
          _stateController.locationPermission(true);
        }
      );
    } else {
      await SpUtil.instance.setBoolValue('locationPermission', false);
      _stateController.locationPermission(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor:
            Theme.of(context).floatingActionButtonTheme.backgroundColor,
        title: Text(
          'Attendance'.toUpperCase(),
          style: const TextStyle(fontSize: 15),
        ),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Obx(() => Switch(
              value: _stateController.locationPermission.value, 
              onChanged: (bool value) => _activeOnChange(value),
            )),
          ),
        ],
      ),
      body: StreamBuilder<List<AttendanceModel>>(
        stream: homes.listControlerAttendance.stream,
        builder: (context, snapshot) {
          QueryBuilder<AttendanceModel> query = mains.objectbox.boxAttendance.query()..order(
            AttendanceModel_.checkInAt, 
            flags: Order.descending,
          );
          _attedanceList = query.build().find().toList();

          return ListView.builder(
            padding: const EdgeInsets.only(
              top: 10, 
              bottom: 15, 
              right: 15, 
              left: 15
            ),
            itemCount: _attedanceList.length,
            itemBuilder: ((context, index) {
              return InkWell(
                onTap: () {
                  // Navigator.push(context,
                  //   MaterialPageRoute(builder: (context) => DocumentPage()),
                  // );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  shadowColor: Colors.black,
                  child: ClipPath(
                    clipper: ShapeBorderClipper(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: _attedanceList[index].status == 1 ? Colors.blue : Colors.grey, 
                            width: 10,
                          ),
                        ),
                        color: Theme.of(context).cardColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14.0,
                          horizontal: 12.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text(
                                    DateFormat('EEEE').format(DateTime.parse(_attedanceList[index].checkInAt!)),
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      // color: Colors.grey.shade700,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('dd MMMM yyyy').format(DateTime.parse(_attedanceList[index].checkInAt!)),
                                    // '31 December 2022',
                                    style: const TextStyle(
                                      fontSize: 13.0,
                                      // color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 170.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 7.0,
                                    ),
                                    child: Row(
                                      children: [
                                        const Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Check in',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontSize: 13.5,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 88.0,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10.0),
                                            child: Text(
                                              DateFormat('HH:mm').format(DateTime.parse(_attedanceList[index].checkInAt!)),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Expanded(
                                        flex: 1,
                                        child: Text(
                                          'Check out',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            fontSize: 13.5,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 88.0,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            _attedanceList[index].status == 0 ? DateFormat('HH:mm').format(DateTime.parse(_attedanceList[index].checkOutAt!)) : '-',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            _attedanceList[index].status == 1 ? const Icon(
                              Icons.login_rounded,
                              color: Colors.blue,
                              size: 24,
                            ) : const Icon(
                              Icons.logout_rounded,
                              color: Colors.grey,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
