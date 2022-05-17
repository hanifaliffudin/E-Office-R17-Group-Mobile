import 'package:militarymessenger/settings/chatbackup.dart';
import 'package:flutter/material.dart';

class ChatSettingPage extends StatelessWidget {
  const ChatSettingPage({Key? key}) : super(key: key);

  @override
  ChatSettingPage createState() => ChatSettingPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              foregroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Chats'.toUpperCase(),
                style: TextStyle(
                    fontSize: 17
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ChatBackupPage()),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Chat Backup'),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('Clear all chats'),
                        content: const Text('You will not be able to restore chats once you clear it.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('Ok'),
                          ),
                        ],
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Clear All Chats',
                        style: TextStyle(
                            color: Colors.red
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('Delete all chats'),
                        content: const Text('You will not be able to restore chats once you delete it.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('Ok'),
                          ),
                        ],
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Delete All Chats',
                        style: TextStyle(
                            color: Colors.red
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
