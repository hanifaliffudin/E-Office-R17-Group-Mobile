import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatefulWidget {
  String? version;
  String? buildNumber;
  AboutPage(this.version, this.buildNumber);
  @override
  State<AboutPage> createState() => _AboutPageState(version, buildNumber);
}

class _AboutPageState extends State<AboutPage> {
  String? version;
  String? buildNumber;
  _AboutPageState(this.version, this.buildNumber);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      foregroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
      elevation: 0,
      title: Text('About'.toUpperCase(),
        style: TextStyle(
            fontSize: 17
        ),
      ),
      centerTitle: true,
    ),
    body: SingleChildScrollView(
      child: Container(
        child: Column(
          children: [

            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExpansionTile(
                    textColor: Color(0xFF2481CF),
                    title: Text('Current Version',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      ),),
                    children: <Widget>[
                      ListTile(
                          title: RichText(
                            text: TextSpan(
                              text: 'Version ' + version!,
                              style: TextStyle(
                                  fontSize: 14,
                                color: Theme.of(context).inputDecorationTheme.labelStyle?.color
                              ),
                              children: <TextSpan>[
                                TextSpan(text: '+' + buildNumber!),
                              ],
                            ),
                          )
                          // Text(
                          //   'Version ' + version!,
                          //   style: TextStyle(
                          //       fontSize: 14
                          //   ),
                          // )
                      ),
                    ],
                  ),
                  ExpansionTile(
                    textColor: Color(0xFF2481CF),
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
                    textColor: Color(0xFF2481CF),
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
  );
}