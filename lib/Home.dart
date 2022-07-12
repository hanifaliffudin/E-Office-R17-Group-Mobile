import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
// import 'package:location/location.dart';
import 'package:militarymessenger/Attendance.dart';
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
import 'package:militarymessenger/functions/permission_dialog_function.dart';
import 'package:militarymessenger/main.dart';
import 'package:militarymessenger/models/AttendanceHistoryModel.dart';
import 'package:militarymessenger/models/AttendanceModel.dart';
import 'package:militarymessenger/models/BadgeModel.dart';
import 'package:militarymessenger/models/GroupNotifModel.dart';
import 'package:militarymessenger/models/NewsModel.dart';
import 'package:militarymessenger/models/SuratModel.dart';
import 'package:militarymessenger/profile.dart';
import 'package:militarymessenger/settings/chat.dart';
import 'package:militarymessenger/settings/notification.dart';
import 'package:militarymessenger/location_accuracy_page.dart';
import 'package:militarymessenger/utils/sp_util.dart';
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

String apiKeyCore =
    '1Hw3G9UYOhounou0679y3*OhouH978%hOtfr57fRtug#9UI8nl7iU4Yt5vR6Fb87tLRB5u3g4Hi92983huiU3g5bkH5BVGv3daf2F5e2Ae4k6F5vblUwIJD9W7ryiuBL24Lbv3P';

