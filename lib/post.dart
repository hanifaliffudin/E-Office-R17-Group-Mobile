import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

import 'package:militarymessenger/provider/theme_provider.dart';

class PostPage extends StatefulWidget {

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final _focusNode = FocusNode();
  bool isLiked = false;
  int likeCount = 0;
  bool likeButton = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: AssetImage(
                                    'assets/images/avatar3.png'
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
                          Text('Mendagri: Pemda Sulawesi Tenggara Siap Percepat Vaksinasi Covid-19',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              height: 1.3,
                            ),
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
                                      // borderRadius: BorderRadius.circular(6)
                                    ),
                                  )
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Erat ornare enim, interdum pretium. Odio semper pellentesque in leo nullam nulla sed molestie aliquet. Tortor, leo ipsum dui quis. Non varius sed ultricies tempus sapien. Mattis arcu in in accumsan dignissim eu maecenas. Vulputate est commodo aliquam risus vitae amet eget vitae magnis. Lacus, aliquam urna nisi, sit quis ante. Pharetra ut turpis interdum faucibus magna amet dignissim elit egestas. Maecenas non aliquam viverra nibh diam.',
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(height: 10,),
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
                              // LikeButton(
                              //   size: 20,
                              //   isLiked: isLiked,
                              //   likeCount: likeCount,
                              //   likeCountPadding: EdgeInsets.only(left: 7),
                              //   circleColor: CircleColor(
                              //     start: Color(0xFF2481CF),
                              //     end: Color(0xFF2481CF)
                              //   ),
                              //   bubblesColor: BubblesColor(
                              //     dotPrimaryColor: Color(0xFF2481CF),
                              //     dotSecondaryColor: Color(0xFF2481CF)
                              //   ),
                              //   onTap: (isLiked) async {
                              //     this.isLiked = !isLiked;
                              //     likeCount += this.isLiked ? 1 : -1;
                              //     return !isLiked;
                              //   },
                              // ),
                              TextButton.icon(
                                onPressed: () {

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
                          ),
                          SizedBox(height: 30,),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Reactions',
                                  style: TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Stack(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          backgroundImage: AssetImage(
                                              'assets/images/avatar1.png'
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            padding: EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Color(0xFFEAF6FF),
                                            ),
                                            child: Icon(
                                              Icons.thumb_up_alt_outlined,
                                              color: Color(0xFF2481CF),
                                              size: 12,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(width: 10,),
                                    Stack(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          backgroundImage: AssetImage(
                                              'assets/images/avatar2.png'
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            padding: EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Color(0xFFEAF6FF),
                                            ),
                                            child: Icon(
                                              Icons.thumb_up_alt_outlined,
                                              color: Color(0xFF2481CF),
                                              size: 12,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(width: 10,),
                                    Stack(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          backgroundImage: AssetImage(
                                              'assets/images/avatar3.png'
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            padding: EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Color(0xFFEAF6FF),
                                            ),
                                            child: Icon(
                                              Icons.thumb_up_alt_outlined,
                                              color: Color(0xFF2481CF),
                                              size: 12,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 30,),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Comments',
                                  style: TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      backgroundImage: AssetImage(
                                          'assets/images/avatar1.png'
                                      ),
                                    ),
                                    SizedBox(width: 15,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Stack(
                                          overflow: Overflow.visible,
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12,),
                                              // margin: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFEEEEEE),
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Container(
                                                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                                                    child:
                                                    Text(
                                                      'They’re holding a meeting right now. Wait, I’ll send you a snap. I\’m hearing them talking about you.',
                                                      style: TextStyle(fontSize: 14, color: Colors.black),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 5,),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text('09.20',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Color(0xFF94A3B8)
                                              ),),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      backgroundImage: AssetImage(
                                          'assets/images/avatar2.png'
                                      ),
                                    ),
                                    SizedBox(width: 15,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Stack(
                                          overflow: Overflow.visible,
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12,),
                                              // margin: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFEEEEEE),
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Container(
                                                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                                                    child:
                                                    Text(
                                                      'They’re holding a meeting right now. Wait, I’ll send you a snap. I\’m hearing them talking about you.',
                                                      style: TextStyle(fontSize: 14, color: Colors.black),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 5,),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text('09.20',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Color(0xFF94A3B8)
                                              ),),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Theme.of(context).backgroundColor,
                      padding: EdgeInsets.only(right: 10, left: 10, top: 7, bottom: 25),
                      child: Row(
                        children: [
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(top: 10, bottom: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              constraints: BoxConstraints(
                                minHeight: 25.0,
                                maxHeight: 100,
                                minWidth: MediaQuery.of(context).size.width,
                                maxWidth: MediaQuery.of(context).size.width,
                              ),
                              child: Scrollbar(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        focusNode: _focusNode,
                                        cursorColor: Color(0xFF2481CF),
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(13),
                                            border: InputBorder.none,
                                            hintText: 'Type something...',
                                            hintStyle: TextStyle(
                                                color: Color(0xff99999B),
                                                fontSize: 12
                                            )
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 20, right: 8),
                              child: Text('Post',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).floatingActionButtonTheme.backgroundColor
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

