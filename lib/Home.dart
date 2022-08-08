import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:another_flushbar/flushbar.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:militarymessenger/pages/attendance_page.dart';
import 'package:militarymessenger/ChatGroup.dart';
import 'package:militarymessenger/ChatScreen.dart';
import 'package:militarymessenger/ChatSearchScreen.dart';
import 'package:militarymessenger/ChatTabScreen.dart';
import 'package:militarymessenger/Drive.dart';
import 'package:militarymessenger/FeedTabScreen.dart';
import 'package:militarymessenger/Login.dart';
import 'package:militarymessenger/EOfficeTabScreen.dart';
import 'package:militarymessenger/History.dart';
import 'package:militarymessenger/NewGroupPage.dart';
import 'package:militarymessenger/SettingsPage.dart';
import 'package:militarymessenger/AboutPage.dart';
import 'package:militarymessenger/contact.dart';
import 'package:militarymessenger/controllers/state_controllers.dart';
import 'package:militarymessenger/document.dart';
import 'package:militarymessenger/functions/attendance_flushbar_function.dart';
import 'package:militarymessenger/functions/attendance_function.dart';
import 'package:militarymessenger/functions/index_function.dart';
import 'package:militarymessenger/functions/location_dialog_function.dart';
import 'package:militarymessenger/main.dart';
import 'package:militarymessenger/models/AttendanceHistoryModel.dart';
import 'package:militarymessenger/models/AttendanceLocationModel.dart';
import 'package:militarymessenger/models/AttendanceModel.dart';
import 'package:militarymessenger/models/BadgeModel.dart';
import 'package:militarymessenger/models/GroupNotifModel.dart';
import 'package:militarymessenger/models/NewsModel.dart';
import 'package:militarymessenger/models/SuratModel.dart';
import 'package:militarymessenger/models/savedModel.dart';
import 'package:militarymessenger/pages/qrcode_eoffice_page.dart';
import 'package:militarymessenger/profile.dart';
import 'package:militarymessenger/services/index_service.dart';
import 'package:militarymessenger/settings/chat.dart';
import 'package:militarymessenger/settings/notification.dart';
import 'package:militarymessenger/location_accuracy_page.dart';
import 'package:militarymessenger/utils/variable_util.dart';
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
import 'package:telephony/telephony.dart';

StreamController<List<ChatModel>> listController = BehaviorSubject();
StreamController<List<ConversationModel>> listControllerConversation =
    BehaviorSubject();
StreamController<List<ContactModel>> listControllerContact = BehaviorSubject();
StreamController<List<UserModel>> listControllerUser = BehaviorSubject();
StreamController<List<SuratModel>> listControllerSurat = BehaviorSubject();
StreamController<List<NewsModel>> listControllerNews = BehaviorSubject();
StreamController<List<BadgeModel>> listControllerBadge = BehaviorSubject();
StreamController<List<AttendanceModel>> listControlerAttendance = BehaviorSubject();
StreamController<List<BadgeModel>> listControlerBadge = BehaviorSubject();

var channel;
int? idSender;

