import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:militarymessenger/AddParticipantsGroup.dart';
import 'package:militarymessenger/ChatGroup.dart';
import 'package:militarymessenger/ChatTabScreen.dart';
import 'package:militarymessenger/EditGroupInfo.dart';
import 'package:militarymessenger/models/ChatModel.dart';
import 'package:militarymessenger/models/ConversationModel.dart';
import 'package:militarymessenger/objectbox.g.dart';
import 'main.dart' as mains;
import 'Home.dart' as homes;
import 'package:http/http.dart' as http;
import 'package:militarymessenger/models/ContactGroupModel.dart';

class GroupInfo extends StatefulWidget {
  ConversationModel? conversation;
  int? roomId;

  GroupInfo(this.conversation, this.roomId);

  @override
  _GroupInfoState createState() => _GroupInfoState(conversation, roomId);
}

class _GroupInfoState extends State<GroupInfo> {
  String? photo = mains.objectbox.boxUser.get(1)?.photo;
  String apiKey = homes.apiKeyCore;
  ConversationModel? conversation;
  int? roomId;
  List<int> arrReceivers = [];
  var contactList,contactData,contactName;
  List<ContactGroupModel> contactGroup = [];
  StreamController<List<ContactGroupModel>>? StreamControllerContactGroup;

  _GroupInfoState(this.conversation, this.roomId);

