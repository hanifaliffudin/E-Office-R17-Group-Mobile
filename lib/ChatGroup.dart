import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'dart:io' as Io;


import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:militarymessenger/GroupInfo.dart';
import 'package:militarymessenger/cards/group_friend_message_card.dart';
import 'package:militarymessenger/cards/group_my_message_card.dart';
import 'package:militarymessenger/cards/system_message.dart';
import 'package:militarymessenger/contact.dart';
import 'package:militarymessenger/models/ChatModel.dart';
import 'package:militarymessenger/models/ContactGroupModel.dart';
import 'package:militarymessenger/models/ContactModel.dart';
import 'package:militarymessenger/models/ConversationModel.dart';
import 'package:militarymessenger/objectbox.g.dart';
import 'package:open_file/open_file.dart';
import 'package:swipe_to/swipe_to.dart';
import 'main.dart' as mains;
import 'package:http/http.dart' as http;
import 'Home.dart' as homes;


class ChatGroup extends StatefulWidget {
  ConversationModel? conversation;
  int? roomId;
  String? groupSystem;

  ChatGroup(this.conversation, this.roomId, this.groupSystem);

  @override
  State<ChatGroup> createState() => _ChatGroupState(conversation, roomId, groupSystem);
}

List<BubbleColor> bubbleColor = [];

class _ChatGroupState extends State<ChatGroup> {
  String apiKey = homes.apiKeyCore;
  var contactList,contactData,contactName;
  List<ContactGroupModel> contactGroup = [];
  StreamController<List<ContactGroupModel>>? StreamControllerContactGroup;

  ConversationModel? conversation;
  int? roomId;
  String? groupSystem;

  _ChatGroupState(this.conversation, this.roomId, this.groupSystem);
  int? idUser;
  String? nameReceivers;

  TextEditingController inputTextController = new TextEditingController();

  Timer? timer;