final Telephony telephony = Telephony.instance;
GlobalKey flushBarKey = GlobalKey();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin, WidgetsBindingObserver {
  final _variableUtil = VariableUtil();
  final _indexFunction = IndexFunction();
  final _attendanceFunction = AttendanceFunction();
  final _indexService = IndexService();
  final _attendanceFlushbarFunc = AttendanceFlushbarFunction();
  final _locationDialogFunc = LocationDialogFunction();
  TabController? _tabController;
  int _selectedTab = 1;
  final String? email = mains.objectbox.boxUser.get(1)?.email;
  String? name;
  String? phone;
  String? photo;
  Uint8List? bytes;
  var contactList, contactData, contactName;
  late StreamSubscription<LocationData> locationStream;
  Location location = Location();
  final StateController _stateController = Get.put(StateController());
  bool _runLocation = false;

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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // RemoteNotification notification = message.notification!;
      int hashCode = UniqueKey().hashCode;
      bool run = true;

      if (message.data.containsKey('type')) {
        if (message.data['type'] == 'logout') {
          _openDialogAutoLogout(context);
        }

        if (message.data['type'] == 'dokumen') {
          _stateController.changeRefreshEoffice(true);

          if (message.data.containsKey('kategori')) {
            _stateController.documentCategory.value = message.data['kategori'];
          }

          var groupNotif = GroupNotifModel(
            dataId: message.data['id'].toString(),
            type: 'dokumen${message.data['type']}',
            // hashcode: notification.hashCode,
            hashcode: hashCode,
          );

          mains.objectbox.boxGroupNotif.put(groupNotif);
        }
      }
      
      if (message.data.containsKey('room_id')) {
        GroupNotifModel groupNotif = GroupNotifModel(
          dataId: message.data['room_id'].toString(),
          type: 'chat',
          // hashcode: notification.hashCode,
          hashcode: hashCode,
        );
        mains.objectbox.boxGroupNotif.put(groupNotif);

        if (_stateController.fromRoomId.value == int.parse(message.data['room_id'])) {
          run = false;
        }
      }

      if (run) {
        AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
          hashCode.toString(),
          message.data['title'],
          // message.notification!.title!,
          // style: AndroidNotificationStyle.BigText,
          icon: "@mipmap/ic_launcher",
          // groupKey: message.data.containsKey('room_id') ? message.data['room_id'].toString() : '',
          groupKey: 'r17eoffice',
          importance: Importance.high, 
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(
            message.data['msg_data'], //  'Locations: <b>${locations.replaceAll("\$", " to ")}</b><br>Vehicle: <b>$vehicle</b><br>Trip Type: <b>$tripType</b><br>Pick-Up Date: <b>$pickUpDate</b><br>Pick-Up Time: <b>$pickUpTime</b>',
            htmlFormatBigText: true,
            // contentTitle: message.notification!.title!,
            contentTitle: message.data['title'],
            htmlFormatContentTitle: true,
            // summaryText: 'Messenger',
            htmlFormatSummaryText: true,
          ),
        );
        IOSNotificationDetails iosNotificationDetails = const IOSNotificationDetails(
          threadIdentifier: 'r17eoffice',
        );
        AndroidNotificationDetails groupAndroidNotificationDetails = AndroidNotificationDetails(
          hashCode.toString(),
          // message.notification!.title!,
          message.data['title'],
          icon: "@mipmap/ic_launcher",
          // groupKey: message.data.containsKey('room_id') ? message.data['room_id'].toString() : '',
          groupKey: 'r17eoffice',
          setAsGroupSummary: true,
          styleInformation: BigTextStyleInformation(
            message.data['msg_data'],
            htmlFormatBigText: true,
            // contentTitle: message.notification!.title!,
            contentTitle: message.data['title'],
            htmlFormatContentTitle: true,
            // summaryText: 'Messenger',
            htmlFormatSummaryText: true,
          ),
        );

        flutterLocalNotificationsPlugin.show(
          hashCode,
          // notification.title,
          message.data['title'],
          // notification.body,
          message.data['body'],
          NotificationDetails(
            android: androidNotificationDetails,
            iOS: iosNotificationDetails,
          ),
          payload: jsonEncode(message.data),
        );
        
        if (Platform.isAndroid) {
          flutterLocalNotificationsPlugin.show(
            0, 
            '', 
            '', 
            NotificationDetails(
              android: groupAndroidNotificationDetails,
              iOS: iosNotificationDetails,
            ),
          );
        }
      }
    });

    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = const IOSInitializationSettings();
    var platform = InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(
      platform,
      onSelectNotification: (payload) {
        var dataPayload = jsonDecode(payload!);

        if (dataPayload['type'] == 'dokumen') {
          var query = mains.objectbox.boxSurat
              .query(SuratModel_.idSurat.equals(dataPayload['id']) &
                  SuratModel_.kategori.equals(dataPayload['kategori']))
              .build();
          if (query.find().isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DocumentPage(
                      mains.objectbox.boxSurat.get(query.find().first.id))),
            );
          } else {
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
              tipeSurat: dataPayload['tipe_surat'].runtimeType == int
                  ? dataPayload['tipe_surat']
                  : int.parse(dataPayload['tipe_surat']),
              approver: dataPayload['approv'],
              penerima: dataPayload['penerima'],
            );

            mains.objectbox.boxSurat.put(surat);

            setState(() {});

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DocumentPage(surat)),
            );
          }
        } else if (dataPayload['type'] == 'pm') {
          //  get id conversation from message data and then query find to object box conversation,
          var query = mains.objectbox.boxConversation
              .query(ConversationModel_.idReceiver
                  .equals(int.parse(dataPayload['id_sender'])))
              .build();
          if (query.find().isNotEmpty) {
            int? count = query.find().first.messageCout;
            if (count == null) {
              count = 1;
            } else {
              count = count + 1;
            }

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
                roomId: int.parse(dataPayload['room_id']));
            mains.objectbox.boxConversation.put(objConversation2);

            Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context)=>ChatScreen(objConversation2, int.parse(dataPayload['room_id']), null)
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
                MaterialPageRoute(builder: (BuildContext context)=>ChatScreen(objConversation2, int.parse(dataPayload['room_id']), null)
                ));
          }
        } else if (dataPayload['type'] == 'group') {
          List<int> idReceivers =
              json.decode(dataPayload['id_receivers']).cast<int>();
          idReceivers.removeWhere(
              (element) => element == mains.objectbox.boxUser.get(1)!.userId);
          idReceivers.add(int.parse(dataPayload['id_sender']));
          //  get id conversation from message data and then query find to object box conversation,
          var query = mains.objectbox.boxConversation
              .query(ConversationModel_.roomId
                  .equals(int.parse(dataPayload['room_id'])))
              .build();
          if (query.find().isNotEmpty) {
            int? count = query.find().first.messageCout;
            if (count == null) {
              count = 1;
            } else {
              count = count + 1;
            }

            ConversationModel objConversation3 = ConversationModel(
                id: query.find().first.id,
                idReceiversGroup: json.encode(idReceivers),
                fullName: query.find().first.fullName,
                image: query.find().first.image,
                photoProfile: query.find().first.photoProfile,
                message: dataPayload['msg_data'],
                date: dataPayload['msg_date'],
                messageCout: count,
                statusReceiver: query.find().first.statusReceiver,
                roomId: query.find().first.roomId);
            mains.objectbox.boxConversation.put(objConversation3);

            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => ChatGroup(objConversation3,
                    int.parse(dataPayload['room_id']), "handle_notif")));
          } else {
            ConversationModel objConversation3 = ConversationModel(
              id: 0,
              idReceiversGroup: json.encode(idReceivers),
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

            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => ChatGroup(objConversation3,
                    int.parse(dataPayload['room_id']), "false")));
          }
        } else if (dataPayload['type'] == 'logout') {
          _openDialogAutoLogout(context);
        } else if (dataPayload['type'] == 'attendance') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AttendancePage()),
          );
        }
      },
    );
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'dokumen') {
      var query = mains.objectbox.boxSurat
          .query(SuratModel_.idSurat.equals(message.data['id']) &
              SuratModel_.kategori.equals(message.data['kategori']))
          .build();
      if (query.find().isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DocumentPage(
                  mains.objectbox.boxSurat.get(query.find().first.id))),
        );
      } else {
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
          tipeSurat: message.data['tipe_surat'].runtimeType == int
              ? message.data['tipe_surat']
              : int.parse(message.data['tipe_surat']),
          approver: message.data['approv'],
          penerima: message.data['penerima'],
        );

        mains.objectbox.boxSurat.put(surat);

        setState(() {});

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DocumentPage(surat)),
        );
      }
    } else if (message.data['type'] == 'pm') {
      //  get id conversation from message data and then query find to object box conversation,
      var query = mains.objectbox.boxConversation
          .query(ConversationModel_.idReceiver
              .equals(int.parse(message.data['id_sender'])))
          .build();
      if (query.find().isNotEmpty) {
        int? count = query.find().first.messageCout;
        if (count == null) {
          count = 1;
        } else {
          count = count + 1;
        }

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
            roomId: int.parse(message.data['room_id']));
        mains.objectbox.boxConversation.put(objConversation2);

        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context)=>ChatScreen(objConversation2, int.parse(message.data['room_id']), null)
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
            MaterialPageRoute(builder: (BuildContext context)=>ChatScreen(objConversation2, int.parse(message.data['room_id']), null)
            ));
      }
    } else if (message.data['type'] == 'group') {
      List<int> idReceivers =
          json.decode(message.data['id_receivers']).cast<int>();
      idReceivers.removeWhere(
          (element) => element == mains.objectbox.boxUser.get(1)!.userId);
      idReceivers.add(int.parse(message.data['id_sender']));
      //  get id conversation from message data and then query find to object box conversation,
      var query = mains.objectbox.boxConversation
          .query(ConversationModel_.roomId
              .equals(int.parse(message.data['room_id'])))
          .build();
      if (query.find().isNotEmpty) {
        int? count = query.find().first.messageCout;
        if (count == null) {
          count = 1;
        } else {
          count = count + 1;
        }

        ConversationModel objConversation3 = ConversationModel(
            id: query.find().first.id,
            idReceiversGroup: json.encode(idReceivers),
            fullName: query.find().first.fullName,
            image: query.find().first.image,
            photoProfile: query.find().first.photoProfile,
            message: message.data['msg_data'],
            date: message.data['msg_date'],
            messageCout: count,
            statusReceiver: query.find().first.statusReceiver,
            roomId: query.find().first.roomId);
        mains.objectbox.boxConversation.put(objConversation3);

        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ChatGroup(objConversation3,
                int.parse(message.data['room_id']), "handle_notif")));
      } else {
        ConversationModel objConversation3 = ConversationModel(
          id: 0,
          idReceiversGroup: json.encode(idReceivers),
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

        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ChatGroup(objConversation3,
                int.parse(message.data['room_id']), "false")));
      }
    } else if (message.data['type'] == 'logout') {
      _openDialogAutoLogout(context);
    } else if (message.data['type'] == 'attendance') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AttendancePage()),
      );
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

  Future<void> _locationAttendance(List<AttendanceLocationModel> attLocs, LocationData location) async {
    Map<String, dynamic> dateTimeMap = await _indexService.getDateTime();

    if (!dateTimeMap['error']) {
      Map<String, dynamic> bodyDateTimeMap = dateTimeMap['body'];
      DateTime now = DateTime.parse(bodyDateTimeMap['data']);

      for (var i = 0; i < attLocs.length; i++) {
        AttendanceLocationModel attLoc = attLocs[i];
        double? distanceOnMeter = _indexFunction.calculateDistance(location.latitude, location.longitude, attLoc.latitude, attLoc.longitude)*1000;

        if (distanceOnMeter <= attLoc.range!) {
          if (now.hour >= 7) {
            var query = mains.objectbox.boxAttendance
              .query(AttendanceModel_.date
                  .equals(DateFormat('dd MM yyyy').format(now)))
              .build()
              .find();

            if (query.isNotEmpty) {
              AttendanceModel attendance = query.first;

              if (attendance.status == 0) {
                attendance.date = DateFormat('dd MM yyyy').format(now);
                attendance.checkInAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                attendance.latitude = location.latitude;
                attendance.longitude = location.longitude;
                attendance.status = 1;
                attendance.server = false;
                attendance.idLocationDb = attLoc.idDb;

                await _saveAttendance(attendance, false);
                break;
              }
            } else {
              AttendanceModel attendance = AttendanceModel(
                date: DateFormat('dd MM yyyy').format(now),
                checkInAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
                latitude: location.latitude,
                longitude: location.longitude,
                status: 1,
                server: false,
                idLocationDb: attLoc.idDb,
              );

              await _saveAttendance(attendance, false);
              break;
            }
          }
        } else if (distanceOnMeter > attLoc.range!) {
          if (now.hour >= 7) {
            var query = mains.objectbox.boxAttendance
              .query(
                AttendanceModel_.date.equals(DateFormat('dd MM yyyy').format(now)) 
                & AttendanceModel_.status.equals(1)
              )
              .build()
              .find();

            if (query.isNotEmpty) {
              AttendanceModel attendance = query.first;

              if (attendance.idLocationDb == attLoc.idDb!) {
                attendance.checkOutAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                attendance.status = 0;
                attendance.server = false;
                attendance.idLocationDb = attLoc.idDb;

                await _saveAttendance(attendance, false);
                break;
              } 
              // else if (attendance.idLocationDb == null) {
              //   attendance.idLocationDb = attLocs[0].idDb;
                
              //   await _saveAttendance(attendance, true);
              //   break;
              // }
            }
          } else {
            DateTime dateYesterday = DateTime(now.year, now.month, now.day - 1);
            var query = mains.objectbox.boxAttendance
              .query(
                AttendanceModel_.date.equals(DateFormat('dd MM yyyy').format(dateYesterday)) 
                & AttendanceModel_.status.equals(1)
                & AttendanceModel_.idLocationDb.equals(attLoc.idDb!)
              )
              .build()
              .find();

            if (query.isNotEmpty) {
              AttendanceModel attendance = query.first;
              String yesterdayMax = dateYesterday.toString() + ' 23:59:59';

              if (attendance.checkOutAt != yesterdayMax) {
                attendance.checkOutAt = DateTime.parse('${dateYesterday.toString()} 23:59:59').toString();
                attendance.status = 0;
                attendance.server = false;
                attendance.idLocationDb = attLoc.idDb;

                await _saveAttendance(attendance, false);
                break;
              }
            }
          }
        }
      }
    }
  }

  // Future<void> _locationAttendance(List<AttendanceLocationModel> attLocs, LocationData locationData) async {
  //   Map<String, dynamic> data = {
  //     'api_key': _variableUtil.apiKeyCore,
  //   };
  //   String url = '${_variableUtil.apiChatUrl}/get_datetime.php';
  //   var response = await http.post(Uri.parse(url),
  //     body: jsonEncode(data),
  //   );
  //   Map<String, dynamic> datetimeMap = jsonDecode(response.body);
  //   DateTime now = DateTime.parse(datetimeMap['data']);
  //   // DateTime now = DateTime.now();

  //   if (locationData != null) {
  //     for (var i = 0; i < attLocs.length; i++) {
  //       AttendanceLocationModel attLoc = attLocs[i];
  //       double? distanceOnMeter = calculateDistance(locationData.latitude, locationData.longitude, attLoc.latitude, attLoc.longitude)*1000;

  //       // print('$locationData $distanceOnMeter ${DateFormat('yyyy-MM-dd HH:mm:ss').format(now)}');
  //       if (distanceOnMeter <= attLoc.range! && now.hour >= 7) {
  //         var query = mains.objectbox.boxAttendance
  //             .query(AttendanceModel_.date
  //                 .equals(DateFormat('dd MM yyyy').format(now)))
  //             .build()
  //             .find();

  //         if (query.isNotEmpty) {
  //           AttendanceModel attendance = query.first;

  //           if (attendance.status == 0) {
  //             attendance.date = DateFormat('dd MM yyyy').format(now);
  //             attendance.checkInAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  //             attendance.latitude = locationData.latitude;
  //             attendance.longitude = locationData.longitude;
  //             attendance.status = 1;
  //             attendance.server = false;
  //             attendance.idLocationDb = attLoc.idDb;

  //             await _saveAttendance(attendance, false);
  //             break;
  //           } else if (attendance.idLocationDb == null) {
  //             attendance.idLocationDb = attLocs[0].idDb;
                
  //             await _saveAttendance(attendance, true);
  //           }
  //         } else {
  //           AttendanceModel attendance = AttendanceModel(
  //             date: DateFormat('dd MM yyyy').format(now),
  //             checkInAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
  //             latitude: locationData.latitude,
  //             longitude: locationData.longitude,
  //             status: 1,
  //             server: false,
  //             idLocationDb: attLoc.idDb,
  //           );

  //           await _saveAttendance(attendance, false);
  //           break;
  //         }
  //       } else if (distanceOnMeter > attLoc.range!) {
  //         if (now.hour >= 7) {
  //           var query = mains.objectbox.boxAttendance
  //             .query(
  //               AttendanceModel_.date.equals(DateFormat('dd MM yyyy').format(now)) 
  //               & AttendanceModel_.status.equals(1)
  //             )
  //             .build()
  //             .find();

  //           if (query.isNotEmpty) {
  //             AttendanceModel attendance = query.first;

  //             if (attendance.idLocationDb == attLoc.idDb!) {
  //               attendance.checkOutAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  //               attendance.status = 0;
  //               attendance.server = false;
  //               attendance.idLocationDb = attLoc.idDb;

  //               await _saveAttendance(attendance, false);
  //               break;
  //             } else if (attendance.idLocationDb == null) {
  //               attendance.idLocationDb = attLocs[0].idDb;
                
  //               await _saveAttendance(attendance, true);
  //               break;
  //             }
  //           }
  //         } else {
  //           DateTime dateYesterday = DateTime(now.year, now.month, now.day - 1);
  //           var query = mains.objectbox.boxAttendance
  //             .query(
  //               AttendanceModel_.date.equals(DateFormat('dd MM yyyy').format(dateYesterday)) 
  //               & AttendanceModel_.status.equals(1)
  //               & AttendanceModel_.idLocationDb.equals(attLoc.idDb!)
  //             )
  //             .build()
  //             .find();

  //           if (query.isNotEmpty) {
  //             AttendanceModel attendance = query.first;
  //             String yesterdayMax = dateYesterday.toString() + ' 23:59:59';

  //             if (attendance.checkOutAt != yesterdayMax) {
  //               attendance.checkOutAt = DateTime.parse('${dateYesterday.toString()} 23:59:59').toString();
  //               attendance.status = 0;
  //               attendance.server = false;
  //               attendance.idLocationDb = attLoc.idDb;

  //               await _saveAttendance(attendance, false);
  //               break;
  //             }
  //           }
  //         }
  //       }
  //     }
  //   }
  // }

  Future<void> _locationService() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();

      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    List<AttendanceLocationModel> attLocs = mains.objectbox.boxAttendanceLocation
      .query()
      .build()
      .find()
      .toList();
    bool runAttendance = true;

    location.enableBackgroundMode(enable: true);
    location.changeSettings(accuracy: LocationAccuracy.high);

    locationStream = location.onLocationChanged
      .listen((LocationData locationData) async {
        if (locationData.accuracy != null && locationData.latitude != null && locationData.longitude != null) { 
          // _stateController.changeLocationAccuracy(locationData.accuracy!);

          if (locationData.accuracy! <= 60.0) {
            // try {
              final result = await InternetAddress.lookup('google.com');

              if (
                result.isNotEmpty 
                && result[0].rawAddress.isNotEmpty
                && runAttendance
              ) {
                runAttendance = false;

                // await _locationAttendance(attLocs, locationData);
                await _attendanceFunction.locationAttendance(context, attLocs, locationData.latitude!, locationData.longitude!);

                runAttendance = true;
              }
            // } catch (e) {
            //   // print(e.toString());
            // }
          }
        }
      });

    _runLocation = true;
    _stateController.changeRunListenLocation(true);
  }

  Future<void> _getAllData() async {
    bool messageGo = false;
    bool attendanceGo = false;
    var queryMessagesDownload = mains.objectbox.boxSaved.query(SavedModel_.type.equals('messagesDownloaded'))
      .build()
      .find();
    var queryAttendancesDownload = mains.objectbox.boxSaved.query(SavedModel_.type.equals('attendancesDownloaded'))
      .build()
      .find();

    if (queryMessagesDownload.isNotEmpty) {
      if (queryMessagesDownload.first.value == false) {
        messageGo = true;
      }
    } else {
      messageGo = true;
    }

    if (queryAttendancesDownload.isNotEmpty) {
      if (queryAttendancesDownload.first.value == false) {
        attendanceGo = true;
      }
    } else {
      attendanceGo = true;
    }

    if (messageGo) {
      EasyLoading.show(status: 'Downloading all messages...');
      await getAllMessages();

      SavedModel saved = SavedModel();

      if (queryMessagesDownload.isNotEmpty) {
        saved = queryMessagesDownload.first;
        saved.value = true;
      } else {
        saved = SavedModel(
          type: 'messagesDownloaded',
          value: true,
        );
      }

      mains.objectbox.boxSaved.put(saved);
    }

    if (attendanceGo) {
      EasyLoading.show(status: 'Downloading all attendances...');
      await _getAllAttendances();

      SavedModel saved = SavedModel();

      if (queryAttendancesDownload.isNotEmpty) {
        saved = queryAttendancesDownload.first;
        saved.value = true;
      } else {
        saved = SavedModel(
          type: 'attendancesDownloaded',
          value: true,
        );
      }

      mains.objectbox.boxSaved.put(saved);
    }

    await _getAllAttendanceLocations();
  }
  
  void _locationPermissionListener() {
    _stateController.locationPermission
      .listen((p0) async {
        if (p0) {
          await _locationService();
        } else {
          if (_runLocation) {
            locationStream.cancel();
          }
        }
      });
  }

  void _runListenLocationListener() {
    _stateController.runListenLocation
      .listen((p0) async {
        if (p0) {
          await _locationService();
        }
      });
  }

  void _listenSmsOtp() {
    if (Platform.isAndroid) {
      telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          String msgBody = message.body!;

          if (msgBody.length >= 39) {
            if (msgBody.substring(0, 33) == 'Kode OTP Digital Signature Anda: ') {
              _stateController.changeOtpCodeSms(msgBody.substring(33, 39));
            }
          }
        },
        listenInBackground: true,
        onBackgroundMessage: smsBackgrounMessageHandler,
      );
    }
  }

  String? version;
  String? buildNumber;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(initialIndex: _selectedTab,length: 4,vsync: this);

    WidgetsBinding.instance.addObserver(this);
    mains.objectbox.boxGroupNotif.removeAll();
    flutterLocalNotificationsPlugin.cancelAll();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (await checkFcmToken() == true) {
        await _getAllData();
        await _accessLocationPermission();
        _locationPermissionListener();
        _listenSmsOtp();
        _runListenLocationListener();
      }

      await getListContact();
    });
    _tabController?.addListener(() => tabListener());
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });

    // getDataUser();
