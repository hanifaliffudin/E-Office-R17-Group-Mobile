import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:militarymessenger/ChatGroup.dart';
import 'package:militarymessenger/ChatScreen.dart';
import 'package:militarymessenger/functions/index_function.dart';
import 'package:militarymessenger/models/ChatModel.dart';
import 'package:militarymessenger/models/ConversationModel.dart';
import 'objectbox.g.dart';
import 'package:intl/intl.dart';
import 'ChatScreen.dart';
import 'models/ConversationModel.dart';

import 'Home.dart' as homes;
import 'main.dart' as mains;
import 'package:http/http.dart' as http;

import 'widgets/cache_image_provider_widget.dart';

class TempConversation {
  int? idReceiver;
  String? idReceiversGroup;
  ImageProvider<Object>? photoProfile;

  TempConversation({
    this.idReceiver,
    this.idReceiversGroup,
    this.photoProfile,
  });
}

int? idUser;

class ChatTabScreen extends StatefulWidget {

  const ChatTabScreen({Key? key}) : super(key: key);

  @override
  State<ChatTabScreen> createState() => _ChatTabScreenState();
}

List<ConversationModel> convSelected = [];

class _ChatTabScreenState extends State<ChatTabScreen> {
  Store? store;

  //Checklist
  bool isChecked = false;

  //Delete widget
  bool isVisible = false;

  String apiKey = homes.apiKeyCore;

  List<String?> pp = [];
  List<TempConversation> _tempConv = [];

