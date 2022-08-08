import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:militarymessenger/utils/variable_util.dart';

class IndexService {
  final VariableUtil _variableUtil = VariableUtil();
  
  Future<Map<String, dynamic>> getDateTime() async {
    try {
      Map<String, dynamic> data = {
        'api_key': _variableUtil.apiKeyCore,
      };
      var response = await http.post(
        Uri.parse('${_variableUtil.apiChatUrl}/get_datetime.php'),
        headers: {
          'Content-Type': 'application/json',
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

  Future<Map<String, dynamic>> getListContact(String email) async {
    try {
      Map<String, dynamic> data = {
        'api_key': _variableUtil.apiKeyCore,
        'email': email,
      };
      var response = await http.post(
        Uri.parse('${_variableUtil.apiChatUrl}/list_contact.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      Map<String, dynamic> bodyMap = jsonDecode(response.body);

      if (bodyMap['error'] == true) {
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