// print(listController.isPaused);
    // if (
    //   !listController.isPaused
    //   && !listControllerConversation.isPaused
    //   && !listControllerContact.isPaused
    //   && !listControlerAttendance.isPaused
    // ) {
      listController
          .addStream(mains.objectbox.queryStreamChat.map((q) => q.find()));
      listControllerConversation.addStream(
          mains.objectbox.queryStreamConversation.map((q) => q.find()));
      listControllerContact
          .addStream(mains.objectbox.queryStreamContact.map((q) => q.find()));
      listControlerAttendance.addStream(mains.objectbox.queryStreamAttendance.map((event) => event.find()));
    // }

    if (mains.objectbox.boxUser.isEmpty()) {
    } else {
      _doConnect();
    }

    setupInteractedMessage();
  }

  void _doConnect() {
    // if (_stateController.runGetLastMessage.value) {
    //   _stateController.changeRunGetLastMessage(false);
    // }

    // if (channel != null) {
    //   close();
    // }

    // channel = IOWebSocketChannel.connect(
    //   Uri.parse(
    //       '${_variableUtil.wssChatUrl}?open_key=${_variableUtil.wssOpenKey}&email=${mains.objectbox.boxUser.get(1)?.email.toString()}'),
    //   pingInterval: const Duration(
    //     seconds: 1,
    //   ),
    // );
    WebSocket.connect('${_variableUtil.wssChatUrl}?open_key=${_variableUtil.wssOpenKey}&email=${mains.objectbox.boxUser.get(1)?.email.toString()}')
      .then((ws) {
        channel = IOWebSocketChannel(ws);

        channel.stream.listen(onReceiveData,
          onDone: onClosed, onError: onError, cancelOnError: false);
      });

    // if (channel != null) {
      // channel.stream.listen(onReceiveData,
      //   onDone: onClosed, onError: onError, cancelOnError: false);
    // }
  }

  Future<void> onReceiveData(message) async {
    var objMessage = json.decode(message);

    if (objMessage['type'] == "pm") {
      //Update Conversation Model
      var query = mains.objectbox.boxConversation
          .query(ConversationModel_.idReceiver.equals(objMessage['id_sender']))
          .build();
      if (query.find().isNotEmpty) {
        int? count = query.find().first.messageCout;
        if (count == null) {
          count = 1;
        } else {
          count = count + 1;
        }

        ConversationModel objConversation = ConversationModel(
            id: query.find().first.id,
            idReceiver: objMessage['id_sender'],
            fullName: objMessage['name_sender'] == ''
                ? query.find().first.fullName
                : objMessage['name_sender'],
            image: query.find().first.image,
            photoProfile: objMessage['photo'] == ''
                ? query.find().first.photoProfile
                : objMessage['photo'],
            message: objMessage['msg_data'],
            date: objMessage['msg_date'],
            messageCout: count,
            statusReceiver: query.find().first.statusReceiver,
            roomId: objMessage['room_id']);
        mains.objectbox.boxConversation.put(objConversation);
      } else {
        ConversationModel objConversation = ConversationModel(
            id: 0,
            idReceiver: objMessage['id_sender'],
            fullName: objMessage['name_sender'],
            image: '',
            photoProfile: objMessage['photo'] == null ? '' : objMessage['photo'],
            message: objMessage['msg_data'],
            date: objMessage['msg_date'],
            messageCout: 1,
            statusReceiver: '',
            roomId: objMessage['room_id']);
        mains.objectbox.boxConversation.put(objConversation);
      }

      // if message is image
      if (objMessage['msg_tipe'] == "image") {
        var contentImage =
            _createImageFromUint(base64.decode(objMessage['img_data']));

        final chat = ChatModel(
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
      else if (objMessage['msg_tipe'] == "file") {
        var contentFile =
            _createFileFromUint(base64.decode(objMessage['file_data']));

        print(objMessage['file_data']);

        final chat = ChatModel(
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
      else {
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
      msg["api_key"] = _variableUtil.apiKeyCore;
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

    } else if (objMessage['type'] == "insert_success") {
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
    } else if (objMessage['type'] == "status_deliver") {
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
    } else if (objMessage['type'] == "status_read") {
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
    } else if (objMessage['type'] == "status_read_arrive") {
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
    } else if (objMessage['type'] == "status_typing") {
      //Update Typing Status
      //print(" \n\n" + json.encode(objMessage)   + "\n\n");
      var query = mains.objectbox.boxConversation
          .query(ConversationModel_.idReceiver.equals(objMessage['id_sender']))
          .build();
      if (query.find().isNotEmpty) {
        ConversationModel objConversation = ConversationModel(
            id: query.find().first.id,
            idReceiver: query.find().first.idReceiver,
            fullName: query.find().first.fullName,
            image: query.find().first.image,
            photoProfile: query.find().first.photoProfile,
            message: query.find().first.message,
            date: query.find().first.date,
            messageCout: query.find().first.messageCout,
            statusReceiver: 'Mengetik...',
            roomId: query.find().first.roomId);
        mains.objectbox.boxConversation.put(objConversation);

        // Delete typing status after 2 seconds
        Future.delayed(const Duration(milliseconds: 2000)).whenComplete(() {
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
        });
      }
    } else if (objMessage['type'] == "group") {
      if (objMessage['from'] == 'self') {
        var query = mains.objectbox.boxChat
          .query(ChatModel_.id.equals(objMessage['id_chat_model']))
          .build()
          .find();

        if (query.isNotEmpty) {
          ChatModel chat = query.first;
          
          if (objMessage['read_by'] != null) {
            if (chat.readBy != null) {
              if (chat.readBy! != objMessage['read_by']) {
                chat.readBy = objMessage['read_by'];
                mains.objectbox.boxChat.put(chat);
              }
            } else {
              chat.readBy = objMessage['read_by'];
              mains.objectbox.boxChat.put(chat);
            }
          }
        }
      } else {
        List<int> idReceivers =
            json.decode(objMessage['id_receivers']).cast<int>();
        idReceivers.removeWhere(
            (element) => element == mains.objectbox.boxUser.get(1)!.userId);
        idReceivers.add(objMessage['id_sender']);

        var query = mains.objectbox.boxConversation
            .query(ConversationModel_.roomId.equals(objMessage['room_id']))
            .build();
        if (query.find().isNotEmpty) {
          int? count = query.find().first.messageCout;
          if (count == null) {
            count = 1;
          } else {
            count = count + 1;
          }

          ConversationModel objConversation = ConversationModel(
            id: query.find().first.id,
            idReceiversGroup: json.encode(idReceivers),
            fullName: objMessage['group_name'],
            image: query.find().first.image,
            photoProfile: objMessage['image'] == null ? '' : objMessage['image'],
            message: "${objMessage['name_sender']}: ${objMessage['msg_data']}",
            date: objMessage['msg_date'],
            messageCout: objMessage['msg_tipe'] == 'system' ? 0 : count,
            statusReceiver: query.find().first.statusReceiver,
            roomId: objMessage['room_id'],
          );
          mains.objectbox.boxConversation.put(objConversation);
        } else {
          ConversationModel objConversation = ConversationModel(
            id: 0,
            idReceiversGroup: json.encode(idReceivers),
            fullName: objMessage['group_name'],
            image: '',
            photoProfile: objMessage['image'] == null ? '' : objMessage['image'],
            message: "${objMessage['name_sender']}: ${objMessage['msg_data']}",
            date: objMessage['msg_date'],
            messageCout: objMessage['msg_tipe'] == 'system' ? 0 : 1,
            statusReceiver: '',
            roomId: objMessage['room_id'],
          );
          mains.objectbox.boxConversation.put(objConversation);
        }

        // if message is image
        if (objMessage['msg_tipe'] == "image") {
          var contentImage =
              _createFileFromUint(base64.decode(objMessage['img_data']));

          final chat = ChatModel(
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
            readBy: objMessage['read_by'],
          );

          mains.objectbox.boxChat.put(chat);
        }
        // if message is file
        else if (objMessage['msg_tipe'] == "file") {
          var contentFile =
              _createFileFromUint(base64.decode(objMessage['file_data']));

          final chat = ChatModel(
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
            readBy: objMessage['read_by'],
          );

          mains.objectbox.boxChat.put(chat);
        }
        // if message is text
        else if (objMessage['msg_tipe'] == "text") {
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
            readBy: objMessage['read_by'],
          );

          mains.objectbox.boxChat.put(chat);
        }
        // if message is system
        else {
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
            readBy: objMessage['read_by'],
          );

          mains.objectbox.boxChat.put(chat);
        }

        // sink if message arrived
        var msg = {};
        msg["api_key"] = _variableUtil.apiKeyCore;
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
    } else if (objMessage['type'] == "group_read" &&
        objMessage['id_chat_model'] != null) {
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
        read: cm.read! + 1,
        readBy: objMessage['read_by'],
      );
      mains.objectbox.boxChat.put(chat);
    } else if (objMessage['type'] == "group_insert_success") {
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
    } else if (objMessage['type'] == "auto_logout") {
      // call auto logout
      print('call auto logout');
      _openDialogAutoLogout(context);
    }
  }

  void onClosed() {
    // _stateController.changeRunGetLastMessage(true);
    
    Future.delayed(const Duration(seconds: 1), () {
      _doConnect();
    });
  }

  void onError(err, StackTrace stackTrace) {
    print("websocket error:" + err.toString());
    print(stackTrace);
  }

  void close() {
    channel.sink.close();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController!.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void tabListener() {
    setState(() {
      _selectedTab = _tabController!.index;
    });
  }

  Future<void> _accessLocationPermission() async {
    bool showDialogAP = false;
    var queryLocationPermission = mains.objectbox.boxSaved
      .query(SavedModel_.type.equals('locationPermission'))
      .build()
      .find();
    SavedModel saved = SavedModel();

    if (queryLocationPermission.isNotEmpty) {
      if (queryLocationPermission.first.value == true) {
        _stateController.changeLocationPermission(queryLocationPermission.first.value!);
        await _locationService();
      }
    } else {
      showDialogAP = true;
    }

    _runLocation = false;

    if (showDialogAP) {
      _locationDialogFunc.locationPermissionDialog(
        context, 
        () async {
          Navigator.pop(context);

          if (queryLocationPermission.isNotEmpty) {
            saved = queryLocationPermission.first;
            saved.value = false;
          } else {
            saved = SavedModel(
              type: 'locationPermission',
              value: false,
            );
          }

          mains.objectbox.boxSaved.put(saved);
        }, 
        () async {
          Navigator.pop(context);

          if (queryLocationPermission.isNotEmpty) {
            saved = queryLocationPermission.first;
            saved.value = true;
          } else {
            saved = SavedModel(
              type: 'locationPermission',
              value: true,
            );
          }
          
          mains.objectbox.boxSaved.put(saved);
          _stateController.changeLocationPermission(true);
        }
      );
    }
  }

  void searchOnTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const ChatSearchScreen()),
      // PageRouteBuilder(
      //   pageBuilder: (c, a1, a2) => const ChatSearchScreen(),
      //   transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
      //   // transitionDuration: Duration(milliseconds: 300),
      // ),
    );
  }

  void attendanceOnTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AttendancePage()),
    );
  }

  void eOfficeOnTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QrcodeEofficePage()),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        mains.objectbox.boxGroupNotif.removeAll();
        await flutterLocalNotificationsPlugin.cancelAll();
        // print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        // print("app in inactive");
        break;
      case AppLifecycleState.paused:
        // print("app in paused");
        break;
      case AppLifecycleState.detached:
        // print("app in detached");
        break;
    }
  }

  File? image;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 5,
            labelStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            tabs: const [
              Tab(
                text: 'News',
              ),
              Tab(
                text: 'Chat',
              ),
              Tab(
                text: 'eOffice',
              ),
              Tab(
                text: 'History',
              ),
            ],
          ),
          title: const Text(
            'eOffice',
            style: TextStyle(fontSize: 17),
          ),
          actions: <Widget>[
            InkWell(
              child: const Icon(Icons.search),
              onTap: () => searchOnTap(),
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
                onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
                child: const Icon(Icons.more_vert)),
            const SizedBox(
              width: 10,
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            children: [
              const SizedBox(
                height: 50,
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      color: Theme.of(context)
                          .inputDecorationTheme
                          .labelStyle
                          ?.color,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Attendance',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                onTap: () => attendanceOnTap(),
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(
                      Icons.qr_code_scanner_rounded,
                      color: Theme.of(context)
                          .inputDecorationTheme
                          .labelStyle
                          ?.color,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Login eOffice Web',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                onTap: () => eOfficeOnTap(),
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      color: Theme.of(context)
                          .inputDecorationTheme
                          .labelStyle
                          ?.color,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()),
                  );
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: Theme.of(context)
                          .inputDecorationTheme
                          .labelStyle
                          ?.color,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Chats',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChatSettingPage()),
                  );
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      color: Theme.of(context)
                          .inputDecorationTheme
                          .labelStyle
                          ?.color,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Notification',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationPage()),
                  );
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Theme.of(context)
                          .inputDecorationTheme
                          .labelStyle
                          ?.color,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Info',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutPage(
                      version, 
                      buildNumber,
                    )),
                  );
                },
              ),
              // ListTile(
              //   title: Row(
              //     children: [
              //       Icon(
              //         Icons.pin_drop_outlined,
              //         color: Theme.of(context)
              //             .inputDecorationTheme
              //             .labelStyle
              //             ?.color,
              //         size: 20,
              //       ),
              //       const SizedBox(
              //         width: 10,
              //       ),
              //       const Text(
              //         'Location Accuracy',
              //         style: TextStyle(
              //           fontSize: 14,
              //           fontWeight: FontWeight.normal,
              //         ),
              //       ),
              //     ],
              //   ),
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => const LocationAccuracyPage()),
              //     );
              //   },
              // ),
              ListTile(
                title: Row(
                  children: [
                    Icon(
                      Icons.exit_to_app_rounded,
                      color: Theme.of(context)
                          .inputDecorationTheme
                          .labelStyle
                          ?.color,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _openDialogLogout(context);
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FeedTabScreen(),
            ChatTabScreen(),
            const EOfficeTabScreen(),
            History(),
          ],
          controller: _tabController,
        ),
        floatingActionButton: _selectedTab == 1
            ? FloatingActionButton(
                elevation: 0,
                child: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => (const ContactPage())),
                  );
                },
              )
            : Container(),
      ),
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ProfilePage()),
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
          MaterialPageRoute(
              builder: (context) => AboutPage(version, buildNumber)),
        );
        break;
    }
  }

  Future<void> _saveAttendance(AttendanceModel attendance, bool revision) async {
    var id = mains.objectbox.boxAttendance.put(attendance);
    var attendanceNew = mains.objectbox.boxAttendance.get(id)!;
    String url = '${_variableUtil.apiChatUrl}/save_attendance_dev.php';

    Map<String, dynamic> data = {
      'api_key': _variableUtil.apiKeyCore,
      'id_user': mains.objectbox.boxUser.get(1)?.userId,
      'latitude': attendance.latitude.toString(),
      'longitude': attendance.longitude.toString(),
      'status': attendance.status,
      'datetime':
          attendance.status == 1 ? attendance.checkInAt : attendance.checkOutAt,
      'id_location': attendance.idLocationDb,
      'revision': revision,
    };

    try {
      var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if(response.statusCode == 200){
        print("${response.body}");
        Map<String, dynamic> attendanceMap = jsonDecode(response.body);

        if(attendanceMap['code_status'] == 0){
          String type = '';
          var attendanceHistory = AttendanceHistoryModel(
            date: attendanceNew.date,
            latitude: attendanceNew.latitude,
            longitude: attendanceNew.longitude,
            datetime: attendanceNew.status == 1 ? attendanceNew.checkInAt : attendanceNew.checkOutAt,
            status: attendanceNew.status,
            server: attendanceNew.server,
            idLocationDb: attendanceNew.idLocationDb,
          );

          if (!revision) {
            if (attendanceMap['data'] != null) {
              if (attendanceMap['data']['check_in'] != null) {
                attendanceNew.date = DateFormat('dd MM yyyy').format(DateTime.parse(attendanceMap['data']['check_in']));
                attendanceNew.checkInAt = attendanceMap['data']['check_in'];
                attendanceHistory.datetime = attendanceMap['data']['check_in'];
                type = 'in';
              } else if (attendanceMap['data']['check_out'] != null) {
                attendanceNew.date = DateFormat('dd MM yyyy').format(DateTime.parse(attendanceMap['data']['check_out']));
                attendanceNew.checkOutAt = attendanceMap['data']['check_out'];
                attendanceHistory.datetime = attendanceMap['data']['check_out'];
                type = 'out';
              }
            }
          }

          attendanceNew.server = true;
          attendanceHistory.server = true;
          mains.objectbox.boxAttendance.put(attendanceNew);
          mains.objectbox.boxAttendanceHistory.put(attendanceHistory);

          if (!revision) {
            _attendanceFlushbarFunc.showAttendanceNotif(
              context, 
              false, 
              type, 
              'Attendance', 
              'Check $type at: ${DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(attendanceHistory.datetime!))}',
            );
          }
        } else {
          // mains.objectbox.boxAttendance.remove(attendanceNew.id);

          // showAttendanceNotif(true, null, 'Error', attendanceMap['message']);
          // print(attendanceMap['code_status']);
          // print(attendanceMap['error']);
        }
      } else {
        mains.objectbox.boxAttendance.remove(attendanceNew.id);

        // showAttendanceNotif(true, null, 'Error', 'Something wrong');
        // print("Gagal terhubung ke server!");
      }
    } catch (e) {
      mains.objectbox.boxAttendance.remove(attendanceNew.id);
      // var attendanceHistory = AttendanceHistoryModel(
      //   date: attendanceNew.date,
      //   latitude: attendanceNew.latitude,
      //   longitude: attendanceNew.longitude,
      //   datetime: attendanceNew.status == 1 ? attendanceNew.checkInAt : attendanceNew.checkOutAt,
      //   status: attendanceNew.status,
      //   server: attendanceNew.server,
      // );
      // mains.objectbox.boxAttendance.put(attendanceNew);
      // mains.objectbox.boxAttendanceHistory.put(attendanceHistory);

      // showAttendanceNotif(true, null, 'Error', 'Catch error');
    }
  }

  Future<http.Response> getDataUser() async {
    String url = '${_variableUtil.apiChatUrl}/get_user.php';

    Map<String, dynamic> data = {
      'api_key': _variableUtil.apiKeyCore,
      'email': mains.objectbox.boxUser.get(1)?.email,
    };

    //encode Map to JSON
    //var body = "?api_key="+variableUtil.apiKeyCore;

    var response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> userMap = jsonDecode(response.body);

      if (userMap['code_status'] == 0) {
        var user = UserModel(
            id: 1,
            email: email,
            userId: userMap['id'],
            userName: userMap['name'],
            phone: userMap['phone'],
            photo: userMap['photo'],
            fcmToken: userMap['fcm_token']);

        print('ini id user: ${user.userId}');

        mains.objectbox.boxUser.put(user);
      } else {
        print("ada yang salah!");
        print(userMap['code_status']);
        print(userMap['error']);
      }
    } else {
      print("Gagal terhubung ke server!");
    }
    return response;
  }

  Future<bool> checkFcmToken() async {
    String url = '${_variableUtil.apiChatUrl}/check_fcm.php';

    Map<String, dynamic> data = {
      'api_key': _variableUtil.apiKeyCore,
      'email': mains.objectbox.boxUser.get(1)!.email,
      'fcm_token': mains.objectbox.boxUser.get(1)!.fcmToken,
    };

    //encode Map to JSON
    //var body = "?api_key="+variableUtil.apiKeyCore;

    var response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    
    if(response.statusCode == 200){
      //print("${response.body}");
      Map<String, dynamic> userMap = jsonDecode(response.body);

      if (userMap['code_status'] == 0) {
        if (userMap['same'] == 1) {
          getDataUser();
          return true;
        } else {
          //  logout
          _openDialogAutoLogout(context);
          return false;
        }
      } else {
        print(userMap['code_status']);
        print(userMap['error']);
        return false;
      }
    } else {
      print("Gagal terhubung ke server!");
      return false;
    }
  }

  Future<void> getListContact() async {
    UserModel user = mains.objectbox.boxUser.get(1)!;
    Map<String, dynamic> listContactMap = await _indexService.getListContact(user.email!);

    if (!listContactMap['error']) {
      Map<String, dynamic> bodyMap = listContactMap['body'];
      List<dynamic> contacts = bodyMap['data'];

      for (var i = 0; i < contacts.length; i++) {
        Map<String, dynamic> contact = Map<String, dynamic>.from(contacts[i]);
        List<ContactModel> query = mains.objectbox.boxContact
          .query(ContactModel_.email.equals(contact['email']))
          .build()
          .find();
        ContactModel contactTemp = ContactModel();
        
        if (query.isNotEmpty) {
          contactTemp = query.first;
          contactTemp.userName = contact['name'];
          contactTemp.photo = (contact['photo'] == '' || contact['photo'] == null) ? '' : contact['photo'];
          contactTemp.phone = contact['phone'];
        } else {
          contactTemp = ContactModel(
            userId: contact['id'],
            userName: contact['name'],
            email: contact['email'],
            photo: (contact['photo'] == '' || contact['photo'] == null) ? '' : contact['photo'],
            phone: contact['phone'],
          );
        }

        nameList.insert(i, contact['name']);
        mains.objectbox.boxContact.put(contactTemp);
      }
    }
  }

  Future<http.Response> getAllMessages() async {
    String url = '${_variableUtil.apiChatUrl}/get_all_messages.php';

    Map<String, dynamic> data = {
      'api_key': _variableUtil.apiKeyCore,
      'email': mains.objectbox.boxUser.get(1)!.email,
      'type': 'get_all_message',
      'id_user': mains.objectbox.boxUser.get(1)!.userId,

    };

    var response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {

      Map<String, dynamic> messagesMap = jsonDecode(response.body);

      if (messagesMap['code_status'] == 0) {
        List chatList = mains.objectbox.boxChat.getAll();

        int messagesLength = messagesMap['array_messages'].length;
        for(int i = 0; i < messagesLength; i++) {
          var dataMessage = Map<String, dynamic>.from(jsonDecode(messagesMap['array_messages'][i]));
          // personal messages
          if(dataMessage['type'] == 'pm'){
            // our messages
            if(dataMessage['id_sender'] == mains.objectbox.boxUser.get(1)!.userId){
              var query = mains.objectbox.boxConversation.query(ConversationModel_.idReceiver.equals(dataMessage['id_receiver'])).build();


              ConversationModel objConversation;

              if(query.find().isNotEmpty) {
                objConversation = ConversationModel(
                    id: query.find().first.id,
                    idReceiver: dataMessage['id_receiver'],
                    fullName: dataMessage['name_receiver'],
                    image: '',
                    message: dataMessage['msg_data'],
                    photoProfile: query.find().first.photoProfile,
                    date: dataMessage['msg_date'],
                    roomId: dataMessage['room_id'] ,
                    messageCout: 0
                );
                idConversation = mains.objectbox.boxConversation.put(objConversation);
              }
              else{
                objConversation = ConversationModel(
                  id: 0,
                  idReceiver: dataMessage['id_receiver'],
                  fullName: dataMessage['name_receiver'],
                  image: '',
                  photoProfile: '',
                  date: dataMessage['msg_date'],
                  roomId: dataMessage['room_id'],
                  message: dataMessage['msg_data'],
                  messageCout: 0,
                );
                idConversation = mains.objectbox.boxConversation.put(objConversation);
              }

              // if message is image
              if (dataMessage['msg_tipe'] == "image") {
                var contentImage =
                _createImageFromUint(base64.decode(dataMessage['img_data']));

                final chat = ChatModel(
                  id: chatList.isEmpty ? 0 : dataMessage['id_chat_model'],
                  idSender: dataMessage['id_sender'],
                  idReceiver: dataMessage['id_receiver'],
                  text: 'image',
                  date: dataMessage['msg_date'],
                  tipe: 'image',
                  content: await contentImage,
                  sendStatus: dataMessage['read'] == 1 ? 'R' : dataMessage['delivered'] == 1 ? 'D' : ' ',
                  delivered: dataMessage['delivered'],
                  read: dataMessage['read'],
                );

                mains.objectbox.boxChat.put(chat);
              }
              // if message is file
              else if (dataMessage['msg_tipe'] == "file") {
                var contentFile =
                _createFileFromUint(base64.decode(dataMessage['file_data']));

                final chat = ChatModel(
                  id: chatList.isEmpty ? 0 : dataMessage['id_chat_model'],
                  idSender: dataMessage['id_sender'],
                  idReceiver: dataMessage['id_receiver'],
                  text: dataMessage['msg_data'],
                  date: dataMessage['msg_date'],
                  tipe: 'file',
                  content: await contentFile,
                  sendStatus: dataMessage['read'] == 1 ? 'R' : dataMessage['delivered'] == 1 ? 'D' : ' ',
                  delivered: dataMessage['delivered'],
                  read: dataMessage['read'],
                );

                mains.objectbox.boxChat.put(chat);
              }
              // if message is text
              else {
                //update Chat Model
                final chat = ChatModel(
                  id: chatList.isEmpty ? 0 : dataMessage['id_chat_model'],
                  idSender: dataMessage['id_sender'],
                  idReceiver: dataMessage['id_receiver'],
                  text: dataMessage['msg_data'],
                  date: dataMessage['msg_date'],
                  tipe: 'text',
                  content: null,
                  sendStatus: dataMessage['read'] == 1 ? 'R' : dataMessage['delivered'] == 1 ? 'D' : ' ',
                  delivered: dataMessage['delivered'],
                  read: dataMessage['read'],
                );
                mains.objectbox.boxChat.put(chat);
              }
            }
            // someone else's message
            else{
              var query = mains.objectbox.boxConversation
                  .query(ConversationModel_.idReceiver.equals(dataMessage['id_sender']))
                  .build();
              if (query.find().isNotEmpty) {

                ConversationModel objConversation = ConversationModel(
                    id: query.find().first.id,
                    idReceiver: dataMessage['id_sender'],
                    fullName: dataMessage['name_sender'],
                    image: query.find().first.image,
                    photoProfile: dataMessage['photo'],
                    message: dataMessage['msg_data'],
                    date: dataMessage['msg_date'],
                    messageCout: 0,
                    statusReceiver: query.find().first.statusReceiver,
                    roomId: dataMessage['room_id']);
                mains.objectbox.boxConversation.put(objConversation);
              } else {
                ConversationModel objConversation = ConversationModel(
                    id: 0,
                    idReceiver: dataMessage['id_sender'],
                    fullName: dataMessage['name_sender'],
                    image: '',
                    photoProfile: dataMessage['photo'],
                    message: dataMessage['msg_data'],
                    date: dataMessage['msg_date'],
                    messageCout: 0,
                    statusReceiver: '',
                    roomId: dataMessage['room_id']);
                mains.objectbox.boxConversation.put(objConversation);
              }

              // if message is image
              if (dataMessage['msg_tipe'] == "image") {
                var contentImage =
                _createImageFromUint(base64.decode(dataMessage['img_data']));

                final chat = ChatModel(
                  idChatFriends: dataMessage['id_chat_model'],
                  idSender: dataMessage['id_sender'],
                  idReceiver: dataMessage['id_receiver'],
                  text: "image",
                  date: dataMessage['msg_date'],
                  tipe: 'image',
                  content: await contentImage,
                  sendStatus: '',
                  delivered: 0,
                  read: 0,
                );

                mains.objectbox.boxChat.put(chat);
              }
              // if message is file
              else if (dataMessage['msg_tipe'] == "file") {
                var contentFile =
                _createFileFromUint(base64.decode(dataMessage['file_data']));

                final chat = ChatModel(
                  idChatFriends: dataMessage['id_chat_model'],
                  idSender: dataMessage['id_sender'],
                  idReceiver: dataMessage['id_receiver'],
                  text: dataMessage['msg_data'],
                  date: dataMessage['msg_date'],
                  tipe: 'file',
                  content: await contentFile,
                  sendStatus: '',
                  delivered: 0,
                  read: 0,
                );

                mains.objectbox.boxChat.put(chat);
              }
              // if message is text
              else {
                //update Chat Model
                final chat = ChatModel(
                  idChatFriends: dataMessage['id_chat_model'],
                  idSender: dataMessage['id_sender'],
                  idReceiver: dataMessage['id_receiver'],
                  text: dataMessage['msg_data'],
                  date: dataMessage['msg_date'],
                  tipe: 'text',
                  sendStatus: '',
                  content: null,
                  delivered: 0,
                  read: 0,
                );
                mains.objectbox.boxChat.put(chat);
              }
            }
          }
          // group messages
          else{

            List<int> idReceivers =
            json.decode(dataMessage['id_receivers']).cast<int>();
            idReceivers.removeWhere(
                    (element) => element == mains.objectbox.boxUser.get(1)!.userId);
            idReceivers.add(dataMessage['id_sender']);

            var query = mains.objectbox.boxConversation
                .query(ConversationModel_.roomId.equals(dataMessage['room_id']))
                .build();
            if (query.find().isNotEmpty) {
              ConversationModel objConversation = ConversationModel(
                id: query.find().first.id,
                idReceiversGroup: json.encode(idReceivers),
                fullName: dataMessage['group_name'],
                image: query.find().first.image,
                photoProfile: '',
                message: "${dataMessage['name_sender']}: ${dataMessage['msg_data']}",
                date: dataMessage['msg_date'],
                messageCout: 0,
                statusReceiver: query.find().first.statusReceiver,
                roomId: dataMessage['room_id'],
              );
              mains.objectbox.boxConversation.put(objConversation);
            } else {
              ConversationModel objConversation = ConversationModel(
                id: 0,
                idReceiversGroup: json.encode(idReceivers),
                fullName: dataMessage['group_name'],
                image: '',
                photoProfile: '',
                message: "${dataMessage['name_sender']}: ${dataMessage['msg_data']}",
                date: dataMessage['msg_date'],
                messageCout: 0,
                statusReceiver: '',
                roomId: dataMessage['room_id'],
              );
              mains.objectbox.boxConversation.put(objConversation);
            }

            //our messages
            if(dataMessage['id_sender'] == mains.objectbox.boxUser.get(1)!.userId){
              // if message is image
              if (dataMessage['msg_tipe'] == "image") {
                var contentImage =
                _createFileFromUint(base64.decode(dataMessage['img_data']));

                final chat = ChatModel(
                  id: chatList.isEmpty ? 0 : dataMessage['id_chat_model'],
                  idSender: dataMessage['id_sender'],
                  nameSender: dataMessage['name_sender'],
                  idRoom: dataMessage['room_id'],
                  idReceiversGroup: dataMessage['id_receivers'],
                  text: "Photo",
                  date: dataMessage['msg_date'],
                  tipe: 'image',
                  content: await contentImage,
                  sendStatus: ' ',
                  delivered: dataMessage['delivered'],
                  read: 0,
                );

                mains.objectbox.boxChat.put(chat);
              }
              // if message is file
              else if (dataMessage['msg_tipe'] == "file") {
                var contentFile =
                _createFileFromUint(base64.decode(dataMessage['file_data']));

                final chat = ChatModel(
                  id: chatList.isEmpty ? 0 : dataMessage['id_chat_model'],
                  idSender: dataMessage['id_sender'],
                  nameSender: dataMessage['name_sender'],
                  idRoom: dataMessage['room_id'],
                  idReceiversGroup: dataMessage['id_receivers'],
                  text: dataMessage['msg_data'],
                  date: dataMessage['msg_date'],
                  tipe: 'file',
                  content: await contentFile,
                  sendStatus: ' ',
                  delivered: dataMessage['delivered'],
                  read: 0,
                );

                mains.objectbox.boxChat.put(chat);
              }
              // if message is text
              else if (dataMessage['msg_tipe'] == "text") {
                //update Chat Model
                final chat = ChatModel(
                  id: chatList.isEmpty ? 0 : dataMessage['id_chat_model'],
                  idSender: dataMessage['id_sender'],
                  nameSender: dataMessage['name_sender'],
                  idRoom: dataMessage['room_id'],
                  idReceiversGroup: dataMessage['id_receivers'],
                  text: dataMessage['msg_data'],
                  date: dataMessage['msg_date'],
                  sendStatus: ' ',
                  delivered: dataMessage['delivered'],
                  read: 0,
                  tipe: 'text',
                  content: null,
                );

                mains.objectbox.boxChat.put(chat);
              }
              // if message is system
              else {
                final chat = ChatModel(
                  id: chatList.isEmpty ? 0 : dataMessage['id_chat_model'],
                  idSender: dataMessage['id_sender'],
                  nameSender: dataMessage['name_sender'],
                  idRoom: dataMessage['room_id'],
                  idReceiversGroup: dataMessage['id_receivers'],
                  text: dataMessage['msg_data'],
                  date: dataMessage['msg_date'],
                  sendStatus: ' ',
                  delivered: dataMessage['delivered'],
                  read: 0,
                  tipe: 'system',
                  content: null,
                );

                mains.objectbox.boxChat.put(chat);
              }
            }
            // someone else's message
            else{
              // if message is image
              if (dataMessage['msg_tipe'] == "image") {
                var contentImage =
                _createFileFromUint(base64.decode(dataMessage['img_data']));

                final chat = ChatModel(
                  idChatFriends: dataMessage['id_chat_model'],
                  idSender: dataMessage['id_sender'],
                  nameSender: dataMessage['name_sender'],
                  idRoom: dataMessage['room_id'],
                  idReceiversGroup: dataMessage['id_receivers'],
                  text: "Photo",
                  date: dataMessage['msg_date'],
                  tipe: 'image',
                  content: await contentImage,
                  sendStatus: ' ',
                  delivered: dataMessage['delivered'],
                  read: 0,
                );

                mains.objectbox.boxChat.put(chat);
              }
              // if message is file
              else if (dataMessage['msg_tipe'] == "file") {
                var contentFile =
                _createFileFromUint(base64.decode(dataMessage['file_data']));

                final chat = ChatModel(
                  idChatFriends: dataMessage['id_chat_model'],
                  idSender: dataMessage['id_sender'],
                  nameSender: dataMessage['name_sender'],
                  idRoom: dataMessage['room_id'],
                  idReceiversGroup: dataMessage['id_receivers'],
                  text: dataMessage['msg_data'],
                  date: dataMessage['msg_date'],
                  tipe: 'file',
                  content: await contentFile,
                  sendStatus: ' ',
                  delivered: dataMessage['delivered'],
                  read: 0,
                );

                mains.objectbox.boxChat.put(chat);
              }
              // if message is text
              else if (dataMessage['msg_tipe'] == "text") {
                //update Chat Model
                final chat = ChatModel(
                  idChatFriends: dataMessage['id_chat_model'],
                  idSender: dataMessage['id_sender'],
                  nameSender: dataMessage['name_sender'],
                  idRoom: dataMessage['room_id'],
                  idReceiversGroup: dataMessage['id_receivers'],
                  text: dataMessage['msg_data'],
                  date: dataMessage['msg_date'],
                  sendStatus: ' ',
                  delivered: dataMessage['delivered'],
                  read: 0,
                  tipe: 'text',
                  content: null,
                );

                mains.objectbox.boxChat.put(chat);
              }
              // if message is system
              else {
                final chat = ChatModel(
                  idChatFriends: dataMessage['id_chat_model'],
                  idSender: dataMessage['id_sender'],
                  nameSender: dataMessage['name_sender'],
                  idRoom: dataMessage['room_id'],
                  idReceiversGroup: dataMessage['id_receivers'],
                  text: dataMessage['msg_data'],
                  date: dataMessage['msg_date'],
                  sendStatus: ' ',
                  delivered: dataMessage['delivered'],
                  read: 0,
                  tipe: 'system',
                  content: null,
                );

                mains.objectbox.boxChat.put(chat);
              }
            }

          }


          if(i == messagesLength/4){
            setState(() {});
          }else if(i == messagesLength/2){
            setState(() {});
          }else if(i == messagesLength*0.75){
            setState(() {});
          }else if(i == messagesLength){
            setState(() {});
          }
        }
        EasyLoading.showSuccess('Done!');
      }
      else {
        EasyLoading.showError(messagesMap['error']);
      }
    } else {
      EasyLoading.showError('Gagal terhubung ke server!');
    }
    return response;
  }

  Future<http.Response> _getAllAttendances() async {
    String url = '${_variableUtil.apiChatUrl}/get_all_attendances.php';

    Map<String, dynamic> data = {
      'api_key': _variableUtil.apiKeyCore,
      'email': mains.objectbox.boxUser.get(1)!.email,
      'id_user': mains.objectbox.boxUser.get(1)!.userId,
    };

    var response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> bodyMap = jsonDecode(response.body);
      Map<String, dynamic> data = bodyMap['data'];
      List<dynamic> attendances = data['attendances'];
      List<dynamic> attendanceHistories = data['attendance_histories'];

      for (var i = 0; i < attendances.length; i++) {
        Map<String, dynamic> attendance = Map<String, dynamic>.from(jsonDecode(attendances[i]));
        var query = mains.objectbox.boxAttendance.query(AttendanceModel_.date.equals(attendance['date']))
          .build()
          .find();
        AttendanceModel attendanceTemp = AttendanceModel();

        if (query.isNotEmpty) {
          attendanceTemp = query.first;
          attendanceTemp.date = attendance['date'];
          attendanceTemp.checkInAt = attendance['check_in_at'];
          attendanceTemp.checkOutAt = attendance['check_out_at'];
          attendanceTemp.latitude = attendance['latitude_in'];
          attendanceTemp.longitude = attendance['longitude_in'];
          attendanceTemp.status = attendance['status'];
          attendanceTemp.server = true;
          attendanceTemp.idLocationDb = attendance['id_location'];
        } else {
          attendanceTemp = AttendanceModel(
            date: attendance['date'],
            checkInAt: attendance['check_in_at'],
            checkOutAt: attendance['check_out_at'],
            latitude: attendance['latitude_in'],
            longitude: attendance['longitude_in'],
            status: attendance['status'],
            server: true,
            idLocationDb: attendance['id_location'],
          );
        }

        mains.objectbox.boxAttendance.put(attendanceTemp);
      }

      for (var i = 0; i < attendanceHistories.length; i++) {
        Map<String, dynamic> attendanceHistory = Map<String, dynamic>.from(jsonDecode(attendanceHistories[i]));
        var query = mains.objectbox.boxAttendanceHistory.query(AttendanceHistoryModel_.datetime.equals(attendanceHistory['datetime']))
          .build()
          .find();
        AttendanceHistoryModel attendanceHistoryTemp = AttendanceHistoryModel();

        if (query.isNotEmpty) {
          attendanceHistoryTemp = query.first;
          attendanceHistoryTemp.date = attendanceHistory['date'];
          attendanceHistoryTemp.datetime = attendanceHistory['datetime'];
          attendanceHistoryTemp.latitude = attendanceHistory['latitude'];
          attendanceHistoryTemp.longitude = attendanceHistory['longitude'];
          attendanceHistoryTemp.status = attendanceHistory['status'];
          attendanceHistoryTemp.server = true;
          attendanceHistoryTemp.idLocationDb = attendanceHistory['id_location'];
        } else {
          attendanceHistoryTemp = AttendanceHistoryModel(
            date: attendanceHistory['date'],
            datetime: attendanceHistory['datetime'],
            latitude: attendanceHistory['latitude'],
            longitude: attendanceHistory['longitude'],
            status: attendanceHistory['status'],
            server: true,
            idLocationDb: attendanceHistory['id_location'],
          );
        }

        mains.objectbox.boxAttendanceHistory.put(attendanceHistoryTemp);
      }

      EasyLoading.showSuccess('Done!');
    } else {
      EasyLoading.showError('Gagal terhubung ke server!');
    }

    return response;
  }

  Future<void> _getAllAttendanceLocations() async {
    String url = '${_variableUtil.apiChatUrl}/get_all_attendance_locations.php';

    Map<String, dynamic> data = {
      'api_key': _variableUtil.apiKeyCore,
    };

    var response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      mains.objectbox.boxAttendanceLocation.removeAll();

      Map<String, dynamic> bodyMap = jsonDecode(response.body);
      List<dynamic> attLocs = bodyMap['data'];

      for (var i = 0; i < attLocs.length; i++) {
        Map<String, dynamic> attLoc = Map<String, dynamic>.from(attLocs[i]);
        List<AttendanceLocationModel> query = mains.objectbox.boxAttendanceLocation
          .query(AttendanceLocationModel_.idDb.equals(attLoc['id']))
          .build()
          .find();
        AttendanceLocationModel attLocTemp = AttendanceLocationModel();

        if (query.isNotEmpty) {
          attLocTemp = query.first;
          attLocTemp.idDb = attLoc['id'];
          attLocTemp.name = attLoc['name'];
          attLocTemp.latitude = attLoc['latitude'];
          attLocTemp.longitude = attLoc['longitude'];
          attLocTemp.range = attLoc['range'];
        } else {
          attLocTemp = AttendanceLocationModel(
            idDb: attLoc['id'],
            name: attLoc['name'],
            latitude: attLoc['latitude'],
            longitude: attLoc['longitude'],
            range: attLoc['range'],
          );
        }

        mains.objectbox.boxAttendanceLocation.put(attLocTemp);
      }
    }
  }
}