  @override
  void initState() {
    idUser = mains.objectbox.boxUser.get(1)?.userId;
    // TODO: implement initState
    var builder = mains.objectbox.boxConversation.query(ConversationModel_.id.notEquals(0) & ConversationModel_.message.notEquals(""));
    List<ConversationModel> conversationList = builder.build().find().toList();

    List<int?> idRoom = conversationList.map((e) => e.roomId).toList();

    // for(int i=0;i<conversationList.length;i++){
    //   pp.add(mains.objectbox.boxConversation.get(conversationList[i].id)!.photoProfile);
    // }

    var msg = {};
    msg["api_key"] = apiKey;
    msg["type"] = "get_last_message";
    msg["id_rooms"] = json.encode(idRoom);
    msg["id_receiver"] = idUser;
    String msgString = json.encode(msg);
    homes.channel.sink.add(msgString);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ImageProvider<Object> _getPhoto(ConversationModel conversation) {
    int indexFound = -1;

    for (var i = 0; i < _tempConv.length; i++) {
      if (
        _tempConv[i].idReceiver == conversation.idReceiver 
        && _tempConv[i].idReceiversGroup == conversation.idReceiversGroup
      ) {
        indexFound = i;
        break;
      }
    }

    // print('${_tempConv[indexFound].photoProfile} $indexFound');

    return _tempConv[indexFound].photoProfile!;
  }
  
  String getIdUnique(ConversationModel conversation) {
    return conversation.idReceiver != null ? conversation.idReceiver.toString() : conversation.photoProfile!;
  }

  @override
  Widget build(BuildContext context) {
    return isVisible == true
        ?
    GestureDetector(
      onTap: () {
        setState(() {
          isVisible = !isVisible;
          clearSelect();
        });
      },
      child: StreamBuilder<List<ConversationModel>>(
          stream: homes.listControllerConversation.stream,
          builder: (context, snapshot){
            if(mains.objectbox.boxConversation.isEmpty()){
              return
                Container(
                    margin: const EdgeInsets.only(top: 15.0),
                    child :const Text(
                      'No chats yet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13,),
                    )
                );
            }
            else
            {
              var builder = mains.objectbox.boxConversation.query(ConversationModel_.id.notEquals(0) & ConversationModel_.message.notEquals(""))
                ..order(ConversationModel_.date, flags: Order.descending);
              List<ConversationModel> conversationList = builder.build().find().toList();

              // for (var i = 0; i < conversationList.length; i++) {
              //   if (conversationList[i].photoProfile!='') {
              //     _tempConv.add(TempConversation(
              //       idReceiver: conversationList[i].id,
              //       photoProfile: Image.memory(base64.decode(mains.objectbox.boxConversation.get(conversationList[i].id)!.photoProfile!), gaplessPlayback: true,).image,
              //     ));
              //   } else {
              //     _tempConv.add(TempConversation());
              //   }
              // }

              return Column(
                children: [
                  Visibility(
                    visible: isVisible,
                    child: Container(
                        height: 50,
                        width: 10000,
                        padding: const EdgeInsets.only(left: 25, right: 5),
                        margin: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${convSelected.length} selected',
                              style: const TextStyle(
                                  color: Colors.grey
                              ),
                            ),
                            Row(
                              children: [

                                //Icon delete chat
                                InkWell(
                                  onTap: () {
                                    if(convSelected.isNotEmpty){
                                      // _openDialog(context);
                                    }
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.grey,
                                  ),
                                ),

                                //Icon more
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    dividerColor: Colors.white,
                                    iconTheme: const IconThemeData(color: Colors.grey),
                                    textTheme: const TextTheme().apply(bodyColor: Colors.white),
                                  ),
                                  child: PopupMenuButton<int>(
                                    icon: const Icon(Icons.more_vert),
                                    color: Colors.white,
                                    onSelected: (item) => onSelected(context, item),
                                    itemBuilder: (context) => [
                                      const PopupMenuItem<int>(
                                        value: 0,
                                        child: Text('Select All',
                                          style: TextStyle(
                                              fontSize: 15
                                          ),
                                        ),
                                        textStyle: TextStyle(color: Colors.black,fontSize: 17),
                                      ),
                                      const PopupMenuItem<int>(
                                        value: 1,
                                        child: Text('Cancel',
                                          style: TextStyle(
                                              fontSize: 15
                                          ),
                                        ),
                                        textStyle: TextStyle(color: Colors.black,fontSize: 17),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                    ),
                  ),
                  Expanded(
                    child: Container(
                      // padding: EdgeInsets.all(10),
                      padding: const EdgeInsets.only(
                        top: 10.0,
                        right: 10.0,
                        left: 10.0,
                      ),
                      child: ListView.builder(
                          itemCount: conversationList.length,
                          itemBuilder:(BuildContext context,index)=>
                              InkWell(
                                  onTap: (){
                                    if (isVisible == true) {
                                      var query = mains.objectbox.boxConversation.query(ConversationModel_.roomId.equals(conversationList[index].roomId!)).build();
                                      setState(() {
                                        if(query.find().isNotEmpty) {
                                          final conv = ConversationModel(
                                            id: query.find().first.id,
                                            idReceiver: query.find().first.idReceiver,
                                            statusReceiver: query.find().first.statusReceiver,
                                            photoProfile: query.find().first.photoProfile,
                                            fullName: query.find().first.fullName,
                                            image: query.find().first.image,
                                            message: query.find().first.message,
                                            date: query.find().first.date,
                                            messageCout: query.find().first.messageCout,
                                            roomId: query.find().first.roomId,
                                            idReceiversGroup: query.find().first.idReceiversGroup,
                                            select: !conversationList[index].select,
                                          );
                                          mains.objectbox.boxConversation.put(conv);

                                          if(conversationList[index].select==false){
                                            convSelected.add(conversationList[index]);
                                          }else{
                                            convSelected.removeWhere((item) => item.roomId == conversationList[index].roomId);
                                          }
                                        }
                                      });
                                    }
                                    else {
                                      if(conversationList[index].idReceiver != null){
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (BuildContext context)=>ChatScreen(conversationList[index], conversationList[index].roomId!, null))
                                        );
                                      }else{
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (BuildContext context)=>ChatGroup(conversationList[index], conversationList[index].roomId!, "open_conv"))
                                        );
                                      }
                                    }
                                  },
                                  onLongPress: () {
                                    setState(() {
                                      isVisible = !isVisible;
                                    });
                                  },
                                  child: Card(
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Visibility(
                                                visible: isVisible,
                                                child: Checkbox(
                                                  activeColor: const Color(0xFF2481CF),
                                                  shape: const CircleBorder(
                                                      side: BorderSide(
                                                          color: Colors.grey
                                                      )
                                                  ),
                                                  checkColor: Colors.white,
                                                  value: conversationList[index].select,
                                                  onChanged: (bool? value) {
                                                    if (isVisible == true) {
                                                      var query = mains.objectbox.boxConversation.query(ConversationModel_.roomId.equals(conversationList[index].roomId!)).build();
                                                      setState(() {
                                                        if(query.find().isNotEmpty) {
                                                          final conv = ConversationModel(
                                                            id: query.find().first.id,
                                                            idReceiver: query.find().first.idReceiver,
                                                            statusReceiver: query.find().first.statusReceiver,
                                                            photoProfile: query.find().first.photoProfile,
                                                            fullName: query.find().first.fullName,
                                                            image: query.find().first.image,
                                                            message: query.find().first.message,
                                                            date: query.find().first.date,
                                                            messageCout: query.find().first.messageCout,
                                                            roomId: query.find().first.roomId,
                                                            idReceiversGroup: query.find().first.idReceiversGroup,
                                                            select: !conversationList[index].select,
                                                          );
                                                          mains.objectbox.boxConversation.put(conv);

                                                          if(conversationList[index].select==false){
                                                            convSelected.add(conversationList[index]);
                                                          }else{
                                                            convSelected.removeWhere((item) => item.roomId == conversationList[index].roomId);
                                                          }
                                                        }
                                                      });
                                                    }
                                                  },
                                                ),
                                              ),
                                              Expanded(
                                                child: ListTile(
                                                  leading: ClipOval(
                                                      child:  conversationList[index].idReceiver != null && conversationList[index].photoProfile==''
                                                          ?
                                                      const CircleAvatar(
                                                        radius: 25,
                                                        backgroundColor: Color(0xffdde1ea),
                                                        child:  Icon(
                                                          Icons.person,
                                                          color: Colors.grey,
                                                        ),
                                                      )
                                                          : conversationList[index].idReceiversGroup != null && conversationList[index].photoProfile==null ?
                                                      const CircleAvatar(
                                                          radius: 25,
                                                          backgroundColor: Color(0xffdde1ea),
                                                          child:  Icon(
                                                            Icons.people_rounded,
                                                            color: Colors.grey,
                                                          )
                                                      )
                                                          : conversationList[index].photoProfile=="" ?
                                                      const CircleAvatar(
                                                        radius: 25,
                                                        backgroundColor: Color(0xffdde1ea),
                                                        child:  Icon(
                                                          Icons.people_rounded,
                                                          color: Colors.grey,
                                                        ),
                                                      )
                                                          :
                                                      CircleAvatar(
                                                        // backgroundImage: _tempConv[index].photoProfile,
                                                        backgroundImage: CacheImageProviderWidget(getIdUnique(conversationList[index]), base64.decode(mains.objectbox.boxConversation.get(conversationList[index].id)!.photoProfile!)),
                                                        backgroundColor: Colors.white,
                                                        radius: 25,
                                                      )
                                                  ),
                                                  title: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: <Widget>[
                                                            Text(
                                                              conversationList[index].fullName!,
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 1,
                                                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                                            ),
                                                            conversationList[index].message != null ?
                                                            ConstrainedBox(
                                                              constraints: const BoxConstraints(
                                                                  maxWidth: 220
                                                              ),
                                                              child: conversationList[index].statusReceiver=='' ?
                                                              Text(
                                                                conversationList[index].message!,
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                                style: const TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
                                                              ):Text(
                                                                conversationList[index].statusReceiver,
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                                style: const TextStyle(color: Color(0xFF25D366), fontSize: 14),
                                                              )
                                                              ,
                                                            ) :
                                                            const Text(
                                                              "",
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 1,
                                                              style: TextStyle(color: Colors.grey),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Column(
                                                        // crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: <Widget>[
                                                          Text(
                                                            DateFormat('HH:mm').format(DateTime.parse(conversationList[index].date!)),
                                                            style: TextStyle(
                                                                color: conversationList[index].messageCout! > 0
                                                                    ? const Color(0xFF25D366)
                                                                    : Colors.grey,
                                                                fontSize: 11),
                                                          ),
                                                          conversationList[index].messageCout! > 0
                                                              ?
                                                          Transform(
                                                              transform: Matrix4.identity()..scale(0.8),
                                                              child: Chip(
                                                                backgroundColor: const Color(0xFF25D366),
                                                                label: Text(
                                                                  '${conversationList[index].messageCout}',
                                                                  style: const TextStyle(color: Colors.white , fontSize: 12),
                                                                ),
                                                              )
                                                          )
                                                              :
                                                          Transform(
                                                              transform: Matrix4.identity()..scale(0.8),
                                                              child: Chip(
                                                                backgroundColor: Theme.of(context).floatingActionButtonTheme.foregroundColor,
                                                                label: const Text(
                                                                  '',
                                                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                                                ),
                                                              )
                                                          )
                                                        ],
                                                      )

                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              )
                      ),
                    ),
                  ),
                ],
              );
            }
          }
      ),
    )
        :
    StreamBuilder<List<ConversationModel>>(
        stream: homes.listControllerConversation.stream,
        builder: (context, snapshot){
          if(mains.objectbox.boxConversation.isEmpty()){
            return
              Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  child :const Text(
                    'No chats yet.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13,),
                  ));
          }
          else
          {
            var builder = mains.objectbox.boxConversation.query(ConversationModel_.id.notEquals(0) & ConversationModel_.message.notEquals(""))
              ..order(ConversationModel_.date, flags: Order.descending);
            List<ConversationModel> conversationList = builder.build().find().toList();
            // bool isNotSame = false;

            // if (_tempConv.isNotEmpty) {
            //   for (var i = 0; i < conversationList.length; i++) {
            //     if (
            //       conversationList[i].idReceiver != _tempConv[i].idReceiver
            //       || conversationList[i].idReceiversGroup != _tempConv[i].idReceiversGroup
            //     ) {
            //       isNotSame = true;
            //     }
            //   }
            // }

            // if (isNotSame) {
            //   _tempConv = [];
            // }

            // if (_tempConv.isEmpty) {
            //   for (var i = 0; i < conversationList.length; i++) {
            //     if (conversationList[i].photoProfile!='') {
            //       _tempConv.add(TempConversation(
            //         idReceiver: conversationList[i].idReceiver,
            //         idReceiversGroup: conversationList[i].idReceiversGroup,
            //         photoProfile: Image.memory(base64.decode(mains.objectbox.boxConversation.get(conversationList[i].id)!.photoProfile!), gaplessPlayback: true,).image,
            //       ));
            //     } else {
            //       _tempConv.add(TempConversation(
            //         idReceiver: conversationList[i].idReceiver,
            //         idReceiversGroup: conversationList[i].idReceiversGroup,
            //       ));
            //     }
            //   }
            // }

            return Column(
              children: [
                Visibility(
                  visible: isVisible,
                  child: Container(
                      height: 50,
                      width: 10000,
                      padding: const EdgeInsets.only(left: 25, right: 5),
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('1 selected',
                            style: TextStyle(
                                color: Colors.grey
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  _openDialog;
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.grey,
                                ),
                              ),
                              Theme(
                                data: Theme.of(context).copyWith(
                                  dividerColor: Colors.white,
                                  iconTheme: const IconThemeData(color: Colors.grey),
                                  textTheme: const TextTheme().apply(bodyColor: Colors.white),
                                ),
                                child: PopupMenuButton<int>(
                                  icon: const Icon(Icons.more_vert),
                                  color: Colors.white,
                                  onSelected: (item) => onSelected(context, item),
                                  itemBuilder: (context) => [
                                    const PopupMenuItem<int>(
                                      value: 0,
                                      child: Text('Select All',
                                        style: TextStyle(
                                            fontSize: 15
                                        ),
                                      ),
                                      textStyle: TextStyle(color: Colors.black,fontSize: 17),
                                    ),
                                    const PopupMenuItem<int>(
                                      value: 1,
                                      child: Text('Cancel',
                                        style: TextStyle(
                                            fontSize: 15
                                        ),
                                      ),
                                      textStyle: TextStyle(color: Colors.black,fontSize: 17),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                  ),
                ),
                Expanded(
                  child: Container(
                    // padding: EdgeInsets.all(10),
                    padding: const EdgeInsets.only(
                      right: 10.0,
                      left: 10.0,
                    ),
                    child: ListView.builder(
                        itemCount: conversationList.length,
                        itemBuilder:(BuildContext context,index) {
                          // print('id: ${conversationList[index].photoProfile} ${conversationList[index].idReceiver} ${conversationList[index].idReceiversGroup} $index');
                          DateTime now = DateTime.now();
                          DateTime date2 = DateTime.parse(conversationList[index].date!);
                          String desc = "";

                          if (IndexFunction.daysBetween(date2, now) < 7) {
                            bool isToday = DateFormat('yyyy-MM-dd').format(now) == DateFormat('yyyy-MM-dd').format(DateTime.parse(conversationList[index].date!));

                            if (isToday) {
                              desc = DateFormat('HH:mm').format(DateTime.parse(conversationList[index].date!));
                            } else if (IndexFunction.daysBetween(date2, now) == 1) {
                              desc = "Yesterday";
                            } else {
                              desc = DateFormat('EEEE').format(DateTime.parse(conversationList[index].date!));
                            }
                          } else {
                            desc = DateFormat('dd-MM-yyyy').format(DateTime.parse(conversationList[index].date!));
                          }

                            return InkWell(
                                onTap: (){
                                  if (isVisible == true) {
                                    setState(() {
                                      isChecked = true;
                                    });
                                  } else {
                                    if(conversationList[index].idReceiver != null){
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (BuildContext context)=>ChatScreen(conversationList[index], conversationList[index].roomId!, null))
                                      );
                                    }else{
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (BuildContext context)=>ChatGroup(conversationList[index], conversationList[index].roomId!, "open_conv"))
                                      );
                                    }
                                  }
                                },
                                onLongPress: () {
                                  // _openDialog(context, conversationList[index]);
                                  //Muncul ceklist delete
                                  setState(() {
                                    isVisible = !isVisible;
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(top: index == 0 ? 10.0 : 5.0),
                                  child: Card(
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              //Checklist delete
                                              Visibility(
                                                visible: isVisible,
                                                child: Checkbox(
                                                  activeColor: const Color(0xFF2481CF),
                                                  shape: const CircleBorder(
                                                      side: BorderSide(
                                                          color: Colors.grey
                                                      )
                                                  ),
                                                  checkColor: Colors.white,
                                                  value: isChecked,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      isChecked = value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(bottom: 1.0),
                                                  child: ListTile(
                                                    leading: ClipOval(
                                                        child:  conversationList[index].idReceiver != null && conversationList[index].photoProfile==null
                                                            ?
                                                        const CircleAvatar(
                                                          radius: 25,
                                                          backgroundColor: Color(0xffdde1ea),
                                                          child:  Icon(
                                                            Icons.person,
                                                            color: Colors.grey,
                                                          ),
                                                        )
                                                            :
                                                        conversationList[index].idReceiversGroup != null && conversationList[index].photoProfile==null ?
                                                        const CircleAvatar(
                                                            radius: 25,
                                                            backgroundColor: Color(0xffdde1ea),
                                                            child:  Icon(
                                                              Icons.people_rounded,
                                                              color: Colors.grey,
                                                            )
                                                        )
                                                            :
                                                        conversationList[index].idReceiver != null && conversationList[index].photoProfile==''
                                                            ?
                                                        const CircleAvatar(
                                                          radius: 25,
                                                          backgroundColor: Color(0xffdde1ea),
                                                          child:  Icon(
                                                            Icons.person,
                                                            color: Colors.grey,
                                                          ),
                                                        )
                                                            :
                                                        conversationList[index].idReceiversGroup != null && conversationList[index].photoProfile=="" ?
                                                        const CircleAvatar(
                                                          radius: 25,
                                                          backgroundColor: Color(0xffdde1ea),
                                                          child:  Icon(
                                                            Icons.people_rounded,
                                                            color: Colors.grey,
                                                          ),
                                                        )
                                                            :
                                                        CircleAvatar(
                                                          // backgroundImage: _getPhoto(conversationList[index]),
                                                          backgroundImage: CacheImageProviderWidget(getIdUnique(conversationList[index]), base64.decode(mains.objectbox.boxConversation.get(conversationList[index].id)!.photoProfile!)),
                                                          backgroundColor: Colors.transparent,
                                                          radius: 25,
                                                          // child: Image(
                                                          //   image: _tempConv[index]!,
                                                          // ),
                                                        )
                                                    ),
                                                    title: Padding(
                                                      padding: const EdgeInsets.only(bottom: 12.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: <Widget>[
                                                                Container(
                                                                  alignment: Alignment.centerRight,
                                                                  child: Text(
                                                                    desc,
                                                                    style: TextStyle(
                                                                      color: conversationList[index].messageCout! > 0
                                                                          ? const Color(0xFF25D366)
                                                                          : Colors.grey,
                                                                      fontSize: 12),
                                                                  ),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            conversationList[index].fullName!,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            maxLines: 1,
                                                                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(right: 6.0),
                                                                            child: conversationList[index].message != null ?
                                                                            conversationList[index].statusReceiver=='' ?
                                                                            Text(
                                                                              conversationList[index].message!,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 1,
                                                                              style: const TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
                                                                            )
                                                                                :
                                                                            Text(
                                                                              conversationList[index].statusReceiver,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 1,
                                                                              style: const TextStyle(color: Color(0xFF25D366), fontSize: 14, height: 1.5),
                                                                            ) :
                                                                            const Text(
                                                                              "",
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 1,
                                                                              style: TextStyle(color: Colors.grey),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ),
                                                                    conversationList[index].messageCout! > 0
                                                                        ?
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Container(
                                                                          padding: const EdgeInsets.symmetric(
                                                                            horizontal: 6.0,
                                                                            vertical: 2.5,
                                                                          ),
                                                                          decoration: BoxDecoration(
                                                                            // border: Border.all(width: 2),
                                                                            // shape: BoxShape.circle,
                                                                            // You can use like this way or like the below line
                                                                            borderRadius: BorderRadius.circular(30.0),
                                                                            color: Color(0xFF25D366),
                                                                          ),
                                                                          child: Text(
                                                                            '${conversationList[index].messageCout}',
                                                                            style: const TextStyle(
                                                                              color: Colors.white, 
                                                                              fontSize: 13,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                        :
                                                                    Container(),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                            );
                        }
                    ),
                  ),
                ),
              ],
            );
          }
        }
    );
  }

  void onSelected(BuildContext context, int item)  {
    switch (item) {
      case 0:
        // Navigator.of(context).push(
        //   MaterialPageRoute(builder: (context) => ProfilePage()),
        // );
        List<ConversationModel> conversationList = mains.objectbox.boxConversation.getAll().toList();
        for(var item in conversationList) {
          var query = mains.objectbox.boxConversation.query(ConversationModel_.id.equals(item.id)).build();
          if (query.find().isNotEmpty) {
            final conv = ConversationModel(
              id: query.find().first.id,
              idReceiver: query.find().first.idReceiver,
              statusReceiver: query.find().first.statusReceiver,
              photoProfile: query.find().first.photoProfile,
              fullName: query.find().first.fullName,
              image: query.find().first.image,
              message: query.find().first.message,
              date: query.find().first.date,
              messageCout: query.find().first.messageCout,
              roomId: query.find().first.roomId,
              idReceiversGroup: query.find().first.idReceiversGroup,
              select: true,
            );
            mains.objectbox.boxConversation.put(conv);
          }
        }
        convSelected.clear();
        convSelected.addAll(conversationList);
        break;
      case 1:
        setState(() {
          clearSelect();
          isVisible = !isVisible;
        });
        break;
    }
  }

  Future<http.Response> getMessages(String idRooms) async {

    String url ='https://chat.dev.r17.co.id/get_message.php';

    Map<String, dynamic> data = {
      'api_key': apiKey,
      'id_rooms': idRooms,
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

        print(userMap['id_rooms']);

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


void _openDialog(ctx) {
  showCupertinoDialog(
      context: ctx,
      builder: (_) => CupertinoAlertDialog(
        title: const Text("Delete Chat"),
        content: const Text("Messages will be removed from this device only."),
        actions: [
          // Close the dialog
          // You can use the CupertinoDialogAction widget instead
          CupertinoButton(
              child: const Text('Cancel',
                style: TextStyle(
                    color: Color(0xFF2481CF)
                ),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
              }),
          CupertinoButton(
            child: const Text('Delete',
              style: TextStyle(
                  color: Colors.red
              ),
            ),
            onPressed: () {
              idUser = mains.objectbox.boxUser.get(1)?.userId;

              for(var conv in convSelected){
                //personal chat delete
                if(conv.idReceiver!=null){
                  var query = mains.objectbox.boxChat.query( (ChatModel_.idReceiver.equals(conv.idReceiver!) & ChatModel_.idSender.equals(idUser!)) | ChatModel_.idReceiver.equals(idUser!) & ChatModel_.idSender.equals(conv.idReceiver!)).build();
                  List<ChatModel> chats = query.find().toList();
                  for(var chat in chats){
                    mains.objectbox.boxChat.remove(chat.id);
                  }
                }
                //group chat delete
                else if(conv.idReceiversGroup!=null){
                  var query = mains.objectbox.boxChat.query( (ChatModel_.idRoom.equals(conv.roomId!))).build();
                  List<ChatModel> chats = query.find().toList();
                  for(var chat in chats){
                    mains.objectbox.boxChat.remove(chat.id);
                  }
                }
                //delete conversation
                mains.objectbox.boxConversation.remove(conv.id);
              }
              Navigator.of(ctx).pop();
              convSelected = [];
            },
          )
        ],
      ));
}

void clearSelect(){
  List<ConversationModel> conversationList = mains.objectbox.boxConversation.getAll().toList();
  for(var item in conversationList) {
    var query = mains.objectbox.boxConversation.query(ConversationModel_.id.equals(item.id)).build();
    if (query.find().isNotEmpty) {
      final conv = ConversationModel(
        id: query.find().first.id,
        idReceiver: query.find().first.idReceiver,
        statusReceiver: query.find().first.statusReceiver,
        photoProfile: query.find().first.photoProfile,
        fullName: query.find().first.fullName,
        image: query.find().first.image,
        message: query.find().first.message,
        date: query.find().first.date,
        messageCout: query.find().first.messageCout,
        roomId: query.find().first.roomId,
        idReceiversGroup: query.find().first.idReceiversGroup,
        select: false,
      );
      mains.objectbox.boxConversation.put(conv);
    }
  }
  convSelected = [];
}