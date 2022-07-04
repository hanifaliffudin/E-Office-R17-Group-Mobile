import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:militarymessenger/ChatGroup.dart';
import 'package:militarymessenger/ChatScreen.dart';
import 'package:militarymessenger/functions/index_function.dart';
import 'package:militarymessenger/models/ChatModel.dart';
import 'package:militarymessenger/models/ContactModel.dart';
import 'package:militarymessenger/models/ConversationModel.dart';
import 'package:militarymessenger/models/UserModel.dart';
import 'package:militarymessenger/objectbox.g.dart';
import 'package:militarymessenger/widgets/cache_image_provider_widget.dart';
import 'main.dart' as mains;
import 'Home.dart' as homes;

class ChatSearchScreen extends StatefulWidget {
  const ChatSearchScreen({Key? key}) : super(key: key);

  @override
  State<ChatSearchScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ChatSearchScreen> {
  String apiKey = homes.apiKeyCore;
  final TextEditingController _messageController = TextEditingController();
  List<ChatModel> _chats = [];
  List<ChatModel> _chatsTemp = [];
  List<ContactModel> _contacts = [];
  List<ContactModel> _contactsTemp = [];
  final UserModel _self = mains.objectbox.boxUser.get(1)!;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    QueryBuilder<ChatModel> chatQueryBuilder = mains.objectbox.boxChat.query()..order(ChatModel_.date);
    Query<ChatModel> chatQuery = chatQueryBuilder.build();
    List<ChatModel> chats = chatQuery.find().reversed.toList();
    QueryBuilder<ContactModel> contactQueryBuilder = mains.objectbox.boxContact.query();
    Query<ContactModel> contactQuery = contactQueryBuilder.build();
    List<ContactModel> contacts = contactQuery.find().reversed.toList();

    // _chats = chats;
    _chatsTemp = chats;
    _contactsTemp = contacts;
  }
  
  void searchOnChanged(String text) {
    List<ChatModel> chatsTemp = [];
    List<ContactModel> contactsTemp = [];

    if (text.isNotEmpty) {
      // var queryBuilder = mains.objectbox.boxChat.query(ChatModel_.text.startsWith(text))..order(ChatModel_.date);
      // var query = queryBuilder.build();
      // List<ChatModel> chats = query.find().reversed.toList();
      // temp = chats;
      chatsTemp = _chatsTemp.where((element) => element.text.toLowerCase().contains(text.toLowerCase()) && element.tipe != 'system').toList();
      contactsTemp = _contactsTemp.where((element) => element.userName!.toLowerCase().contains(text.toLowerCase())).toList();
    } else {
      chatsTemp = [];
      contactsTemp = [];
    }

    setState(() {
      _chats = chatsTemp;
      _contacts = contactsTemp;
    });
  }

