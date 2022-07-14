import 'package:objectbox/objectbox.dart';

@Entity()
class GroupNotifModel {
  int id;
  String? dataId;
  String? type;
  int? hashcode;

  GroupNotifModel({
    this.id = 0,
    this.dataId,
    this.type,
    this.hashcode,
  });
}