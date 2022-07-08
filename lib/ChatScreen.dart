import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;


import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:militarymessenger/ProfileInfo.dart';
import 'package:militarymessenger/models/ConversationModel.dart';
import 'package:militarymessenger/models/ChatModel.dart';
import 'package:militarymessenger/cards/friend_message_card_personal.dart';
import 'package:militarymessenger/cards/my_message_card_personal.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:open_file/open_file.dart';
import 'functions/index_function.dart';

import 'objectbox.g.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'main.dart' as mains;
import 'Home.dart' as homes;

int lastConnection = 0;

class ChatScreen extends StatefulWidget {
  final ConversationModel? conversation;
  Store? store;
  int roomId;
  ChatModel? chatFocus;

  ChatScreen(
    this.conversation, 
    this.roomId,
    this.chatFocus,
  );


  @override
  _ChatScreenState createState() => _ChatScreenState(conversation,roomId,chatFocus);
}

class _ChatScreenState extends State<ChatScreen> {
  final ConversationModel? conversation;
  int? roomId;
  Store? store;
  ChatModel? chatFocus;
  final itemKey = GlobalKey();
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  _ChatScreenState(this.conversation, this.roomId, this.chatFocus);
  int? idUser;
  int? idReceiver;

  TextEditingController inputTextController = TextEditingController();

  String apiKey = homes.apiKeyCore;

  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    idUser = mains.objectbox.boxUser.get(1)?.userId;
    idReceiver = conversation?.idReceiver;

    // var semua = mains.objectbox.boxChat.query( (ChatModel_.idReceiver.equals(idReceiver!) & (ChatModel_.idSender.equals(idUser!)))).build();
    // List<ChatModel> listSemua = semua.find().toList();
    // for(int i=0;i<listSemua.length;i++){
    //   print('id: ${listSemua[i].id}');
    //   print('text: ${listSemua[i].text}');
    // }


    //update others chat read when open chat
    int checkChatsRead(){
      var queryUnread = mains.objectbox.boxChat.query(ChatModel_.read.equals(0) & (ChatModel_.idReceiver.equals(idUser!) & (ChatModel_.idSender.equals(idReceiver!)))).build();
      List<ChatModel> chatsUnread = queryUnread.find().toList();
      return chatsUnread.length;
    }
    void setChatsToRead(){
      var queryUnread = mains.objectbox.boxChat.query(ChatModel_.read.equals(0) & (ChatModel_.idReceiver.equals(idUser!) & (ChatModel_.idSender.equals(idReceiver!)))).build();
      List<ChatModel> chatsUnread = queryUnread.find().toList();
      for(int i=0;i<chatsUnread.length;i++){
        var msg = {};
        msg["api_key"] = apiKey;
        msg["type"] = "status_read";
        msg["id_chat_model"] = chatsUnread[i].id;
        msg["id_chat_model_friends"] = chatsUnread[i].idChatFriends;
        msg["id_sender"] = chatsUnread[i].idSender;
        msg["id_receiver"] = chatsUnread[i].idReceiver;
        msg["msg_tipe"] = chatsUnread[i].tipe;
        msg["room_id"] = conversation!.roomId;
        String msgString = json.encode(msg);
        homes.channel.sink.add(msgString);

        //update status to read=1 deliver=1
        final chat = ChatModel(
          id: chatsUnread[i].id,
          idChatFriends: chatsUnread[i].idChatFriends,
          idSender: chatsUnread[i].idSender,
          idReceiver: chatsUnread[i].idReceiver,
          text: chatsUnread[i].text,
          date: chatsUnread[i].date,
          tipe: chatsUnread[i].tipe,
          content: chatsUnread[i].content,
          sendStatus: chatsUnread[i].sendStatus,
          delivered: 1,
          read: 1,
          readDB: 0
        );
        mains.objectbox.boxChat.put(chat);
      }
    }
    if(checkChatsRead() > 0){
      setChatsToRead();
    }

