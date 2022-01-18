import 'package:militarymessenger/settings/autobackup.dart';
import 'package:flutter/material.dart';

class ChatBackupPage extends StatelessWidget {
  const ChatBackupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
          children: [
            AppBar(
              title: Text(
                'Chat Backup',
                style: TextStyle(
                    fontSize: 15
                ),
              ),
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Color(0xffE6E6E8)
                      )
                  )
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.backup_outlined,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Last Backup: 12/12/21, 13.52'),
                            Text('Total Size: 2,38 GB')
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text('Backed up chat history is saved on iCloud and can be restored if you lose your phone or switch to a new one and reinstall this app.',
                      style: TextStyle(
                          color: Colors.grey
                      ),),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Color(0xffE6E6E8)
                      )
                  )
              ),
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
                      child: Text(
                        'Back up now'
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AutoBackupPage()),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Auto Backup'),
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
                        title: Text('Delete history'),
                        content: const Text('You will not be able to restore chat backup history once you delete it.'),
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
                          'Delete chat history backup',
                        style: TextStyle(
                          color: Colors.red
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
    );
  }
}
