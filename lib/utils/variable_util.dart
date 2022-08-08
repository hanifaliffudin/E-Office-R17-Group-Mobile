import 'package:militarymessenger/utils/config_util.dart';

class VariableUtil {
  String eOfficeUrl = ProdConfigUtil().eOfficeUrl;
  String apiChatUrl = ProdConfigUtil().apiChatUrl;
  String wssChatUrl = ProdConfigUtil().wssChatUrl;
  String wssOpenKey = ProdConfigUtil().wssOpenKey;
  String apiKeyCore = ProdConfigUtil().apiKeyCore;
  String apiKeyEoffice = ProdConfigUtil().apiKeyEoffice;
  // String eOfficeUrlLocal = 'http://192.168.11.41:8000';
}