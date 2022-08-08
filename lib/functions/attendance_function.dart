import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:militarymessenger/functions/attendance_flushbar_function.dart';
import 'package:militarymessenger/functions/index_function.dart';
import 'package:militarymessenger/models/AttendanceHistoryModel.dart';
import 'package:militarymessenger/models/AttendanceLocationModel.dart';
import 'package:militarymessenger/models/AttendanceModel.dart';
import 'package:militarymessenger/main.dart' as mains;
import 'package:militarymessenger/objectbox.g.dart';
import 'package:militarymessenger/services/index_service.dart';
import 'package:militarymessenger/utils/variable_util.dart';
import 'package:http/http.dart' as http;

class AttendanceFunction {
  final _variableUtil = VariableUtil();
  final _indexFunction = IndexFunction();
  final _indexService = IndexService();
  final _attendanceFlushbarFunc = AttendanceFlushbarFunction();

  Future<void> locationAttendance(BuildContext context, List<AttendanceLocationModel> attLocs, double latitude, double longitude) async {
    Map<String, dynamic> dateTimeMap = await _indexService.getDateTime();

    if (!dateTimeMap['error']) {
      Map<String, dynamic> bodyDateTimeMap = dateTimeMap['body'];
      DateTime now = DateTime.parse(bodyDateTimeMap['data']);

      for (var i = 0; i < attLocs.length; i++) {
        AttendanceLocationModel attLoc = attLocs[i];
        double? distanceOnMeter = _indexFunction.calculateDistance(latitude, longitude, attLoc.latitude, attLoc.longitude)*1000;

        if (distanceOnMeter <= attLoc.range!) {
          if (now.hour >= 7) {
            var query = mains.objectbox.boxAttendance
              .query(AttendanceModel_.date
                  .equals(DateFormat('dd MM yyyy').format(now)))
              .build()
              .find();

            if (query.isNotEmpty) {
              AttendanceModel attendance = query.first;

              if (attendance.status == 0) {
                attendance.date = DateFormat('dd MM yyyy').format(now);
                attendance.checkInAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                attendance.latitude = latitude;
                attendance.longitude = longitude;
                attendance.status = 1;
                attendance.server = false;
                attendance.idLocationDb = attLoc.idDb;

                await saveAttendance(context, attendance);
                break;
              }
            } else {
              AttendanceModel attendance = AttendanceModel(
                date: DateFormat('dd MM yyyy').format(now),
                checkInAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
                latitude: latitude,
                longitude: longitude,
                status: 1,
                server: false,
                idLocationDb: attLoc.idDb,
              );

              await saveAttendance(context, attendance);
              break;
            }
          }
        } else if (distanceOnMeter > attLoc.range!) {
          if (now.hour >= 7) {
            var query = mains.objectbox.boxAttendance
              .query(
                AttendanceModel_.date.equals(DateFormat('dd MM yyyy').format(now)) 
                & AttendanceModel_.status.equals(1)
              )
              .build()
              .find();

            if (query.isNotEmpty) {
              AttendanceModel attendance = query.first;

              if (attendance.idLocationDb == attLoc.idDb!) {
                attendance.checkOutAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                attendance.status = 0;
                attendance.server = false;
                attendance.idLocationDb = attLoc.idDb;

                await saveAttendance(context, attendance);
                break;
              }
              // else if (attendance.idLocationDb == null) {
              //   attendance.idLocationDb = attLocs[0].idDb;
                
              //   await saveAttendance(context, attendance);
              // }
            }
          } else {
            DateTime dateYesterday = DateTime(now.year, now.month, now.day - 1);
            var query = mains.objectbox.boxAttendance
              .query(
                AttendanceModel_.date.equals(DateFormat('dd MM yyyy').format(dateYesterday)) 
                & AttendanceModel_.status.equals(1)
                & AttendanceModel_.idLocationDb.equals(attLoc.idDb!)
              )
              .build()
              .find();

            if (query.isNotEmpty) {
              AttendanceModel attendance = query.first;
              String yesterdayMax = DateFormat('yyyy-MM-dd').format(dateYesterday)+' 23:59:59';

              if (attendance.checkOutAt != yesterdayMax) {
                attendance.checkOutAt = DateTime.parse(yesterdayMax).toString();
                attendance.status = 0;
                attendance.server = false;
                attendance.idLocationDb = attLoc.idDb;

                await saveAttendance(context, attendance);
                break;
              }
            }
          }
        }
      }
    }
  }
  
