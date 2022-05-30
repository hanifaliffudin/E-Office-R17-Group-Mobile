import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class MyMessageCardGroup extends StatelessWidget {
  final String message;
  final String date;
  final int read;
  final String tipe;
  final String filePath;
  final bool showTriangle;
  final bool attachment;

  const MyMessageCardGroup(
      this.message,
      this.date,
      this.read,
      this.tipe,
      this.filePath,
      this.showTriangle,
      this.attachment,
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            read == 0 ?
                Text(""):
            Text("Read by ${read}",
              style: TextStyle(
                  fontSize: 11
              ),
            ),
            Text(date,
              style: TextStyle(
                  fontSize: 11
              ),)
          ],
        ),
        Container(
          child: Align(
            alignment: Alignment.topRight,
            child :  Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      child:  Align(
                        alignment: Alignment.topRight,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            !attachment ?
                                tipe == 'text' ?
                            //    text bubble
                                Container(
                              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12,),
                              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                              decoration: BoxDecoration(
                                color: Color(0xFF2381d0),
                                borderRadius: BorderRadius.circular(5),

                              ),
                              child: Container(
                                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.70),
                                child: Text(
                                  message,
                                  style: TextStyle(fontSize: 16,color: Colors.white),
                                  textAlign: TextAlign.left,
                                  maxLines: 100,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                            )
                            :
                                //     system bubble
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12,),
                                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF2381d0).withOpacity(.5),
                                    borderRadius: BorderRadius.circular(5),

                                  ),
                                  child: Container(
                                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.70),
                                    child: Text(
                                      message,
                                      style: TextStyle(fontSize: 16,color: Colors.white),
                                      textAlign: TextAlign.left,
                                      maxLines: 100,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                )
                            : tipe == 'image' ?
                            //    image bubble
                            InkWell(
                              onTap: (){
                                OpenFile.open(filePath);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 3,vertical: 3,),
                                margin: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                decoration: BoxDecoration(
                                  color: Color(0xFF2381d0),
                                  borderRadius: BorderRadius.circular(5),

                                ),
                                child: Container(
                                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.70),
                                  child: Image(
                                    image: Image.file(new File(filePath)).image,
                                  ),
                                ),
                              ),
                            )
                            :
                            //    document bubble
                            InkWell(
                              onTap: (){
                                OpenFile.open(filePath);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 3,vertical: 3,),
                                margin: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                decoration: BoxDecoration(
                                  color: Color(0xFF2381d0),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      child: Image(image: AssetImage('assets/images/pdf.png'),width: 40,),
                                    ),
                                    SizedBox(width: 5,),
                                    Container(
                                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.55),
                                      child: Text(
                                        message,
                                        style: TextStyle(fontSize: 16,color: Colors.white),
                                        textAlign: TextAlign.left,
                                        maxLines: 100,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 5,),
                          ],
                        ),

                      ),

                    ),
                    Positioned(
                      right: 0,
                      top: 2,
                      child: ClipPath(
                        clipper: TriangleClipper2(),
                        child: Container(
                          height: 20,
                          width: 30,
                          color: showTriangle?Color(0xFF2381d0):Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TriangleClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper2 oldClipper) => false;
}