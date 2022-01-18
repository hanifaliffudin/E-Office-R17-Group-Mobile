import 'package:flutter/material.dart';

class ApprovedPage extends StatefulWidget {
  const ApprovedPage({Key? key}) : super(key: key);

  @override
  _ApprovedPageState createState() => _ApprovedPageState();
}

class _ApprovedPageState extends State<ApprovedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Approved'),
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
                                  Icons.check_rounded,
                                  color: Color(0xFF059669),
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
                                  Icons.check_rounded,
                                  color: Color(0xFF059669),
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
                                  Icons.check_rounded,
                                  color: Color(0xFF059669),
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
