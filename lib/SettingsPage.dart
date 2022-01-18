import 'package:flutter/material.dart';
import 'package:militarymessenger/settings/chat.dart';
import 'package:militarymessenger/settings/help.dart';
import 'package:militarymessenger/settings/notification.dart';
import 'package:militarymessenger/AboutPage.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Settings'.toUpperCase()),
      centerTitle: true,
      backgroundColor: Color(0xFFF8FAFC),
      foregroundColor: Color(0xFF2481CF),
      elevation: 0,
    ),
    body: Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(top: 20, bottom: 5),
              child: Text(
                'General',
                style: TextStyle(
                    fontSize: 10
                ),
              )
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChatPage()),
              );
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(
                    Icons.message_outlined,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text('Chats'),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text('Notifications'),
                  )
                ],
              ),
            ),
          ),

          InkWell(
            onTap: () {
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text('Privacy and Security'),
                  )
                ],
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 20, bottom: 5),
              child: Text(
                'App Info',
                style: TextStyle(
                    fontSize: 10
                ),
              )
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => HelpPage()),
              );
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(
                    Icons.help_outline_rounded,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text('Help'),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}