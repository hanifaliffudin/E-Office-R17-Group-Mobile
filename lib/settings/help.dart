import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              foregroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Help Center'.toUpperCase(),
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
                  Container(
                    child: Text(
                      'FAQs',
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                  ExpansionTile(
                    title: Text('Checking/changing your password',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      ),),
                    children: <Widget>[
                      ListTile(
                          title: Text(
                            'Unfortunately, there is no way to directly check your registered password.',
                            style: TextStyle(
                                fontSize: 14
                            ),
                          )
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text('Unsending messages',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      ),),
                    children: <Widget>[
                      ListTile(
                          title: Text(
                            'You can unsend a message within 24 hours of sending it. This removes the message so that it can no longer be seen by anyone in the chat where it was sent, even after it has been read.',
                            style: TextStyle(
                                fontSize: 14
                            ),
                          )
                      ),
                    ],
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
