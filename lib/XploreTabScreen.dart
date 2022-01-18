import 'package:flutter/material.dart';
import 'objectbox.g.dart';
import 'package:badges/badges.dart';
import 'document.dart';
import 'package:militarymessenger/approved.dart';
import 'package:militarymessenger/draft.dart';
import 'package:militarymessenger/inbox.dart';
import 'package:militarymessenger/sent.dart';
import 'package:militarymessenger/document.dart';




class XploreTabScreen extends StatelessWidget {
  Store? store;
  XploreTabScreen();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Material(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => InboxPage()),
                        );
                      },
                      child: Column(
                        children: [
                          Badge(
                            position: BadgePosition.bottomEnd(end: 0, bottom: -6),
                            badgeContent: Text(
                              '3',
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                            badgeColor: Color(0xFFE2574C),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Color(0xFF5584AC),
                              child: CircleAvatar(
                                backgroundImage: AssetImage('assets/icons/inbox_icon2.png'),
                                backgroundColor: Color(0xFF5584AC),
                                radius: 20,
                              ),
                            ),
                          ),
                          Text(
                            'Inbox',
                            style: TextStyle(
                              height: 2,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SentPage()),
                        );
                      },
                      child: Column(
                        children: [
                          Badge(
                            position: BadgePosition.bottomEnd(end: 0, bottom: -6),
                            badgeContent: Text(
                              '3',
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                            badgeColor: Color(0xFFE2574C),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Color(0xFFE49D23),
                              child: CircleAvatar(
                                backgroundImage: AssetImage('assets/icons/sent_icon2.png'),
                                backgroundColor: Color(0xFFE49D23),
                                radius: 20,
                              ),
                            ),
                          ),
                          Text(
                            'Sent',
                            style: TextStyle(
                              height: 2,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ApprovedPage()),
                        );
                      },
                      child: Column(
                        children: [
                          Badge(
                            position: BadgePosition.bottomEnd(end: 0, bottom: -6),
                            badgeContent: Text(
                              '3',
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                            badgeColor: Color(0xFFE2574C),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Color(0xFF3B8880),
                              child: CircleAvatar(
                                backgroundImage: AssetImage('assets/icons/approved_icon2.png'),
                                backgroundColor: Color(0xFF3B8880),
                                radius: 20,
                              ),
                            ),
                          ),
                          Text(
                            'Approved',
                            style: TextStyle(
                              height: 2,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => DraftPage()),
                        );
                      },
                      child: Column(
                        children: [
                          Badge(
                            position: BadgePosition.bottomEnd(end: 0, bottom: -6),
                            badgeContent: Text(
                              '3',
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                            badgeColor: Color(0xFFE2574C),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Color(0xFF9EADBD),
                              child: CircleAvatar(
                                backgroundImage: AssetImage('assets/icons/draft_icon2.png'),
                                backgroundColor: Color(0xFF9EADBD),
                                radius: 20,
                              ),
                            ),
                          ),
                          Text(
                            'Draft',
                            style: TextStyle(
                              height: 2,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 15, left: 20),
                decoration: BoxDecoration(
                  color: Color(0xFFF8FAFC),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recently",
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            height: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  height: 124,
                                  width: 124,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                      image: DecorationImage(
                                        image: AssetImage("assets/images/pdf.png"),
                                        fit: BoxFit.cover,
                                      )
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  width: 200,
                                  child: Material(
                                    child: Text(
                                      "Penunjukan Menteri Dalam Negeri.pdf",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          height: 1.3
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  height: 124,
                                  width: 124,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                      image: DecorationImage(
                                        image: AssetImage("assets/images/pdf.png"),
                                        fit: BoxFit.cover,
                                      )
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  width: 200,
                                  child: Material(
                                    child: Text(
                                      "Penunjukan Menteri Dalam Negeri.pdf",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          height: 1.3
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  height: 124,
                                  width: 124,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                      image: DecorationImage(
                                        image: AssetImage("assets/images/pdf.png"),
                                        fit: BoxFit.cover,
                                      )
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  width: 200,
                                  child: Material(
                                    child: Text(
                                      "Penunjukan Menteri Dalam Negeri.pdf",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          height: 1.3
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  height: 124,
                                  width: 124,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                      image: DecorationImage(
                                        image: AssetImage("assets/images/pdf.png"),
                                        fit: BoxFit.cover,
                                      )
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  width: 200,
                                  child: Material(
                                    child: Text(
                                      "Penunjukan Menteri Dalam Negeri.pdf",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          height: 1.3
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Today",
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "More",
                            style: TextStyle(
                                color: Color(0xFF2481CF),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                height: 1.3
                            ),
                          )
                        ],
                      ),
                    ),
                    Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => DocumentPage()),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 5),
                          height: 75,
                          width: 500,
                          child: Card(
                            margin: EdgeInsets.only(top: 3, bottom: 3),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      margin: EdgeInsets.only(right: 5),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage("assets/images/pdf.png")
                                          )
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 55,
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
                                            "Penunjukan Menteri Dalam Negeri.pdf",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Jul 17, 2021 15.34",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            height: 2,
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
                                      child: Icon(
                                        Icons.file_upload_outlined,
                                        color: Color(0xFF2481CF),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => DocumentPage()),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 5),
                          height: 75,
                          width: 500,
                          child: Card(
                            margin: EdgeInsets.only(top: 3, bottom: 3),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      margin: EdgeInsets.only(right: 5),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage("assets/images/pdf.png")
                                          )
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 55,
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
                                            "Penunjukan Menteri Dalam Negeri.pdf",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Jul 17, 2021 15.34",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            height: 2,
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
                                        child: Icon(
                                          Icons.file_download_outlined,
                                          color: Color(0xFF059669),
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => DocumentPage()),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 5),
                          height: 75,
                          width: 500,
                          child: Card(
                            margin: EdgeInsets.only(top: 3, bottom: 3),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      margin: EdgeInsets.only(right: 5),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage("assets/images/pdf.png")
                                          )
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 55,
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
                                            "Penunjukan Menteri Dalam Negeri.pdf",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Jul 17, 2021 15.34",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            height: 2,
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
                                      child: Icon(
                                        Icons.file_upload_outlined,
                                        color: Color(0xFF2481CF),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => DocumentPage()),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 5),
                          height: 75,
                          width: 500,
                          child: Card(
                            margin: EdgeInsets.only(top: 3, bottom: 3),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      margin: EdgeInsets.only(right: 5),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage("assets/images/pdf.png")
                                          )
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 55,
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
                                            "Penunjukan Menteri Dalam Negeri.pdf",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Jul 17, 2021 15.34",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            height: 2,
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
                                        child: Icon(
                                          Icons.file_download_outlined,
                                          color: Color(0xFF059669),
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
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
}