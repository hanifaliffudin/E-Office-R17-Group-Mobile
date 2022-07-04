import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:io' as Io;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:militarymessenger/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';
import 'main.dart' as mains;
import 'home.dart' as homes;
import 'package:http/http.dart' as http;
import 'models/UserModel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);


  @override
  _ProfilePageState createState() => _ProfilePageState();
}

enum AppState {
  cropped,
}

class _ProfilePageState extends State<ProfilePage> {

  String apiKey ='1Hw3G9UYOhounou0679y3*OhouH978%hOtfr57fRtug#9UI8nl7iU4Yt5vR6Fb87tLRB5u3g4Hi92983huiU3g5bkH5BVGv3daf2F5e2Ae4k6F5vblUwIJD9W7ryiuBL24Lbv3P';

  final String? email = mains.objectbox.boxUser.get(1)?.email;
  String? name = mains.objectbox.boxUser.get(1)?.userName;
  String? phone = mains.objectbox.boxUser.get(1)?.phone;
  String? photo = mains.objectbox.boxUser.get(1)?.photo;
  Uint8List? bytes;




  Future<String> _createFileFromString() async {
    Uint8List bytes = base64.decode(photo!);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".png");
    await file.writeAsBytes(bytes);
    setState(() {
      image = File(file.path);
    });
    return file.path;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getData();
    if(photo!=null){
      if(photo!=''){
        _createFileFromString();
      }
    }
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
        String img64 = base64Encode(bytes);

