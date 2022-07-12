import 'dart:async';
import 'package:flutter/material.dart';
import 'package:militarymessenger/Home.dart';
import 'package:militarymessenger/Login.dart';
import 'package:militarymessenger/models/UserModel.dart';
import 'package:rxdart/rxdart.dart';
import 'main.dart' as mains;

StreamController<List<UserModel>> userController = BehaviorSubject();

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();

    userController.addStream(mains.objectbox.queryStreamUser.map((q) => q.find()));
  }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserModel>>(
      stream: userController.stream,
      builder: (context, snapshot) {
        print('test: ${mains.objectbox.boxUser.isEmpty()}');

        return mains.objectbox.boxUser.isEmpty() ? Login() : Home();
      }
    );
  }
}