  Future<void> saveAttendance(BuildContext context, AttendanceModel attendance) async {
    var id = mains.objectbox.boxAttendance.put(attendance);
    var attendanceNew = mains.objectbox.boxAttendance.get(id)!;
    String url = '${_variableUtil.apiChatUrl}/save_attendance_dev.php';

    Map<String, dynamic> data = {
      'api_key': _variableUtil.apiKeyCore,
      'id_user': mains.objectbox.boxUser.get(1)?.userId,
      'latitude': attendance.latitude.toString(),
      'longitude': attendance.longitude.toString(),
      'status': attendance.status,
      'datetime':
          attendance.status == 1 ? attendance.checkInAt : attendance.checkOutAt,
      'id_location': attendance.idLocationDb,
    };

    try {
      var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if(response.statusCode == 200){
        print("${response.body}");
        Map<String, dynamic> attendanceMap = jsonDecode(response.body);

        if(attendanceMap['code_status'] == 0){
          String type = '';
          var attendanceHistory = AttendanceHistoryModel(
            date: attendanceNew.date,
            latitude: attendanceNew.latitude,
            longitude: attendanceNew.longitude,
            datetime: attendanceNew.status == 1 ? attendanceNew.checkInAt : attendanceNew.checkOutAt,
            status: attendanceNew.status,
            server: attendanceNew.server,
            idLocationDb: attendanceNew.idLocationDb,
          );

          if (attendanceMap['data'] != null) {
            if (attendanceMap['data']['check_in'] != null) {
              attendanceNew.date = DateFormat('dd MM yyyy').format(DateTime.parse(attendanceMap['data']['check_in']));
              attendanceNew.checkInAt = attendanceMap['data']['check_in'];
              attendanceHistory.datetime = attendanceMap['data']['check_in'];
              type = 'in';
            } else if (attendanceMap['data']['check_out'] != null) {
              attendanceNew.date = DateFormat('dd MM yyyy').format(DateTime.parse(attendanceMap['data']['check_out']));
              attendanceNew.checkOutAt = attendanceMap['data']['check_out'];
              attendanceHistory.datetime = attendanceMap['data']['check_out'];
              type = 'out';
            }
          }

          attendanceNew.server = true;
          attendanceHistory.server = true;
          mains.objectbox.boxAttendance.put(attendanceNew);
          mains.objectbox.boxAttendanceHistory.put(attendanceHistory);

          _attendanceFlushbarFunc.showAttendanceNotif(
            context, 
            false, 
            type, 
            'Attendance', 
            'Check $type at: ${DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(attendanceHistory.datetime!))}',
          );
        } else {
          // mains.objectbox.boxAttendance.remove(attendanceNew.id);

          // showAttendanceNotif(true, null, 'Error', attendanceMap['message']);
          // print(attendanceMap['code_status']);
          // print(attendanceMap['error']);
        }
      } else {
        mains.objectbox.boxAttendance.remove(attendanceNew.id);

        // showAttendanceNotif(true, null, 'Error', 'Something wrong');
        // print("Gagal terhubung ke server!");
      }
    } catch (e) {
      mains.objectbox.boxAttendance.remove(attendanceNew.id);
      // var attendanceHistory = AttendanceHistoryModel(
      //   date: attendanceNew.date,
      //   latitude: attendanceNew.latitude,
      //   longitude: attendanceNew.longitude,
      //   datetime: attendanceNew.status == 1 ? attendanceNew.checkInAt : attendanceNew.checkOutAt,
      //   status: attendanceNew.status,
      //   server: attendanceNew.server,
      // );
      // mains.objectbox.boxAttendance.put(attendanceNew);
      // mains.objectbox.boxAttendanceHistory.put(attendanceHistory);

      // showAttendanceNotif(true, null, 'Error', 'Catch error');
    }
  }

