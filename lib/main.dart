import 'package:flutter/material.dart';
import 'package:militarymessenger/ChatTabScreen.dart';
import 'package:militarymessenger/Home.dart';
import 'package:militarymessenger/Login.dart';
import 'package:militarymessenger/Register.dart';
import 'package:militarymessenger/objectbox.g.dart';
import 'ObjectBox.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:io';
import 'package:web_socket_channel/io.dart';
import 'package:militarymessenger/models/ConversationModel.dart';
import 'dart:convert';

late ObjectBox objectbox;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  objectbox = await ObjectBox.create();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'militarymessenger',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: objectbox.boxUser.isEmpty() ? Login() : Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}