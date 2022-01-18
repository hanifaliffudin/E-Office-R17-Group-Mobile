import 'package:militarymessenger/AboutPage.dart';
import 'package:militarymessenger/settings/chat.dart';
import 'package:militarymessenger/settings/help.dart';
import 'package:militarymessenger/Home.dart';
import 'package:militarymessenger/settings/notification.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text('About'),
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
    );
  }
}
