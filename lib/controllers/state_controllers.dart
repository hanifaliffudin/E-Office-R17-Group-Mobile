import 'package:get/get.dart';

class StateController extends GetxController {
  var fromRoomId = 0.obs;
  var inAttendance = false.obs;
  var locationPermission = false.obs;
  var locationAccuracy = 0.0.obs;
  var refreshEofficePage = false.obs;
  var documentCategory = ''.obs;
  var otpCodeSms = ''.obs;
  var runGetLastMessages = false.obs;

  void changeFromRoomId(int value) => fromRoomId.value = value;

  void changeInAttendance(bool value) => inAttendance.value = value;

  void changeLocationPermission(bool value) => locationPermission.value = value;

  void changeLocationAccuracy(double value) => locationAccuracy.value = value;

  void changeRefreshEoffice(bool value) => refreshEofficePage.value = value;

  void changeDocumentCategory(String value) => documentCategory.value = value;

  void changeOtpCodeSms(String value) => otpCodeSms.value = value;

  void changeRunGetLastMessages(bool value) => runGetLastMessages.value = value;
}