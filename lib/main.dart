import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:militarymessenger/Home.dart';
import 'package:militarymessenger/Login.dart';
import 'package:militarymessenger/models/GroupNotifModel.dart';
import 'package:militarymessenger/provider/theme_provider.dart';
import 'package:militarymessenger/utils/sp_util.dart';
import 'package:telephony/telephony.dart';
import 'ObjectBox.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

late ObjectBox objectbox;

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    // 'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // try {
    //   Map<String, dynamic> data = {
    //     'api_key': '1Hw3G9UYOhounou0679y3*OhouH978%hOtfr57fRtug#9UI8nl7iU4Yt5vR6Fb87tLRB5u3g4Hi92983huiU3g5bkH5BVGv3daf2F5e2Ae4k6F5vblUwIJD9W7ryiuBL24Lbv3P',
    //   };
    //   String url = 'https://chat.dev.r17.co.id/get_datetime.php';
    //   var response = await http.post(Uri.parse(url),
    //     body: jsonEncode(data),
    //   );
    //   Map<String, dynamic> datetimeMap = jsonDecode(response.body);
    //   print(datetimeMap);
    // } catch (e) {
      
    // }

    // print('hashCode: ${message.notification.hashCode}');
    // print('Handling a background message: ${message.data}');
}

smsBackgrounMessageHandler(SmsMessage message) async {
	//Handle background message	
  print('background');
  String msgBody = message.body!;

  if (msgBody.length >= 39) {
    if (msgBody.substring(0, 33) == 'Kode OTP Digital Signature Anda: ') {
      print(msgBody.substring(33, 39));
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  objectbox = await ObjectBox.create();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'militarymessenger',
      themeMode: ThemeMode.system,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      home: objectbox.boxUser.isEmpty() ? Login() : Home(),
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
    );
  }
}