  @override
  void initState() {
    // TODO: implement initState
    // arrReceivers = json.decode(conversation!.idReceiversGroup!).cast<int>();
    StreamControllerContactGroup = StreamController<List<ContactGroupModel>>();
    getListParticipantsGroup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
        title: Text('Group Info'.toUpperCase(),
          style: TextStyle(
              fontSize: 15
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditGroupInfo(conversation, roomId)),
                );
              },
              icon: Icon(Icons.more_vert_rounded)),
          SizedBox(width: 15,)
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Center(
              child: conversation!.photoProfile != '' && conversation!.photoProfile != null ?
              CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xffF2F1F6),
                backgroundImage:  Image.memory(base64.decode(conversation!.photoProfile!)).image,
              )
                  :
              CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xffF2F1F6),
                child: Icon(
                  Icons.people_alt_outlined,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 10,),
            Center(
              child: Text(conversation!.fullName!,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(height: 50,),
            StreamBuilder<List<ContactGroupModel>>(
                stream: this.StreamControllerContactGroup!.stream,
                builder: (context, snapshot) {
                  if(snapshot.data!=null){
                    List<ContactGroupModel> listContactGroup = snapshot.data!.toList();
                    listContactGroup.sort((a,b)=> a.userName!.toLowerCase().compareTo(b.userName!.toLowerCase()));
                    List<int?> listId = listContactGroup.map((e) => e.userId).toList();
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${snapshot.data!.toList().length} Participants'),
                        SizedBox(height: 20,),
                        // Container(
                        //   padding: EdgeInsets.only(top: 17, right: 17, left: 17),
                        //   decoration: BoxDecoration(
                        //       color: Theme.of(context).cardColor,
                        //       borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                        //   ),
                        //   child: Row(
                        //     children: [
                        //       CircleAvatar(
                        //         radius: 20,
                        //         backgroundColor: Color(0xffdde1ea),
                        //         backgroundImage: Image.memory(base64.decode(photo!)).image,
                        //
                        //       ),
                        //       SizedBox(width: 15,),
                        //       Text('You')
                        //     ],
                        //   ),
                        // ),
                        Container(
                          padding: EdgeInsets.all(17),
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
                          ),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: listContactGroup.length,
                            itemBuilder: (BuildContext context, index)=>
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        listContactGroup[index].photo == '' ? CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Color(0xffdde1ea),
                                          child:  Icon(
                                            Icons.person,
                                            color: Colors.grey,
                                          ),
                                        ) :CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Color(0xffF2F1F6),
                                          backgroundImage: Image.memory(base64.decode(listContactGroup[index].photo!)).image,
                                        ),
                                        SizedBox(width: 15,),
                                        listContactGroup[index].userId == mains.objectbox.boxUser.get(1)?.userId?
                                        Text("You")
                                            :
                                        Text(listContactGroup[index].userName!)
                                      ],
                                    ),
                                    SizedBox(height: 15,),
                                  ],
                                ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Card(
                            margin: EdgeInsets.all(0),
                            child: Container(
                                width: 100000,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>AddParticipantsGroup(conversation, roomId, listId)));
                                        },
                                        child: Container(
                                            width: 10000,
                                            padding: EdgeInsets.all(17),
                                            child: Text('Add New Participants')
                                        )
                                    ),
                                    Container(
                                      color: Colors.grey,
                                      height: 0.3,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        // _openDialog(context, conversation!);
                                        showCupertinoDialog(
                                            context: context,
                                            builder: (context) => CupertinoAlertDialog(
                                              title: Text("Exit Group"),
                                              content: Text("Are you sure you want to exit group?"),
                                              actions: [
                                                // Close the dialog
                                                // You can use the CupertinoDialogAction widget instead
                                                CupertinoButton(
                                                    child: Text('Cancel',
                                                      style: TextStyle(
                                                          color: Color(0xFF2481CF)
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    }),
                                                CupertinoButton(
                                                  child: Text('Yes',
                                                    style: TextStyle(
                                                        color: Colors.red
                                                    ),
                                                  ),
                                                  onPressed: () {

                                                    var query = mains.objectbox.boxConversation.query(ConversationModel_.roomId.equals(conversation!.roomId!)).build();
                                                    if(query.find().isNotEmpty) {

                                                      setState(() {
                                                        ConversationModel objConversation = ConversationModel(
                                                          id: query.find().first.id,
                                                          idReceiversGroup: query.find().first.idReceiversGroup,
                                                          fullName: query.find().first.fullName,
                                                          image: query.find().first.image,
                                                          photoProfile: query.find().first.photoProfile,
                                                          message: query.find().first.message,
                                                          date: query.find().first.date,
                                                          messageCout: query.find().first.messageCout,
                                                          statusReceiver: query.find().first.statusReceiver,
                                                          roomId: query.find().first.roomId,
                                                          exited: true,
                                                        );

                                                        mains.objectbox.boxConversation.put(objConversation);
                                                      });

                                                      final chat = ChatModel (
                                                        idSender: idUser,
                                                        idRoom: query.find().first.roomId,
                                                        idReceiversGroup: query.find().first.idReceiversGroup,
                                                        text: '${mains.objectbox.boxUser.get(1)?.userName} left',
                                                        tipe: 'system',
                                                        date: DateTime.now().toString(),
                                                        sendStatus: '',
                                                        delivered: 0,
                                                        read: 0,
                                                      );

                                                      int id = mains.objectbox.boxChat.put(chat);

                                                      var msg = {};
                                                      msg["api_key"] = apiKey;
                                                      msg["decrypt_key"] = "";
                                                      msg["id_chat_model"] = id;
                                                      msg["type"] = "group";
                                                      msg["system_feature"] = "left_group";
                                                      msg["id_sender"] = idUser;
                                                      msg["id_receivers"] = query.find().first.idReceiversGroup;
                                                      msg["msg_tipe"] = 'system';
                                                      msg["msg_data"] = '${mains.objectbox.boxUser.get(1)?.userName} left';
                                                      msg["room_id"] = query.find().first.roomId;
                                                      msg["group_name"] = query.find().first.fullName;

                                                      String msgString = json.encode(msg);

                                                      homes.channel.sink.add(msgString);

                                                      Navigator.of(context).pop();
                                                      Navigator.of(context).pop();
                                                      Navigator.of(context).pop();

                                                        //personal chat delete
                                                          var queryDel = mains.objectbox.boxChat.query( (ChatModel_.idRoom.equals(conversation!.roomId!))).build();
                                                          List<ChatModel> chats = queryDel.find().toList();
                                                          for(var chat in chats){
                                                            mains.objectbox.boxChat.remove(chat.id);
                                                          }
                                                        //delete conversation
                                                        mains.objectbox.boxConversation.remove(conversation!.id);
                                                    }

                                                  },
                                                )
                                              ],
                                            )
                                        );
                                        setState(() {

                                        });
                                      },
                                      child: Container(
                                          width: 10000,
                                          padding: EdgeInsets.all(17),
                                          child: Text('Exit Group',
                                            style: TextStyle(
                                                color: Colors.red
                                            ),
                                          )),
                                    ),
                                  ],
                                )
                            )
                        ),
                      ],
                    );
                  }else{
                    return Container();
                  }
                }
            )
          ],
        ),
      ),
    );
  }

  Future<http.Response> getListParticipantsGroup() async {

    String url ='https://chat.dev.r17.co.id/get_user.php';

    Map<String, dynamic> data = {
      'api_key': this.apiKey,
      'room_id': conversation!.roomId,
      'id_sender': mains.objectbox.boxUser.get(1)?.userId,
    };

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );
    if(response.statusCode == 200){
      Map<String, dynamic> userMap = jsonDecode(response.body);

      if(userMap['code_status'] == 0){

        for(int i = 0; i < userMap['data'].length; i++){
          contactList = Map<String, dynamic>.from(userMap['data'][i]);

          contactGroup.add(ContactGroupModel(
              id: i,
              userId: contactList['id'],
              email: contactList['email'],
              userName: contactList['name'],
              photo: contactList['photo']=='' || contactList['photo'] == null ? '':contactList['photo'],
              phone: contactList['phone']
          ));
        }

        StreamControllerContactGroup!.add(contactGroup);

      }else{
        print("ada yang salah!");
      }
    }
    else{
      print(response.statusCode);
      print("Gagal terhubung ke server!");
    }
    return response;
  }

}

