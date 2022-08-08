import 'package:objectbox/objectbox.dart';

@Entity()
class AttendanceLocationModel {
  int id;
  int? idDb;
  String? name;
  double? latitude;
  double? longitude;
  int? range;

  AttendanceLocationModel({
    this.id = 0,
    this.idDb,
    this.name,
    this.latitude,
    this.longitude,
    this.range,
  });
}
