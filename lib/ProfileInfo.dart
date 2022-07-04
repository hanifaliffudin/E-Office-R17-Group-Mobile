import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:militarymessenger/models/ContactModel.dart';
import 'package:militarymessenger/models/ConversationModel.dart';
import 'package:militarymessenger/objectbox.g.dart';
import 'main.dart' as mains;
import 'Home.dart' as homes;

class ProfileInfo extends StatefulWidget {
  final ConversationModel? conversation;
  int? roomId;

  ProfileInfo(this.conversation, this.roomId);

  @override
  _ProfileInfoState createState() => _ProfileInfoState(conversation, roomId);
}

class _ProfileInfoState extends State<ProfileInfo> {

  final ConversationModel? conversation;
  int? roomId;

  _ProfileInfoState(this.conversation, this.roomId);

  void pictureOnTap(String photo) {
    showGeneralDialog(
      context: context, 
      barrierDismissible: false,
      // barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      // barrierColor: Colors.black,
      // transitionDuration: Duration(),
      pageBuilder: (BuildContext context, Animation first, Animation second) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back, 
                color: Colors.blue,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width, //- 10
            // height: MediaQuery.of(context).size.height - 80,
            // color: Colors.white,
            child: Image(
              image: Image.memory(base64.decode(photo)).image,
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
        title: Text('Contact Info'.toUpperCase(),
          style: TextStyle(
              fontSize: 15
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back, 
            color: Colors.blue,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<List<ContactModel>>(
        stream: homes.listControllerContact.stream,
        builder: (context, snapshot) {
          List<ContactModel> contactList = [];
            var query = mains.objectbox.boxContact.query(ContactModel_.userId.equals(conversation!.idReceiver!)).build();
            if(query.find().isNotEmpty) {
              contactList.add(query.find().first);
            }
          return Padding(
            padding: EdgeInsets.all(20),
            child: ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index)=>
                Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: contactList[index].photo == '' ?
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xffF2F1F6),
                      child: Icon(
                        Icons.people_alt_outlined,
                        color: Colors.grey,
                      ),
                    )
                        :
                    InkWell(
                      onTap: () => pictureOnTap(contactList[index].photo!),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Color(0xffF2F1F6),
                        backgroundImage: Image.memory(base64.decode(contactList[index].photo!)).image,
                      ),
                    ),
                  ),
                  SizedBox(height: 50,),
                  Text('Name'.toUpperCase(),
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: 100000,
                    child: Card(
                      margin: EdgeInsets.all(0),
                      child: Container(
                          padding: EdgeInsets.all(15),
                          child: Text(contactList[index].userName!)),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text('Email'.toUpperCase(),
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: 100000,
                    child: Card(
                      margin: EdgeInsets.all(0),
                      child: Container(
                          padding: EdgeInsets.all(15),
                          child: Text(contactList[index].email!)),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text('Phone'.toUpperCase(),
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: 100000,
                    child: Card(
                      margin: EdgeInsets.all(0),
                      child: Container(
                          padding: EdgeInsets.all(15),
                          child: contactList[index].phone == null ?
                          Text("-")
                              :
                          Text(contactList[index].phone!)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}