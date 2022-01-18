import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      color: Colors.white,
      child: Material(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 500,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage('assets/images/avatar1.png'),
                          radius: 25,
                        ),
                        Positioned(
                          left: 60,
                          top: 20,
                          child: Container(
                            width: 220,
                            child: Text(
                              "Account Name",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 20,
                          child: Container(
                            width: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.message_rounded,
                                  size: 20,
                                  color: Color(0xFF94A3B8),
                                ),
                                Icon(
                                  Icons.local_phone_rounded,
                                  size: 20,
                                  color: Color(0xFF94A3B8),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 500,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage('assets/images/avatar2.png'),
                          radius: 25,
                        ),
                        Positioned(
                          left: 60,
                          top: 20,
                          child: Container(
                            width: 220,
                            child: Text(
                              "Account Name",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 20,
                          child: Container(
                            width: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.message_rounded,
                                  size: 20,
                                  color: Color(0xFF94A3B8),
                                ),
                                Icon(
                                  Icons.local_phone_rounded,
                                  size: 20,
                                  color: Color(0xFF94A3B8),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 500,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage('assets/images/avatar3.png'),
                            radius: 25,
                          ),
                        Positioned(
                          left: 60,
                          top: 20,
                          child: Container(
                            width: 220,
                            child: Text(
                              "Account Name",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 20,
                          child: Container(
                            width: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.message_rounded,
                                  size: 20,
                                  color: Color(0xFF94A3B8),
                                ),
                                Icon(
                                  Icons.local_phone_rounded,
                                  size: 20,
                                  color: Color(0xFF94A3B8),
                                )
                              ],
                            ),
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
    );
  }
}
