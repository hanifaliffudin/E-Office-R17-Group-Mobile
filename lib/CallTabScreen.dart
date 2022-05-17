import 'package:flutter/material.dart';
import 'objectbox.g.dart';

class CallTabScreen extends StatelessWidget {
  Store? store;
  CallTabScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Column(
            children: [
              SizedBox(height: 5,),
              Card(
                margin: EdgeInsets.fromLTRB(20,10,20,0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(right: 20.0),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: AssetImage('assets/images/defaultuser.png'),
                                )
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: 200
                                  ),
                                  child: Text('Ramadhan Akbar',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  children: [
                                    Icon(Icons.phone,
                                      color: Color(0xFF1FA463),
                                      size: 16,),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('Incoming Call'),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text('09.56',
                      style: TextStyle(
                        fontSize: 12
                      ),),
                    ],
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.fromLTRB(20,10,20,0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(right: 20.0),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: AssetImage('assets/images/defaultuser.png'),
                                )
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: 200
                                  ),
                                  child: Text('Hanif Aliffudin',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  children: [
                                    Icon(Icons.phone,
                                      color: Color(0xFFDC2626),
                                      size: 16,),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('Missed Call'),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text('08.56',
                        style: TextStyle(
                            fontSize: 12
                        ),),
                    ],
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.fromLTRB(20,10,20,0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(right: 20.0),
                                child: Image(image: AssetImage('assets/images/pdf.png'),width: 50,),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: 200
                                  ),
                                  child: Text('Penunjukan Menteri Dalam Negeri',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                SizedBox(height: 5,),
                                Text('yesterday'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                      height: 50,
                      width: 30,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/icons/download_icon.png")
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
