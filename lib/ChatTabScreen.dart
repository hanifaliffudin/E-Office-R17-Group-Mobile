import 'package:flutter/material.dart';
import 'package:militarymessenger/ChatScreen.dart';
import 'package:militarymessenger/models/ConversationModel.dart';
import 'objectbox.g.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'Home.dart' as homes;
import 'main.dart' as mains;

class ChatTabScreen extends StatelessWidget {
  Store? store;
  ChatTabScreen();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConversationModel>>(
        stream: homes.listControllerConversation.stream,
        builder: (context, snapshot){
          if(mains.objectbox.boxConversation.isEmpty()){
            return
              Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  child :Text(
                    'Belum ada pesan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13,),
                  ));
          }
          else
          {
            List<ConversationModel> conversationList = mains.objectbox.boxConversation.getAll().toList();
            return ListView.builder(
                itemCount: conversationList.length,
                itemBuilder:(BuildContext context,index)=>conversation(context,conversationList[index])
            );
          }
        }
    );
  }
}

Widget conversation(BuildContext context, ConversationModel conversation) {
  return InkWell(
    onTap: ()=>Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context)=>ChatScreen(conversation))
    ),
    child: Container(
      padding: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: ClipOval(
                child: conversation.image=='' ? CircleAvatar(child: Image.asset('assets/images/defaultuser.png',),radius: 25,) : CircleAvatar(child: Image.network(conversation.image!),radius: 25,)
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      conversation.fullName!,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                    ),
                    Text(
                      conversation.message!,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      conversation.date!,
                      style: TextStyle(
                          color: conversation.messageCout! > 0
                              ? Color(0xFF25D366)
                              : Colors.grey,
                          fontSize: 12),
                    ),
                    conversation.messageCout! > 0
                        ? Transform(
                        transform: new Matrix4.identity()..scale(0.9),
                        child: Chip(
                          backgroundColor: Color(0xFF25D366),
                          label: Text(
                            '${conversation.messageCout}',
                            style: TextStyle(color: Colors.white , fontSize: 12),
                          ),
                        )
                    )
                        : Text(''),
                  ],
                )
              ],
            ),
          ),
          Container(
            width: 330,
            height: 1,
            margin: EdgeInsets.only(left: 40, top: 5),
            color: Colors.grey.withOpacity(.2),
          )
        ],
      ),
    ),
  );
}
