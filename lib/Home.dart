import 'dart:async';
import 'package:flutter/material.dart';
import 'package:militarymessenger/ChatScreen.dart';
import 'package:militarymessenger/ChatTabScreen.dart';
import 'package:militarymessenger/FeedTabScreen.dart';
import 'package:militarymessenger/XploreTabScreen.dart';
import 'package:militarymessenger/CallTabScreen.dart';
import 'package:militarymessenger/NewGroupPage.dart';
import 'package:militarymessenger/SettingsPage.dart';
import 'package:militarymessenger/AboutPage.dart';
import 'package:militarymessenger/chat.dart';
import 'package:militarymessenger/contact.dart';
import 'package:militarymessenger/profile.dart';
import 'package:rxdart/rxdart.dart';
import 'objectbox.g.dart';
import 'package:militarymessenger/models/ChatModel.dart';
import 'package:militarymessenger/models/ConversationModel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:io';
import 'package:web_socket_channel/io.dart';
import 'main.dart' as mains;

StreamController<List<ChatModel>> listController = new BehaviorSubject();
StreamController<List<ConversationModel>> listControllerConversation = new BehaviorSubject();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{
  TabController? _tabController;
  Store? _store;
  String apiKey = '1uV2YG%Cr#esr5TY78o99p5iKoL2ij3O5bg6drxd5cTR4UCw1uBturdwAst54ERdyfIYhJp3oijp4OmnJ9FsdCv899gJ8B5NKml';

  @override
  void initState()  {
    _tabController =  new TabController(initialIndex: 2,length: 4,vsync: this);
    super.initState();

    listController.addStream(mains.objectbox.queryStreamChat.map((q) => q.find()));
    listControllerConversation.addStream(mains.objectbox.queryStreamConversation.map((q) => q.find()));

    if(mains.objectbox.boxUser.isEmpty()){}
    else{
      var channel = IOWebSocketChannel.connect(Uri.parse('wss://chat.dev.r17.co.id:443/wss/?open_key=2K0LJBnj7BK17sdlH65jhB33Ky1V2bY5Tcr09Ex8e76wZ54eRc4dF1H2G7vG570J9H8465GJ'));
      channel.stream.listen((message) {
        //channel.sink.close(status.goingAway);
        var query = mains.objectbox.boxConversation.query(ConversationModel_.fullName.equals("Barlian R17")).build();
        if(query.find().isNotEmpty) {
          int? count = query
              .find()
              .first
              .messageCout;
          if (count == null)
            count = 1;
          else
            count = count + 1;

          ConversationModel objConversation = ConversationModel(
              id: query.find().first.id,
              idConversation: 1,
              idReceiver: 2,
              fullName: 'Barlian R17',
              image: '',
              message: 'Hello...',
              date: 'yesterday',
              messageCout: count);
              mains.objectbox.boxConversation.put(objConversation);
        }else{
          ConversationModel objConversation = ConversationModel(
              id: 0,
              idConversation: 1,
              idReceiver: 2,
              fullName: 'Barlian R17',
              image: '',
              message: 'Hello...',
              date: 'yesterday',
              messageCout: 1);
              mains.objectbox.boxConversation.put(objConversation);
        }
      });

      //send type start message when open main
      if(mains.objectbox.boxUser.get(1)?.email != null){
        Map msg = {
          'api_key': apiKey
          , 'type': 'start'
          , 'email': mains.objectbox.boxUser
              .get(1)
              ?.email
              .toString()
        };
        channel.sink.add(msg.toString());
        print(msg.toString());
      }
    }

  }


  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF2481CF),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 4,
            labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                child: Icon(Icons.dynamic_feed),
              ),
              Tab(
                text: 'Chats',
              ),
              Tab(
                text: 'Surat',
              ),
              Tab(
                text: 'Recents',
              ),
            ],
          ),
          title: Text('e-Office'.toUpperCase(),
            style: TextStyle(fontSize: 17),),
          actions: <Widget>[
            Icon(Icons.search),
            SizedBox(
              width: 10,
            ),
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.white),
                textTheme: TextTheme().apply(bodyColor: Colors.white),
              ),
              child: PopupMenuButton<int>(
                icon: Icon(Icons.more_vert),
                color: Colors.white,
                onSelected: (item) => onSelected(context, item),
                itemBuilder: (context) => [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text('Profile'),
                    textStyle: TextStyle(color: Colors.black,fontSize: 17),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text('New Group'),
                    textStyle: TextStyle(color: Colors.black,fontSize: 17),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Text('Settings'),
                    textStyle: TextStyle(color: Colors.black,fontSize: 17),
                  ),
                  PopupMenuItem<int>(
                    value: 3,
                    child: Text('About'),
                    textStyle: TextStyle(color: Colors.black,fontSize: 17),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
          ],
        ),
        body: TabBarView(
          children: [
            FeedTabScreen(),
            ChatTabScreen(),
            XploreTabScreen(),
            CallTabScreen(),
          ],
          controller: _tabController,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.comment),
          backgroundColor: Color(0xFF2381d0),
          onPressed: (){
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => (ContactPage())),
            );
          },
        ),
      ),
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => NewGroupPage()),
        );
        break;
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
        break;
      case 3:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AboutPage()),
        );
        break;
    }
  }

}