    //update others chat read in db where chat read when offline
    int checkChatsUnreadDb(){
      var queryUnreadDb = mains.objectbox.boxChat.query(ChatModel_.read.equals(1) & ChatModel_.readDB.equals(0) & (ChatModel_.idReceiver.equals(idUser!) & (ChatModel_.idSender.equals(idReceiver!)))).build();
      List<ChatModel> chatsUnreadDb = queryUnreadDb.find().toList();
      return chatsUnreadDb.length;
    }
    void setChatsToReadDb(){
      var queryUnreadDb = mains.objectbox.boxChat.query(ChatModel_.read.equals(1) & ChatModel_.readDB.equals(0) & (ChatModel_.idReceiver.equals(idUser!) & (ChatModel_.idSender.equals(idReceiver!)))).build();
      List<ChatModel> chatsUnreadDb = queryUnreadDb.find().toList();

      for(int i=0;i<chatsUnreadDb.length;i++){
        var msg = {};
        msg["api_key"] = apiKey;
        msg["type"] = "status_read";
        msg["id_chat_model"] = chatsUnreadDb[i].id;
        msg["id_chat_model_friends"] = chatsUnreadDb[i].idChatFriends;
        msg["id_sender"] = chatsUnreadDb[i].idSender;
        msg["id_receiver"] = chatsUnreadDb[i].idReceiver;
        msg["msg_tipe"] = chatsUnreadDb[i].tipe;
        msg["room_id"] = conversation!.roomId;
        String msgString = json.encode(msg);
        homes.channel.sink.add(msgString);
      }
    }
    if(checkChatsUnreadDb() > 0){
      setChatsToReadDb();
    }

    //get our chats where undelivered and unread for check in db
    int checkChatsDelivNRead(){
      var queryDelivNRead = mains.objectbox.boxChat.query(ChatModel_.read.equals(0) & (ChatModel_.idReceiver.equals(idReceiver!) & (ChatModel_.idSender.equals(idUser!)))).build();
      List<ChatModel> chatsUndelivNUnread = queryDelivNRead.find().toList();
      return chatsUndelivNUnread.length;
    }
    void getUndelUnreadChat(){
      var queryDelivNRead = mains.objectbox.boxChat.query(ChatModel_.read.equals(0) & (ChatModel_.idReceiver.equals(idReceiver!) & (ChatModel_.idSender.equals(idUser!)))).build();
      List<ChatModel> chatsUndelivNUnread = queryDelivNRead.find().toList();
      // print("chatsUndelivNUnread: ${chatsUndelivNUnread.map((e) => e.text)}");

      for(int i=0;i<chatsUndelivNUnread.length;i++){
        var msg = {};
        msg["api_key"] = apiKey;
        msg["type"] = "check_status";
        msg["id_chat_model"] = chatsUndelivNUnread[i].id;
        msg["id_sender"] = chatsUndelivNUnread[i].idSender;
        msg["id_receiver"] = chatsUndelivNUnread[i].idReceiver;
        msg["msg_tipe"] = chatsUndelivNUnread[i].tipe;
        msg["msg_data"] = chatsUndelivNUnread[i].text;
        msg["date"] = chatsUndelivNUnread[i].date;
        msg["room_id"] = conversation!.roomId;
        String msgString = json.encode(msg);
        
        homes.channel.sink.add(msgString);
      }
    }
    if(checkChatsDelivNRead()>0){
      getUndelUnreadChat();
    }

    //get our chats where failed to send
    int checkChatsNotSent(){
      var queryNotSent = mains.objectbox.boxChat.query(ChatModel_.sendStatus.equals("") & (ChatModel_.idReceiver.equals(idReceiver!) & (ChatModel_.idSender.equals(idUser!)))).build();
      List<ChatModel> chatsNotSent = queryNotSent.find().toList();
      return chatsNotSent.length;
    }
    void getFailedChat(){
      var queryNotSent = mains.objectbox.boxChat.query(ChatModel_.sendStatus.equals("") & (ChatModel_.idReceiver.equals(idReceiver!) & (ChatModel_.idSender.equals(idUser!)))).build();
      List<ChatModel> chatsNotSent = queryNotSent.find().toList();
      for(int i=0;i<chatsNotSent.length;i++){
        var msg = {};
        msg["api_key"] = apiKey;
        msg["decrypt_key"] = "";
        msg["id_chat_model"] = chatsNotSent[i].id;
        msg["id_chat_db"] = chatsNotSent[i].idChat;
        msg["type"] = "pm";
        msg["id_sender"] = chatsNotSent[i].idSender;
        msg["id_receiver"] = chatsNotSent[i].idReceiver;
        msg["msg_tipe"] = chatsNotSent[i].tipe;
        msg["msg_data"] = chatsNotSent[i].text;
        msg["room_id"] = roomId;
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

    //update conversation on open chat
    final objConversation = ConversationModel(
      id: conversation!.id,
      message: conversation!.message,
      date: conversation!.date,
      idReceiver: conversation!.idReceiver,
      fullName: conversation!.fullName,
      image: conversation!.image,
      photoProfile: conversation!.photoProfile,
      messageCout: 0,
      statusReceiver: conversation!.statusReceiver,
      roomId: conversation!.roomId,
    );
    mains.objectbox.boxConversation.put(objConversation);

    super.initState();
    timer = Timer.periodic(const Duration(seconds: 7), (Timer t) {
      if(checkChatsRead() > 0){
        setChatsToRead();
      }
      if(checkChatsUnreadDb() > 0){
        setChatsToReadDb();
      }
      if(checkChatsDelivNRead()>0){
        getUndelUnreadChat();
      }
      if(checkChatsNotSent()>0){
        getFailedChat();
      }
    });
  }

  @override
  void dispose(){
    timer?.cancel();
    super.dispose();
  }

  bool _isWriting = false;
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

  File? image;
  Contact? contact;

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? imagePicked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 25);

