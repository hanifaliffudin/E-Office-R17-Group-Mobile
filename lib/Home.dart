import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:militarymessenger/ChatGroup.dart';
import 'package:militarymessenger/ChatScreen.dart';
import 'package:militarymessenger/ChatTabScreen.dart';
import 'package:militarymessenger/FeedTabScreen.dart';
import 'package:militarymessenger/Login.dart';
import 'package:militarymessenger/XploreTabScreen.dart';
import 'package:militarymessenger/History.dart';
import 'package:militarymessenger/NewGroupPage.dart';
import 'package:militarymessenger/SettingsPage.dart';
import 'package:militarymessenger/AboutPage.dart';
import 'package:militarymessenger/contact.dart';
import 'package:militarymessenger/document.dart';
import 'package:militarymessenger/main.dart';
import 'package:militarymessenger/models/BadgeModel.dart';
import 'package:militarymessenger/models/NewsModel.dart';
import 'package:militarymessenger/models/SuratModel.dart';
import 'package:militarymessenger/profile.dart';
import 'package:militarymessenger/settings/chat.dart';
import 'package:militarymessenger/settings/notification.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'models/ContactModel.dart';
import 'models/UserModel.dart';
import 'objectbox.g.dart';
import 'package:militarymessenger/models/ChatModel.dart';
import 'package:militarymessenger/models/ConversationModel.dart';
import 'package:militarymessenger/models/ContactModel.dart';
import 'dart:io';
import 'package:web_socket_channel/io.dart';
import 'main.dart' as mains;
import 'package:http/http.dart' as http;


StreamController<List<ChatModel>> listController = new BehaviorSubject();
StreamController<List<ConversationModel>> listControllerConversation = new BehaviorSubject();
StreamController<List<ContactModel>> listControllerContact = new BehaviorSubject();
StreamController<List<UserModel>> listControllerUser = new BehaviorSubject();
StreamController<List<SuratModel>> listControllerSurat = new BehaviorSubject();
StreamController<List<NewsModel>> listControllerNews = new BehaviorSubject();
StreamController<List<BadgeModel>> listControllerBadge = new BehaviorSubject();

String apiKeyCore = '1Hw3G9UYOhounou0679y3*OhouH978%hOtfr57fRtug#9UI8nl7iU4Yt5vR6Fb87tLRB5u3g4Hi92983huiU3g5bkH5BVGv3daf2F5e2Ae4k6F5vblUwIJD9W7ryiuBL24Lbv3P';