var channel;
int? idSender;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _tabController;
  int _selectedTab = 1;
  String apiKey = apiKeyCore;
  final String? email = mains.objectbox.boxUser.get(1)?.email;
  String? name;
  String? phone;
  String? photo;
  Uint8List? bytes;
  var contactList, contactData, contactName;
  late StreamSubscription<LocationData> locationSubscription;
  Location location = Location();
  final StateController _stateController = Get.put(StateController());
  bool grouping = true;

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
      if (message.data['type'] == 'logout') {
        _openDialogAutoLogout(context);
      }
      RemoteNotification notification = message.notification!;
      bool run = true;
      
      if (message.data.containsKey('room_id')) {
        if (_stateController.fromRoomId.value == int.parse(message.data['room_id'])) {
          run = false;
        }
      }

      if (run) {
        List<ActiveNotification>? activeNotifications = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.getActiveNotifications();

        AndroidNotificationDetails notificationDetails = AndroidNotificationDetails(
          message.data['id'],
          message.notification!.title!,
          // style: AndroidNotificationStyle.BigText,
          icon: "@mipmap/ic_launcher",
          // groupKey: message.data.containsKey('room_id') ? message.data['room_id'].toString() : '',
          groupKey: 'r17eoffice',
          importance: Importance.defaultImportance, 
          priority: Priority.defaultPriority,
          styleInformation: BigTextStyleInformation(
            message.data['msg_data'], //  'Locations: <b>${locations.replaceAll("\$", " to ")}</b><br>Vehicle: <b>$vehicle</b><br>Trip Type: <b>$tripType</b><br>Pick-Up Date: <b>$pickUpDate</b><br>Pick-Up Time: <b>$pickUpTime</b>',
            htmlFormatBigText: true,
            contentTitle: message.notification!.title!,
            htmlFormatContentTitle: true,
            summaryText: 'Messenger',
            htmlFormatSummaryText: true,
          ),
        );
        AndroidNotificationDetails groupNotificationDetails = AndroidNotificationDetails(
          message.data['id'],
          message.notification!.title!,
          icon: "@mipmap/ic_launcher",
          // groupKey: message.data.containsKey('room_id') ? message.data['room_id'].toString() : '',
          groupKey: 'r17eoffice',
          setAsGroupSummary: true,
          styleInformation: BigTextStyleInformation(
            message.data['msg_data'],
            htmlFormatBigText: true,
            contentTitle: message.notification!.title!,
            htmlFormatContentTitle: true,
            summaryText: 'Messenger',
            htmlFormatSummaryText: true,
          ),
        );

        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(android: notificationDetails),
          payload: jsonEncode(message.data),
        );
        flutterLocalNotificationsPlugin.show(
          0, 
          '', 
          '', 
          NotificationDetails(android: groupNotificationDetails),
        );

        if (message.data.containsKey('room_id')) {
          var groupNotif = GroupNotifModel(
            roomId: int.parse(message.data['room_id']),
            notifId: notification.hashCode,
          );

          mains.objectbox.boxGroupNotif.put(groupNotif);
        }

        // setState(() {
        //   grouping = false;
        // });
      }
    });

    var android = const AndroidInitializationSettings('mipmap/ic_launcher');
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
            MaterialPageRoute(builder: (context) => const Attendance()),
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
        MaterialPageRoute(builder: (context) => const Attendance()),
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

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void _locationAttendance(LocationData locationData) async {
    try {
      Map<String, dynamic> data = {
        'api_key': apiKey,
      };
      String url = 'https://chat.dev.r17.co.id/get_datetime.php';
      var response = await http.post(Uri.parse(url),
        body: jsonEncode(data),
      );
      Map<String, dynamic> datetimeMap = jsonDecode(response.body);
      DateTime now = DateTime.parse(datetimeMap['data']);
      // DateTime now = DateTime.now();

      if (locationData != null) {
        double? distanceOnMeter = calculateDistance(locationData.latitude, locationData.longitude, -6.230103, 106.810062) * 1000;
        DateTime dateYesterday = DateTime(now.year, now.month, now.day - 1);

        // print('$locationData $distanceOnMeter ${DateFormat('yyyy-MM-dd HH:mm:ss').format(now)}');
        if (distanceOnMeter <= 70 && now.hour >= 7) {
          var query = mains.objectbox.boxAttendance
              .query(AttendanceModel_.date
                  .equals(DateFormat('dd MM yyyy').format(now)))
              .build();

          if (query.find().isNotEmpty) {
            var attendance = query.find().first;

            if (attendance.status == 0) {
              // print('time call check in');
              attendance.date = DateFormat('dd MM yyyy').format(now);
              // attendance.checkInAt =
              //     DateFormat('yyyy-MM-dd HH:mm:ss').format(now).toString();
              attendance.checkInAt = attendance.checkInAt;
              attendance.checkOutAt = attendance.checkOutAt;
              attendance.latitude = locationData.latitude;
              attendance.longitude = locationData.longitude;
              attendance.status = 1;
              attendance.server = false;

              saveAttendance(attendance, true);
            }
          } else {
            // print('first time call check in');
            var attendance = AttendanceModel(
              date: DateFormat('dd MM yyyy').format(now),
              checkInAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
              latitude: locationData.latitude,
              longitude: locationData.longitude,
              status: 1,
              server: false,
            );

            saveAttendance(attendance, true);
          }
        } else if (distanceOnMeter > 100) {
          if (now.hour >= 7) {
            var query = mains.objectbox.boxAttendance
                .query(AttendanceModel_.date
                        .equals(DateFormat('dd MM yyyy').format(now)) &
                    AttendanceModel_.status.equals(1))
                .build();

            if (query.find().isNotEmpty) {
              var attendance = query.find().first;
              attendance.id = attendance.id;
              attendance.date = attendance.date;
              attendance.checkInAt = attendance.checkInAt;
              attendance.checkOutAt =
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
              attendance.latitude = attendance.latitude;
              attendance.longitude = attendance.longitude;
              attendance.status = 0;
              attendance.server = false;

              saveAttendance(attendance, true);
            }
          } else {
            var query = mains.objectbox.boxAttendance
              .query(AttendanceModel_.date.equals(DateFormat('dd MM yyyy')
                      .format(dateYesterday)) &
                  AttendanceModel_.status.equals(1))
              .build();

            if (query.find().isNotEmpty) {
              var attendance = query.find().first;
              String yesterdayMax = dateYesterday.toString() + ' 23:59:59';

              if (attendance.checkOutAt != yesterdayMax) {
                attendance.id = attendance.id;
                attendance.date = attendance.date;
                attendance.checkInAt = attendance.checkInAt;
                attendance.checkOutAt =
                    DateTime.parse('${dateYesterday.toString()} 23:59:59')
                        .toString();
                attendance.latitude = attendance.latitude;
                attendance.longitude = attendance.longitude;
                attendance.status = 0;
                attendance.server = false;

                saveAttendance(attendance, false);
              }
            }
          }
        }
      }
    } catch (e) {
      
    }
  }

  void _locationService() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    if (_serviceEnabled) {
      _permissionGranted = await location.hasPermission();

      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();

        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      if (_permissionGranted == PermissionStatus.granted) {
        location.enableBackgroundMode(enable: true);
        location.changeSettings(accuracy: LocationAccuracy.high);
        locationSubscription = location.onLocationChanged.listen((locationData) async {
          _stateController.changeLocationAccuracy(locationData.accuracy!);

          if (locationData.accuracy! < 20) {
            try {
              final result = await InternetAddress.lookup('google.com');

              if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                _locationAttendance(locationData);
              }
            } catch (e) {
              // print(e.toString());
            }
          }
        });
      }
    }
  }

  Future<bool> _getAllData() async {
    bool messageGo = false;
    bool attendanceGo = false;

    if (await SpUtil.instance.containsKey('messagesDownloaded')) {
      if (!await SpUtil.instance.getBoolValue('messagesDownloaded')) {
        messageGo = true;
      }
    } else {
      messageGo = true;
    }

    if (await SpUtil.instance.containsKey('attendancesDownloaded')) {
      if (!await SpUtil.instance.getBoolValue('attendancesDownloaded')) {
        attendanceGo = true;
      }
    } else {
      attendanceGo = true;
    }

    if (messageGo) {
      EasyLoading.show(status: 'Downloading all messages...');
      await getAllMessages();
      await SpUtil.instance.setBoolValue('messagesDownloaded', true);
    }

    if (attendanceGo) {
      EasyLoading.show(status: 'Downloading all attendances...');
      await _getAllAttendances();
      await SpUtil.instance.setBoolValue('attendancesDownloaded', true);
    }

    return true;
  }
  
  void _locationPermissionListener() {
    _stateController.locationPermission
      .listen((p0) {
        if (p0 == true) {
          _locationService();
        } else {
          locationSubscription.cancel();
        }
      });
  }

  String? version;
  String? buildNumber;

  @override
  void initState() {
    
    flutterLocalNotificationsPlugin.cancelAll();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (await checkFcmToken() == true) {
        await _getAllData();
        _accessLocationPermission();
        _locationPermissionListener();
      }
    });

    _tabController = TabController(initialIndex: _selectedTab,length: 4,vsync: this);
    _tabController?.addListener(() => tabListener());

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });

    super.initState();

    getListContact();
    // getDataUser();

    listController
        .addStream(mains.objectbox.queryStreamChat.map((q) => q.find()));
    listControllerConversation.addStream(
        mains.objectbox.queryStreamConversation.map((q) => q.find()));
    listControllerContact
        .addStream(mains.objectbox.queryStreamContact.map((q) => q.find()));
    listControlerAttendance.addStream(mains.objectbox.queryStreamAttendance.map((event) => event.find()));

    if (mains.objectbox.boxUser.isEmpty()) {
    } else {
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
      Uri.parse(
          'wss://chat.dev.r17.co.id:443/wss/?open_key=2K0LJBnj7BK17sdlH65jh58B33Ky1V2bY5Tcr09Ex8e76wZ54eRc4dF1H2G7vG570J9H8465GJ&email=${mains.objectbox.boxUser.get(1)?.email.toString()}'),
      pingInterval: const Duration(
        seconds: 1,
      ),
    );
    channel.stream.listen(onReceiveData,
        onDone: onClosed, onError: onError, cancelOnError: false);
  }

  Future<void> onReceiveData(message) async {
    var objMessage = json.decode(message);
    // print(objMessage);

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
            statusReceiver: objMessage['send_status'],
            roomId: query.find().first.roomId);
        mains.objectbox.boxConversation.put(objConversation);

        // Delete typing status after 2 seconds
        // setState((){});
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
          // setState((){});
        });
      }
    } else if (objMessage['type'] == "group") {
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
    _tabController!.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void tabListener() {
    setState(() {
      _selectedTab = _tabController!.index;
    });
  }

  void _accessLocationPermission() async {
    bool showDialogAP = false;

    if (await SpUtil.instance.containsKey('locationPermission')) {
      if (await SpUtil.instance.getBoolValue('locationPermission')) {
        _stateController.changeLocationPermission(await SpUtil.instance.getBoolValue('locationPermission'));
      }
    } else {
      showDialogAP = true;
    }

    if (showDialogAP) {
      locationPermissionDialog(
        context, 
        () async {
          Navigator.of(context).pop();
          await SpUtil.instance.setBoolValue('locationPermission', false);
        }, 
        () async {
          Navigator.of(context).pop();
          await SpUtil.instance.setBoolValue('locationPermission', true);
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

  void showAttendanceNotif(bool error, String? type, String title, String message) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      titleText: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
        ),
      ),
      messageText: Padding(
        padding: const EdgeInsets.only(
          left: 0.0,
        ),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 13.0,
          ),
        ),
      ),
      icon: Padding(
        padding: const EdgeInsets.only(
          left: 4,
        ),
        child: Icon(
          error == false ? type == 'in' ? Icons.login_rounded : Icons.logout_rounded : Icons.error_rounded,
          size: 28.0,
          color: error == false ? type == 'in' ? Colors.blue : Colors.grey : Colors.red,
        ),
      ),
      // duration: const Duration(
      //   seconds: 3,
      // ),
      leftBarIndicatorColor: error == false ? type == 'in' ? Colors.blue : Colors.grey : Colors.red,
      padding: const EdgeInsets.only(
        top: 11.0,
        bottom: 14.0,
      ),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(5),
      backgroundColor: Theme.of(context).cardColor,
      boxShadows: const [
        BoxShadow(
          color: Colors.black26,
          offset: Offset(0.0, 2.5), 
          blurRadius: 3.0,
        ),
      ],
      onTap: (Flushbar<dynamic> flushbar) {
        if (error == false && _stateController.inAttendance.value == false) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Attendance()),
          );
        }

        flushbar.dismiss(true);
      },
    ).show(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        flutterLocalNotificationsPlugin.cancelAll();
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Attendance()),
                  );
                },
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => AboutPage(version, buildNumber)),
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

  void saveAttendance(AttendanceModel attendance, bool showNotif) async {
    var id = mains.objectbox.boxAttendance.put(attendance);
    var attendanceNew = mains.objectbox.boxAttendance.get(id)!;
    String url = 'https://chat.dev.r17.co.id/save_attendance.php';

    Map<String, dynamic> data = {
      'api_key': apiKey,
      'id_user': mains.objectbox.boxUser.get(1)?.userId,
      'latitude': attendance.latitude.toString(),
      'longitude': attendance.longitude.toString(),
      'status': attendance.status,
      'datetime':
          attendance.status == 1 ? attendance.checkInAt : attendance.checkOutAt,
    };

    attendanceNew.id = attendanceNew.id;
    attendanceNew.date = attendanceNew.date;
    attendanceNew.latitude = attendanceNew.latitude;
    attendanceNew.longitude = attendanceNew.longitude;
    attendanceNew.status = attendanceNew.status;
    attendanceNew.checkInAt = attendanceNew.checkInAt;
    attendanceNew.checkOutAt = attendanceNew.checkOutAt;
    attendanceNew.server = attendanceNew.server;

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
          );

          if (attendanceMap['data'] != null) {
            if (attendanceMap['data']['check_in'] != null) {
              attendanceNew.date = DateFormat('dd MM yyyy').format(DateTime.parse(attendanceMap['data']['check_in']));

              if (attendanceNew.checkOutAt == null) {
                attendanceNew.checkInAt = attendanceMap['data']['check_in'];
              }

              attendanceHistory.datetime = attendanceMap['data']['check_in'];
              type = 'in';
            } else if (attendanceMap['data']['check_out'] != null) {
              attendanceNew.date = DateFormat('dd MM yyyy').format(DateTime.parse(attendanceMap['data']['check_out']));
              attendanceNew.checkOutAt = attendanceMap['data']['check_out'];
              attendanceHistory.datetime = attendanceMap['data']['check_out'];
              type = 'out';
            }
          }

          attendanceNew.server = true;
          mains.objectbox.boxAttendance.put(attendanceNew);
          mains.objectbox.boxAttendanceHistory.put(attendanceHistory);

          showAttendanceNotif(false, type, 'Attendance', 'Check $type at: ${DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(attendanceHistory.datetime!))}');
        } else {
          mains.objectbox.boxAttendance.remove(attendanceNew.id);

          // showAttendanceNotif(true, null, 'Error', attendanceMap['message']);
          print(attendanceMap['code_status']);
          print(attendanceMap['error']);
        }
      } else {
        mains.objectbox.boxAttendance.remove(attendanceNew.id);

        // showAttendanceNotif(true, null, 'Error', 'Something wrong');
        print("Gagal terhubung ke server!");
      }
    } catch (e) {
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
      mains.objectbox.boxAttendance.remove(attendanceNew.id);

      // showAttendanceNotif(true, null, 'Error', 'Catch error');
      print(e.toString());
    }
  }

  Future<http.Response> getDataUser() async {
    String url = 'https://chat.dev.r17.co.id/get_user.php';

    Map<String, dynamic> data = {
      'api_key': apiKey,
      'email': mains.objectbox.boxUser.get(1)?.email,
    };

    //encode Map to JSON
    //var body = "?api_key="+this.apiKey;

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
    String url = 'https://chat.dev.r17.co.id/check_fcm.php';

    Map<String, dynamic> data = {
      'api_key': apiKey,
      'email': mains.objectbox.boxUser.get(1)!.email,
      'fcm_token': mains.objectbox.boxUser.get(1)!.fcmToken,
    };

    //encode Map to JSON
    //var body = "?api_key="+this.apiKey;

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

  Future<http.Response> getListContact() async {
    String url = 'https://chat.dev.r17.co.id/list_contact.php';

    Map<String, dynamic> data = {
      'api_key': apiKey,
      'email': mains.objectbox.boxUser.get(1)?.email,
    };

    //encode Map to JSON
    //var body = "?api_key="+this.apiKey;

    var response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> userMap = json.decode(response.body);

      if (userMap['code_status'] == 1) {
        contactData = userMap['data'];
        for (int i = 0; i < userMap['data'].length; i++) {
          contactList = Map<String, dynamic>.from(userMap['data'][i]);
          nameList.insert(i, contactList['name']);

          var query = mains.objectbox.boxContact
              .query(
                  ContactModel_.email.equals(contactList['email'].toString()))
              .build();

          if (query.find().isNotEmpty) {
            final contact = ContactModel(
              id: query.find().first.id,
              userId: query.find().first.userId,
              userName: contactList['name'],
              email: query.find().first.email,
              photo: contactList['photo'] == '' || contactList['photo'] == null
                  ? ''
                  : contactList['photo'],
              phone: contactList['phone'],
            );

            mains.objectbox.boxContact.put(contact);
          } else {
            final contact = ContactModel(
              userId: contactList['id'],
              userName: contactList['name'],
              email: contactList['email'],
              photo: contactList['photo'] == '' || contactList['photo'] == null
                  ? ''
                  : contactList['photo'],
              phone: contactList['phone'],
            );

            mains.objectbox.boxContact.put(contact);
          }
        }
      } else {
        print("ada yang salah!");
      }
    } else {
      print("Gagal terhubung ke server!");
    }
    return response;
  }

  Future<http.Response> getAllMessages() async {
    String url = 'https://chat.dev.r17.co.id/get_all_messages.php';

    Map<String, dynamic> data = {
      'api_key': apiKey,
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
    String url = 'https://chat.dev.r17.co.id/get_all_attendances.php';

    Map<String, dynamic> data = {
      'api_key': apiKey,
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
      Map<String, dynamic> bodyMap = jsonDecode(response.body);

      Map<String, dynamic> data = bodyMap['data'];
      List<dynamic> attendances = data['attendances'];
      List<dynamic> attendanceHistories = data['attendance_histories'];

      for (var i = 0; i < attendances.length; i++) {
        Map<String, dynamic> attendance = Map<String, dynamic>.from(jsonDecode(attendances[i]));
        final AttendanceModel newAttendance = AttendanceModel(
          date: attendance['date'],
          checkInAt: attendance['check_in_at'],
          checkOutAt: attendance['check_out_at'],
          latitude: double.parse(attendance['latitude_in']),
          longitude: double.parse(attendance['longitude_in']),
          status: attendance['status'],
          server: true,
        );
        mains.objectbox.boxAttendance.put(newAttendance);
      }

      for (var i = 0; i < attendanceHistories.length; i++) {
        Map<String, dynamic> attendanceHistory = Map<String, dynamic>.from(jsonDecode(attendanceHistories[i]));
        final AttendanceHistoryModel newAttendanceHistory = AttendanceHistoryModel(
          date: attendanceHistory['date'],
          datetime: attendanceHistory['datetime'],
          latitude: double.parse(attendanceHistory['latitude']),
          longitude: double.parse(attendanceHistory['longitude']),
          status: attendanceHistory['status'],
          server: true,
        );
        mains.objectbox.boxAttendanceHistory.put(newAttendanceHistory);
      }

      EasyLoading.showSuccess('Done!');
    } else {
      EasyLoading.showError('Gagal terhubung ke server!');
    }

    return response;
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

                  await SpUtil.instance.removeValue('messagesDownloaded');
                  await SpUtil.instance.removeValue('attendancesDownloaded');
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

                  // Navigator.pop(ctx);
                  // Navigator.pushReplacement(
                  //   ctx, 
                  //   MaterialPageRoute(builder: (context) => Login()),
                  // );

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
                  onPressed: () {
                    _deleteAppDir();
                    _deleteCacheDir();

                    mains.objectbox.boxConversation.removeAll();
                    mains.objectbox.boxChat.removeAll();
                    mains.objectbox.boxContact.removeAll();
                    mains.objectbox.boxUser.removeAll();
                    mains.objectbox.boxAttendance.removeAll();
                    mains.objectbox.boxSurat.removeAll();
                    mains.objectbox.boxBadge.removeAll();
                    mains.objectbox.boxNews.removeAll();
                    mains.objectbox.boxUserPreference.removeAll();

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