        var query = mains.objectbox.boxUser.query(UserModel_.email.equals(email!)).build();
        if(query.find().isNotEmpty) {
          var user = UserModel(
            id: 1,
            email: email,
            userId: query.find().first.userId,
            userName: query.find().first.userName,
            phone: query.find().first.phone,
            photo: img64,
            fcmToken: query.find().first.fcmToken,
            status: query.find().first.status,
            enable: query.find().first.enable,
            idInstall: query.find().first.idInstall,
            token: query.find().first.idInstall,
            verification_code: query.find().first.verification_code,
          );

          mains.objectbox.boxUser.put(user);
          setPhoto(img64);
        }
      });
    }
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
        title: Text('Profile'.toUpperCase(),
          style: TextStyle(
              fontSize: 17
          ),
        ),
        centerTitle: true,
        elevation: 0,

      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<UserModel>>(
                    stream: homes.listControllerUser.stream,
                    builder: (context, snapshot){
                      List<UserModel> userList = mains.objectbox.boxUser.getAll().toList();
                      return ListView.builder(
                          itemCount: userList.length,
                          itemBuilder:(BuildContext context,index)=>
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: InkWell(
                                      onTap: () {
                                        showCupertinoModalPopup(
                                          context: context,
                                          builder: (context) => CupertinoActionSheet(
                                            actions: [
                                              image != null ? CupertinoActionSheetAction(
                                                child: Text('Remove photo',
                                                  style: TextStyle(
                                                      color: Colors.red
                                                  ),),
                                                onPressed: () {
                                                  _openDialog(context);
                                                  // showDialog<String>(
                                                  //   context: context,
                                                  //   builder: (BuildContext context) => AlertDialog(
                                                  //     content: const Text('Are you sure to remove photo?'),
                                                  //     actions: <Widget>[
                                                  //       TextButton(
                                                  //         onPressed: () => Navigator.pop(context, 'Cancel'),
                                                  //         child: const Text('Cancel',
                                                  //           style: TextStyle(color: Color(0xFF2481CF), fontSize: 17),),
                                                  //       ),
                                                  //       TextButton(
                                                  //         onPressed: () {
                                                  //           Navigator.pop(context);
                                                  //           setState(() {
                                                  //             image = null;
                                                  //             var query = mains.objectbox.boxUser.query(UserModel_.email.equals(email!)).build();
                                                  //             if(query.find().isNotEmpty) {
                                                  //               var user = UserModel(
                                                  //                 id: 1,
                                                  //                 email: email,
                                                  //                 userId: query.find().first.userId,
                                                  //                 userName: query.find().first.userName,
                                                  //                 phone: query.find().first.phone,
                                                  //                 photo: '',
                                                  //               );
                                                  //
                                                  //               mains.objectbox.boxUser.put(user);
                                                  //             }
                                                  //             setPhoto("null");
                                                  //           });
                                                  //         },
                                                  //         child: const Text('Yes',
                                                  //           style: TextStyle(color: Color(0xFF2481CF), fontSize: 17),),
                                                  //       ),
                                                  //     ],
                                                  //   ),
                                                  // );
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
                                      child: Stack(
                                        children: [
                                          Padding(
                                              padding: const EdgeInsets.only(bottom: 10),
                                              child: image != null ? CircleAvatar(
                                                radius: 50,
                                                backgroundColor: Color(0xffF2F1F6),
                                                backgroundImage: Image.file(
                                                    image!).image,
                                              ) : CircleAvatar(
                                                radius: 50,
                                                backgroundColor: Color(0xffF2F1F6),
                                                child: Icon(
                                                  Icons.person,
                                                  color: Colors.grey,
                                                ),
                                              )
                                          ),
                                          Positioned(
                                            bottom: 10,
                                            right: 5,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white
                                              ),
                                              padding: EdgeInsets.all(5),
                                              child: Icon(
                                                Icons.camera_alt_outlined,
                                                color: Color(0xFF2481CF),
                                                size: 20,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                        content: TextField(
                                          controller: _usernameController,
                                          decoration: InputDecoration(
                                            hintText: userList[index].userName,
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              if(_usernameController.text!=""){
                                                setName(_usernameController.text);
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: const Text('Save'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Name',
                                          style: TextStyle(
                                            fontSize: 12,

                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        TextField(
                                          enabled: false,
                                          decoration: InputDecoration(
                                              suffixIcon: Icon(
                                                Icons.edit,
                                                color: Color(0xFF2481CF),
                                                size: 24,
                                              ),
                                              border: OutlineInputBorder(),
                                              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                              hintText: userList[index].userName!,
                                              hintStyle: TextStyle(
                                                  color: Theme.of(context).inputDecorationTheme.labelStyle?.color,
                                                  fontSize: 12
                                              )
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 30,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Email',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      TextField(
                                        enabled: false,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                            hintText: userList[index].email!,
                                            hintStyle: TextStyle(
                                                color: Theme.of(context).inputDecorationTheme.labelStyle?.color,
                                                fontSize: 12
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 30,),
                                  InkWell(
                                    onTap: () => showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                        content: TextField(
                                          keyboardType: TextInputType.phone,
                                          controller: _phoneController,
                                          decoration: InputDecoration(
                                            hintText: userList[index].phone,
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setPhone(_phoneController.text);
                                              Navigator.pop(context);
                                              phone = _phoneController.text;
                                            },
                                            child: const Text('Save'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Phone Number',
                                          style: TextStyle(
                                            fontSize: 12,

                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        TextField(
                                          enabled: false,
                                          decoration: InputDecoration(
                                              suffixIcon: Icon(
                                                Icons.edit,
                                                color: Color(0xFF2481CF),
                                                size: 24,
                                              ),
                                              border: OutlineInputBorder(),
                                              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                              hintText: phone == null || phone == "" ? "-" : userList[index].phone!,
                                              hintStyle: TextStyle(
                                                  color: Theme.of(context).inputDecorationTheme.labelStyle?.color,
                                                  fontSize: 12
                                              )
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                      );
                    }
                ),
              ),
            ]
        ),
      ),
    );
  }

  void _openDialog(ctx) {
    showCupertinoDialog(
        context: ctx,
        builder: (_) => CupertinoAlertDialog(
          title: Text("Remove photo"),
          content: Text("Are you sure to remove photo?"),
          actions: [
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
              child: Text('Remove',
                style: TextStyle(
                    color: Colors.red
                ),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                setState(() {
                  image = null;
                  var query = mains.objectbox.boxUser.query(UserModel_.email.equals(email!)).build();
                  if(query.find().isNotEmpty) {
                    var user = UserModel(
                      id: 1,
                      email: email,
                      userId: query.find().first.userId,
                      userName: query.find().first.userName,
                      phone: query.find().first.phone,
                      photo: '',
                      fcmToken: query.find().first.fcmToken,
                      status: query.find().first.status,
                      enable: query.find().first.enable,
                      idInstall: query.find().first.idInstall,
                      token: query.find().first.idInstall,
                      verification_code: query.find().first.verification_code,
                    );

                    mains.objectbox.boxUser.put(user);
                  }
                  setPhoto("null");
                });
              },
            )
          ],
        ));
  }



  Future<http.Response> setPhoto(String photo64) async {

    String url ='https://chat.dev.r17.co.id/profile.php';


    Map<String, dynamic> data = {
      'api_key': this.apiKey,
      'email': email,
      'photo64': photo64,
    };

    //encode Map to JSON
    //var body = "?api_key="+this.apiKey;

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );
    if(response.statusCode == 200){
      Map<String, dynamic> userMap = jsonDecode(response.body);

      if(userMap['code_status'] == 0){

        print(userMap['info']);

      }else{
        print(userMap['code_status']);
        print("ada yang salah!");
      }
    }
    else{
      print("Gagal terhubung ke server!");
      print(response.statusCode);
    }
    return response;
  }

  Future<http.Response> setName(String name) async {

    String url ='https://chat.dev.r17.co.id/profile.php';

    Map<String, dynamic> data = {
      'api_key': this.apiKey,
      'email': email,
      'name': name,
    };

    //encode Map to JSON
    //var body = "?api_key="+this.apiKey;

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );
    if(response.statusCode == 200){
      Map<String, dynamic> userMap = jsonDecode(response.body);

      if(userMap['code_status'] == 0){

        var query = mains.objectbox.boxUser.query(UserModel_.email.equals(email!)).build();
        if(query.find().isNotEmpty) {
          var user = UserModel(
            id: 1,
            email: query.find().first.email,
            userId: query.find().first.userId,
            userName: name,
            phone: query.find().first.phone,
            photo: query.find().first.photo,
            fcmToken: query.find().first.fcmToken,
            status: query.find().first.status,
            enable: query.find().first.enable,
            idInstall: query.find().first.idInstall,
            token: query.find().first.idInstall,
            verification_code: query.find().first.verification_code,
          );

          mains.objectbox.boxUser.put(user);
        }
        setState(() {

        });

      }else{
        print(userMap['code_status']);
        print("ada yang salah!");
      }
    }
    else{
      print("Gagal terhubung ke server!");
      print(response.statusCode);
    }
    return response;
  }

  Future<http.Response> setPhone(String phone) async {

    String url ='https://chat.dev.r17.co.id/profile.php';

    Map<String, dynamic> data = {
      'api_key': this.apiKey,
      'email': email,
      'phone': phone,
    };

    //encode Map to JSON
    //var body = "?api_key="+this.apiKey;

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );
    if(response.statusCode == 200){
      Map<String, dynamic> userMap = jsonDecode(response.body);

      if(userMap['code_status'] == 0){

        var query = mains.objectbox.boxUser.query(UserModel_.email.equals(email!)).build();
        if(query.find().isNotEmpty) {
          var user = UserModel(
            id: 1,
            email: query.find().first.email,
            userId: query.find().first.userId,
            userName: query.find().first.userName,
            phone: phone,
            photo: query.find().first.photo,
            fcmToken: query.find().first.fcmToken,
            status: query.find().first.status,
            enable: query.find().first.enable,
            idInstall: query.find().first.idInstall,
            token: query.find().first.idInstall,
            verification_code: query.find().first.verification_code,
          );

          mains.objectbox.boxUser.put(user);
        }
        setState(() {

        });

      }else{
        print(userMap['code_status']);
        print("ada yang salah!");
      }
    }
    else{
      print("Gagal terhubung ke server!");
      print(response.statusCode);
    }
    return response;
  }

}