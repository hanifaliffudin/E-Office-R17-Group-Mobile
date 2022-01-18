import 'package:flutter/material.dart';

class DraftPage extends StatefulWidget {
  const DraftPage({Key? key}) : super(key: key);

  @override
  _DraftPageState createState() => _DraftPageState();
}

class _DraftPageState extends State<DraftPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Draft'),
        centerTitle: true,
        backgroundColor: Color(0xFF2381d0),
      ),
      body: Material(
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
                                    "Draft",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red
                                    ),
                                  ),
                                ),
                                Text(
                                  "Email Subject",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                    color: Color(0xFF171717),
                                  ),
                                ),
                                Text(
                                  "Email Content",
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
                                    "Draft",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red
                                    ),
                                  ),
                                ),
                                Text(
                                  "Email Subject",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                    color: Color(0xFF171717),
                                  ),
                                ),
                                Text(
                                  "Email Content",
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
}
