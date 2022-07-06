import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:militarymessenger/models/AttendanceModel.dart';
import 'package:militarymessenger/objectbox.g.dart';
import 'main.dart' as mains;
import 'Home.dart' as homes;

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
            style: const TextStyle(fontSize: 15),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: StreamBuilder<List<AttendanceModel>>(
          stream: homes.listControlerAttendance.stream,
          builder: (context, snapshot) {
            QueryBuilder<AttendanceModel> query = mains.objectbox.boxAttendance.query()..order(AttendanceModel_.checkInAt, flags: Order.descending);
            _attedanceList = query.build().find().toList();

            return ListView.builder(
              padding: const EdgeInsets.only(
                top: 10, 
                bottom: 15, 
                right: 15, 
                left: 15
              ),
              itemCount: _attedanceList.length,
              itemBuilder: ((context, index) {
                return InkWell(
                  onTap: () {
                    // Navigator.push(context,
                    //   MaterialPageRoute(builder: (context) => DocumentPage()),
                    // );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    shadowColor: Colors.black,
                    child: ClipPath(
                      clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: _attedanceList[index].status == 1 ? Colors.blue : Colors.grey, 
                              width: 10,
                            ),
                          ),
                          color: Theme.of(context).cardColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14.0,
                            horizontal: 12.0,
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 5.0,
                                ),
                                child: Text(
                                  // DateFormat('dd-MM-yyyy').format(DateTime.parse(_attedanceList[index].checkInAt!)),
                                  _attedanceList[index].date!,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 5.0,
                                      ),
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 100.0,
                                            child: Text(
                                              'Check in',
                                              textAlign: TextAlign.end
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 10.0),
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
                                        const SizedBox(
                                          width: 100.0,
                                          child: Text(
                                            'Check out',
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10.0),
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
                                color: Colors.blue,
                                size: 24,
                              ) : const Icon(
                                Icons.logout_rounded,
                                color: Colors.grey,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
    );
  }
}