void _openDialogLogout(ctx) {
  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  Future<void> _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  showCupertinoDialog(
      context: ctx,
      builder: (_) => CupertinoAlertDialog(
            title: const Text("Logout"),
            content: const Text("Are you sure you want to logout?"),
            actions: [
              // Close the dialog
              // You can use the CupertinoDialogAction widget instead
              CupertinoButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Color(0xFF2481CF)),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  }),
              CupertinoButton(
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () async {
                  _deleteAppDir();
                  _deleteCacheDir();

                  // await listController.close();
                  // await listControllerConversation.close();
                  // await listControllerContact.close();
                  // await listControlerAttendance.close();
                  mains.objectbox.boxConversation.removeAll();
                  mains.objectbox.boxChat.removeAll();
                  mains.objectbox.boxContact.removeAll();
                  mains.objectbox.boxAttendance.removeAll();
                  mains.objectbox.boxAttendanceHistory.removeAll();
                  mains.objectbox.boxSurat.removeAll();
                  mains.objectbox.boxBadge.removeAll();
                  mains.objectbox.boxNews.removeAll();
                  mains.objectbox.boxUserPreference.removeAll();
                  mains.objectbox.boxGroupNotif.removeAll();
                  mains.objectbox.boxUser.removeAll();
                  mains.objectbox.boxSaved.removeAll();
                  mains.objectbox.boxAttendanceLocation.removeAll();

                  // Navigator.pop(ctx);
                  // Navigator.pushReplacement(
                  //   ctx, 
                  //   MaterialPageRoute(builder: (context) => Login()),
                  // );

                  // Navigator.pushAndRemoveUntil(
                  //   ctx,
                  //   MaterialPageRoute(builder: (context) => Login()),
                  //   (Route<dynamic> route) => false,
                  // );

                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  exit(0);
                },
              )
            ],
          ));
}

