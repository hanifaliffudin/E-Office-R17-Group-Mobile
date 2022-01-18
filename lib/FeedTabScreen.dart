import 'package:flutter/material.dart';
import 'objectbox.g.dart';
import 'package:militarymessenger/approved.dart';
import 'package:militarymessenger/draft.dart';
import 'package:militarymessenger/inbox.dart';
import 'package:militarymessenger/sent.dart';
import 'package:badges/badges.dart';
import 'package:militarymessenger/document.dart';




class FeedTabScreen extends StatelessWidget {
  Store? store;
  FeedTabScreen();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),

        // column of three rows
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // first row
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Card(
                    child: Container(
                      height: 250,
                      width: 360,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/gunung.jpg"),
                            fit: BoxFit.cover,
                          )
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'FOTO: Hiruk Pikuk Menyambut Festival Cahaya Diwali',
                                    style: TextStyle(
                                      fontFamily: 'Alte',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8,),

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

            // second row (single item)
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Container(
                    height: 100,
                    child: Row(
                      //Stretches to vertically fill its parent container
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                            height: 40,
                            width: 120,
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/bis.jpg"),
                                    fit: BoxFit.fill,
                                  )
                              ),
                            )),
                        Expanded(
                            child: Container(
                                height: 40,
                                width: 40,
                                padding: EdgeInsets.only(top: 15, bottom: 15, right: 15, left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sopir Korban Tewas Kecelakaan Transjakarta Jadi Tersangka',
                                      style: TextStyle(
                                        fontFamily: 'Alte',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    const SizedBox(height: 20,),
                                    Text(
                                      '3 jam yang lalu',
                                      style: TextStyle(
                                        fontFamily: 'Alte',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13,
                                        color: Colors.grey,
                                        decoration: TextDecoration.none,
                                      ),
                                    )
                                  ],
                                )
                            )
                        ),
                      ],
                    )
                )
            ),

            // third row
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Container(
                    height: 100,
                    child: Row(
                      //Stretches to vertically fill its parent container
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                            height: 40,
                            width: 120,
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/tebing.jpg"),
                                    fit: BoxFit.fill,
                                  )
                              ),
                            )),
                        Expanded(
                            child: Container(
                                height: 40,
                                width: 40,
                                padding: EdgeInsets.only(top: 15, bottom: 15, right: 15, left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Perito Moreno, Gletser Purba yang Disebut Bernyawa',
                                      style: TextStyle(
                                        fontFamily: 'Alte',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    const SizedBox(height: 20,),
                                    Text(
                                      '3 jam yang lalu',
                                      style: TextStyle(
                                        fontFamily: 'Alte',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13,
                                        color: Colors.grey,
                                        decoration: TextDecoration.none,
                                      ),
                                    )
                                  ],
                                )
                            )
                        ),
                      ],
                    )
                )
            ),

            // forth row
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Container(
                    height: 100,
                    child: Row(
                      //Stretches to vertically fill its parent container
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                            height: 40,
                            width: 120,
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/macet.jpeg"),
                                    fit: BoxFit.fill,
                                  )
                              ),
                            )),
                        Expanded(
                            child: Container(
                                height: 40,
                                width: 40,
                                padding: EdgeInsets.only(top: 15, bottom: 15, right: 15, left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Penyebab Matahari Terbit Awal di Bulan November',
                                      style: TextStyle(
                                        fontFamily: 'Alte',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    const SizedBox(height: 20,),
                                    Text(
                                      '3 jam yang lalu',
                                      style: TextStyle(
                                        fontFamily: 'Alte',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13,
                                        color: Colors.grey,
                                        decoration: TextDecoration.none,
                                      ),
                                    )
                                  ],
                                )
                            )
                        ),
                      ],
                    )
                )
            ),

            // fifth row
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Container(
                    height: 100,
                    child: Row(
                      //Stretches to vertically fill its parent container
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                            height: 40,
                            width: 120,
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/macet.jpeg"),
                                    fit: BoxFit.fill,
                                  )
                              ),
                            )),
                        Expanded(
                            child: Container(
                                height: 40,
                                width: 40,
                                padding: EdgeInsets.only(top: 15, bottom: 15, right: 15, left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Penyebab Matahari Terbit Awal di Bulan November',
                                      style: TextStyle(
                                        fontFamily: 'Alte',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    const SizedBox(height: 20,),
                                    Text(
                                      '3 jam yang lalu',
                                      style: TextStyle(
                                        fontFamily: 'Alte',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13,
                                        color: Colors.grey,
                                        decoration: TextDecoration.none,
                                      ),
                                    )
                                  ],
                                )
                            )
                        ),
                      ],
                    )
                )
            ),


          ],
        ),
      ),
    );
  }
}

