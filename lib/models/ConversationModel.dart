import 'package:objectbox/objectbox.dart';

@Entity()
class ConversationModel {
  int id = 0;
  int? idReceiver;
  String statusReceiver = '';
  String? photoProfile = '';
  String? fullName;
  String? image;
  String? message;
  String? date;
  int? messageCout;
  int? roomId;
  String? idReceiversGroup;
  bool select = false;
  bool exited = false;

  ConversationModel(
      {
        required this.id,
        this.idReceiver,
        this.statusReceiver ='',
        this.photoProfile ='',
        this.fullName,
        this.image,
        this.message,
        this.date,
        this.messageCout,
        this.roomId,
        this.idReceiversGroup,
        this.select = false,
        this.exited = false,
      });

  ConversationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idReceiver = json['id_receiver'];
    statusReceiver = json['status_receiver'];
    fullName = json['full_name'];
    image = json['image'];
    message = json['message'];
    date = json['date'];
    messageCout = json['message_cout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_receiver'] = this.idReceiver;
    data['status_receiver'] = this.statusReceiver;
    data['full_name'] = this.fullName;
    data['image'] = this.image;
    data['message'] = this.message;
    data['date'] = this.date;
    data['message_cout'] = this.messageCout;
    return data;
  }
}
