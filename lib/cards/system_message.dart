import 'package:flutter/material.dart';

class SystemMessage extends StatelessWidget {
  final String message;

  const SystemMessage(this.message,);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.70),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(0, 0, 0, 0.45),
        ),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Text(
          message,
          style: TextStyle(
              color: Colors.white
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}