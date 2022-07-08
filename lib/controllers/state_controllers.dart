import 'package:get/get.dart';

class StateController extends GetxController {
  var fromRoomId = 0.obs;
  var inAttendance = false.obs;

  void changeFromRoomId(int value) => fromRoomId.value = value;

  void changeInAttendance(bool value) => inAttendance.value = value;
}