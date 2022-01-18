import 'package:objectbox/objectbox.dart';

@Entity()
class ChatModel {
  int id = 0;
  int? idChat;
  int? idConversation;
  int? idSender;
  int? idReceiver;
  String text="";
  String sendStatus="";
  String date="";

  ChatModel(
      {
        this.idChat,
        this.idConversation,
        this.idSender,
        this.idReceiver,
        this.text='',
        this.sendStatus='',
        this.date='',
      });

  /*
  ChatModel.fromJson(Map<String, dynamic> json) {
    idChat = json['id_chat'];
    idConversation = json['id_conversation'];
    idSender = json['id_sender'];
    idReceiver = json['id_receiver'];
    text = json['text'];
    sendStatus = json['send_status'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_chat'] = this.idChat;
    data['id_conversation'] = this.idConversation;
    data['id_sender'] = this.idSender;
    data['id_receiver'] = this.idReceiver;
    data['text'] = this.text;
    data['send_status'] = this.sendStatus;
    data['date'] = this.date;
    return data;
  }
*/
/*
  List<ChatModel> fetchAll(){
    return [
      ChatModel(idChat: 1, idConversation: 1,idSender: 1, idReceiver: 2,text: '.',sendStatus: 'R',date: 'yesterday'),
      ChatModel(idChat: 1, idConversation: 1,idSender: 1, idReceiver: 2,text: 'Hi... Apa kabar kamu disana ?',sendStatus: 'R',date: 'yesterday'),
      ChatModel(idChat: 1, idConversation: 1,idSender: 1, idReceiver: 2,text: 'Hello...',sendStatus: 'R',date: 'yesterday'),
      ChatModel(idChat: 1, idConversation: 1,idSender: 2, idReceiver: 1,text: 'Hello...',sendStatus: 'R',date: 'yesterday'),
      ChatModel(idChat: 2, idConversation: 1,idSender: 2, idReceiver: 1,text: 'Apa Kabar ?',sendStatus: 'R',date: 'yesterday'),
      ChatModel(idChat: 3, idConversation: 1,idSender: 1, idReceiver: 2,text: 'Hi, Saya baik2 saja. kamu gmn yayaya kabarnya ?...  Saya baik2 saja. kamu gmn kabarnya ?... ',sendStatus: 'R',date: 'yesterday'),
      ChatModel(idChat: 4, idConversation: 1,idSender: 2, idReceiver: 1,text: 'Saya baik juga mas...',sendStatus: 'R',date: '11.10 am'),
      ChatModel(idChat: 1, idConversation: 1,idSender: 2, idReceiver: 1,text: 'Hello...',sendStatus: 'R',date: 'yesterday'),
      ChatModel(idChat: 2, idConversation: 1,idSender: 2, idReceiver: 1,text: 'Apa Kabar ?',sendStatus: 'R',date: 'yesterday'),
      ChatModel(idChat: 3, idConversation: 1,idSender: 1, idReceiver: 2,text: 'Hi, Saya baik2 saja. kamu gmn yayaya kabarnya ?...  Saya baik2 saja. kamu gmn kabarnya ?... ',sendStatus: 'R',date: 'yesterday'),
      ChatModel(idChat: 4, idConversation: 1,idSender: 2, idReceiver: 1,text: 'Saya baik juga mas...',sendStatus: 'R',date: '11.10 am'),
      ChatModel(idChat: 1, idConversation: 1,idSender: 2, idReceiver: 1,text: 'Hello...',sendStatus: 'R',date: 'yesterday'),
      ChatModel(idChat: 2, idConversation: 1,idSender: 2, idReceiver: 1,text: 'Apa Kabar ?',sendStatus: 'R',date: 'yesterday'),
      ChatModel(idChat: 3, idConversation: 1,idSender: 1, idReceiver: 2,text: 'Hi, Saya baik2 saja. kamu gmn yayaya kabarnya ?...  Saya baik2 saja. kamu gmn kabarnya ?... ',sendStatus: 'R',date: 'yesterday'),
      ChatModel(idChat: 4, idConversation: 1,idSender: 2, idReceiver: 1,text: 'Saya baik juga mas...',sendStatus: 'R',date: '11.10 am'),
      ChatModel(idChat: 1, idConversation: 1,idSender: 2, idReceiver: 1,text: 'Hello...',sendStatus: 'R',date: 'yesterday'),
      ChatModel(idChat: 2, idConversation: 1,idSender: 2, idReceiver: 1,text: 'Apa Kabar ?',sendStatus: 'R',date: 'yesterday'),
      ChatModel(idChat: 3, idConversation: 1,idSender: 1, idReceiver: 2,text: 'Hi, Saya baik2 saja. kamu gmn yayaya kabarnya ?...  Saya baik2 saja. kamu gmn kabarnya ?... ',sendStatus: 'R',date: 'yesterday'),
      ChatModel(idChat: 4, idConversation: 1,idSender: 2, idReceiver: 1,text: 'Saya baik juga mas...',sendStatus: 'R',date: '11.10 am'),
      ChatModel(idChat: 1, idConversation: 1,idSender: 2, idReceiver: 1,text: 'Hello...',sendStatus: 'R',date: 'yesterday'),
      ChatModel(idChat: 2, idConversation: 1,idSender: 2, idReceiver: 1,text: 'Apa Kabar ?',sendStatus: 'R',date: 'yesterday'),
      ChatModel(idChat: 3, idConversation: 1,idSender: 1, idReceiver: 2,text: 'Hi, Saya baik2 saja. kamu gmn yayaya kabarnya ?...  Saya baik2 saja. kamu gmn kabarnya ?... ',sendStatus: 'R',date: 'yesterday'),
      ChatModel(idChat: 4, idConversation: 1,idSender: 2, idReceiver: 1,text: 'Saya baik juga mas...',sendStatus: 'R',date: '11.10 am'),
      ChatModel(idChat: 1, idConversation: 1,idSender: 2, idReceiver: 1,text: 'Hello...',sendStatus: 'R',date: 'yesterday'),
      ChatModel(idChat: 2, idConversation: 1,idSender: 2, idReceiver: 1,text: 'Apa Kabar ?',sendStatus: 'R',date: 'yesterday'),
      ChatModel(idChat: 3, idConversation: 1,idSender: 1, idReceiver: 2,text: 'Hi, Saya baik2 saja. kamu gmn yayaya kabarnya ?...  Saya baik2 saja. kamu gmn kabarnya ?... ',sendStatus: 'R',date: 'yesterday'),
      ChatModel(idChat: 4, idConversation: 1,idSender: 2, idReceiver: 1,text: 'Saya baik juga mas...',sendStatus: 'R',date: '11.10 am'),
      ChatModel(idChat: 1, idConversation: 1,idSender: 2, idReceiver: 1,text: 'Hello...',sendStatus: 'R',date: 'yesterday'),
      ChatModel(idChat: 2, idConversation: 1,idSender: 2, idReceiver: 1,text: 'Apa Kabar ?',sendStatus: 'R',date: 'yesterday'),
      ChatModel(idChat: 3, idConversation: 1,idSender: 1, idReceiver: 2,text: 'Hi, Saya baik2 saja. kamu gmn yayaya kabarnya ?...  Saya baik2 saja. kamu gmn kabarnya ?... ',sendStatus: 'R',date: 'yesterday'),
      ChatModel(idChat: 4, idConversation: 1,idSender: 2, idReceiver: 1,text: 'Saya baik juga mas...',sendStatus: 'R',date: '11.10 am'),
      ChatModel(idChat: 1, idConversation: 1,idSender: 2, idReceiver: 1,text: 'Hello...',sendStatus: 'R',date: 'yesterday'),
      ChatModel(idChat: 2, idConversation: 1,idSender: 2, idReceiver: 1,text: 'Apa Kabar ?',sendStatus: 'R',date: 'yesterday'),
      ChatModel(idChat: 3, idConversation: 1,idSender: 1, idReceiver: 2,text: 'Hi, Saya baik2 saja. kamu gmn yay kabarnya ?...  Saya baik2 saja. kamu gmn kabarnya ?... ',sendStatus: 'R',date: 'yesterday'),
      ChatModel(idChat: 4, idConversation: 1,idSender: 2, idReceiver: 1,text: 'Hello apa kabar ?...',sendStatus: 'R',date: '11.10 am'),
    ];
  }
  */
}
