import 'package:flutter/material.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({Key? key}) : super(key: key);

  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Inbox'),
      centerTitle: true,
      backgroundColor: Color(0xFF2381d0),
    ),
    body: Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 5),
                height: 90,
                width: 500,
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 5,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(
                              'assets/images/defaultuser.png',
                            ),
                            radius: 25,
                          ),
                        ),
                        Positioned(
                          left: 65,
                          top: 5,
                          bottom: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth: 250
                                ),
                                child: Text(
                                  "Novran Ardiyanto",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                "Surat Persetujuan",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  height: 1.5,
                                  color: Color(0xFF171717),
                                ),
                              ),
                              Text(
                                "Selamat siang Bapak/Ibu, bersamaan dengan email ini",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                  color: Color(0xFF171717),
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          right: 5,
                          top: 10,
                          child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                '13.45',
                                style: TextStyle(
                                    fontSize: 11
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5),
                height: 90,
                width: 500,
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 5,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(
                              'assets/images/defaultuser.png',
                            ),
                            radius: 25,
                          ),
                        ),
                        Positioned(
                          left: 65,
                          top: 5,
                          bottom: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth: 250
                                ),
                                child: Text(
                                  "Nurul Rizal",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                "Surat Disposisi",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  height: 1.5,
                                  color: Color(0xFF171717),
                                ),
                              ),
                              Text(
                                "Selamat pagi Bapak/Ibu, bersamaan dengan email ini",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                  color: Color(0xFF171717),
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          right: 5,
                          top: 10,
                          child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                '09.45',
                                style: TextStyle(
                                    fontSize: 11
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
