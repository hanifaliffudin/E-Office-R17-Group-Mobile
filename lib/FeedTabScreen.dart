import 'package:flutter/material.dart';
import 'package:militarymessenger/post.dart';
import 'objectbox.g.dart';

class FeedTabScreen extends StatefulWidget {

  FeedTabScreen();

  @override
  State<FeedTabScreen> createState() => _FeedTabScreenState();
}

class _FeedTabScreenState extends State<FeedTabScreen> {
  Store? store;

  bool likeButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: AssetImage(
                                    'assets/images/defaultuser.png'
                                ),
                              ),
                              SizedBox(width: 10,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nurul Rizal',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text('Jul 17, 2021',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,
                                            height: 2
                                        ),
                                      ),
                                      SizedBox(width: 15,),
                                      Text('09.10',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,
                                            height: 2
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                    height: MediaQuery.of(context).size.width * 0.45,
                                    width: MediaQuery.of(context).size.width * 1,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage("assets/images/news1.png"),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(6)
                                    ),
                                  )
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Text('Mendagri: Pemda Sulawesi Tenggara Siap Percepat Vaksinasi Covid-19',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              height: 1.3,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.thumb_up_outlined,
                                      color: Color(0xFF94A3B8),
                                      size: 15,
                                    ),
                                    SizedBox(width: 5,),
                                    Text('12',
                                      style: TextStyle(
                                          color: Color(0xFF94A3B8),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400
                                      ),
                                    )
                                  ],
                                ),
                                Text('100 Comments',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10,
                                      color: Color(0xFF94A3B8)
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 1,
                            margin: EdgeInsets.only(top: 10),
                            color: Colors.grey.withOpacity(.2),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                onPressed: () => setState(() => likeButton = !likeButton),
                                icon: Icon(Icons.thumb_up_outlined,
                                  color: likeButton ? Color(0xFF2481CF) : Colors.grey,
                                  size: 15,
                                ),
                                label: Text("Like",
                                  style: TextStyle(
                                      color: likeButton ? Color(0xFF2481CF) : Colors.grey,
                                      fontSize: 14
                                  ),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => PostPage()),
                                  );
                                },
                                icon: Icon(Icons.chat_bubble_outline_rounded,
                                  color: Color(0xFF94A3B8),
                                  size: 15,
                                ),
                                label: Text("Comment",
                                  style: TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 14
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: AssetImage(
                                    'assets/images/defaultuser.png'
                                ),
                              ),
                              SizedBox(width: 10,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nurul Rizal',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text('Jul 17, 2021',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,
                                            height: 2
                                        ),
                                      ),
                                      SizedBox(width: 15,),
                                      Text('09.10',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,
                                            height: 2
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                    height: MediaQuery.of(context).size.width * 0.45,
                                    width: MediaQuery.of(context).size.width * 1,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage("assets/images/news2.png"),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(6)
                                    ),
                                  )
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Text('Tindaklanjuti Arahan Presiden, Mendagri Minta Pemda Penuhi Target Vaksinasi Covid-19',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              height: 1.3,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.thumb_up_outlined,
                                      color: Color(0xFF94A3B8),
                                      size: 15,
                                    ),
                                    SizedBox(width: 5,),
                                    Text('12',
                                      style: TextStyle(
                                          color: Color(0xFF94A3B8),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400
                                      ),
                                    )
                                  ],
                                ),
                                Text('100 Comments',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10,
                                      color: Color(0xFF94A3B8)
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 1,
                            margin: EdgeInsets.only(top: 10),
                            color: Colors.grey.withOpacity(.2),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  // Respond to button press
                                },
                                icon: Icon(Icons.thumb_up_outlined,
                                  color: Color(0xFF94A3B8),
                                  size: 15,
                                ),
                                label: Text("Like",
                                  style: TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 14
                                  ),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => PostPage()),
                                  );
                                },
                                icon: Icon(Icons.chat_bubble_outline_rounded,
                                  color: Color(0xFF94A3B8),
                                  size: 15,
                                ),
                                label: Text("Comment",
                                  style: TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 14
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: AssetImage(
                                    'assets/images/defaultuser.png'
                                ),
                              ),
                              SizedBox(width: 10,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nurul Rizal',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text('Jul 17, 2021',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,
                                            height: 2
                                        ),
                                      ),
                                      SizedBox(width: 15,),
                                      Text('09.10',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,
                                            height: 2
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                    height: MediaQuery.of(context).size.width * 0.45,
                                    width: MediaQuery.of(context).size.width * 1,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage("assets/images/news3.png"),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(6)
                                    ),
                                  )
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Text('TP PKK Pusat Terjun Langsung Bantu Penanganan Erupsi Semeru',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              height: 1.3,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.thumb_up_outlined,
                                      color: Color(0xFF94A3B8),
                                      size: 15,
                                    ),
                                    SizedBox(width: 5,),
                                    Text('12',
                                      style: TextStyle(
                                          color: Color(0xFF94A3B8),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400
                                      ),
                                    )
                                  ],
                                ),
                                Text('100 Comments',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10,
                                      color: Color(0xFF94A3B8)
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 1,
                            margin: EdgeInsets.only(top: 10),
                            color: Colors.grey.withOpacity(.2),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  // Respond to button press
                                },
                                icon: Icon(Icons.thumb_up_outlined,
                                  color: Color(0xFF94A3B8),
                                  size: 15,
                                ),
                                label: Text("Like",
                                  style: TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 14
                                  ),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => PostPage()),
                                  );
                                },
                                icon: Icon(Icons.chat_bubble_outline_rounded,
                                  color: Color(0xFF94A3B8),
                                  size: 15,
                                ),
                                label: Text("Comment",
                                  style: TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 14
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        // Column(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     Row(
        //       children: [
        //         Expanded(
        //           child: Padding(
        //             padding: EdgeInsets.all(12),
        //             child: Card(
        //               child: Container(
        //                 height: 250,
        //                 width: 355,
        //                 padding: const EdgeInsets.all(8.0),
        //                 decoration: BoxDecoration(
        //                     image: DecorationImage(
        //                       image: AssetImage("assets/images/gunung.jpg"),
        //                       fit: BoxFit.cover,
        //                     )
        //                 ),
        //                 child: Column(
        //                   children: <Widget>[
        //                     Container(
        //                       child: Container(
        //                         child: Column(
        //                           crossAxisAlignment: CrossAxisAlignment.start,
        //                           children: <Widget>[
        //                             Text(
        //                               'FOTO: Hiruk Pikuk Menyambut Festival Cahaya Diwali',
        //                               style: TextStyle(
        //                                 fontFamily: 'Alte',
        //                                 fontSize: 18,
        //                                 fontWeight: FontWeight.bold,
        //                                 color: Colors.white,
        //                               ),
        //                             ),
        //                             const SizedBox(height: 8,),
        //                           ],
        //                         ),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //     Padding(
        //         padding: EdgeInsets.only(left: 10, right: 10),
        //         child: Container(
        //             height: 100,
        //             child: Row(
        //               //Stretches to vertically fill its parent container
        //               crossAxisAlignment: CrossAxisAlignment.stretch,
        //               children: <Widget>[
        //                 Container(
        //                     padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
        //                     height: 40,
        //                     width: 120,
        //                     child: Container(
        //                       decoration: BoxDecoration(
        //                           image: DecorationImage(
        //                             image: AssetImage("assets/images/bis.jpg"),
        //                             fit: BoxFit.fill,
        //                           )
        //                       ),
        //                     )),
        //                 Expanded(
        //                     child: Container(
        //                         height: 40,
        //                         width: 40,
        //                         padding: EdgeInsets.only(top: 15, bottom: 15, right: 15, left: 10),
        //                         child: Column(
        //                           crossAxisAlignment: CrossAxisAlignment.start,
        //                           children: [
        //                             Text(
        //                               'Sopir Korban Tewas Kecelakaan Transjakarta Jadi Tersangka',
        //                               overflow: TextOverflow.ellipsis,
        //                               maxLines: 2,
        //                               style: TextStyle(
        //                                 fontFamily: 'Alte',
        //                                 fontSize: 14,
        //                                 fontWeight: FontWeight.bold,
        //                                 decoration: TextDecoration.none,
        //                               ),
        //                             ),
        //                             const SizedBox(height: 20,),
        //                             Text(
        //                               '3 jam yang lalu',
        //                               style: TextStyle(
        //                                 fontFamily: 'Alte',
        //                                 fontWeight: FontWeight.normal,
        //                                 fontSize: 13,
        //                                 color: Colors.grey,
        //                                 decoration: TextDecoration.none,
        //                               ),
        //                             )
        //                           ],
        //                         )
        //                     )
        //                 ),
        //               ],
        //             )
        //         )
        //     ),
        //     Padding(
        //         padding: EdgeInsets.only(left: 10, right: 10),
        //         child: Container(
        //             height: 100,
        //             child: Row(
        //               //Stretches to vertically fill its parent container
        //               crossAxisAlignment: CrossAxisAlignment.stretch,
        //               children: <Widget>[
        //                 Container(
        //                     padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
        //                     height: 40,
        //                     width: 120,
        //                     child: Container(
        //                       decoration: BoxDecoration(
        //                           image: DecorationImage(
        //                             image: AssetImage("assets/images/tebing.jpg"),
        //                             fit: BoxFit.fill,
        //                           )
        //                       ),
        //                     )),
        //                 Expanded(
        //                     child: Container(
        //                         height: 40,
        //                         width: 40,
        //                         padding: EdgeInsets.only(top: 15, bottom: 15, right: 15, left: 10),
        //                         child: Column(
        //                           crossAxisAlignment: CrossAxisAlignment.start,
        //                           children: [
        //                             Text(
        //                               'Perito Moreno, Gletser Purba yang Disebut Bernyawa',
        //                               overflow: TextOverflow.ellipsis,
        //                               maxLines: 2,
        //                               style: TextStyle(
        //                                 fontFamily: 'Alte',
        //                                 fontSize: 14,
        //                                 fontWeight: FontWeight.bold,
        //                                 decoration: TextDecoration.none,
        //                               ),
        //                             ),
        //                             const SizedBox(height: 20,),
        //                             Text(
        //                               '3 jam yang lalu',
        //                               style: TextStyle(
        //                                 fontFamily: 'Alte',
        //                                 fontWeight: FontWeight.normal,
        //                                 fontSize: 13,
        //                                 color: Colors.grey,
        //                                 decoration: TextDecoration.none,
        //                               ),
        //                             )
        //                           ],
        //                         )
        //                     )
        //                 ),
        //               ],
        //             )
        //         )
        //     ),
        //     Padding(
        //         padding: EdgeInsets.only(left: 10, right: 10),
        //         child: Container(
        //             height: 100,
        //             child: Row(
        //               //Stretches to vertically fill its parent container
        //               crossAxisAlignment: CrossAxisAlignment.stretch,
        //               children: <Widget>[
        //                 Container(
        //                     padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
        //                     height: 40,
        //                     width: 120,
        //                     child: Container(
        //                       decoration: BoxDecoration(
        //                           image: DecorationImage(
        //                             image: AssetImage("assets/images/macet.jpeg"),
        //                             fit: BoxFit.fill,
        //                           )
        //                       ),
        //                     )),
        //                 Expanded(
        //                     child: Container(
        //                         height: 40,
        //                         width: 40,
        //                         padding: EdgeInsets.only(top: 15, bottom: 15, right: 15, left: 10),
        //                         child: Column(
        //                           crossAxisAlignment: CrossAxisAlignment.start,
        //                           children: [
        //                             Text(
        //                               'Penyebab Matahari Terbit Awal di Bulan November',
        //                               overflow: TextOverflow.ellipsis,
        //                               maxLines: 2,
        //                               style: TextStyle(
        //                                 fontFamily: 'Alte',
        //                                 fontSize: 14,
        //                                 fontWeight: FontWeight.bold,
        //                                 decoration: TextDecoration.none,
        //                               ),
        //                             ),
        //                             const SizedBox(height: 20,),
        //                             Text(
        //                               '3 jam yang lalu',
        //                               style: TextStyle(
        //                                 fontFamily: 'Alte',
        //                                 fontWeight: FontWeight.normal,
        //                                 fontSize: 13,
        //                                 color: Colors.grey,
        //                                 decoration: TextDecoration.none,
        //                               ),
        //                             )
        //                           ],
        //                         )
        //                     )
        //                 ),
        //               ],
        //             )
        //         )
        //     ),
        //     Padding(
        //         padding: EdgeInsets.only(left: 10, right: 10),
        //         child: Container(
        //             height: 100,
        //             child: Row(
        //               //Stretches to vertically fill its parent container
        //               crossAxisAlignment: CrossAxisAlignment.stretch,
        //               children: <Widget>[
        //                 Container(
        //                     padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
        //                     height: 40,
        //                     width: 120,
        //                     child: Container(
        //                       decoration: BoxDecoration(
        //                           image: DecorationImage(
        //                             image: AssetImage("assets/images/macet.jpeg"),
        //                             fit: BoxFit.fill,
        //                           )
        //                       ),
        //                     )),
        //                 Expanded(
        //                     child: Container(
        //                         height: 40,
        //                         width: 40,
        //                         padding: EdgeInsets.only(top: 15, bottom: 15, right: 15, left: 10),
        //                         child: Column(
        //                           crossAxisAlignment: CrossAxisAlignment.start,
        //                           children: [
        //                             Text(
        //                               'Penyebab Matahari Terbit Awal di Bulan November',
        //                               overflow: TextOverflow.ellipsis,
        //                               maxLines: 2,
        //                               style: TextStyle(
        //                                 fontFamily: 'Alte',
        //                                 fontSize: 14,
        //                                 fontWeight: FontWeight.bold,
        //                                 decoration: TextDecoration.none,
        //                               ),
        //                             ),
        //                             const SizedBox(height: 20,),
        //                             Text(
        //                               '3 jam yang lalu',
        //                               style: TextStyle(
        //                                 fontFamily: 'Alte',
        //                                 fontWeight: FontWeight.normal,
        //                                 fontSize: 13,
        //                                 color: Colors.grey,
        //                                 decoration: TextDecoration.none,
        //                               ),
        //                             )
        //                           ],
        //                         )
        //                     )
        //                 ),
        //               ],
        //             )
        //         )
        //     ),
        //     Padding(
        //         padding: EdgeInsets.only(left: 10, right: 10),
        //         child: Container(
        //             height: 100,
        //             child: Row(
        //               //Stretches to vertically fill its parent container
        //               crossAxisAlignment: CrossAxisAlignment.stretch,
        //               children: <Widget>[
        //                 Container(
        //                     padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
        //                     height: 40,
        //                     width: 120,
        //                     child: Container(
        //                       decoration: BoxDecoration(
        //                           image: DecorationImage(
        //                             image: AssetImage("assets/images/macet.jpeg"),
        //                             fit: BoxFit.fill,
        //                           )
        //                       ),
        //                     )),
        //                 Expanded(
        //                     child: Container(
        //                         height: 40,
        //                         width: 40,
        //                         padding: EdgeInsets.only(top: 15, bottom: 15, right: 15, left: 10),
        //                         child: Column(
        //                           crossAxisAlignment: CrossAxisAlignment.start,
        //                           children: [
        //                             Text(
        //                               'Penyebab Matahari Terbit Awal di Bulan November',
        //                               overflow: TextOverflow.ellipsis,
        //                               maxLines: 2,
        //                               style: TextStyle(
        //                                 fontFamily: 'Alte',
        //                                 fontSize: 14,
        //                                 fontWeight: FontWeight.bold,
        //                                 decoration: TextDecoration.none,
        //                               ),
        //                             ),
        //                             const SizedBox(height: 20,),
        //                             Text(
        //                               '3 jam yang lalu',
        //                               style: TextStyle(
        //                                 fontFamily: 'Alte',
        //                                 fontWeight: FontWeight.normal,
        //                                 fontSize: 13,
        //                                 color: Colors.grey,
        //                                 decoration: TextDecoration.none,
        //                               ),
        //                             )
        //                           ],
        //                         )
        //                     )
        //                 ),
        //               ],
        //             )
        //         )
        //     ),
        //   ],
        // ),
      ),
    );
  }
}