var channel;
int? idSender;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{
  TabController? _tabController;
  String apiKey = apiKeyCore;
  final String? email = mains.objectbox.boxUser.get(1)?.email;
  String? name;
  String? phone;
  String? photo;
  Uint8List? bytes;
  var contactList,contactData,contactName;

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
              message.data['id'],
                message.notification!.title!,
            // style: AndroidNotificationStyle.BigText,
            icon: "@mipmap/ic_launcher",
            styleInformation: BigTextStyleInformation(
                message.data['msg_data'],//  'Locations: <b>${locations.replaceAll("\$", " to ")}</b><br>Vehicle: <b>$vehicle</b><br>Trip Type: <b>$tripType</b><br>Pick-Up Date: <b>$pickUpDate</b><br>Pick-Up Time: <b>$pickUpTime</b>',
            htmlFormatBigText: true,
            contentTitle: message.notification!.title!,
            htmlFormatContentTitle: true,
            summaryText: 'Messenger',
            htmlFormatSummaryText: true
              ),
              )
            ),
          payload: jsonEncode(message.data),
        );
      }
    });

    var android = AndroidInitializationSettings('mipmap/ic_launcher');
    var ios =  IOSInitializationSettings();
    var platform = InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(platform,
      onSelectNotification: (payload) {

        var dataPayload = jsonDecode(payload!);

        if (dataPayload['type'] == 'dokumen') {
          var query = mains.objectbox.boxSurat.query(SuratModel_.idSurat.equals(dataPayload['id']) & SuratModel_.kategori.equals(dataPayload['kategori'])).build();
          if(query.find().isNotEmpty) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DocumentPage(mains.objectbox.boxSurat.get(query.find().first.id))),);
          }
          else{
            final surat = SuratModel(
              idSurat: dataPayload['id'],
              namaSurat: dataPayload['perihal'],
              nomorSurat: dataPayload['nomor'],
              editor: dataPayload['editor'],
              perihal: dataPayload['perihal'],
              status: dataPayload['status'],
              tglSelesai: dataPayload['tgl_selesai'],
              url: dataPayload['isi_surat'],
              kategori: dataPayload['kategori'],
              tglBuat: dataPayload['tgl_buat'],
              tipeSurat: dataPayload['tipe_surat'].runtimeType == int ? dataPayload['tipe_surat'] : int.parse(dataPayload['tipe_surat']) ,
              approver: dataPayload['approv'],
              penerima: dataPayload['penerima'],
            );

            mains.objectbox.boxSurat.put(surat);

            setState(() {});

            Navigator.push(context, MaterialPageRoute(builder: (context) => DocumentPage(surat)),);
          }
        }

        if (dataPayload['type'] == 'pm') {
          //  get id conversation from message data and then query find to object box conversation,
          var query = mains.objectbox.boxConversation.query(ConversationModel_.idReceiver.equals(int.parse(dataPayload['id_sender']))).build();
          if(query.find().isNotEmpty) {
            int? count = query
                .find()
                .first
                .messageCout;
            if (count == null)
              count = 1;
            else
              count = count + 1;

            ConversationModel objConversation2 = ConversationModel(
                id: query.find().first.id,
                idReceiver: int.parse(dataPayload['id_sender']),
                fullName: query.find().first.fullName,
                image: query.find().first.image,
                photoProfile: query.find().first.photoProfile,
                message: dataPayload['msg_data'],
                date: dataPayload['msg_date'],
                messageCout: count,
                statusReceiver: query.find().first.statusReceiver,
                roomId: int.parse(dataPayload['room_id'])
            );
            mains.objectbox.boxConversation.put(objConversation2);

            Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context)=>ChatScreen(objConversation2, int.parse(dataPayload['room_id']))
                ));

          }
          else{
            ConversationModel objConversation2 = ConversationModel(
                id: 0,
                idReceiver: int.parse(dataPayload['id_sender']),
                fullName: dataPayload['name_sender'],
                image: '',
                photoProfile: dataPayload['photo'],
                message: dataPayload['msg_data'],
                date: dataPayload['msg_date'],
                messageCout: 1,
                statusReceiver: '',
                roomId: int.parse(dataPayload['room_id']));
            mains.objectbox.boxConversation.put(objConversation2);

            Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context)=>ChatScreen(objConversation2, int.parse(dataPayload['room_id']))
                ));
          }

        }
        else if(dataPayload['type'] == 'group'){
          List<int> id_receivers = json.decode(dataPayload['id_receivers']).cast<int>();
          id_receivers.removeWhere((element) => element == mains.objectbox.boxUser.get(1)!.userId);
          id_receivers.add(int.parse(dataPayload['id_sender']));
          //  get id conversation from message data and then query find to object box conversation,
          var query = mains.objectbox.boxConversation.query(ConversationModel_.roomId.equals(int.parse(dataPayload['room_id']))).build();
          if(query.find().isNotEmpty) {
            int? count = query
                .find()
                .first
                .messageCout;
            if (count == null)
              count = 1;
            else
              count = count + 1;

            ConversationModel objConversation3 = ConversationModel(
                id: query.find().first.id,
                idReceiversGroup: json.encode(id_receivers),
                fullName: query.find().first.fullName,
                image: query.find().first.image,
                photoProfile: query.find().first.photoProfile,
                message: dataPayload['msg_data'],
                date: dataPayload['msg_date'],
                messageCout: count,
                statusReceiver: query.find().first.statusReceiver,
                roomId: query.find().first.roomId
            );
            mains.objectbox.boxConversation.put(objConversation3);

            Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context)=>ChatGroup(objConversation3, int.parse(dataPayload['room_id']), "handle_notif")
                ));
          }
          else{
            ConversationModel objConversation3 = ConversationModel(
              id: 0,
              idReceiversGroup: json.encode(id_receivers),
              fullName: dataPayload['group_name'],
              image: '',
              // photoProfile: message.data['photo'],
              message: dataPayload['msg_data'],
              date: dataPayload['msg_date'],
              roomId: int.parse(dataPayload['room_id']),
              messageCout: 1,
              statusReceiver: '',
            );
            mains.objectbox.boxConversation.put(objConversation3);

            Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context)=>ChatGroup(objConversation3, int.parse(dataPayload['room_id']), "false")
                ));
          }
        }

      },
    );


  }


  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'dokumen') {
      print(message.data);
      var query = mains.objectbox.boxSurat.query(SuratModel_.idSurat.equals(message.data['id']) & SuratModel_.kategori.equals(message.data['kategori'])).build();
      if(query.find().isNotEmpty) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DocumentPage(mains.objectbox.boxSurat.get(query.find().first.id))),);
      }
      else{
        final surat = SuratModel(
          idSurat: message.data['id'],
          namaSurat: message.data['perihal'],
          nomorSurat: message.data['nomor'],
          editor: message.data['editor'],
          perihal: message.data['perihal'],
          status: message.data['status'],
          tglSelesai: message.data['tgl_selesai'],
          url: message.data['isi_surat'],
          kategori: message.data['kategori'],
          tglBuat: message.data['tgl_buat'],
          tipeSurat: message.data['tipe_surat'].runtimeType == int ? message.data['tipe_surat'] : int.parse(message.data['tipe_surat']) ,
          approver: message.data['approv'],
          penerima: message.data['penerima'],
        );

        mains.objectbox.boxSurat.put(surat);

        setState(() {});

        Navigator.push(context, MaterialPageRoute(builder: (context) => DocumentPage(surat)),);
      }
    }

    if (message.data['type'] == 'pm') {
        //  get id conversation from message data and then query find to object box conversation,
        var query = mains.objectbox.boxConversation.query(ConversationModel_.idReceiver.equals(int.parse(message.data['id_sender']))).build();
        if(query.find().isNotEmpty) {
          int? count = query
              .find()
              .first
              .messageCout;
          if (count == null)
            count = 1;
          else
            count = count + 1;

          ConversationModel objConversation2 = ConversationModel(
              id: query.find().first.id,
              idReceiver: int.parse(message.data['id_sender']),
              fullName: query.find().first.fullName,
              image: query.find().first.image,
              photoProfile: query.find().first.photoProfile,
              message: message.data['msg_data'],
              date: message.data['msg_date'],
              messageCout: count,
              statusReceiver: query.find().first.statusReceiver,
              roomId: int.parse(message.data['room_id'])
          );
          mains.objectbox.boxConversation.put(objConversation2);

          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context)=>ChatScreen(objConversation2, int.parse(message.data['room_id']))
              ));

        }
        else{
          ConversationModel objConversation2 = ConversationModel(
              id: 0,
              idReceiver: int.parse(message.data['id_sender']),
              fullName: message.data['name_sender'],
              image: '',
              photoProfile: message.data['photo'],
              message: message.data['msg_data'],
              date: message.data['msg_date'],
              messageCout: 1,
              statusReceiver: '',
              roomId: int.parse(message.data['room_id']));
          mains.objectbox.boxConversation.put(objConversation2);

          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context)=>ChatScreen(objConversation2, int.parse(message.data['room_id']))
              ));
        }

      }
    else if(message.data['type'] == 'group'){
        List<int> id_receivers = json.decode(message.data['id_receivers']).cast<int>();
        id_receivers.removeWhere((element) => element == mains.objectbox.boxUser.get(1)!.userId);
        id_receivers.add(int.parse(message.data['id_sender']));
        //  get id conversation from message data and then query find to object box conversation,
        var query = mains.objectbox.boxConversation.query(ConversationModel_.roomId.equals(int.parse(message.data['room_id']))).build();
        if(query.find().isNotEmpty) {
          int? count = query
              .find()
              .first
              .messageCout;
          if (count == null)
            count = 1;
          else
            count = count + 1;

          ConversationModel objConversation3 = ConversationModel(
              id: query.find().first.id,
              idReceiversGroup: json.encode(id_receivers),
              fullName: query.find().first.fullName,
              image: query.find().first.image,
              photoProfile: query.find().first.photoProfile,
              message: message.data['msg_data'],
              date: message.data['msg_date'],
              messageCout: count,
              statusReceiver: query.find().first.statusReceiver,
              roomId: query.find().first.roomId
          );
          mains.objectbox.boxConversation.put(objConversation3);

          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context)=>ChatGroup(objConversation3, int.parse(message.data['room_id']), "handle_notif")
              ));
        }
        else{
          ConversationModel objConversation3 = ConversationModel(
              id: 0,
              idReceiversGroup: json.encode(id_receivers),
              fullName: message.data['group_name'],
              image: '',
              // photoProfile: message.data['photo'],
              message: message.data['msg_data'],
              date: message.data['msg_date'],
              roomId: int.parse(message.data['room_id']),
              messageCout: 1,
              statusReceiver: '',
          );
          mains.objectbox.boxConversation.put(objConversation3);

          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context)=>ChatGroup(objConversation3, int.parse(message.data['room_id']), "false")
              ));
        }
      }
  }

  Future<String> _createImageFromUint(Uint8List bytes) async {
    // Uint8List bytes = base64.decode(photo!);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".png");
    await file.writeAsBytes(bytes);
    return file.path;
  }

  Future<String> _createFileFromUint(Uint8List bytes) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".pdf");
    await file.writeAsBytes(bytes);
    return file.path;
  }

  String? version;
  String? buildNumber;

  @override
  void initState()  {
    _tabController =  new TabController(initialIndex: 1,length: 4,vsync: this);

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });

    super.initState();

    getListContact();
    getDataUser();

    listController.addStream(mains.objectbox.queryStreamChat.map((q) => q.find()));
    listControllerConversation.addStream(mains.objectbox.queryStreamConversation.map((q) => q.find()));
    listControllerContact.addStream(mains.objectbox.queryStreamContact.map((q) => q.find()));

    if(mains.objectbox.boxUser.isEmpty()){}
    else{
      _doConnect();
    }

    setupInteractedMessage();

  }

  void connect() {
    _doConnect();
  }
  void _doConnect() {
    if (channel != null) {
      close();
    }
    channel = IOWebSocketChannel.connect(
      Uri.parse('wss://chat.dev.r17.co.id:443/wss/?open_key=2K0LJBnj7BK17sdlH65jh58B33Ky1V2bY5Tcr09Ex8e76wZ54eRc4dF1H2G7vG570J9H8465GJ&email=${mains.objectbox.boxUser.get(1)?.email.toString()}'),
      pingInterval: Duration(
        seconds: 1,
      ),
    );
    channel.stream.listen(onReceiveData,
        onDone: onClosed, onError: onError, cancelOnError: false);
  }

  Future<void> onReceiveData(message) async {

    var objMessage = json.decode(message);
    // print(objMessage);


    if(objMessage['type']=="pm"){
      //Update Conversation Model
      var query = mains.objectbox.boxConversation.query(ConversationModel_.idReceiver.equals(objMessage['id_sender'])).build();
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
            idReceiver: objMessage['id_sender'],
            fullName: objMessage['name_sender'] == '' ? query.find().first.fullName : objMessage['name_sender'],
            image: query.find().first.image,
            photoProfile: objMessage['photo'] == '' ? query.find().first.photoProfile : objMessage['photo'],
            message: objMessage['msg_data'],
            date: objMessage['msg_date'],
            messageCout: count,
            statusReceiver: query.find().first.statusReceiver,
            roomId: objMessage['room_id']
        );
        mains.objectbox.boxConversation.put(objConversation);
      }
      else{
        ConversationModel objConversation = ConversationModel(
            id: 0,
            idReceiver: objMessage['id_sender'],
            fullName: objMessage['name_sender'],
            image: '',
            photoProfile: objMessage['photo'],
            message: objMessage['msg_data'],
            date: objMessage['msg_date'],
            messageCout: 1,
            statusReceiver: '',
            roomId: objMessage['room_id']
        );
        mains.objectbox.boxConversation.put(objConversation);
      }

      // if message is image
      if(objMessage['msg_tipe']=="image"){
        var contentImage = _createImageFromUint(base64.decode(objMessage['img_data']));

        final chat = ChatModel (
          idChatFriends: objMessage['id_chat_model'],
          idSender: objMessage['id_sender'],
          idReceiver: objMessage['id_receiver'],
          text: "image",
          date: objMessage['msg_date'],
          tipe: 'image',
          content: await contentImage,
          sendStatus: '',
          delivered: 0,
          read: 0,
        );

        mains.objectbox.boxChat.put(chat);
      }
      // if message is file
      else if(objMessage['msg_tipe']=="file"){
        var contentFile = _createFileFromUint(base64.decode(objMessage['file_data']));

        print(objMessage['file_data']);

        final chat = ChatModel (
          idChatFriends: objMessage['id_chat_model'],
          idSender: objMessage['id_sender'],
          idReceiver: objMessage['id_receiver'],
          text: objMessage['msg_data'],
          date: objMessage['msg_date'],
          tipe: 'file',
          content: await contentFile,
          sendStatus: '',
          delivered: 0,
          read: 0,
        );

        mains.objectbox.boxChat.put(chat);
      }
      // if message is text
      else{
        //update Chat Model
        final chat = ChatModel(
          idChatFriends: objMessage['id_chat_model'],
          idSender: objMessage['id_sender'],
          idReceiver: objMessage['id_receiver'],
          text: objMessage['msg_data'],
          date: objMessage['msg_date'],
          tipe: 'text',
          sendStatus: '',
          content: null,
          delivered: 0,
          read: 0,
        );
        mains.objectbox.boxChat.put(chat);
      }

      // sink if message arrived
      var msg = {};
      msg["api_key"] = apiKey;
      msg["type"] = "status_deliver";
      msg["id_chat_model_friends"] = objMessage['id_chat_model'];
      msg["id_sender"] = objMessage['id_sender'];
      msg["id_receiver"] = objMessage['id_receiver'];
      msg["msg_tipe"] = objMessage['msg_tipe'];
      msg["room_id"] = objMessage['room_id'];
      String msgString = json.encode(msg);
      channel.sink.add(msgString);

      // if(objMessage['otp'] != null){
      //   print(objMessage['otp']);
      // }

    }
    else if(objMessage['type']=="insert_success"){
      ChatModel cm = mains.objectbox.boxChat.get(objMessage['id_chat_model'])!;
      print(objMessage['id_chat_model']);
      final chat = ChatModel(
        id: cm.id,
        idChat: objMessage['id_chat_db'],
        idSender: cm.idSender,
        idReceiver: cm.idReceiver,
        text: cm.text,
        date: objMessage['created_at'],
        tipe: cm.tipe,
        content: cm.content,
        sendStatus: ' ',
        delivered: 0,
        read: 0,
      );
      mains.objectbox.boxChat.put(chat);
    }
    else if(objMessage['type']=="status_deliver"){
      ChatModel cm = mains.objectbox.boxChat.get(objMessage['id_chat_model'])!;
      final chat = ChatModel(
        id: cm.id,
        idSender: cm.idSender,
        idReceiver: cm.idReceiver,
        text: cm.text,
        date: cm.date,
        tipe: cm.tipe,
        content: cm.content,
        sendStatus: 'D',
        delivered: 1,
        read: 0,
      );
      mains.objectbox.boxChat.put(chat);
    }
    else if(objMessage['type']=="status_read"){
      ChatModel cm = mains.objectbox.boxChat.get(objMessage['id_chat_model'])!;
      final chat = ChatModel(
        id: cm.id,
        idSender: cm.idSender,
        idReceiver: cm.idReceiver,
        text: cm.text,
        date: cm.date,
        tipe: cm.tipe,
        content: cm.content,
        sendStatus: 'R',
        delivered: 1,
        read: 1,
      );
      mains.objectbox.boxChat.put(chat);
    }
    else if(objMessage['type']=="status_read_arrive"){
      ChatModel cm = mains.objectbox.boxChat.get(objMessage['id_chat_model'])!;
      final chat = ChatModel(
        id: cm.id,
        idSender: cm.idSender,
        idReceiver: cm.idReceiver,
        text: cm.text,
        date: cm.date,
        tipe: cm.tipe,
        content: cm.content,
        sendStatus: 'R',
        delivered: 1,
        read: 1,
        readDB: 1,
      );
      mains.objectbox.boxChat.put(chat);
    }
    else if(objMessage['type']=="status_typing"){
      //Update Typing Status
      //print(" \n\n" + json.encode(objMessage)   + "\n\n");
      var query = mains.objectbox.boxConversation.query(ConversationModel_.idReceiver.equals(objMessage['id_sender'])).build();
      if(query.find().isNotEmpty) {
        ConversationModel objConversation = ConversationModel(
            id: query.find().first.id,
            idReceiver: query.find().first.idReceiver,
            fullName: query.find().first.fullName,
            image: query.find().first.image,
            photoProfile: query.find().first.photoProfile,
            message: query.find().first.message,
            date: query.find().first.date,
            messageCout: query.find().first.messageCout,
            statusReceiver: objMessage['send_status'],
            roomId: query.find().first.roomId);
        mains.objectbox.boxConversation.put(objConversation);

        // Delete typing status after 2 seconds
        // setState((){});
        Future.delayed(Duration(milliseconds: 2000)).whenComplete((){
          ConversationModel objConversation = ConversationModel(
              id: query.find().first.id,
              idReceiver: query.find().first.idReceiver,
              fullName: query.find().first.fullName,
              image: query.find().first.image,
              photoProfile: query.find().first.photoProfile,
              message: query.find().first.message,
              date: query.find().first.date,
              messageCout: query.find().first.messageCout,
              statusReceiver: '',
              roomId: query.find().first.roomId);
          mains.objectbox.boxConversation.put(objConversation);
          // setState((){});
        });

      }
    }
    else if(objMessage['type']=="group"){

      List<int> id_receivers = json.decode(objMessage['id_receivers']).cast<int>();
      id_receivers.removeWhere((element) => element == mains.objectbox.boxUser.get(1)!.userId);
      id_receivers.add(objMessage['id_sender']);

      var query = mains.objectbox.boxConversation.query(ConversationModel_.roomId.equals(objMessage['room_id'])).build();
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
            idReceiversGroup: json.encode(id_receivers),
            fullName: objMessage['group_name'],
            image: query.find().first.image,
            photoProfile: objMessage['image'],
            message: "${objMessage['name_sender']}: ${objMessage['msg_data']}",
            date: objMessage['msg_date'],
            messageCout: objMessage['msg_tipe'] == 'system' ? 0 : count,
            statusReceiver: query.find().first.statusReceiver,
            roomId: objMessage['room_id'],
        );
        mains.objectbox.boxConversation.put(objConversation);
      }
      else{
        ConversationModel objConversation = ConversationModel(
          id: 0,
          idReceiversGroup: json.encode(id_receivers),
          fullName: objMessage['group_name'],
          image: '',
          photoProfile: objMessage['image'],
          message: "${objMessage['name_sender']}: ${objMessage['msg_data']}",
          date: objMessage['msg_date'],
          messageCout: objMessage['msg_tipe'] == 'system' ? 0 : 1,
          statusReceiver: '',
          roomId: objMessage['room_id'],
        );
        mains.objectbox.boxConversation.put(objConversation);
      }

      // if message is image
      if(objMessage['msg_tipe']=="image"){
        var contentImage = _createFileFromUint(base64.decode(objMessage['img_data']));

        final chat = ChatModel (
          idChatFriends: objMessage['id_chat_model'],
          idSender: objMessage['id_sender'],
          nameSender: objMessage['name_sender'],
          idRoom: objMessage['room_id'],
          idReceiversGroup: objMessage['id_receivers'],
          text: "Photo",
          date: objMessage['msg_date'],
          tipe: 'image',
          content: await contentImage,
          sendStatus: '',
          delivered: 0,
          read: 0,
        );

        mains.objectbox.boxChat.put(chat);
      }
      // if message is file
      else if(objMessage['msg_tipe']=="file"){
        var contentFile = _createFileFromUint(base64.decode(objMessage['file_data']));

        final chat = ChatModel (
          idChatFriends: objMessage['id_chat_model'],
          idSender: objMessage['id_sender'],
          nameSender: objMessage['name_sender'],
          idRoom: objMessage['room_id'],
          idReceiversGroup: objMessage['id_receivers'],
          text: objMessage['msg_data'],
          date: objMessage['msg_date'],
          tipe: 'file',
          content: await contentFile,
          sendStatus: '',
          delivered: 0,
          read: 0,
        );

        mains.objectbox.boxChat.put(chat);
      }
      // if message is text
      else if(objMessage['msg_tipe']=="text"){
        //update Chat Model
        final chat = ChatModel(
          idChatFriends: objMessage['id_chat_model'],
          idSender: objMessage['id_sender'],
          nameSender: objMessage['name_sender'],
          idRoom: objMessage['room_id'],
          idReceiversGroup: objMessage['id_receivers'],
          text: objMessage['msg_data'],
          date: objMessage['msg_date'],
          sendStatus: '',
          delivered: 0,
          read: 0,
          tipe: 'text',
          content: null,
        );

        mains.objectbox.boxChat.put(chat);
      }
      // if message is system
      else{
        final chat = ChatModel(
          idChatFriends: objMessage['id_chat_model'],
          idSender: objMessage['id_sender'],
          nameSender: objMessage['name_sender'],
          idRoom: objMessage['room_id'],
          idReceiversGroup: objMessage['id_receivers'],
          text: objMessage['msg_data'],
          date: objMessage['msg_date'],
          sendStatus: '',
          delivered: 0,
          read: 0,
          tipe: 'system',
          content: null,
        );

        mains.objectbox.boxChat.put(chat);
      }

      // sink if message arrived
      var msg = {};
      msg["api_key"] = apiKey;
      msg["type"] = "msg_group_received";
      msg["id_received"] = mains.objectbox.boxUser.get(1)!.userId;
      msg["id_chat_model"] = objMessage['id_chat_model'];
      msg["id_sender"] = objMessage['id_sender'];
      msg["id_receivers"] = objMessage['id_receivers'];
      msg["msg_tipe"] = objMessage['msg_tipe'];
      msg["room_id"] = objMessage['room_id'];
      msg["date"] = objMessage['msg_date'];
      String msgString = json.encode(msg);
      channel.sink.add(msgString);
    }
    else if(objMessage['type']=="group_read" && objMessage['id_chat_model']!=null){
      ChatModel cm = mains.objectbox.boxChat.get(objMessage['id_chat_model'])!;

      final chat = ChatModel(
        id: cm.id,
        idChatFriends: cm.idChatFriends,
        idSender: cm.idSender,
        nameSender: cm.nameSender,
        idRoom: cm.idRoom,
        idReceiversGroup: cm.idReceiversGroup,
        text: cm.text,
        tipe: cm.tipe,
        content: cm.content,
        date: cm.date,
        sendStatus: objMessage['send_status'],
        delivered: 1,
        read: cm.read!+1,
      );
      mains.objectbox.boxChat.put(chat);
    }
    else if(objMessage['type']=="group_insert_success"){
      ChatModel cm = mains.objectbox.boxChat.get(objMessage['id_chat_model'])!;
      final chat = ChatModel(
        id: cm.id,
        idSender: cm.idSender,
        idRoom: cm.idRoom,
        idReceiversGroup: cm.idReceiversGroup,
        text: cm.text,
        tipe: cm.tipe,
        content: cm.content,
        date: objMessage['created_at'],
        sendStatus: ' ',
        delivered: 0,
        read: 0,
      );

      mains.objectbox.boxChat.put(chat);
    }

  }

  void onClosed() {
    new Future.delayed(Duration(seconds: 1), () {
      _doConnect();
    });
  }

  void onError(err, StackTrace stackTrace) {
    print("websocket error:" + err.toString());
    if (stackTrace != null) {
      print(stackTrace);
    }
  }

  void close() {
    channel.sink.close();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  File? image;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 4,
            labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                text: 'News',
              ),
              Tab(
                text: 'Chat',
              ),
              Tab(
                text: 'Home',
              ),
              Tab(
                text: 'History',
              ),
            ],
          ),
          title: Text('eOffice',
            style: TextStyle(fontSize: 17),),
          actions: <Widget>[
            InkWell(
                onTap: (){
                },
                child: Icon(Icons.search)),
            SizedBox(
              width: 10,
            ),
            InkWell(
                onTap: () =>_scaffoldKey.currentState?.openEndDrawer(),
                child: Icon(
                    Icons.more_vert
                )
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 5,
            ),
          ],
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            children: [
              SizedBox(height: 50,),
              ListTile(
                title: Row(
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      color: Theme.of(context).inputDecorationTheme.labelStyle?.color,
                      size: 20,
                    ),
                    SizedBox(width: 10,),
                    Text('Profile',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),),
                  ],
                ),
                onTap: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: Theme.of(context).inputDecorationTheme.labelStyle?.color,
                      size: 20,
                    ),
                    SizedBox(width: 10,),
                    Text('Chats',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),),
                  ],
                ),
                onTap: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatSettingPage()),
                  );
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      color: Theme.of(context).inputDecorationTheme.labelStyle?.color,
                      size: 20,
                    ),
                    SizedBox(width: 10,),
                    Text('Notification',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),),
                  ],
                ),
                onTap: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NotificationPage()),
                  );
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Theme.of(context).inputDecorationTheme.labelStyle?.color,
                      size: 20,
                    ),
                    SizedBox(width: 10,),
                    Text('Info',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AboutPage(version, buildNumber)),
                  );
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(
                      Icons.exit_to_app_rounded,
                      color: Theme.of(context).inputDecorationTheme.labelStyle?.color,
                      size: 20,
                    ),
                    SizedBox(width: 10,),
                    Text('Logout',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),),
                  ],
                ),
                onTap: () {
                  _openDialog(context);
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FeedTabScreen(),
            ChatTabScreen(),
            XploreTabScreen(),
            History(),
          ],
          controller: _tabController,
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => (ContactPage())),
            );
          },
        ),
      ),
    );
  }

  void onSelected(BuildContext context, int item)  {
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
          MaterialPageRoute(builder: (context) => AboutPage(version, buildNumber)),
        );
        break;
    }
  }

  Future<http.Response> getDataUser() async {

    String url ='https://chat.dev.r17.co.id/get_user.php';

    Map<String, dynamic> data = {
      'api_key': this.apiKey,
      'email': mains.objectbox.boxUser.get(1)?.email,
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

        var user = UserModel(
          id: 1,
          email: email,
          userId: userMap['id'],
          userName: userMap['name'],
          phone: userMap['phone'],
          photo: userMap['photo'],
        );

        print(user.userId);

        mains.objectbox.boxUser.put(user);

      }else{
        print("ada yang salah!");
        print(userMap['code_status']);
        print(userMap['error']);
        print(response.statusCode);
      }
    }
    else{
      print("Gagal terhubung ke server!");
    }
    return response;
  }

  Future<http.Response> getListContact() async {
    String url ='https://chat.dev.r17.co.id/list_contact.php';

    Map<String, dynamic> data = {
      'api_key': this.apiKey,
      'email': mains.objectbox.boxUser.get(1)?.email,
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


        contactData = userMap['data'];
        for(int i = 0; i < userMap['data'].length; i++){
          contactList = Map<String, dynamic>.from(userMap['data'][i]);
          // contactName = contactList['name'];
          nameList.insert(i, contactList['name']);

          var query = mains.objectbox.boxContact.query(ContactModel_.email.equals(contactList['email'].toString())).build();

          if(query.find().isNotEmpty) {
            final contact = ContactModel(
              id: query.find().first.id,
              userId: query.find().first.userId,
              userName: contactList['name'],
              email: query.find().first.email,
              photo: contactList['photo']=='' || contactList['photo'] == null ? '':contactList['photo'],
              phone: contactList['phone'],
            );

            mains.objectbox.boxContact.put(contact);
          }
          else{
            final contact = ContactModel(
              userId: contactList['id'],
              userName: contactList['name'],
              email: contactList['email'],
              photo: contactList['photo']=='' || contactList['photo'] == null ? '':contactList['photo'],
              phone: contactList['phone'],

            );

            mains.objectbox.boxContact.put(contact);
          }
        }

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
  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  Future<void> _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if(appDir.existsSync()){
      appDir.deleteSync(recursive: true);
    }
  }

  showCupertinoDialog(
      context: ctx,
      builder: (_) => CupertinoAlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to logout?"),
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
                  color: Colors.red
              ),
            ),
            onPressed: () {


              _deleteAppDir();
              _deleteCacheDir();

              mains.objectbox.boxConversation.removeAll();
              mains.objectbox.boxChat.removeAll();
              mains.objectbox.boxContact.removeAll();
              mains.objectbox.boxUser.removeAll();


              Navigator.pushAndRemoveUntil(
                ctx,
                MaterialPageRoute(builder: (context) => Login()),
                    (Route<dynamic> route) => false,
              );

              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              exit(0);
            },
          )
        ],
      ));
}