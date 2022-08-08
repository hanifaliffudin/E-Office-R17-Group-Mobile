import 'dart:io';
import 'dart:io' as Io;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:militarymessenger/ChatGroup.dart';
import 'package:militarymessenger/ChatTabScreen.dart';
import 'package:militarymessenger/models/ChatModel.dart';
import 'package:militarymessenger/models/ConversationModel.dart';
import 'package:militarymessenger/objectbox.g.dart';
import 'package:militarymessenger/utils/variable_util.dart';
import 'main.dart' as mains;
import 'Home.dart' as homes;

class EditGroupInfo extends StatefulWidget {
  ConversationModel? conversation;
  int? roomId;

  EditGroupInfo(this.conversation, this.roomId);

  @override
  _EditGroupInfoState createState() => _EditGroupInfoState(conversation, roomId);
}

final TextEditingController _controller = TextEditingController();

class _EditGroupInfoState extends State<EditGroupInfo> {
  final VariableUtil _variableUtil = VariableUtil();
  ConversationModel? conversation;
  int? roomId;

  _EditGroupInfoState(this.conversation, this.roomId);

  @override
  File? image;

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? imagePicked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (imagePicked != null) {
      cropImage(imagePicked.path);
    }
  }

  Future getCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? imageCamera = await _picker.pickImage(source: ImageSource.camera);
    if (imageCamera != null)
      cropImage(imageCamera.path);
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

        var query = mains.objectbox.boxConversation.query(ConversationModel_.roomId.equals(conversation!.roomId!)).build();
        if(query.find().isNotEmpty) {

          ConversationModel objConversation = ConversationModel(
              id: query.find().first.id,
              idReceiversGroup: query.find().first.idReceiversGroup,
              fullName: query.find().first.fullName,
              image: query.find().first.image,
              // photoProfile: objMessage['image'],
              photoProfile: img64,
              message: query.find().first.message,
              date: query.find().first.date,
              messageCout: query.find().first.messageCout,
              statusReceiver: query.find().first.statusReceiver,
              roomId: query.find().first.roomId
          );
          mains.objectbox.boxConversation.put(objConversation);

          final chat = ChatModel (
            idSender: idUser,
            idRoom: query.find().first.roomId,
            idReceiversGroup: query.find().first.idReceiversGroup,
            text: "${mains.objectbox.boxUser.get(1)?.userName} changed this group's icon",
            tipe: 'system',
            date: DateTime.now().toString(),
            sendStatus: '',
            delivered: 0,
            read: 0,
          );

          int id = mains.objectbox.boxChat.put(chat);

          var msg = {};
          msg["api_key"] = _variableUtil.apiKeyCore;
          msg["decrypt_key"] = "";
          msg["id_chat_model"] = id;
          msg["type"] = "group";
          msg["system_feature"] = "change_group_image";
          msg["id_sender"] = idUser;
          msg["id_receivers"] = query.find().first.idReceiversGroup;
          msg["msg_tipe"] = 'system';
          msg["msg_data"] = "${mains.objectbox.boxUser.get(1)?.userName} changed this group's icon";
          msg["room_id"] = query.find().first.roomId;
          msg["group_name"] = query.find().first.fullName;
          msg["group_image"] = img64;

          String msgString = json.encode(msg);

          homes.channel.sink.add(msgString);

          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.push(context,MaterialPageRoute(builder: (context) => (ChatGroup(objConversation, conversation!.roomId, "change_group_image"))),);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,
        foregroundColor: Theme
            .of(context)
            .floatingActionButtonTheme
            .backgroundColor,
        title: Text('Edit Group'.toUpperCase(),
          style: TextStyle(
              fontSize: 15
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _openDialog(context, conversation!);
            },
            icon: Icon(
                Icons.done
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: StreamBuilder<List<ConversationModel>>(
                  stream: homes.listControllerConversation.stream,
                  builder: (context, snapshot) {
                    if(snapshot.data!=null){
                      // var cok = mains.objectbox.boxConversation.get(conversation!.id);

                      // var standby = mains.objectbox.boxConversation.query(ConversationModel_.roomId.equals(conversation!.roomId!)).build();
                      // print(standby.find().map((e) => e.photoProfile));
                      // // List<ChatModel> chatsUnread = standby.find().
                      // List<ConversationModel> uhuy = snapshot.data!.where((element) => element.id == conversation!.id).toList();
                      // conversation = cok;

                    }

                    return InkWell(
                      onTap: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (context) =>
                              CupertinoActionSheet(
                                actions: [
                                  image != null ? CupertinoActionSheetAction(
                                    child: Text('Remove photo',
                                      style: TextStyle(
                                          color: Colors.red
                                      ),),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              content: const Text(
                                                  'Are you sure to remove photo?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'Cancel'),
                                                  child: const Text('Cancel',
                                                    style: TextStyle(
                                                        color: Color(0xFF2481CF),
                                                        fontSize: 17),),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Yes',
                                                    style: TextStyle(
                                                        color: Color(0xFF2481CF),
                                                        fontSize: 17),),
                                                ),
                                              ],
                                            ),
                                      );
                                    },
                                  )
                                      : SizedBox(),
                                  CupertinoActionSheetAction(
                                    child: Text('Take a photo',
                                      style: TextStyle(
                                          color: Color(0xFF2481CF)
                                      ),),
                                    onPressed: () async {
                                      await getCamera();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  CupertinoActionSheetAction(
                                    child: Text('Choose from gallery',
                                      style: TextStyle(
                                          color: Color(0xFF2481CF)
                                      ),),
                                    onPressed: () async {
                                      await getImage();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  CupertinoActionSheetAction(
                                    child: Text('Cancel',
                                      style: TextStyle(
                                          color: Color(0xFF2481CF)
                                      ),),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                        );
                      },
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
                    );
                  }
              ),
            ),
            SizedBox(height: 10,),
            SizedBox(height: 30,),
            InkWell(
              child: Card(
                  margin: EdgeInsets.all(0),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: 100000,
                    child: TextField(
                      controller: _controller,
                      enabled: true,
                      decoration: InputDecoration(
                        hintText: conversation!.fullName,
                        suffixIcon: Icon(
                          Icons.edit,
                          color: Color(0xFF2481CF),
                          size: 24,
                        ),
                      ),
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }

  void _openDialog(ctx, ConversationModel conversation) {
    showCupertinoDialog(
      context: ctx,
      builder: (_) => CupertinoAlertDialog(
        title: Text("Edit Group Name"),
        content: Text("Are you sure to change the group name?"),
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
                Navigator.of(ctx).pop();
              }),
          CupertinoButton(
            child: Text('Yes',
              style: TextStyle(
                  color: Color(0xFF2481CF)
              ),
            ),
            onPressed: () {
              var query = mains.objectbox.boxConversation.query(ConversationModel_.roomId.equals(conversation.roomId!)).build();
              if(query.find().isNotEmpty) {

                ConversationModel objConversation = ConversationModel(
                    id: query.find().first.id,
                    idReceiversGroup: query.find().first.idReceiversGroup,
                    fullName: _controller.text,
                    image: query.find().first.image,
                    // photoProfile: objMessage['image'],
                    photoProfile: query.find().first.photoProfile,
                    message: query.find().first.message,
                    date: query.find().first.date,
                    messageCout: query.find().first.messageCout,
                    statusReceiver: query.find().first.statusReceiver,
                    roomId: query.find().first.roomId
                );
                mains.objectbox.boxConversation.put(objConversation);

                final chat = ChatModel (
                  idSender: idUser,
                  idRoom: query.find().first.roomId,
                  idReceiversGroup: query.find().first.idReceiversGroup,
                  text: '${mains.objectbox.boxUser.get(1)?.userName} change the subject to "${_controller.text}"',
                  tipe: 'system',
                  date: DateTime.now().toString(),
                  sendStatus: '',
                  delivered: 0,
                  read: 0,
                );

                int id = mains.objectbox.boxChat.put(chat);

                var msg = {};
                msg["api_key"] = _variableUtil.apiKeyCore;
                msg["decrypt_key"] = "";
                msg["id_chat_model"] = id;
                msg["type"] = "group";
                msg["system_feature"] = "change_group_name";
                msg["id_sender"] = idUser;
                msg["id_receivers"] = query.find().first.idReceiversGroup;
                msg["msg_tipe"] = 'system';
                msg["msg_data"] = '${mains.objectbox.boxUser.get(1)?.userName} change the subject to "${_controller.text}"';
                msg["room_id"] = query.find().first.roomId;
                msg["group_name"] = _controller.text;

                String msgString = json.encode(msg);

                homes.channel.sink.add(msgString);
                Navigator.of(ctx).pop();
                Navigator.of(ctx).pop();
                Navigator.of(ctx).pop();
                Navigator.of(ctx).pop();
                Navigator.push(ctx,MaterialPageRoute(builder: (context) => (ChatGroup(objConversation, conversation.roomId, "change_group_name"))),);
                _controller.clear();
              }
            },
          )
        ],
      ),
    );
  }
}