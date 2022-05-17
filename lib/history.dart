import 'document.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'.toUpperCase(),
          style: TextStyle(
              fontSize: 17
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 10, bottom: 15, right: 15, left: 15),
        child: Column(
          children: [
            SizedBox(
              height: 68,
              width: 500,
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DocumentPage()),
                  );
                },
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/images/pdf.png")
                                )
                            ),
                          ),
                        ),
                        Positioned(
                          left: 50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth: 240
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
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/icons/checkCircle_icon.png")
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 68,
              width: 500,
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DocumentPage()),
                  );
                },
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/images/pdf.png")
                                )
                            ),
                          ),
                        ),
                        Positioned(
                          left: 50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth: 240
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
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/icons/upload_icon.png")
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
