import 'package:objectbox/objectbox.dart';

@Entity()
class GroupNotifModel {
  int id;
  int? roomId;
  int? notifId;

  GroupNotifModel({
    this.id = 0,
    this.roomId,
    this.notifId,
  });
}