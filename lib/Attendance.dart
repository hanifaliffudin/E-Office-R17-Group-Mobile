import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:militarymessenger/models/AttendanceModel.dart';
import 'package:militarymessenger/objectbox.g.dart';
import 'main.dart' as mains;

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  List<AttendanceModel> _attedanceList = [];

  @override
  void initState() {
    super.initState();

    QueryBuilder<AttendanceModel> query = mains.objectbox.boxAttendance.query()..order(AttendanceModel_.checkInAt, flags: Order.descending);
    _attedanceList = query.build().find().toList();
  }

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
        // body: SingleChildScrollView(
        //   padding: EdgeInsets.only(top: 10, bottom: 15, right: 15, left: 15),
        //   child: Column(
        //     children: [
        //       SizedBox(
        //         height: 78,
        //         width: 500,
        //         child: InkWell(
        //           onTap: () {
        //             // Navigator.push(context,
        //             //   MaterialPageRoute(builder: (context) => DocumentPage()),
        //             // );
        //           },
        //           child: Card(
        //             margin: EdgeInsets.symmetric(vertical: 3),
        //             child: Padding(
        //               padding: const EdgeInsets.all(10),
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 children: [
        //                   Text('05-08-2022'),
        //                   Text('09:00'),
        //                   Text('Check In'),
        //                   Icon(
        //                       Icons.login_rounded,
        //                       color: Colors.green,
        //                       size: 20,
        //                   )
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //       SizedBox(
        //         height: 78,
        //         width: 500,
        //         child: InkWell(
        //           onTap: () {
        //             // Navigator.push(context,
        //             //   MaterialPageRoute(builder: (context) => DocumentPage()),
        //             // );
        //           },
        //           child: Card(
        //             margin: EdgeInsets.symmetric(vertical: 3),
        //             child: Padding(
        //               padding: const EdgeInsets.all(10),
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 children: [
        //                   Text('05-08-2022'),
        //                   Text('19:00'),
        //                   Text('Check out'),
        //                   Icon(
        //                       Icons.logout_rounded,
        //                       color: Colors.red,
        //                       size: 20,
        //                   )
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // )
        body: ListView.builder(
          padding: EdgeInsets.only(top: 10, bottom: 15, right: 15, left: 15),
          itemCount: _attedanceList.length,
          itemBuilder: ((context, index) {
            return SizedBox(
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
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(_attedanceList[index].checkInAt!))),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 5.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 100.0,
                                      child: Text(
                                        'Check in',
                                        textAlign: TextAlign.end
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          DateFormat('HH:mm:ss').format(DateTime.parse(_attedanceList[index].checkInAt!)),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 100.0,
                                    child: Text(
                                      'Check out',
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _attedanceList[index].status == 0 ? DateFormat('HH:mm:ss').format(DateTime.parse(_attedanceList[index].checkOutAt!)) : '-',
                                        textAlign: TextAlign.center
                                      ),
                                    )
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _attedanceList[index].status == 1 ? const Icon(
                          Icons.login_rounded,
                          color: Colors.green,
                          size: 20,
                        ) : const Icon(
                          Icons.logout_rounded,
                          color: Colors.red,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
    );
  }
}
