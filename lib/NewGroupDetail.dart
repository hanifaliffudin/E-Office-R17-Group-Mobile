import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' as Io;

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:militarymessenger/models/ContactModel.dart';
import 'package:militarymessenger/ChatGroup.dart';
import 'package:militarymessenger/contact.dart';
import 'package:http/http.dart' as http;
import 'package:militarymessenger/models/ConversationModel.dart';
import 'main.dart' as mains;
import 'Home.dart' as homes;
import 'package:fluttertoast/fluttertoast.dart';


class NewGroupDetail extends StatefulWidget {
  // const NewGroupDetail(List<ContactModel> groups, {Key? key}) : super(key: key);

  int? userId = mains.objectbox.boxUser.get(1)?.userId;
  List<ContactModel> groups;

  NewGroupDetail(this.groups);

  @override
  _NewGroupDetailState createState() => _NewGroupDetailState(groups);
}

enum AppState {
  cropped,
}

class _NewGroupDetailState extends State<NewGroupDetail> {
  String? groupName, groupImg64;
  String apiKey = homes.apiKeyCore;
  List<ContactModel> groups;
  _NewGroupDetailState(this.groups);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  File? image;

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? imagePicked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 25);

    cropImage(imagePicked!.path);
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
        groupImg64 = base64Encode(bytes);
      });
    }
  }

  final _focusNode = FocusNode();
  final TextEditingController _groupNameController = TextEditingController();
  bool _validate = false;

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
          elevation: 0,
          centerTitle: true,
          title: Text('new group'.toUpperCase(),
            style: TextStyle(
                fontSize: 17
            ),
          ),
        ),
        body: Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showCupertinoModalPopup(
                                          context: context,
                                          builder: (context) => CupertinoActionSheet(
                                            actions: <Widget>[
                                              Container(
                                                color: Colors.white,
                                                child: image != null ? CupertinoActionSheetAction(
                                                  child: Text('Remove photo',
                                                    style: TextStyle(
                                                        color: Colors.red
                                                    ),),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    showDialog<String>(
                                                      context: context,
                                                      builder: (BuildContext context) => AlertDialog(
                                                        content: const Text('Are you sure to remove photo?'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () => Navigator.pop(context, 'Cancel'),
                                                            child: const Text('Cancel',
                                                              style: TextStyle(color: Color(0xFF2481CF), fontSize: 17),),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                              setState(() {
                                                                image = null;
                                                              });
                                                            },
                                                            child: const Text('Yes',
                                                              style: TextStyle(color: Color(0xFF2481CF), fontSize: 17),),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                )
                                                    : SizedBox(),
                                              ),
                                              Container(
                                                color: Colors.white,
                                                child: CupertinoActionSheetAction(
                                                  child: Text('Take a photo',
                                                    style: TextStyle(
                                                        color: Color(0xFF2481CF)
                                                    ),),
                                                  onPressed: () async {
                                                    await getCamera();
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                              Container(
                                                color: Colors.white,
                                                child: CupertinoActionSheetAction(
                                                  child: Text('Choose from gallery',
                                                    style: TextStyle(
                                                        color: Color(0xFF2481CF)
                                                    ),),
                                                  onPressed: () async {
                                                    await getImage();
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
                                                  child: Text('Cancel',
                                                    style: TextStyle(
                                                        color: Color(0xFF2481CF)
                                                    ),),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                )
                                            ),
                                          )
                                      );
                                    },
                                    child: image != null ? CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Color(0xffF2F1F6),
                                      backgroundImage: Image.file(
                                          image!).image,
                                    ) : CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Color(0xffF2F1F6),
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: Color(0xFFFF2481CF),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                ],
                              ),
                            ),
                            SizedBox(height: 20,),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Group Name',
                                          style: TextStyle(
                                              color: Color(0xFFA0A09F),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                        SizedBox(height: 8,),
                                        TextField(
                                            focusNode: _focusNode,
                                            cursorColor: Colors.grey,
                                            controller: _groupNameController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: new BorderSide(color: Colors.grey),
                                              ),
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      height: 35,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Text('Participants: ',
                            style: TextStyle(
                              fontSize: 12,
                              // color: Theme.of(context).inputDecorationTheme.labelStyle?.color,
                              // fontWeight: FontWeight.bold
                            ),),
                          Text(groups.length.toString(),
                            style: TextStyle(
                                fontSize: 12
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      margin: EdgeInsets.only(top: 5),
                      color: Colors.grey.withOpacity(.2),
                    ),
                  ],
                ),
                Expanded(
                    child: ListView.builder(
                      itemCount: groups.length,
                      itemBuilder: (context, index)=>
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 10, right: 20, left: 20),
                                padding: EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 15),
                                          child: groups[index].photo == '' ? CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Color(0xffdde1ea),
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.grey,
                                            ),
                                          ) : CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Color(0xffF2F1F6),
                                            backgroundImage: Image.memory(base64.decode(groups[index].photo!)).image,
                                          ),
                                        ),
                                        SizedBox(width: 15,),
                                        Text(groups[index].userName!)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 1,
                                margin: EdgeInsets.only(top: 5),
                                color: Colors.grey.withOpacity(.2),
                              ),
                            ],
                          ),
                    )
                )
              ],
            )
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          backgroundColor: Color(0xFF2481CF),
          foregroundColor: Colors.white,
          child: Icon(Icons.check),
          onPressed: (){
            _groupNameController.text.isEmpty ? _validate = true : _validate = false;
            if(_validate){
              _showToast();
            }else{
              groupName = _groupNameController.text;
              List<int> ids = [];
              for(var item in groups){
                ids.add(item.userId!);
              }
              String groupsJson = json.encode(ids);
              if(groupImg64==null){
                // Navigator.pop(context);
                createGroup(userId!, groupsJson, groupName!, "");
              }else{
                // Navigator.pop(context);
                createGroup(userId!, groupsJson, groupName!, groupImg64!);
              }
            }
          },
        ),
      ),
    );
  }

  late FToast fToast;

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.grey,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Provide a group subject"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }


  Future<http.Response> createGroup(int idSender, String Receivers, String groupName, String groupImg) async {
    String url ='https://chat.dev.r17.co.id/create_chat.php';

    Map<String, dynamic> data = {
      'api_key': this.apiKey,
      'id_sender': idSender,
      'id_receivers': Receivers,
      'group_name': groupName,
      'group_img': groupImg,
      'tipe_chat': 'group',
    };

    //encode Map to JSON
    //var body = "?api_key="+this.apiKey;

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );

    if(response.statusCode == 200){
      //print("${response.body}");
      Map<String, dynamic> userMap = json.decode(response.body);

      if(userMap['code_status'] == 1){

        //put objconversation

        var now = new DateTime.now();

        ConversationModel objConversation = ConversationModel(
            id: 0,
            idReceiversGroup: Receivers,
            fullName: groupName,
            image: '',
            photoProfile: groupImg,
            date: now.toString(),
            roomId: userMap['room_id'] ,
            messageCout: 0);

        idConversation = mains.objectbox.boxConversation.put(objConversation);

        int roomId = userMap['room_id'];

        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context)=>ChatGroup(objConversation, roomId, "new_group"))
        );

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