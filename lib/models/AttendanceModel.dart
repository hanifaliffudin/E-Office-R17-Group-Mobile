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
  int? idLocationDb;
  int status = 0;
  bool server = false;

  AttendanceModel(
      {
        this.id = 0,
        this.date,
        this.checkInAt,
        this.checkOutAt,
        this.latitude,
        this.longitude,
        this.category,
        this.idLocationDb,
        this.status = 0,
        this.server = false,
      });
}
