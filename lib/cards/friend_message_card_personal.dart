import 'package:flutter/material.dart';


class FriendMessageCardPersonal extends StatelessWidget {
  final String message;
  final String date;
  final bool showTriangle;

  const FriendMessageCardPersonal(
    this.message,
    this.date,
    this.showTriangle,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12,),
                margin: EdgeInsets.symmetric(horizontal: 21,vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      child:
                      Text(
                        message.length>9?message:message+'          ',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(width: 5,),
                  ],
                ),
              ),
              Container(
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3,left:34),
                      child:Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          date,
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left:7,
                top: 2,
                child: ClipPath(
                  clipper: TriangleClipper(),
                  child: Container(
                    height: 20,
                    width: 30,
                    color: showTriangle?Colors.white:Colors.transparent,
                  ),
                ),
              )
            ],
          ),
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