  void chatOnTap(int index) {
    ChatModel chat = _chats[index];
    Query<ConversationModel> query;
    ConversationModel conversation;

    if (_self.userId != _chats[index].idReceiver) {
      query = mains.objectbox.boxConversation.query(ConversationModel_.idReceiver.equals(chat.idReceiver!)).build();
    } else {
      query = mains.objectbox.boxConversation.query(ConversationModel_.idReceiver.equals(chat.idSender!)).build();
    }
    
    conversation = query.find().first;

    if(conversation.idReceiver != null){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) => ChatScreen(conversation, conversation.roomId!, chat)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) => ChatGroup(conversation, conversation.roomId!, "open_conv"))
      );
    }
  }

  void contactOnTap(int index) {
    ContactModel contact = _contacts[index];
    
    createChat(_self.userId!, contact.userId!, contact.userName!, contact.photo ?? '');
  }

  Future<http.Response> createChat(int idSender, int idReceiver, String userName, String photo) async {
    String url ='https://chat.dev.r17.co.id/create_chat.php';

    Map<String, dynamic> data = {
      'api_key': this.apiKey,
      'id_sender': idSender,
      'id_receiver': idReceiver,
      'tipe_chat': 'pm',
    };

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );

    if(response.statusCode == 200){
      print("${response.body}");
      Map<String, dynamic> userMap = json.decode(response.body);
      int? roomId;

      if(userMap['code_status'] == 1){
        roomId = userMap['room_id'];
        var query = mains.objectbox.boxConversation.query(ConversationModel_.idReceiver.equals(idReceiver)).build();
        var now = DateTime.now();
        ConversationModel objConversation;

        if(query.find().isNotEmpty) {
          objConversation = ConversationModel(
            id: query.find().first.id,
            idReceiver: idReceiver,
            fullName: userName,
            image: '',
            message: query.find().first.message,
            photoProfile: photo,
            date: query.find().first.date,
            roomId: userMap['room_id'] ,
            messageCout: 0,
          );
          mains.objectbox.boxConversation.put(objConversation);
        } else {
          objConversation = ConversationModel(
            id: 0,
            idReceiver: idReceiver,
            fullName: userName,
            image: '',
            photoProfile: photo,
            date: now.toString(),
            roomId: userMap['room_id'] ,
            messageCout: 0,
          );
          mains.objectbox.boxConversation.put(objConversation);
        }

        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context)=>ChatScreen(objConversation, roomId!, null))
        );
      } else {
        print("ada yang salah!");
      }
    } else {
      print("Gagal terhubung ke server!");
    }

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(63.0),
        child: AppBar(
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(
              top: 4.0,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back, 
                color: Colors.white
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          titleSpacing: 0,
          title: Container(
            margin: const EdgeInsets.only(
              top: 5.0,
              right: 25.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
            ),
            height: 42,
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    left: 13.0,
                    right: 10.0,
                  ),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 22,
                  ),
                ),
                Flexible(
                  child: TextField(
                    controller: _messageController,
                    cursorColor: Colors.blue,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16
                    ),
                    maxLines: 1,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.only(
                        left: 0,
                      ),
                      border: InputBorder.none,
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: Color(0xff99999B),
                        fontSize: 16
                      ),
                    ),
                    onChanged: (String text) => searchOnChanged(text),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _contacts.isNotEmpty ? Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 15.0,
                left: 15.0,
              ),
              child: const Text(
                "Contacts",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ) : Container(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _contacts.length,
              itemBuilder: (BuildContext context, index) {
                return InkWell(
                  onTap: () => contactOnTap(index),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                      top: 10.0,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 10,
                              ),
                              child: _contacts[index].photo != '' ? CircleAvatar(
                                radius: 20,
                                backgroundColor: Color(0xffF2F1F6),
                                // backgroundImage: _getPhoto(_foundContact[index]),
                                backgroundImage: CacheImageProviderWidget(_contacts[index].userId.toString(), base64.decode(_contacts[index].photo!)),
                              ) : const CircleAvatar(
                                radius: 20,
                                backgroundColor: Color(0xffdde1ea),
                                child:  Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Text(
                              _contacts[index].userName!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: Divider(
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            ),
            _chats.isNotEmpty ? Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 20.0,
                left: 15.0,
              ),
              child: const Text(
                "Messages",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ) : Container(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _chats.length,
              itemBuilder: (BuildContext context, index) {
                ContactModel contact = ContactModel();
                Query<ContactModel> query;

                if (_self.userId != _chats[index].idSender) {
                  query = mains.objectbox.boxContact.query(ContactModel_.userId.equals(_chats[index].idSender!)).build();
                } else {
                  query = mains.objectbox.boxContact.query(ContactModel_.userId.equals(_chats[index].idReceiver!)).build();
                }

                contact = query.find().first;
                DateTime now = DateTime.now();
                DateTime date2 = DateTime.parse(_chats[index].date);
                String desc = "";

                if (IndexFunction.daysBetween(date2, now) < 7) {
                  bool isToday = DateFormat('yyyy-MM-dd').format(now) == DateFormat('yyyy-MM-dd').format(DateTime.parse(_chats[index].date));

                  if (isToday) {
                    desc = DateFormat('HH:mm').format(DateTime.parse(_chats[index].date));
                  } else if (IndexFunction.daysBetween(date2, now) == 1) {
                    desc = "Yesterday";
                  } else {
                    desc = DateFormat('EEEE').format(DateTime.parse(_chats[index].date));
                  }
                } else {
                  desc = DateFormat('dd-MM-yyyy').format(DateTime.parse(_chats[index].date));
                }

                return InkWell(
                  onTap: () => chatOnTap(index),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                      top: 10.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              contact.userName!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              desc,
                              style: const TextStyle(
                                fontSize: 12.0,
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0,
                          ),
                          child: Text(
                            _chats[index].text,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: Divider(
                            height: 0,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}