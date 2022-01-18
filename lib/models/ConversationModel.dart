import 'package:objectbox/objectbox.dart';

@Entity()
class ConversationModel {
  int id = 0;
  int? idConversation;
  int? idReceiver;
  String? fullName;
  String? image;
  String? message;
  String? date;
  int? messageCout;

  ConversationModel(
      {
        required this.id,
        this.idConversation,
        this.idReceiver,
        this.fullName,
        this.image,
        this.message,
        this.date,
        this.messageCout
      });
  ConversationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idConversation = json['id_conversation'];
    idReceiver = json['id_receiver'];
    fullName = json['full_name'];
    image = json['image'];
    message = json['message'];
    date = json['date'];
    messageCout = json['message_cout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_conversation'] = this.idConversation;
    data['id_receiver'] = this.idReceiver;
    data['full_name'] = this.fullName;
    data['image'] = this.image;
    data['message'] = this.message;
    data['date'] = this.date;
    data['message_cout'] = this.messageCout;
    return data;
  }
}