void _openDialogAutoLogout(ctx) {
  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  Future<void> _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  showCupertinoDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
            onWillPop: () async => false,
            child: CupertinoAlertDialog(
              title: const Text("Logged Out"),
              content: const Text(
                  "Logged out because you logged in from another device. You can only be logged in on one device at a time."),
              actions: [
                // Close the dialog
                // You can use the CupertinoDialogAction widget instead
                CupertinoButton(
                  child: const Text(
                    'Ok',
                    style: TextStyle(color: Color(0xFF2481CF)),
                  ),
                  onPressed: () async {
                    _deleteAppDir();
                    _deleteCacheDir();

                    mains.objectbox.boxConversation.removeAll();
                    mains.objectbox.boxChat.removeAll();
                    mains.objectbox.boxContact.removeAll();
                    mains.objectbox.boxAttendance.removeAll();
                    mains.objectbox.boxAttendanceHistory.removeAll();
                    mains.objectbox.boxSurat.removeAll();
                    mains.objectbox.boxBadge.removeAll();
                    mains.objectbox.boxNews.removeAll();
                    mains.objectbox.boxUserPreference.removeAll();
                    mains.objectbox.boxGroupNotif.removeAll();
                    mains.objectbox.boxUser.removeAll();
                    mains.objectbox.boxSaved.removeAll();
                    mains.objectbox.boxAttendanceLocation.removeAll();

                    // Navigator.pushAndRemoveUntil(
                    //   ctx,
                    //   MaterialPageRoute(builder: (context) => Login()),
                    //       (Route<dynamic> route) => false,
                    // );

                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                    exit(0);
                  },
                )
              ],
            ),
          ));
}