  @override
  void initState() {
    idUser = mains.objectbox.boxUser.get(1)?.userId;

    StreamControllerContactGroup = StreamController<List<ContactGroupModel>>();

    getDataUser();
    nameList = [];

    nameReceivers = nameList.join(", ");

    if(groupSystem == "new_group"){
      final chat = ChatModel (
        idSender: idUser,
        idRoom: roomId,
        idReceiversGroup: conversation!.idReceiversGroup,
        text: '${mains.objectbox.boxUser.get(1)?.userName} created group "${conversation?.fullName}"',
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
      msg["id_sender"] = idUser;
      msg["id_receivers"] = conversation!.idReceiversGroup;
      msg["msg_tipe"] = 'system';
      msg["msg_data"] = '${mains.objectbox.boxUser.get(1)?.userName} created group "${conversation?.fullName}"';
      msg["room_id"] = roomId;
      msg["group_name"] = conversation?.fullName;

      String msgString = json.encode(msg);

      homes.channel.sink.add(msgString);
    }

    getListParticipantsGroup();

    //get our chats where failed to send
    int checkChatsNotSent(){
      var queryNotSent = mains.objectbox.boxChat.query(ChatModel_.sendStatus.equals("") & ChatModel_.idRoom.equals(conversation!.roomId!) & ChatModel_.idSender.equals(idUser!) & ChatModel_.tipe.notEquals("system")).build();
      List<ChatModel> chatsNotSent = queryNotSent.find().toList();
      return chatsNotSent.length;
    }
    void getFailedChat(){
      var queryNotSent = mains.objectbox.boxChat.query(ChatModel_.sendStatus.equals("") & ChatModel_.idRoom.equals(conversation!.roomId!) & ChatModel_.idSender.equals(idUser!) & ChatModel_.tipe.notEquals("system")).build();
      List<ChatModel> chatsNotSent = queryNotSent.find().toList();
      for(int i=0;i<chatsNotSent.length;i++){
        var msg = {};
        msg["api_key"] = apiKey;
        msg["decrypt_key"] = "";
        msg["id_chat_model"] = chatsNotSent[i].id;
        msg["type"] = "group";
        msg["id_sender"] = chatsNotSent[i].idSender;
        msg["id_receivers"] = chatsNotSent[i].idReceiversGroup;
        msg["msg_tipe"] = chatsNotSent[i].tipe;
        msg["msg_data"] = chatsNotSent[i].text;
        msg["room_id"] = roomId;
        msg["group_name"] = conversation!.fullName;
        if(chatsNotSent[i].tipe == "file"){
          final bytes = Io.File(chatsNotSent[i].content!).readAsBytesSync();
          String file64 = base64Encode(bytes);
          msg["file"] = file64;
        }else if(chatsNotSent[i].tipe == "image"){
          final bytes = Io.File(chatsNotSent[i].content!).readAsBytesSync();
          String img64 = base64Encode(bytes);
          msg["image"] = img64;
        }

        String msgString = json.encode(msg);
        homes.channel.sink.add(msgString);
      }
    }
    if(checkChatsNotSent()>0){
      getFailedChat();
    }

    super.initState();
    timer = Timer.periodic(Duration(seconds: 7), (Timer t) {
      if(checkChatsNotSent()>0){
        getFailedChat();
      }
    });

  }

  bool firstTime = true;

  //emoji
  bool emojiShowing = false;
  bool isKeyboardVisible = false;

  _onEmojiSelected(Emoji emoji) {
    inputTextController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: inputTextController.text.length));
  }
  _onBackspacePressed() {
    inputTextController
      ..text = inputTextController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: inputTextController.text.length));
  }
  final _focusNode = FocusNode();

  @override
  File? image;
  Contact? contact;

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? imagePicked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 25);

    if(imagePicked!=null)
      cropImage(imagePicked.path);
  }

  Future getCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? imageCamera = await _picker.pickImage(source: ImageSource.camera);

    cropImage(imageCamera!.path);
  }

  Future cropImage(filePath) async {
    File? croppedImage = await ImageCropper().cropImage(
        sourcePath: filePath,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop image',
            toolbarColor: Color(0xFF2481CF),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );

    if (croppedImage != null) {
      setState(() {
        image = croppedImage;
        final bytes = Io.File(croppedImage.path).readAsBytesSync();
        String img64 = base64Encode(bytes);

        final chat = ChatModel (
          idSender: idUser,
          idRoom: roomId,
          idReceiversGroup: conversation!.idReceiversGroup,
          text: 'Photo',
          tipe: 'image',
          content: croppedImage.path,
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
        msg["id_sender"] = idUser;
        msg["id_receivers"] = conversation!.idReceiversGroup;
        msg["msg_tipe"] = 'image';
        msg["msg_data"] = "Photo";
        msg["room_id"] = roomId;
        msg["group_name"] = conversation?.fullName;
        msg['image'] = img64;

        String msgString = json.encode(msg);

        homes.channel.sink.add(msgString);
      });
    }
  }

  Future getContact() async {
    final FlutterContactPicker _contactPicker = new FlutterContactPicker();
    Contact? contacts = await _contactPicker.selectContact();
    setState(() {
      contact = contacts;
    });
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  @override
  Widget build(BuildContext context) {
    List<ContactModel> contactList = [];

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(63.0),
          child: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            elevation: 0,
            titleSpacing: 0,
            title: StreamBuilder<List<ConversationModel>>(
                stream: homes.listControllerConversation.stream,
                builder: (context, snapshot) {
                  if(snapshot.data!=null){
                    List<ConversationModel> uhuy = snapshot.data!.where((element) => element.id == conversation!.id).toList();
                    conversation = uhuy[0];
                  }

                  return InkWell(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => GroupInfo(conversation, roomId)),
                      );
                    },
                    child: ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: ClipOval(
                            child: conversation!.photoProfile != '' && conversation!.photoProfile != null ? CircleAvatar(
                              backgroundImage:  Image.memory(base64.decode(conversation!.photoProfile!)).image,
                              backgroundColor: Color(0xffF2F1F6),
                              radius: 20,
                            ):
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Color(0xffdde1ea),
                              child:  Icon(
                                Icons.people_rounded,
                                color: Colors.grey,
                              ),
                            )
                        ),
                        title: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: 220
                          ),
                          child: Text(
                            conversation!.fullName!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(color: Colors.white, fontSize: 15,),
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            // Text('You, ',
                            //   style: TextStyle(
                            //       color: Colors.white.withOpacity(.7),
                            //       fontSize: 12
                            //   ),
                            // ),
                            Expanded(
                              child: Container(
                                height: 15,
                                child: StreamBuilder<List<ContactGroupModel>>(
                                  stream: this.StreamControllerContactGroup!.stream,
                                  builder: (context, snapshot){
                                    if(snapshot.data!=null){
                                      List<ContactGroupModel> listContactGroup = snapshot.data!.toList();
                                      listContactGroup.sort((a,b)=> a.userName!.toLowerCase().compareTo(b.userName!.toLowerCase()));

                                      return Container(
                                        height: 15,
                                        child: ListView.builder(
                                          itemCount: listContactGroup.length,
                                          scrollDirection: Axis.horizontal,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index)=>
                                          index != listContactGroup.length-1 ?
                                          Text("${listContactGroup[index].userName!.split(" ")[0]}, ",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(.7),
                                              fontSize: 12,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                              :
                                          Text(listContactGroup[index].userName!.split(" ")[0],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(.7),
                                              fontSize: 12,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      );
                                    }else{
                                      return Container(
                                        child: Text('tap here for group info'),
                                      );
                                    }

                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                  );
                }
            ),
            actions: <Widget>[
              SizedBox(
                width: 15,
              ),
              Icon(Icons.videocam),
              SizedBox(
                width: 15,
              ),
              Icon(Icons.call),
              SizedBox(
                width: 15,
              ),
            ],
          ),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  child: Column(
                    children: [
                      Expanded(
                        child: StreamBuilder<List<ChatModel>>(
                            stream: homes.listController.stream,
                            builder: (context, snapshot)
                            {
                              if(snapshot.data != null){
                                //update chat read when standby chat
                                var standby = mains.objectbox.boxChat.query(ChatModel_.idRoom.equals(conversation!.roomId!) & ChatModel_.read.equals(0) & ChatModel_.idChatFriends.notNull() & ChatModel_.tipe.notEquals("system")).build();
                                List<ChatModel> chatsUnread = standby.find().toList();
                                for(int i=0;i<chatsUnread.length;i++){
                                  var msg = {};
                                  msg["api_key"] = apiKey;
                                  msg["type"] = "group_read";
                                  msg["id_chat_model_friends"] = chatsUnread[i].idChatFriends;
                                  msg["id_sender"] = chatsUnread[i].idSender;
                                  msg["id_receivers"] = chatsUnread[i].idReceiversGroup;
                                  msg["msg_tipe"] = chatsUnread[i].tipe;
                                  msg["room_id"] = conversation!.roomId;
                                  String msgString = json.encode(msg);
                                  homes.channel.sink.add(msgString);

                                  // update status to read=1
                                  final chat = ChatModel(
                                    id: chatsUnread[i].id,
                                    idChatFriends: chatsUnread[i].idChatFriends,
                                    idSender: chatsUnread[i].idSender,
                                    nameSender: chatsUnread[i].nameSender,
                                    idRoom: chatsUnread[i].idRoom,
                                    idReceiversGroup: chatsUnread[i].idReceiversGroup,
                                    text: chatsUnread[i].text,
                                    tipe: chatsUnread[i].tipe,
                                    content: chatsUnread[i].content,
                                    date: chatsUnread[i].date,
                                    sendStatus: chatsUnread[i].sendStatus,
                                    delivered: 1,
                                    read: chatsUnread[i].read!+1,
                                  );
                                  mains.objectbox.boxChat.put(chat);

                                }



                                var queryBuilder = mains.objectbox.boxChat.query( ( ChatModel_.idRoom.equals(conversation!.roomId!)) )..order(ChatModel_.date);
                                var query = queryBuilder.build();
                                List<ChatModel> chats = query.find().reversed.toList();
                                
                                DateTime now = new DateTime.now();

                                if(query.find().isNotEmpty){
                                  ConversationModel objConversation = ConversationModel(
                                      id: conversation!.id,
                                      message: query.find().toList().length == 0 ? '' : query.find().last.text,
                                      idReceiversGroup: conversation!.idReceiversGroup,
                                      fullName: conversation!.fullName,
                                      image: '',
                                      photoProfile: conversation!.photoProfile,
                                      date: query.find().last.date,
                                      roomId: conversation!.roomId,
                                      messageCout: 0);

                                  mains.objectbox.boxConversation.put(objConversation);
                                }

                                List<MaterialColor> primary = <MaterialColor>[
                                  Colors.red,
                                  Colors.pink,
                                  Colors.purple,
                                  Colors.deepPurple,
                                  Colors.indigo,
                                  Colors.blue,
                                  Colors.teal,
                                  Colors.green,
                                  Colors.orange,
                                  Colors.brown,
                                  Colors.blueGrey,
                                ];

                                for(var item in json.decode(conversation!.idReceiversGroup!)){
                                  if(!bubbleColor.map((e) => e.idUser).contains(item)){
                                    bubbleColor.add(BubbleColor(idUser: item, Color: primary[Random().nextInt(primary.length)]));
                                  }
                                }

                                return ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    reverse: true,
                                    shrinkWrap: false,
                                    padding: const EdgeInsets.only(top: 2, bottom: 2),
                                    itemCount: chats.length!=0 ? chats.length : 0,
                                    itemBuilder: (context, index) {
                                      var content = chats[index].idSender == idUser ?
                                      SwipeTo(
                                          onLeftSwipe: () {
                                          },
                                          child: chats[index].tipe == 'text' ?
                                          MyMessageCardGroup(
                                            chats[index].text,
                                            chats[index].sendStatus == "" ?
                                            ""
                                                :
                                            DateFormat.Hm().format( DateTime.parse(chats[index].date) ),
                                            chats[index].read!,
                                            chats[index].tipe!,
                                            '',
                                            index+1==chats.length?true:chats[index].idSender==chats[index+1].idSender?false:true,
                                            false,
                                          )
                                              : chats[index].tipe == 'image' ?
                                          MyMessageCardGroup(
                                            chats[index].content!,
                                            chats[index].sendStatus == "" ?
                                            ""
                                                :
                                            DateFormat.Hm().format( DateTime.parse(chats[index].date) ),
                                            chats[index].read!,
                                            chats[index].tipe!,
                                            chats[index].content!,
                                            false,
                                            true,
                                          )
                                              : chats[index].tipe == 'file' ?
                                          MyMessageCardGroup(
                                            chats[index].text,
                                            chats[index].sendStatus == "" ?
                                            ""
                                                :
                                            DateFormat.Hm().format( DateTime.parse(chats[index].date) ),
                                            chats[index].read!,
                                            chats[index].tipe!,
                                            chats[index].content!,
                                            false,
                                            true,
                                          )
                                              :
                                          //    card system bubble
                                          SystemMessage(
                                            chats[index].text,
                                          )
                                      ) :
                                      chats[index].tipe == 'text' ?
                                      FriendMessageCardGroup(
                                        chats[index].idSender!,
                                        chats[index].nameSender.toString(),
                                        chats[index].text,
                                        DateFormat.Hm().format( DateTime.parse(chats[index].date) ),
                                        bubbleColor.where((element) => element.idUser == chats[index].idSender).map((e) => e.Color).toString(),
                                        chats[index].tipe!,
                                        '',
                                        index+1==chats.length?true:chats[index].idSender==chats[index+1].idSender?false:true,
                                        false,
                                      )
                                          : chats[index].tipe == 'image' ?
                                      FriendMessageCardGroup(
                                        chats[index].idSender!,
                                        chats[index].nameSender.toString(),
                                        chats[index].content!,
                                        DateFormat.Hm().format( DateTime.parse(chats[index].date) ),
                                        bubbleColor.where((element) => element.idUser == chats[index].idSender).map((e) => e.Color).toString(),
                                        chats[index].tipe!,
                                        chats[index].content!,
                                        false,
                                        true,
                                      )
                                          : chats[index].tipe == 'file' ?
                                      FriendMessageCardGroup(
                                        chats[index].idSender!,
                                        chats[index].nameSender.toString(),
                                        chats[index].text,
                                        DateFormat.Hm().format( DateTime.parse(chats[index].date) ),
                                        bubbleColor.where((element) => element.idUser == chats[index].idSender).map((e) => e.Color).toString(),
                                        chats[index].tipe!,
                                        chats[index].content!,
                                        false,
                                        true,
                                      )
                                          :
                                      //    system bubble
                                      SystemMessage(
                                        chats[index].text,
                                      );
                                    
                                      DateTime date2 = DateTime.parse(chats[index].date);
                                      bool isLessThan7 = daysBetween(date2, now) <= 7;
                                      bool isSame = false;
                                      String desc = "";

                                      if (index != chats.length-1) {
                                        isSame = DateFormat('yyyy-MM-dd').format(DateTime.parse(chats[index].date)) == DateFormat('yyyy-MM-dd').format(DateTime.parse(chats[index+1].date));
                                      }

                                      if (!isSame) {
                                        if (isLessThan7) {
                                          bool isToday = DateFormat('yyyy-MM-dd').format(now) == DateFormat('yyyy-MM-dd').format(DateTime.parse(chats[index].date));
                                          bool isYesterday = daysBetween(date2, now) == 1;

                                          if (isToday) {
                                            desc = "Today";
                                          } else if (isYesterday) {
                                            desc = "Yesterday";
                                          } else {
                                            desc = DateFormat('E').format(DateTime.parse(chats[index].date));
                                          }
                                        } else {
                                          desc = DateFormat('yyyy-MM-dd').format(DateTime.parse(chats[index].date));
                                        }
                                      }
// DateTime lastDayOfMonth = new DateTime(now.year, now.month, (now.day+4)-6);
                                      return Column(
                                        children: [
                                          !isSame ?
                                          Container(
                                            padding: const EdgeInsets.all(8.0),
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 8.0,
                                            ),
                                            child: Text(
                                              desc,
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                          ) : Container(),
                                          content,
                                        ],
                                      );
                                    }
                                );
                              }else{
                                if (snapshot.hasError) {
                                  print(snapshot.error.toString());
                                  return const Text("Error");
                                }
                                return const CircularProgressIndicator();
                              }
                            }
                        ),
                      )
                      ,
                    ],
                  ),
                ),
              ),
              Container(
                color: Theme.of(context).backgroundColor,
                padding: Platform.isAndroid ?
                EdgeInsets.only(right: 10, left: 10, top: 7, bottom: 7):
                EdgeInsets.only(right: 10, left: 10, top: 7, bottom: 25),
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.only(top: 10, bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        constraints: BoxConstraints(
                          minHeight: 25.0,
                          maxHeight: 100,
                          minWidth: MediaQuery.of(context).size.width,
                          maxWidth: MediaQuery.of(context).size.width,
                        ),
                        child: Scrollbar(
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    emojiShowing = !emojiShowing;
                                    if (emojiShowing) {
                                      _focusNode.unfocus();
                                    }
                                    else {
                                      FocusScope.of(context).requestFocus(_focusNode);
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.tag_faces,
                                  color: Colors.grey,
                                ),
                              ),
                              Expanded(
                                child: FocusScope(
                                  child: Focus(
                                    onFocusChange: (focus) {
                                      if(focus){
                                        emojiShowing = false;
                                      }
                                    },
                                    child: TextField(
                                      focusNode: _focusNode,
                                      cursorColor: Color(0xFF2481CF),
                                      keyboardType: TextInputType.multiline,
                                      controller: inputTextController,
                                      maxLines: null,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15
                                      ),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(top: 13, bottom: 13),
                                          border: InputBorder.none,
                                          hintText: 'Type a message',
                                          hintStyle: TextStyle(
                                              color: Color(0xff99999B),
                                              fontSize: 15
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Transform.rotate(
                                angle: 70,
                                child: IconButton(
                                  onPressed: () {
                                    showCupertinoModalPopup(
                                        context: context,
                                        builder: (context) => CupertinoActionSheet(
                                          actions: <Widget>[
                                            Container(
                                              color: Colors.white,
                                              child: CupertinoActionSheetAction(
                                                onPressed: () {
                                                  getCamera();
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'Camera',
                                                  style: TextStyle(
                                                      color: Color(0xFF2481CF)
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              color: Colors.white,
                                              child: CupertinoActionSheetAction(
                                                onPressed: () {
                                                  getImage();
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'Photo & Video Library',
                                                  style: TextStyle(
                                                      color: Color(0xFF2481CF)
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              color: Colors.white,
                                              child: CupertinoActionSheetAction(
                                                child: const Text(
                                                  'Documents',
                                                  style: TextStyle(
                                                      color: Color(0xFF2481CF)
                                                  ),
                                                ),
                                                onPressed: () {
                                                  pickFile();
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                            Container(
                                              color: Colors.white,
                                              child: CupertinoActionSheetAction(
                                                child: const Text(
                                                  'Contacts',
                                                  style: TextStyle(
                                                      color: Color(0xFF2481CF)
                                                  ),
                                                ),
                                                onPressed: () {
                                                  // getContact();
                                                },
                                              ),
                                            ),
                                          ],
                                          cancelButton: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: CupertinoActionSheetAction(
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: Color(0xFF2481CF)
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                        )
                                    );
                                  },
                                  icon: Icon(
                                    Icons.attach_file_rounded,
                                    size: 25,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 8),
                        child: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () async {
                            if(inputTextController.text.trim().isEmpty) {
                              print(conversation!.roomId!);
                            }else{
                              final chat = ChatModel (
                                idSender: idUser,
                                idRoom: roomId,
                                idReceiversGroup: conversation!.idReceiversGroup,
                                text: inputTextController.text,
                                tipe: 'text',
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
                              msg["id_sender"] = idUser;
                              msg["id_receivers"] = conversation!.idReceiversGroup;
                              msg["msg_tipe"] = 'text';
                              msg["msg_data"] = chat.text;
                              msg["room_id"] = roomId;
                              msg["group_name"] = conversation?.fullName;

                              String msgString = json.encode(msg);

                              homes.channel.sink.add(msgString);

                              inputTextController.clear();

                            }
                          },
                          color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
                        )
                    )
                  ],
                ),
              ),
              Offstage(
                offstage: !emojiShowing,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    height: 250,
                    child: EmojiPicker(
                        onEmojiSelected: (Category category, Emoji emoji) {
                          _onEmojiSelected(emoji);
                        },
                        onBackspacePressed: _onBackspacePressed,
                        config: Config(
                            columns: 8,
                            // Issue: https://github.com/flutter/flutter/issues/28894
                            emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                            verticalSpacing: 0,
                            horizontalSpacing: 0,
                            initCategory: Category.SMILEYS,
                            bgColor: Theme.of(context).scaffoldBackgroundColor,
                            indicatorColor: Colors.blue,
                            iconColor: Colors.grey,
                            iconColorSelected: Colors.blue,
                            progressIndicatorColor: Colors.blue,
                            backspaceColor: Colors.blue,
                            skinToneDialogBgColor: Colors.white,
                            skinToneIndicatorColor: Colors.grey,
                            enableSkinTones: true,
                            showRecentsTab: true,
                            recentsLimit: 28,
                            tabIndicatorAnimDuration: kTabScrollDuration,
                            categoryIcons: const CategoryIcons(),
                            buttonMode: ButtonMode.MATERIAL)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['doc', 'pdf'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      final bytes = Io.File(file.path!).readAsBytesSync();
      String file64 = base64Encode(bytes);

      final chat = ChatModel (
        idSender: idUser,
        idRoom: roomId,
        idReceiversGroup: conversation!.idReceiversGroup,
        text: file.name,
        date: DateTime.now().toString(),
        tipe: "file",
        content: file.path,
        sendStatus: '',
        delivered: 0,
        read: 0,
      );

      int id = mains.objectbox.boxChat.put(chat);

      //send file message
      var msg = {};
      msg["api_key"] = apiKey;
      msg["decrypt_key"] = "";
      msg["id_chat_model"] = id;
      msg["type"] = "group";
      msg["id_sender"] = idUser;
      msg["id_receivers"] = conversation!.idReceiversGroup;
      msg["msg_tipe"] = 'file';
      msg["msg_data"] = file.name;
      msg["room_id"] = roomId;
      msg["group_name"] = conversation?.fullName;
      msg["file"] = file64;

      String msgString = json.encode(msg);

      homes.channel.sink.add(msgString);
    }else{
      return;
    }

    // PlatformFile? file = result!.files.first;

  }

  void viewFile(PlatformFile file) {
    OpenFile.open(file.path);
  }

  Future<http.Response> getDataUser() async {

    String url ='https://chat.dev.r17.co.id/get_user.php';

    Map<String, dynamic> data = {
      'api_key': this.apiKey,
      'id_receivers': conversation!.idReceiversGroup,
    };

    //encode Map to JSON
    //var body = "?api_key="+this.apiKey;

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );
    if(response.statusCode == 200){
      //print("${response.body}");
      Map<String, dynamic> userMap = jsonDecode(response.body);

      if(userMap['code_status'] == 0){



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

  Future<http.Response> getListParticipantsGroup() async {

    String url ='https://chat.dev.r17.co.id/get_user.php';

    Map<String, dynamic> data = {
      'api_key': this.apiKey,
      'room_id': conversation!.roomId,
      'id_sender': idUser,
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

class BubbleColor{
  int? idUser;
  MaterialColor? Color;

  BubbleColor({this.idUser, this.Color});
}

class TriangleClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper2 oldClipper) => false;
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}