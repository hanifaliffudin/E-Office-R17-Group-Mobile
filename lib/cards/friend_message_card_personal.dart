import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';


class FriendMessageCardPersonal extends StatelessWidget {
  final String message;
  final String date;
  final String tipe;
  final String filePath;
  final bool showTriangle;
  final bool attachment;


  const FriendMessageCardPersonal(
      this.message,
      this.date,
      this.tipe,
      this.filePath,
      this.showTriangle,
      this.attachment
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Stack(
            children: <Widget>[
              !attachment ?
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12,),
                margin: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.70),
                      child:
                      Text(
                        message,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(width: 5,),
                  ],
                ),
              )
                  : tipe == 'image' ?
              InkWell(
                onTap: (){
                  OpenFile.open(filePath);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3,vertical: 3,),
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                  decoration: BoxDecoration(
                    color: Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.70),
                        child: Image(
                          image: Image.file(new File(filePath)).image,
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  :
              InkWell(
                onTap: (){
                  OpenFile.open(filePath);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12,),
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                  decoration: BoxDecoration(
                    color: Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        child: Image(image: AssetImage('assets/images/pdf.png'),width: 40,),
                      ),
                      SizedBox(width: 5),
                      Container(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.55),
                        child: Text(
                          message,
                          style: TextStyle(fontSize: 16,color: Colors.black),
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
              Positioned(
                left:0,
                top: 2,
                child: ClipPath(
                  clipper: TriangleClipper(),
                  child: Container(
                    height: 20,
                    width: 30,
                    color: showTriangle?Color(0xFFEEEEEE):Colors.transparent,
                  ),
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(date,
                style: TextStyle(
                  fontSize: 11,
                ),),
            ],
          )
        ],
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}