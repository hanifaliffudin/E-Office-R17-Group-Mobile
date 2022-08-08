import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:militarymessenger/models/AttendanceModel.dart';
import 'package:militarymessenger/utils/variable_util.dart';

class AttendanceService {
  final VariableUtil _variableUtil = VariableUtil();

  Future<Map<String, dynamic>> saveAttendance(int userId, AttendanceModel attendance, bool revision) async {
    try {
      Map<String, dynamic> data = {
        'api_key': _variableUtil.apiKeyCore,
        'id_user': userId,
        'latitude': attendance.latitude.toString(),
        'longitude': attendance.longitude.toString(),
        'status': attendance.status,
        'datetime': attendance.status == 1 ? attendance.checkInAt : attendance.checkOutAt,
        'id_location': attendance.idLocationDb,
        'revision': revision,
      };
      var response = await http.post(
        Uri.parse('${_variableUtil.apiChatUrl}/save_attendance_dev.php'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );
      Map<String, dynamic> bodyMap = jsonDecode(response.body);

      if (bodyMap['error']) {
        return {
          'error': true,
        };
      }

      return {
        'error': false,
        'body': bodyMap,
      };
    } catch (e) {
      return {
        'error': true,
        'message': e.toString(),
      };
    }
  }
}