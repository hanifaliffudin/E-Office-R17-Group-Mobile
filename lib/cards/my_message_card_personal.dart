import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class MyMessageCardPersonal extends StatelessWidget {
  final String message;
  final String date;
  final String sendStatus;
  final bool showTriangle;

  const MyMessageCardPersonal(
    this.message,
    this.date,
    this.sendStatus,
    this.showTriangle,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.topRight,

        child :  Column(
        children: <Widget>[
          Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                child:  Align(
                  alignment: Alignment.topRight,
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                  Container(
                  padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12,),
                    margin: EdgeInsets.symmetric(horizontal: 21,vertical: 2),
                    decoration: BoxDecoration(
                      color: Color(0xFF2381d0),
                      borderRadius: BorderRadius.circular(5),

                    ),
                    child:
                      Text(
                        message.length>9?message:message+'          ',
                        style: TextStyle(fontSize: 16,color: Colors.white),
                        textAlign: TextAlign.left,
                      ),

                  ),

                    SizedBox(width: 5,),
                  ],
                ),

                ),

              ),
              Container(
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3,right:44),
                      child:Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          date,
                          style: TextStyle(fontSize: 10, color: Color(0xE8E8E8E5)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 6,
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
              Positioned(
                right: 25,
                top: 3,
                child: Row(
                  children: [
                    Text(sendStatus,
                      style: TextStyle(fontSize: 12, color: Color(0xE8E8E8E5),fontWeight: FontWeight.bold,
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      ),
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