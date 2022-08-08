import 'dart:convert';
import 'dart:typed_data';

import 'package:militarymessenger/NewGroupPage.dart';
import 'package:militarymessenger/models/ContactModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:militarymessenger/utils/variable_util.dart';
import 'package:militarymessenger/widgets/cache_image_provider_widget.dart';
import 'main.dart' as mains;
import 'Home.dart' as homes;

import 'ChatScreen.dart';
import 'models/ConversationModel.dart';
import 'objectbox.g.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}
List<String> nameList = [];
int? userId = mains.objectbox.boxUser.get(1)?.userId;
int idSender = 0;
int idReceiver = 0;
int idConversation = 0;
String tableName = '';
int? roomId;

class _ContactPageState extends State<ContactPage> {
  final VariableUtil _variableUtil = VariableUtil();
  Uint8List? bytes;

  ConversationModel? conversation;

  List<ContactModel> contactList = mains.objectbox.boxContact.getAll().toList();

  List<ContactModel> _foundContact = [];
  List<ImageProvider<Object>?> _tempPhoto = [];

  get chat => null;

  @override
  void initState() {
    // List<ImageProvider<Object>?> temp = [];

    // // for (var i = 0; i < contactList.length; i++) {
    // //   if (contactList[i].photo != '') {
    // //     temp.add(Image.memory(base64.decode(contactList[i].photo!)).image);
    // //   } else {
    // //     temp.add(null);
    // //   }
    // // }

    // // _tempPhoto = temp;
    _foundContact = contactList;

    super.initState();
  }

  void _runFilter(String enteredKeyword){
    List<ContactModel> results = [];

    if(enteredKeyword.isEmpty){
      results = contactList;
    }else{
      results = contactList.where((element) => element.userName!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    }

    setState(() {
      _foundContact = results;
    });
  }

  ImageProvider<Object> _getPhoto(ContactModel foundContact) {
    int indexFound = -1;

    for (var i = 0; i < contactList.length; i++) {
      if (contactList[i].photo == foundContact.photo) {
        indexFound = i;
      }
    }

    return _tempPhoto[indexFound]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
                Icons.close
            ),
          ),
          SizedBox(width: 5,)
        ],
        title: Text('New Chat'.toUpperCase(),
          style: TextStyle(
            fontSize: 17,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<ContactModel>>(
                  stream: homes.listControllerContact.stream,
                  builder: (context, snapshot){
                    if(mains.objectbox.boxContact.isEmpty()){
                      return
                        Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            margin: const EdgeInsets.only(top: 15.0),
                            child :Text(
                              'No contact yet.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: Theme.of(context).inputDecorationTheme.labelStyle?.color),
                            ));
                    }
                    else
                    {
                      return Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Column(
                          children: [
                            Container(
                              color: Theme.of(context).appBarTheme.backgroundColor,
                              child: Container(
                                padding: EdgeInsets.only(right: 8, left: 8),
                                margin: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.search,
                                      color: Color(0xff99999B),
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: TextField(
                                        cursorColor: Colors.grey,
                                        onChanged: (value) {
                                          _runFilter(value);
                                        },
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15
                                        ),
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Search contact...',
                                            hintStyle: TextStyle(
                                                color: Color(0xff99999B),
                                                fontSize: 15
                                            )
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => NewGroupPage()),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    child: Row(
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.only(right: 15),
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Color(0xffEAF6FF),
                                              child:  Icon(
                                                Icons.people_alt_outlined,
                                                color: Color(0xFF4094E7),
                                              ),
                                            )
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  maxWidth: 250
                                              ),
                                              child: Text('New Group',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Theme.of(context).inputDecorationTheme.labelStyle?.color
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  margin: EdgeInsets.only(top: 5),
                                  color: Colors.grey.withOpacity(.2),
                                ),
                              ],
                            ),
                            Container(
                              color: Theme.of(context).backgroundColor,
                              height: 20,
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: _foundContact.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder:(BuildContext context,index)=>
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            createChat(userId!, _foundContact[index].userId!, _foundContact[index].userName!, _foundContact[index].photo ?? '');
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            child: Row(
                                              children: [
                                                Padding(
                                                    padding: const EdgeInsets.only(right: 15),
                                                    child: _foundContact[index].photo == '' ? CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: Color(0xffdde1ea),
                                                      child:  Icon(
                                                        Icons.person,
                                                        color: Colors.grey,
                                                      ),
                                                    ) :CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: Color(0xffF2F1F6),
                                                      // backgroundImage: _getPhoto(_foundContact[index]),
                                                      backgroundImage: CacheImageProviderWidget(_foundContact[index].userId.toString(), base64.decode(_foundContact[index].photo!)),
                                                    )
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ConstrainedBox(
                                                      constraints: BoxConstraints(
                                                          maxWidth: 250
                                                      ),
                                                      child: Text(_foundContact[index].userName!,
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            color: Theme.of(context).inputDecorationTheme.labelStyle?.color
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 1,
                                          margin: EdgeInsets.only(top: 5),
                                          color: Colors.grey.withOpacity(.2),
                                        ),
                                      ],
                                    ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<http.Response> createChat(int idSender, int idReceiver, String userName, String photo) async {
    String url ='${_variableUtil.apiChatUrl}/create_chat.php';

    Map<String, dynamic> data = {
      'api_key': _variableUtil.apiKeyCore,
      'id_sender': idSender,
      'id_receiver': idReceiver,
      'tipe_chat': 'pm',
    };

    //encode Map to JSON
    //var body = "?api_key="+_variableUtil.apiKeyCore;

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );

    if(response.statusCode == 200){
      // print("${response.body}");
      Map<String, dynamic> userMap = json.decode(response.body);

      if(userMap['code_status'] == 1){

        //put objconversation
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
              messageCout: 0);
          idConversation = mains.objectbox.boxConversation.put(objConversation);
        }
        else{
          objConversation = ConversationModel(
              id: 0,
              idReceiver: idReceiver,
              fullName: userName,
              image: '',
              photoProfile: photo,
              date: now.toString(),
              roomId: userMap['room_id'] ,
              messageCout: 0);
          idConversation = mains.objectbox.boxConversation.put(objConversation);
        }

        roomId = userMap['room_id'];

        Navigator.pop(context);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context)=>ChatScreen(objConversation, roomId!, null))
        );


      }else{
        print("ada yang salah!");
      }
    }
    else{
      print("Gagal terhubung ke server!");
    }
    return response;
  }

}