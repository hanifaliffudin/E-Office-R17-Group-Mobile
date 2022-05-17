import 'package:objectbox/objectbox.dart';

@Entity()
class ContactModel {
  int id;
  int? userId;
  String? email;
  String? userName;
  String? photo;
  String? phone;
  bool select = false;

  ContactModel(
      {
        this.id = 0,
        this.userId,
        this.email,
        this.userName,
        this.photo,
        this.phone,
        this.select = false,
      });
}
