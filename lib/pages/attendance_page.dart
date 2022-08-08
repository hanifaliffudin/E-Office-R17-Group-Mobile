import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:militarymessenger/controllers/state_controllers.dart';
import 'package:militarymessenger/functions/attendance_flushbar_function.dart';
import 'package:militarymessenger/functions/attendance_function.dart';
import 'package:militarymessenger/functions/index_function.dart';
import 'package:militarymessenger/functions/location_dialog_function.dart';
import 'package:militarymessenger/models/AttendanceHistoryModel.dart';
import 'package:militarymessenger/models/AttendanceModel.dart';
import 'package:militarymessenger/models/UserModel.dart';
import 'package:militarymessenger/models/savedModel.dart';
import 'package:militarymessenger/objectbox.g.dart';
import 'package:militarymessenger/services/attendance_service.dart';
import 'package:militarymessenger/services/index_service.dart';
import '../main.dart' as mains;
import '../Home.dart' as homes;
import '../models/AttendanceLocationModel.dart';
import 'package:collection/collection.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final _indexService = IndexService();
  final _attendanceFunction = AttendanceFunction();
  final _attendanceService = AttendanceService();
  final _locationDialogFunc = LocationDialogFunction();
  final _attendanceFlushbarFunc = AttendanceFlushbarFunction();
  Location location = Location();
  final StateController _stateController = Get.put(StateController());
  List<AttendanceLocationModel> _attLocs = [];
  bool _attendanceLoading = false;

  @override
  void initState() {
    super.initState();
    
    _attLocs = mains.objectbox.boxAttendanceLocation
      .query()
      .build()
      .find()
      .toList();
    _stateController.changeInAttendance(true);
  }

  @override
  void dispose() {
    _stateController.changeInAttendance(false);

    super.dispose();
  }

  void _locationPermissionOnChange(bool value) async {
    if (value) {
      var queryLocationPermission = mains.objectbox.boxSaved
        .query(SavedModel_.type.equals('locationPermission'))
        .build()
        .find();
      SavedModel saved = SavedModel();

      _locationDialogFunc.locationPermissionDialog(
        context, 
        () async {
          Navigator.pop(context);

          if (queryLocationPermission.isNotEmpty) {
            saved = queryLocationPermission.first;
            saved.value = false;
          } else {
            saved = SavedModel(
              type: 'locationPermission',
              value: false,
            );
          }

          mains.objectbox.boxSaved.put(saved);
          _stateController.changeLocationPermission(false);
        }, 
        () async {
          Navigator.pop(context);

          if (queryLocationPermission.isNotEmpty) {
            saved = queryLocationPermission.first;
            saved.value = true;
          } else {
            saved = SavedModel(
              type: 'locationPermission',
              value: true,
            );
          }

          mains.objectbox.boxSaved.put(saved);
          _stateController.changeLocationPermission(true);
        }
      );
    } else {
      _locationDialogFunc.locAttOffDialog(
        context,
        () {
          Navigator.pop(context);
        },
        () async {
          Map<String, dynamic> dateTimeMap = await _indexService.getDateTime();

          if (!dateTimeMap['error']) {
            Map<String, dynamic> bodyDateTimeMap = dateTimeMap['body'];
            DateTime now = DateTime.parse(bodyDateTimeMap['data']);
            var query = mains.objectbox.boxAttendance
              .query(
                AttendanceModel_.date.equals(DateFormat('dd MM yyyy').format(now))
              )
              .build()
              .find();

            if (query.isNotEmpty) {
              AttendanceModel attendance = query.first;

              if (attendance.status == 1) {
                UserModel user = mains.objectbox.boxUser.get(1)!;
                Map<String, dynamic> saveAttendanceMap = await _attendanceService.saveAttendance(
                  user.userId!, 
                  attendance,
                  false,
                );

                attendance.checkOutAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                attendance.status = 0;
                attendance.server = false;

                if (!saveAttendanceMap['error']) {
                  _stateController.changeLocationPermission(false);
                  Navigator.pop(context);

                  var queryLocationPermission = mains.objectbox.boxSaved
                    .query(SavedModel_.type.equals('locationPermission'))
                    .build()
                    .find();
                  SavedModel saved = SavedModel();

                  if (queryLocationPermission.isNotEmpty) {
                    saved = queryLocationPermission.first;
                    saved.value = false;
                  } else {
                    saved = SavedModel(
                      type: 'locationPermission',
                      value: false,
                    );
                  }

                  mains.objectbox.boxSaved.put(saved);

                  Map<String, dynamic> bodySaveAttendanceMap = saveAttendanceMap['body'];
                  var attendanceHistory = AttendanceHistoryModel(
                    date: attendance.date,
                    latitude: attendance.latitude,
                    longitude: attendance.longitude,
                    datetime: attendance.status == 1 ? attendance.checkInAt : attendance.checkOutAt,
                    status: attendance.status,
                    server: attendance.server,
                    idLocationDb: attendance.idLocationDb,
                  );

                  if (bodySaveAttendanceMap['data'] != null) {
                    if (bodySaveAttendanceMap['data']['check_out'] != null) {
                      attendance.date = DateFormat('dd MM yyyy').format(DateTime.parse(bodySaveAttendanceMap['data']['check_out']));
                      attendance.checkOutAt = bodySaveAttendanceMap['data']['check_out'];
                      attendanceHistory.datetime = bodySaveAttendanceMap['data']['check_out'];
                    }
                  }

                  attendance.server = true;
                  attendanceHistory.server = true;
                  mains.objectbox.boxAttendance.put(attendance);
                  mains.objectbox.boxAttendanceHistory.put(attendanceHistory);
                  _attendanceFlushbarFunc.showAttendanceNotif(
                    context, 
                    false, 
                    'out', 
                    'Attendance', 
                    'Check out at: ${DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(attendanceHistory.datetime!))}',
                  );
                }
              } else {
                _stateController.changeLocationPermission(false);
                Navigator.pop(context);

                var queryLocationPermission = mains.objectbox.boxSaved
                  .query(SavedModel_.type.equals('locationPermission'))
                  .build()
                  .find();
                SavedModel saved = SavedModel();

                if (queryLocationPermission.isNotEmpty) {
                  saved = queryLocationPermission.first;
                  saved.value = false;
                } else {
                  saved = SavedModel(
                    type: 'locationPermission',
                    value: false,
                  );
                }

                mains.objectbox.boxSaved.put(saved);
              }
            } else {
              _stateController.changeLocationPermission(false);
              Navigator.pop(context);

              var queryLocationPermission = mains.objectbox.boxSaved
                .query(SavedModel_.type.equals('locationPermission'))
                .build()
                .find();
              SavedModel saved = SavedModel();

              if (queryLocationPermission.isNotEmpty) {
                saved = queryLocationPermission.first;
                saved.value = false;
              } else {
                saved = SavedModel(
                  type: 'locationPermission',
                  value: false,
                );
              }

              mains.objectbox.boxSaved.put(saved);
            }
          }
        },
      );
    }
  }

  List<Map<String, dynamic>> _getDetailAtts(AttendanceModel attendance) {
    List<Map<String, dynamic>> detailAtts = [];
    
    if (attendance.idLocationDb != null) {
      var queryAttHis = mains.objectbox.boxAttendanceHistory
        .query(
          AttendanceHistoryModel_.datetime.equals(attendance.checkInAt!),
        )
        .build()
        .find();
      
      if (queryAttHis.isNotEmpty) {
        AttendanceHistoryModel attHis = queryAttHis.first;

        if (attHis.idLocationDb == null) {
          attHis.idLocationDb = attendance.idLocationDb;

          mains.objectbox.boxAttendanceHistory.put(attHis);
        }
      }
    }
    
    bool notFound = true;

    if (attendance.idLocationDb != null) {
      for (var i = 0; i < _attLocs.length; i++) {
        AttendanceLocationModel attLoc = _attLocs[i];
        var queryOrderIn = mains.objectbox.boxAttendanceHistory
          .query(
            AttendanceHistoryModel_.date.equals(attendance.date!)
            & AttendanceHistoryModel_.idLocationDb.equals(attLoc.idDb!)
            & AttendanceHistoryModel_.status.equals(1)
          )..order(AttendanceHistoryModel_.id);
        var queryFindIn = queryOrderIn.build().find();
        
        if (queryFindIn.isNotEmpty) {
          String checkOut = '-';
          var queryOrderLast = mains.objectbox.boxAttendanceHistory
            .query(
              AttendanceHistoryModel_.date.equals(attendance.date!)
            )..order(AttendanceHistoryModel_.id, flags: Order.descending);
          var queryFindLast = queryOrderLast.build().find();
          AttendanceHistoryModel attHisLast = queryFindLast.first;

          if (attHisLast.idLocationDb != attLoc.idDb || attHisLast.status == 0) {
            var queryOrderOut = mains.objectbox.boxAttendanceHistory
              .query(
                AttendanceHistoryModel_.date.equals(attendance.date!)
                & AttendanceHistoryModel_.status.equals(0)
                & AttendanceHistoryModel_.idLocationDb.equals(attLoc.idDb!)
              )
              ..order(AttendanceHistoryModel_.id, flags: Order.descending);
            var queryFindOut = queryOrderOut.build().find();

            if (queryFindOut.isNotEmpty) {
              AttendanceHistoryModel attHisOut = queryFindOut.first;
              checkOut = DateFormat('HH:mm').format(DateTime.parse(attHisOut.datetime!));
            }
          }

          AttendanceHistoryModel attHisIn = queryFindIn.first;
          detailAtts.add({
            'locationName': attLoc.name,
            'checkIn': DateFormat('HH:mm').format(DateTime.parse(attHisIn.datetime!)),
            'checkOut': checkOut,
          });
          notFound = false;
        }
      }
    }

    if (notFound) {
      var queryOrderIn = mains.objectbox.boxAttendanceHistory
        .query(
          AttendanceHistoryModel_.date.equals(attendance.date!)
          & AttendanceHistoryModel_.status.equals(1)
        )..order(AttendanceHistoryModel_.id);
      var queryFindIn = queryOrderIn.build().find();

      if (queryFindIn.isNotEmpty) {
        AttendanceHistoryModel attHisIn = queryFindIn.first;
        
        detailAtts.add({
          'locationName': '-',
          'checkIn': DateFormat('HH:mm').format(DateTime.parse(attHisIn.datetime!)),
          'checkOut': attendance.status == 0 ? DateFormat('HH:mm').format(DateTime.parse(attendance.checkOutAt!)) : '-',
        });
      }
    }

    return detailAtts;
  }

  void _checkInPressed() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
 
      if (!serviceEnabled) {
        return;
      }

      _stateController.changeRunListenLocation(false);
    }

    permissionGranted = await location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();

      if (permissionGranted != PermissionStatus.granted) {        
        return;
      }

      _stateController.changeRunListenLocation(false);
    }

    _stateController.changeRunListenLocation(true);


    if (!_attendanceLoading) {
      setState(() {
        _attendanceLoading = true;
      });

      LocationData locationData = await location.getLocation();

      if (locationData.accuracy != null && locationData.latitude != null && locationData.longitude != null) {  
        if (locationData.accuracy! <= 60.0) {
          Map<String, dynamic> attRespMap = await _attendanceFunction.locationAttendanceManual(context, _attLocs, locationData.latitude!, locationData.longitude!);

          if (attRespMap['message'] != null) {
            _attendanceFlushbarFunc.showAttendanceError(context, 'Info', attRespMap['message']);
          }
        } else {
          _attendanceFlushbarFunc.showAttendanceError(context, 'Info', 'Accuracy ${locationData.accuracy!.toInt()} is more than 60');
        }
      } else {
        _attendanceFlushbarFunc.showAttendanceError(context, 'Info', 'Location data is empty');
      }

      setState(() {
        _attendanceLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
        title: const Text(
          'ATTENDANCE',
          style: TextStyle(fontSize: 15),
        ),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Obx(() => Switch(
              activeColor: Colors.blue,
              value: _stateController.locationPermission.value, 
              onChanged: (bool value) => _locationPermissionOnChange(value),
            )),
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<List<AttendanceModel>>(
          stream: homes.listControlerAttendance.stream,
          builder: (context, snapshot) {
            QueryBuilder<AttendanceModel> query = mains.objectbox.boxAttendance
              .query()
              ..order(AttendanceModel_.checkInAt, flags: Order.descending);
            List<AttendanceModel> attendances = query.build().find().toList();
            AttendanceModel lastAttendance = attendances[0];

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 10, 
                      bottom: 15, 
                      right: 15, 
                      left: 15
                    ),
                    itemCount: attendances.length,
                    itemBuilder: ((context, index) {
                      AttendanceModel attendance = attendances[index];
                      List<Map<String, dynamic>> detailAtts = _getDetailAtts(attendance);
            
                      return Card(
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
                                  color: attendances[index].status == 1 ? Colors.blue : Colors.grey, 
                                  width: 10,
                                ),
                              ),
                              color: Theme.of(context).cardColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 10.0,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 5.0),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              DateFormat('EEEE, dd MMM yyyy').format(DateTime.parse(attendance.checkInAt!)),
                                              style: const TextStyle(
                                                fontSize: 13.0,
                                                // color: Colors.grey.shade700,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                  child: Column(
                                                    children: detailAtts.mapIndexed((index, element) {
                                                      return Column(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(bottom: 2.0),
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(right: 14.0),
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        const Padding(
                                                                          padding: EdgeInsets.only(bottom: 2.5),
                                                                          child: Text(
                                                                            'Check in at',
                                                                            style: TextStyle(
                                                                              fontSize: 11.5,
                                                                            ),
                                                                            textAlign: TextAlign.left,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          element['locationName'],
                                                                          style: const TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 15.5,
                                                                          ),
                                                                          maxLines: 2,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                ),
                                                                SizedBox(
                                                                  width: 125,
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                          bottom: 3.0,
                                                                        ),
                                                                        child: Row(
                                                                          children: [
                                                                            const Expanded(
                                                                              flex: 1,
                                                                              child: Text(
                                                                                'Check in',
                                                                                textAlign: TextAlign.end,
                                                                                style: TextStyle(
                                                                                  fontSize: 13,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 55.0,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(
                                                                                  left: 6.0, 
                                                                                  right: 3.0,
                                                                                ),
                                                                                child: Text(
                                                                                  element['checkIn'],
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
                                                                                fontSize: 13,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width: 55.0,
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.only(
                                                                                left: 6.0,
                                                                                right: 3.0,
                                                                              ),
                                                                              child: Text(
                                                                                element['checkOut'],
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
                                                                )
                                                              ]
                                                            ),
                                                          ),
                                                          index != detailAtts.length-1 ? 
                                                            const Divider(height: 12.0) 
                                                          : 
                                                            Container()
                                                        ],
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                              // attendance.status == 1 ? const Icon(
                                              //   Icons.login_rounded,
                                              //   color: Colors.blue,
                                              //   size: 24,
                                              // ) : const Icon(
                                              //   Icons.logout_rounded,
                                              //   color: Colors.grey,
                                              //   size: 24,
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  attendance.status == 1 ? const Icon(
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
                      );
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 10.0,
                  ),
                  child: Obx(() => SizedBox(
                    height: 40.0,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // primary: lastAttendance.status == 0 ?Colors.blue : Colors.grey,
                        primary: Colors.blue,
                      ),
                      // onPressed: lastAttendance.status == 0 ? () => _checkInPressed(lastAttendance) : null,
                      // onPressed: () => _checkInPressed(lastAttendance),
                      onPressed: _stateController.locationPermission.value ? 
                        !_attendanceLoading ? 
                          () => _checkInPressed()
                        : null
                      : null,
                      child: !_attendanceLoading ? 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            // Padding(
                            //   padding: EdgeInsets.only(right: 3.0),
                            //   child: Icon(
                            //     Icons.login_rounded,
                            //     color: Colors.white,
                            //   ),
                            // ),
                            Text(
                              'Attendance',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        )
                      :
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Transform.scale(
                              scale: 0.45,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              'Loading',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                    ),
                  )),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
