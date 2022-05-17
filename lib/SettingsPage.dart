import 'package:flutter/material.dart';
import 'package:militarymessenger/settings/chat.dart';
import 'package:militarymessenger/settings/help.dart';
import 'package:militarymessenger/settings/notification.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      foregroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
      elevation: 0,
      title: Text('Settings'.toUpperCase(),
        style: TextStyle(
          fontSize: 17,
        ),),
      centerTitle: true,
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
                MaterialPageRoute(builder: (context) => ChatSettingPage()),
              );
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(
                    Icons.message_outlined,
                    color: Colors.grey,
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
                    color: Colors.grey,
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
                    color: Colors.grey,
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
                    color: Colors.grey,
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