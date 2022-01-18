import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('About'),
      centerTitle: true,
      backgroundColor: Color(0xFF2381d0),
    ),
    body: Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [

              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExpansionTile(
                      title: Text('Current Version',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        ),),
                      children: <Widget>[
                        ListTile(
                            title: Text(
                              'Version 0.1',
                              style: TextStyle(
                                  fontSize: 14
                              ),
                            )
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text('Terms and Conditions of Use',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        ),),
                      children: <Widget>[
                        ListTile(
                            title: Text(
                              'Terms and condition',
                              style: TextStyle(
                                  fontSize: 14
                              ),
                            )
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text('Privacy Policy',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        ),),
                      children: <Widget>[
                        ListTile(
                            title: Text(
                              'Privacy policy',
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
      ),
    ),
  );
}