  Future<Map<String, dynamic>> locationAttendanceManual(BuildContext context, List<AttendanceLocationModel> attLocs, double latitude, double longitude) async {
    String? message;
    bool attendanceExist = false;
    Map<String, dynamic> dateTimeMap = await _indexService.getDateTime();

    if (!dateTimeMap['error']) {
      Map<String, dynamic> bodyDateTimeMap = dateTimeMap['body'];
      DateTime now = DateTime.parse(bodyDateTimeMap['data']);

      for (var i = 0; i < attLocs.length; i++) {
        AttendanceLocationModel attLoc = attLocs[i];
        double? distanceOnMeter = _indexFunction.calculateDistance(latitude, longitude, attLoc.latitude, attLoc.longitude)*1000;

        if (distanceOnMeter <= attLoc.range!) {
          if (now.hour >= 7) {
            var query = mains.objectbox.boxAttendance
              .query(AttendanceModel_.date
                  .equals(DateFormat('dd MM yyyy').format(now)))
              .build()
              .find();

            if (query.isNotEmpty) {
              attendanceExist = true;

              AttendanceModel attendance = query.first;

              if (attendance.status == 0) {
                attendance.date = DateFormat('dd MM yyyy').format(now);
                attendance.checkInAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                attendance.latitude = latitude;
                attendance.longitude = longitude;
                attendance.status = 1;
                attendance.server = false;
                attendance.idLocationDb = attLoc.idDb;

                await saveAttendance(context, attendance);
                break;
              } else {
                message = 'Attendance today is already check in';
              }
            } else {
              AttendanceModel attendance = AttendanceModel(
                date: DateFormat('dd MM yyyy').format(now),
                checkInAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
                latitude: latitude,
                longitude: longitude,
                status: 1,
                server: false,
                idLocationDb: attLoc.idDb,
              );

              await saveAttendance(context, attendance);
              break;
            }
          } else {
            message = "Attendance today should above be 7 o'clock";
            break;
          }
        } else if (distanceOnMeter > attLoc.range!) {
          if (now.hour >= 7) {
            var query = mains.objectbox.boxAttendance
              .query(
                AttendanceModel_.date.equals(DateFormat('dd MM yyyy').format(now)) 
              )
              .build()
              .find();

            if (query.isNotEmpty) {
              attendanceExist = true;

              AttendanceModel attendance = query.first;

              if (attendance.status == 1) {
                if (attendance.idLocationDb == attLoc.idDb!) {
                  attendance.checkOutAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                  attendance.status = 0;
                  attendance.server = false;
                  attendance.idLocationDb = attLoc.idDb;

                  await saveAttendance(context, attendance);
                  break;
                }
              } else {
                message = 'Attendance today is already check out';
              }
              // else if (attendance.idLocationDb == null) {
              //   attendance.idLocationDb = attLocs[0].idDb;
                
              //   await saveAttendance(context, attendance);
              // }
            } else {
              if (!attendanceExist) {
                message = 'Outside from attendance locations';
              }
            }
          } else {
            DateTime dateYesterday = DateTime(now.year, now.month, now.day - 1);
            var query = mains.objectbox.boxAttendance
              .query(
                AttendanceModel_.date.equals(DateFormat('dd MM yyyy').format(dateYesterday)) 
                & AttendanceModel_.idLocationDb.equals(attLoc.idDb!)
              )
              .build()
              .find();

            if (query.isNotEmpty) {
              attendanceExist = true;

              AttendanceModel attendance = query.first;

              if (attendance.status == 1) {
                String yesterdayMax = DateFormat('yyyy-MM-dd').format(dateYesterday)+' 23:59:59';

                if (attendance.checkOutAt != yesterdayMax) {
                  attendance.checkOutAt = DateTime.parse(yesterdayMax).toString();
                  attendance.status = 0;
                  attendance.server = false;
                  attendance.idLocationDb = attLoc.idDb;

                  await saveAttendance(context, attendance);
                  break;
                } else {
                  message = 'Attendance tomorrow is already check out at $yesterdayMax';
                }
              } else {
                message = 'Attendance tomorrow is already check out';
              }
            } else {
              if (!attendanceExist) {
                message = 'Outside from attendance locations';
              }
            }
          }
        }
      }
    } else {
      message = 'Something wrong in server';
    }

    return {
      'message': message,
    };
  }
}