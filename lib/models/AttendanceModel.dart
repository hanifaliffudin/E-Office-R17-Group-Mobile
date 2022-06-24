import 'package:objectbox/objectbox.dart';

@Entity()
class AttendanceModel {
  int id;
  String? date;
  String? checkInAt;
  String? checkOutAt;
  double? latitude;
  double? longitude;
  String? category;

  AttendanceModel(
      {
        this.id = 0,
        this.date,
        this.checkInAt,
        this.checkOutAt,
        this.latitude,
        this.longitude,
        this.category,
      });
}
