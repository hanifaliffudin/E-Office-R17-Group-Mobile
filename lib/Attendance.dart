import 'package:flutter/material.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor:
              Theme.of(context).floatingActionButtonTheme.backgroundColor,
          title: Text(
            'Attendance'.toUpperCase(),
            style: TextStyle(fontSize: 15),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 10, bottom: 15, right: 15, left: 15),
          child: Column(
            children: [
              SizedBox(
                height: 78,
                width: 500,
                child: InkWell(
                  onTap: () {
                    // Navigator.push(context,
                    //   MaterialPageRoute(builder: (context) => DocumentPage()),
                    // );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 3),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('05-08-2022'),
                          Text('09:00'),
                          Text('Check In'),
                          Icon(
                              Icons.login_rounded,
                              color: Colors.green,
                              size: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 78,
                width: 500,
                child: InkWell(
                  onTap: () {
                    // Navigator.push(context,
                    //   MaterialPageRoute(builder: (context) => DocumentPage()),
                    // );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 3),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('05-08-2022'),
                          Text('19:00'),
                          Text('Check out'),
                          Icon(
                              Icons.logout_rounded,
                              color: Colors.red,
                              size: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
