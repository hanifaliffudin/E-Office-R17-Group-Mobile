import 'package:flutter/material.dart';

class NewContactPage extends StatefulWidget {
  const NewContactPage({Key? key}) : super(key: key);

  @override
  _NewContactPageState createState() => _NewContactPageState();
}

class _NewContactPageState extends State<NewContactPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Text(
                      'New Contact',
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      'Save',
                      style: TextStyle(
                          color: Colors.grey
                      ),
                    )
                  ],
                ),
              ),
              CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/images/avatar1.png',
                ),
                backgroundColor: Colors.white,
                radius: 30,
              ),
              Container(
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'First Name',
                  ),
                ),
              ),
              Container(
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Last Name',
                  ),
                ),
              ),
              Container(
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Phone Number',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