// void _openDialog(ctx, ConversationModel conversation) {
//   showCupertinoDialog(
//       context: ctx,
//       builder: (_) => CupertinoAlertDialog(
//         title: Text("Exit Group"),
//         content: Text("Are you sure you want to exit group?"),
//         actions: [
//           // Close the dialog
//           // You can use the CupertinoDialogAction widget instead
//           CupertinoButton(
//               child: Text('Cancel',
//                 style: TextStyle(
//                     color: Color(0xFF2481CF)
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.of(ctx).pop();
//               }),
//           CupertinoButton(
//             child: Text('Yes',
//               style: TextStyle(
//                   color: Colors.red
//               ),
//             ),
//             onPressed: () {
//
//               var query = mains.objectbox.boxConversation.query(ConversationModel_.roomId.equals(conversation.roomId!)).build();
//               if(query.find().isNotEmpty) {
//
//                 ConversationModel objConversation = ConversationModel(
//                     id: query.find().first.id,
//                     idReceiversGroup: query.find().first.idReceiversGroup,
//                     fullName: "asda",
//                     image: query.find().first.image,
//                     photoProfile: query.find().first.photoProfile,
//                     message: query.find().first.message,
//                     date: query.find().first.date,
//                     messageCout: query.find().first.messageCout,
//                     statusReceiver: "exit",
//                     roomId: query.find().first.roomId,
//                     exited: true,
//                 );
//
//                 mains.objectbox.boxConversation.put(objConversation);
//
//                 final chat = ChatModel (
//                   idSender: idUser,
//                   idRoom: query.find().first.roomId,
//                   idReceiversGroup: query.find().first.idReceiversGroup,
//                   text: '${mains.objectbox.boxUser.get(1)?.userName} left',
//                   tipe: 'system',
//                   date: DateTime.now().toString(),
//                   sendStatus: '',
//                   delivered: 0,
//                   read: 0,
//                 );
//
//                 int id = mains.objectbox.boxChat.put(chat);
//
//                 var msg = {};
//                 msg["api_key"] = apiKey;
//                 msg["decrypt_key"] = "";
//                 msg["id_chat_model"] = id;
//                 msg["type"] = "group";
//                 msg["system_feature"] = "left_group";
//                 msg["id_sender"] = idUser;
//                 msg["id_receivers"] = query.find().first.idReceiversGroup;
//                 msg["msg_tipe"] = 'system';
//                 msg["msg_data"] = '${mains.objectbox.boxUser.get(1)?.userName} left';
//                 msg["room_id"] = query.find().first.roomId;
//                 msg["group_name"] = query.find().first.fullName;
//
//                 String msgString = json.encode(msg);
//
//                 homes.channel.sink.add(msgString);
//                 Navigator.of(ctx).pop();
//                 Navigator.of(ctx).pop();
//                 Navigator.of(ctx).pop();
//                 Navigator.push(ctx,MaterialPageRoute(builder: (context) => (ChatGroup(objConversation, conversation.roomId, "change_group_name"))),);
//               }
//
//             },
//           )
//         ],
//       )
//   );
// }