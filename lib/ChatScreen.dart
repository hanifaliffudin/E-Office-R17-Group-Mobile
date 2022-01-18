import 'package:flutter/material.dart';
import 'package:militarymessenger/models/ConversationModel.dart';
import 'package:militarymessenger/models/ChatModel.dart';
import 'package:militarymessenger/cards/friend_message_card_personal.dart';
import 'package:militarymessenger/cards/my_message_card_personal.dart';
import 'objectbox.g.dart';
//import 'DBHelpers.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';
import 'main.dart' as mains;
import 'Home.dart' as homes;


class ChatScreen extends StatefulWidget {
  final ConversationModel? conversation;
  Store? store;

  ChatScreen(this.conversation);

  @override
  _ChatScreenState createState() => _ChatScreenState(conversation);
}

class _ChatScreenState extends State<ChatScreen> {
  final ConversationModel? conversation;
  Store? store;
  _ChatScreenState(this.conversation);
  final int idUser = 1;
  final int idConversation = 1;
  final int idReceiver = 2;
  TextEditingController inputTextController = new TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFe8dfd8),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(63.0),
        child: AppBar(
          backgroundColor: Color(0xFF2381D0),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          titleSpacing: 0,
          title: ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(conversation!.image!),
            ),
            title: Text(
              conversation!.fullName!,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            subtitle: Text(
              conversation!.date!,
              style: TextStyle(color: Colors.white.withOpacity(.7)),
            ),
          ),
          actions: <Widget>[
            Icon(Icons.videocam),
            SizedBox(
              width: 15,
            ),
            Icon(Icons.call),
            SizedBox(
              width: 15,
            ),
            Icon(Icons.more_vert),
            SizedBox(
              width: 5,
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<ChatModel>>(
            stream: homes.listController.stream,
              builder: (context, snapshot)
              {
                if (snapshot.data != null) {
                  List<ChatModel> chats = mains.objectbox.boxChat.getAll().reversed.toList();
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    reverse: true,
                    shrinkWrap: false,
                    padding: const EdgeInsets.all(2),
                    itemCount: chats.length!=0 ? chats.length : 0,
                    itemBuilder: (context, index) =>
                    chats[index].idSender == idUser ?
                    MyMessageCardPersonal(
                      chats[index].text,
                      DateFormat.Hms().format( DateTime.parse(chats[index].date) ),
                      chats[index].sendStatus,
                      index+1==chats.length?true:chats[index].idSender==chats[index+1].idSender?false:true,
                    )
                        : FriendMessageCardPersonal(
                      chats[index].text,
                      DateFormat.Hms().format( DateTime.parse(chats[index].date) ),
                      index+1==chats.length?true:chats[index].idSender==chats[index+1].idSender?false:true,
                    ),
                  );}else{

                        if (snapshot.hasError) {
                          print(snapshot.error.toString());
                          return const Text("Error");
                        }
                        return const CircularProgressIndicator();

                }},
                ),
                ),
                Row(
                children: <Widget>[
              Stack(
              overflow: Overflow.visible,
                children: <Widget>[
                Container(
                padding: EdgeInsets.all(4),
              margin: EdgeInsets.only(left: 10,bottom: 10,right: 1,top: 1),
              height : 45,
                decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                ),
              child: Row(
              children: <Widget>[
                        Icon(
                          Icons.tag_faces,
                          color: Colors.grey,
                          size: 35,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 245,
                          child: TextField(
                            controller: inputTextController,
                            style: TextStyle(
                              fontSize: 19.0,
                              height: 2.0,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Type a message',
                                contentPadding: EdgeInsets.only(left: 5,top: -25,right:0),
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 20)),
                          ),
                        ),
                        SizedBox(
                          width: 0,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                            size: 30,
                          ),
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            //print(inputTextController.text);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.only(left: 2,bottom: 9),
                decoration: BoxDecoration(
                    color: Color(0xFF2381D0), shape: BoxShape.circle),
                child:
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 23,
                    ),
                    padding: EdgeInsets.all(0),
                    onPressed: () async{
                      final chat = ChatModel(
                          text: inputTextController.text,
                          date: DateTime.now().toString(),
                          idConversation: idConversation,
                          idReceiver: idReceiver  ,
                          idSender: idUser,
                          sendStatus: 'D'
                      );
                      int id = mains.objectbox.boxChat.put(chat);
                      print(id);

                      ChatModel? chats = mains.objectbox.boxChat.get(id);
                      if(chats!=null)
                      print(chats.text);
                      inputTextController.clear();
                      //int id = await DBHelpers.setChat(chat);
                      //String? text = await DBHelpers.getChat(1);
                      //final id = boxChat.put(chat);
                      //print(id);
                      //print(text);

                      //List<ChatModel> chats =await DBHelpers.getChatAll();

                    },
                  ),
              )
            ],
          )
        ],
      ),
    );
  }
}

