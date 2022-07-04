import 'package:objectbox/objectbox.dart';

@Entity()
class AttendanceHistoryModel {
  int id;
  String? date;
  String? datetime;
  double? latitude;
  double? longitude;
  int status = 0;
  bool server = false;

  AttendanceHistoryModel({
    this.id = 0,
    this.date,
    this.datetime,
    this.latitude,
    this.longitude,
    this.status = 0,
    this.server = false,
  });
}