    if(imagePicked!=null) {
      cropImage(imagePicked.path);
    }
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
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Crop image',
            toolbarColor: Color(0xFF2481CF),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );

    //send image chat
    if (croppedImage != null) {
      setState(() {
        image = croppedImage;
        final bytes = Io.File(croppedImage.path).readAsBytesSync();
        final bytesSize = Io.File(croppedImage.path).readAsBytesSync().lengthInBytes;
        final kb = bytesSize / 1024;
        final mb = kb / 1024;
        if(mb < 16){
          String img64 = base64Encode(bytes);

          // send image message
          final chat = ChatModel (
            idSender: idUser,
            idReceiver: idReceiver,
            text: "Photo",
            date: DateTime.now().toString(),
            tipe: "image",
            content: croppedImage.path,
            sendStatus: '',
            delivered: 0,
            read: 0,
          );

          int id = mains.objectbox.boxChat.put(chat);

          var msg = {};
          msg["api_key"] = apiKey;
          msg["decrypt_key"] = "";
          msg["id_chat_model"] = id;
          msg["type"] = "pm";
          msg["id_sender"] = idUser;
          msg["id_receiver"] = idReceiver;
          msg["msg_tipe"] = 'image';
          msg["msg_data"] = "Photo";
          msg["room_id"] = roomId;
          msg["image"] = img64;

          String msgString = json.encode(msg);

          homes.channel.sink.add(msgString);
        }
        else{
          Flushbar(
            backgroundColor: Colors.grey,
            message: '1 image you tried adding is larger than the 16MB limit.',
            duration: const Duration(seconds: 3),
          ).show(context);
        }
      });
    }
  }

  void chatOnSwipe(ChatModel chat) {
    // print(chat.text);
  }

  @override
  Widget build(BuildContext context) {

    DateTime dateTime = DateTime.parse(conversation!.date!);
    String formattedDate = DateFormat('HH:mm').format(dateTime);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(63.0),
          child: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
                // Navigator.pushReplacement(context, 
                //   MaterialPageRoute(builder: (context) => Home()),
                // );
              },
            ),
            titleSpacing: 0,
            title: InkWell(
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileInfo(conversation, roomId)),
                );
              },
              child: ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading:
                  ClipOval(
                      child: conversation!.photoProfile != null  ?
                      conversation!.photoProfile != '' ?
                      CircleAvatar(
                        backgroundImage:  Image.memory(base64.decode(conversation!.photoProfile!)).image,
                        backgroundColor: const Color(0xffF2F1F6),
                        radius: 20,
                        child: Image(
                          image: Image.memory(base64.decode(conversation!.photoProfile!)).image,
                        ),
                      )
                          :
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xffdde1ea),
                        child:  Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                      ):
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xffdde1ea),
                        child:  Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                      )
                  ),
                  title: ConstrainedBox(
                    constraints: const BoxConstraints(
                        maxWidth: 220
                    ),
                    child: Text(
                      conversation!.fullName!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(color: Colors.white, fontSize: 15,),
                    ),
                  ),
                  subtitle:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                            child: StreamBuilder<List<ConversationModel>>(
                                stream: homes.listControllerConversation.stream,
                                builder: (context, snapshot)
                                {

                                  var queryConv = mains.objectbox.boxConversation.query(ConversationModel_.id.equals(conversation!.id)).build();
                                  //List<ConversationModel> queryConv = queryConv.find().reversed.toList();
                                  if(queryConv.find().first.statusReceiver==''){
                                    return Text(
                                      formattedDate,
                                      style: TextStyle(color: Colors.white.withOpacity(.7)),
                                    );
                                  }
                                  else{
                                    return Text(
                                      queryConv.find().first.statusReceiver,
                                      style: const TextStyle(color: Color(0xFF25D366)),
                                    );
                                  }

                                  //return const CircularProgressIndicator();
                                }
                            )),
                      ]
                  )
              ),
            ),
            actions: const <Widget>[
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: StreamBuilder<List<ChatModel>>(
                  stream: homes.listController.stream,
                  builder: (context, snapshot)
                  {
                    if (snapshot.data != null) {
                      //update chat read status when receive new chat and chatscreen standby
                      var query2 = mains.objectbox.boxChat.query(ChatModel_.read.equals(0) & (ChatModel_.idReceiver.equals(idUser!) & (ChatModel_.idSender.equals(idReceiver!)))).build();
                      List<ChatModel> chats2 = query2.find().toList();
                      for(int i=0;i<chats2.length;i++){
                        var msg = {};
                        msg["api_key"] = apiKey;
                        msg["type"] = "status_read";
                        msg["id_chat_model"] = chats2[i].id;
                        msg["id_chat_model_friends"] = chats2[i].idChatFriends;
                        msg["id_sender"] = chats2[i].idSender;
                        msg["id_receiver"] = chats2[i].idReceiver;
                        msg["msg_tipe"] = chats2[i].tipe;
                        msg["room_id"] = conversation!.roomId;
                        String msgString = json.encode(msg);
                        homes.channel.sink.add(msgString);

                        //update status to read=1 deliver=1
                        final chat = ChatModel(
                          id: chats2[i].id,
                          idSender: chats2[i].idSender,
                          idReceiver: chats2[i].idReceiver,
                          text: chats2[i].text,
                          date: chats2[i].date,
                          tipe: chats2[i].tipe,
                          content: chats2[i].content,
                          sendStatus: chats2[i].sendStatus,
                          delivered: 1,
                          read: 1,
                        );
                        mains.objectbox.boxChat.put(chat);
                      }

                      var queryBuilder = mains.objectbox.boxChat.query( (ChatModel_.idReceiver.equals(idReceiver!) & ChatModel_.idSender.equals(idUser!)) | ChatModel_.idReceiver.equals(idUser!) & ChatModel_.idSender.equals(idReceiver!))..order(ChatModel_.date);
                      var query = queryBuilder.build();
                      List<ChatModel> chats = query.find().reversed.toList();

                      DateTime now = DateTime.now();
                      DateTime date = DateTime(now.year, now.month, now.day);

                      if(query.find().isNotEmpty & firstTime==false) {
                        //update conversation count=0 when receive new chat and user create new chat (both when chatscreen standby)
                        final objConversation = ConversationModel(
                          id: conversation!.id,
                          message: query.find().toList().isEmpty ? '' : query.find().last.text,
                          date: query.find().toList().isEmpty ? conversation!.date : query.find().last.date,
                          idReceiver: conversation!.idReceiver,
                          fullName: conversation!.fullName,
                          image: conversation!.image,
                          photoProfile: conversation!.photoProfile,
                          messageCout: 0,
                          statusReceiver: '',
                          roomId: conversation!.roomId,
                        );
                        mains.objectbox.boxConversation.put(objConversation);
                      }
                      else{
                        // set statusreceiver supaya status mengetik hilang
                        final objConversation = ConversationModel(
                          id: conversation!.id,
                          message: query.find().toList().isEmpty ? '' : query.find().last.text,
                          date: query.find().toList().isEmpty ? conversation!.date : query.find().last.date,
                          idReceiver: conversation!.idReceiver,
                          fullName: conversation!.fullName,
                          image: conversation!.image,
                          photoProfile: conversation!.photoProfile,
                          messageCout: 0,
                          statusReceiver: '',
                          roomId: conversation!.roomId,
                        );
                        mains.objectbox.boxConversation.put(objConversation);
                      }

                      if (chatFocus != null) {
                        int indexFocus = chats.indexWhere((element) => element.id == chatFocus?.id);

                        if (firstTime == true && indexFocus != -1) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            itemScrollController.jumpTo(
                              index: indexFocus,
                              alignment: 0.4,
                            );
                          });
                        }
                      }

                      firstTime = false;

                      return ScrollablePositionedList.builder(
                          scrollDirection: Axis.vertical,
                          reverse: true,
                          shrinkWrap: false,
                          itemScrollController: itemScrollController,
                          itemPositionsListener: itemPositionsListener,
                          padding: const EdgeInsets.all(2),
                          itemCount: chats.isNotEmpty ? chats.length : 0,
                          itemBuilder: (context, index) {
                            DateTime date2 = DateTime.parse(chats[index].date);
                            bool isSame = false;
                            String desc = "";
                            bool showTriangleRight = false;
                            bool showTriangleLeft = false;

                            if (index != chats.length-1) {
                              isSame = DateFormat('yyyy-MM-dd').format(DateTime.parse(chats[index].date)) == DateFormat('yyyy-MM-dd').format(DateTime.parse(chats[index+1].date));
                            }

                            if (!isSame) {
                              if (IndexFunction.daysBetween(date2, now) < 7) {
                                bool isToday = DateFormat('yyyy-MM-dd').format(now) == DateFormat('yyyy-MM-dd').format(DateTime.parse(chats[index].date));

                                if (isToday) {
                                  desc = "Today";
                                } else if (IndexFunction.daysBetween(date2, now) == 1) {
                                  desc = "Yesterday";
                                } else {
                                  desc = DateFormat('EEEE').format(DateTime.parse(chats[index].date));
                                }
                              } else {
                                desc = DateFormat('dd-MM-yyyy').format(DateTime.parse(chats[index].date));
                              }

                              showTriangleLeft = true;
                              showTriangleRight = true;
                            } else {
                              if (chats[index].idSender != chats[index+1].idSender) {
                                showTriangleLeft = true;
                              }

                              if (chats[index].idSender != chats[index+1].idSender) {
                                showTriangleRight = true;
                              }
                            }

                            var content = chats[index].idSender == idUser ?
                              SwipeTo(
                                onRightSwipe: () => chatOnSwipe(chats[index]),
                                child: chats[index].tipe == 'text' ?
                                  //    text
                                  MyMessageCardPersonal(
                                    chats[index].text,
                                    chats[index].sendStatus == "" ? "" : DateFormat.Hm().format(DateTime.parse(chats[index].date)),
                                    chats[index].sendStatus,
                                    chats[index].tipe!,
                                    '',
                                    // index+1==chats.length?true:chats[index].idSender==chats[index+1].idSender?false:true,
                                    showTriangleRight,
                                    false
                                  ) : chats[index].tipe == 'image' ?
                                  //    image
                                  MyMessageCardPersonal(
                                    chats[index].content!,
                                    chats[index].sendStatus == "" ? "" : DateFormat.Hm().format(DateTime.parse(chats[index].date)),
                                    chats[index].sendStatus,
                                    chats[index].tipe!,
                                    chats[index].content!,
                                    false,
                                    true
                                  ) :
                                  MyMessageCardPersonal(
                                    chats[index].text,
                                    chats[index].sendStatus == "" ? "" : DateFormat.Hm().format(DateTime.parse(chats[index].date)),
                                    chats[index].sendStatus,
                                    chats[index].tipe!,
                                    chats[index].content!,
                                    false,
                                    true
                                  )
                              ) : chats[index].idSender == idReceiver ?
                              SwipeTo(
                                onLeftSwipe: () => chatOnSwipe(chats[index]),
                                child: chats[index].tipe == 'text' ?
                                  FriendMessageCardPersonal(
                                    chats[index].text,
                                    DateFormat.Hm().format(DateTime.parse(chats[index].date)),
                                    chats[index].tipe!,
                                    '',
                                    // index+1==chats.length?true:chats[index].idSender==chats[index+1].idSender?false:true,
                                    showTriangleLeft,
                                    false
                                  ) : chats[index].tipe == 'image' ?
                                  FriendMessageCardPersonal(
                                    chats[index].content!,
                                    DateFormat.Hm().format(DateTime.parse(chats[index].date)),
                                    chats[index].tipe!,
                                    chats[index].content!,
                                    false,
                                    true
                                  ) :
                                  FriendMessageCardPersonal(
                                    chats[index].text,
                                    DateFormat.Hm().format(DateTime.parse(chats[index].date)),
                                    chats[index].tipe!,
                                    chats[index].content!,
                                    false,
                                    true
                                  ),
                              ) :
                              Container();

                            return Column(
                              children: [
                                !isSame ?
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  margin: EdgeInsets.only(
                                    top: index == chats.length ? 2.0 : 8.0,
                                    bottom: 10.0,
                                  ),
                                  child: Text(
                                    desc,
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ) : Container(),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: index == 0 ? 8.0 : 2.0,
                                  ),
                                  child: content,
                                ),
                              ],
                            );
                          }
                      );
                    }else{
                      if (snapshot.hasError) {
                        // print(snapshot.error.toString());
                        return const Text("Error");
                      }
                      return const CircularProgressIndicator();
                    }},
                ),
              ),
            ),
            // SizedBox(height: 10,),
            Container(
              color: Theme.of(context).backgroundColor,
              padding: Platform.isAndroid ?
              const EdgeInsets.only(right: 10, left: 10, top: 7, bottom: 10)
                  :
              const EdgeInsets.only(right: 10, left: 10, top: 7, bottom: 25),

              child: Row(
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        const SizedBox(height: 5,),
                        Container(
                          margin: const EdgeInsets.only(bottom: 5),
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
                                icon: const Icon(
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
                                      cursorColor: Colors.grey,
                                      keyboardType: TextInputType.multiline,
                                      controller: inputTextController,
                                      focusNode: _focusNode,
                                      onChanged: (text) {
                                        if (!_isWriting){
                                          _isWriting = true;

                                          //update typing status when type messages
                                          var msg = {};
                                          msg["api_key"] = apiKey;
                                          msg["type"] = "status_typing";
                                          msg["id_sender"] = idUser;
                                          msg["id_receiver"] = idReceiver;
                                          msg["room_id"] = conversation!.roomId;
                                          String msgString = json.encode(msg);
                                          homes.channel.sink.add(msgString);

                                          // setState((){});
                                          Future.delayed(const Duration(milliseconds: 900)).whenComplete((){
                                            _isWriting = false;
                                            // setState((){});
                                          });
                                        }
                                      },
                                      maxLines: null,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16
                                      ),
                                      decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.only(top: 13, bottom: 13),
                                          border: InputBorder.none,
                                          hintText: 'Type a message',
                                          hintStyle: TextStyle(
                                              color: Color(0xff99999B),
                                              fontSize: 16
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
                                                onPressed: () async {
                                                  await getCamera();
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
                                  icon: const Icon(
                                    Icons.attach_file_rounded,
                                    size: 25,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 8),
                      child: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () async {
                          if(inputTextController.text.trim().isEmpty) {
                            // print(conversation!.roomId!);
                          }
                          else {
                            //send text message
                            final chat = ChatModel (
                              idSender: idUser,
                              idReceiver: idReceiver,
                              text: inputTextController.text,
                              date: DateTime.now().toString(),
                              tipe: 'text',
                              sendStatus: '',
                              delivered: 0,
                              read: 0,
                            );

                            int id = mains.objectbox.boxChat.put(chat);

                            var msg = {};
                            msg["api_key"] = apiKey;
                            msg["decrypt_key"] = "";
                            msg["id_chat_model"] = id;
                            msg["type"] = "pm";
                            msg["id_sender"] = idUser;
                            msg["id_receiver"] = idReceiver;
                            msg["msg_data"] = chat.text;
                            msg["msg_tipe"] = 'text';
                            msg["room_id"] = roomId;

                            String msgString = json.encode(msg);
                            // print(msgString);

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
          ],
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
      if(file.size < 16777216){
        final bytes = Io.File(file.path!).readAsBytesSync();
        String file64 = base64Encode(bytes);

        final chat = ChatModel (
          idSender: idUser,
          idReceiver: idReceiver,
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
        msg["type"] = "pm";
        msg["id_sender"] = idUser;
        msg["id_receiver"] = idReceiver;
        msg["msg_tipe"] = 'file';
        msg["msg_data"] = file.name;
        msg["room_id"] = roomId;
        msg["file"] = file64;

        String msgString = json.encode(msg);

        homes.channel.sink.add(msgString);
      }
      else{
        Flushbar(
          backgroundColor: Colors.grey,
          message: '1 file you tried adding is larger than the 16MB limit.',
          duration: const Duration(seconds: 3),
        ).show(context);
      }
    }
    else {
      return;
    }

    // PlatformFile? file = result!.files.first;

  }

  void viewFile(PlatformFile file) {
    OpenFile.open(file.path);
  }

// void replyToMessage(ChatModel message) {
//   setState(() {
//     replyMessage = message;
//   });
// }

}