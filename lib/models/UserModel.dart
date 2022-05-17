import 'package:objectbox/objectbox.dart';

@Entity()
class UserModel {
  int id;
  int? userId;
  String? fcmToken;
  String? photo;
  String? userName;
  String? email;
  String? phone;
  int? verification_code;
  int? enable;
  String? token;
  String? status;
  String? idInstall;

  UserModel(
      {
        this.id = 0,
        this.userId,
        this.fcmToken,
        this.photo,
        this.userName,
        this.email,
        this.phone,
        this.verification_code,
        this.enable,
        this.token,
        this.status,
        this.idInstall,
      });
}
