import 'package:militarymessenger/newcontact.dart';
import 'package:flutter/material.dart';
import 'package:militarymessenger/newgroup.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Contact'.toUpperCase(),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF2481CF),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: ListView(
          children: [
            Container(
              height: 35,
              padding: EdgeInsets.only(right: 8, left: 8),
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              decoration: BoxDecoration(
                  color: Color(0xffE6E6E8),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Color(0xff99999B),
                    size: 20,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: Color(0xff99999B),
                          )
                      ),
                    ),
                  )
                ],
              ),
            ),
            // Container(
            //   height: 35,
            //   decoration: BoxDecoration(
            //       color: Color(0xffE5E5E5)
            //   ),
            //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   child: Text(
            //       "C"
            //   ),
            // ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      top: BorderSide(
                          color: Color(0xffE6E6E8)
                      )
                  )
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xffF2F1F6),
                      child: Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Contact 1",
                        style: TextStyle(
                          color: Colors.black,
                        ),),
                      Text("Busy",
                        style: TextStyle(
                          color: Colors.grey,
                        ),)
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      top: BorderSide(
                          color: Color(0xffE6E6E8)
                      )
                  )
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xffF2F1F6),
                      child: Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Contact 2",
                        style: TextStyle(
                          color: Colors.black,
                        ),),
                      Text("Busy",
                        style: TextStyle(
                          color: Colors.grey,
                        ),)
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
