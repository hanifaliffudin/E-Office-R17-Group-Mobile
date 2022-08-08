import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:militarymessenger/utils/variable_util.dart';

class QrAuthService {
  final VariableUtil _variableUtil = VariableUtil();
  
  Future<Map<String, dynamic>> readQrAuth(String code, String email) async {
    try {
      Map<String, dynamic> data = {
        'api_key': _variableUtil.apiKeyEoffice,
        'code': code,
        'email': email,
      };
      var response = await http.post(
        Uri.parse('${_variableUtil.eOfficeUrl}/api/readQrAuth'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      Map<String, dynamic> bodyMap = jsonDecode(response.body);

      if (bodyMap['error']) {
        return {
          'error': true,
          'message': bodyMap['message'],
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