import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DocumentPage extends StatefulWidget {
  const DocumentPage({Key? key}) : super(key: key);

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  int groupValue = 0;
  bool detailVisible = true;
  bool editorVisible = false;
  bool approverVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 0,
        title: Text('Penunjukan Menteri Dalam Negeri.pdf',
          style: TextStyle(
              fontSize: 16
          ),),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10, bottom: 15, right: 15, left: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 470,
                      color: Color(0xFFD1D1D6),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SfPdfViewer.asset('assets/files/file.pdf',
                          pageLayoutMode: PdfPageLayoutMode.single,
                          scrollDirection: PdfScrollDirection.horizontal,),
                      ),
                    ),
                    SizedBox(height: 10,),
                    CupertinoSegmentedControl<int>(
                      padding: EdgeInsets.all(8),
                      groupValue: groupValue,
                      selectedColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
                      unselectedColor: Theme.of(context).cardTheme.color,
                      borderColor: Theme.of(context).scaffoldBackgroundColor,
                      pressedColor: Color(0xFFF8FAFC),
                      children: {
                        0: buildSegment(
                          'Detail'.toUpperCase(),
                        ),
                        1: buildSegment('Editor'.toUpperCase()),
                        2: buildSegment('Approver'.toUpperCase()
                        )
                      },
                      onValueChanged: (groupValue) {
                        setState(() {
                          this.groupValue = groupValue;
                          groupValue == 0
                              ? [detailVisible = true, editorVisible = false, approverVisible = false]
                              : groupValue == 1
                              ? [editorVisible = true, detailVisible = false, approverVisible = false]
                              : [approverVisible = true, detailVisible = false, editorVisible = false];
                        });
                      },
                    ),
                    Visibility(
                        visible: detailVisible,
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Nomor Surat',
                                          style: TextStyle(
                                              color: Color(0xFF94A3B8),
                                              fontSize: 12
                                          ),
                                        ),
                                        Text(':',
                                          style: TextStyle(
                                            color: Color(0xFF94A3B8),
                                            fontSize: 12,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Text('821.1/4837/SJ',
                                    style: TextStyle(
                                        fontSize: 12
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height:20),
                              Row(
                                children: [
                                  Container(
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Perihal',
                                          style: TextStyle(
                                            color: Color(0xFF94A3B8),
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(':',
                                          style: TextStyle(
                                            color: Color(0xFF94A3B8),
                                            fontSize: 12,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  SizedBox(
                                    width: 200,
                                    child: Text('Penunjukan Menteri Dalam Negeri Ad Interim',
                                      style: TextStyle(
                                        fontSize: 12,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 1,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                children: [
                                  Container(
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Lampiran',
                                          style: TextStyle(
                                            color: Color(0xFF94A3B8),
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(':',
                                          style: TextStyle(
                                            color: Color(0xFF94A3B8),
                                            fontSize: 12,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Text('-',
                                    style: TextStyle(
                                        fontSize: 12
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                    ),
                    Visibility(
                        visible: editorVisible,
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(
                                    'assets/images/avatar1.png'
                                ),
                                radius: 18,
                              ),
                              SizedBox(width: 10,),
                              Text('Nurul Rizal',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),
                        )
                    ),
                    Visibility(
                        visible: approverVisible,
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFF94A3B8)
                                        ),
                                        child: Text('1',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'assets/images/avatar1.png'
                                        ),
                                        radius: 18,
                                      ),
                                      SizedBox(width: 10,),
                                      SizedBox(
                                          width: 170,
                                          child: Text(
                                            'Dr. Ir. Muhammad Hudori, M.Si',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis
                                            ),
                                            maxLines: 1,
                                          )
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFFECFDF5),
                                      ),
                                      child: Text(
                                        'Approved',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF1FA463)
                                        ),
                                      )
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFF94A3B8)
                                        ),
                                        child: Text('2',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'assets/images/avatar2.png'
                                        ),
                                        radius: 18,
                                      ),
                                      SizedBox(width: 10,),
                                      SizedBox(
                                          width: 170,
                                          child: Text(
                                            'Dr. Ir. Lili, M.Si',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis
                                            ),
                                            maxLines: 1,
                                          )
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFFFFEBEA),
                                      ),
                                      child: Text(
                                        'Rejected',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFFDC2626)
                                        ),
                                      )
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFF94A3B8)
                                        ),
                                        child: Text('3',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'assets/images/avatar3.png'
                                        ),
                                        radius: 18,
                                      ),
                                      SizedBox(width: 10,),
                                      SizedBox(
                                          width: 170,
                                          child: Text(
                                            'Dr. Ir. H. Djuanda, M.Si',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis
                                            ),
                                            maxLines: 1,
                                          )
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFFEAF6FF),
                                      ),
                                      child: Text(
                                        'Returned',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF2481CF)
                                        ),
                                      )
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFF94A3B8)
                                        ),
                                        child: Text('4',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'assets/images/avatar1.png'
                                        ),
                                        radius: 18,
                                      ),
                                      SizedBox(width: 10,),
                                      SizedBox(
                                          width: 170,
                                          child: Text(
                                            'Dr. Ir. Hasannuddin, M.Si',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis
                                            ),
                                            maxLines: 1,
                                          )
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFFECEFF1),
                                      ),
                                      child: Text(
                                        'Pending',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF94A3B8)
                                        ),
                                      )
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                    )
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                      minWidth: MediaQuery.of(context).size.width * 0.3,
                      minHeight: 48,
                      maxHeight: 50
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/icons/reject.png')
                                  )
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text('Are you sure?',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Do you really want to reject this document?',
                              style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 12
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text('Please explain your reason for rejecting this document or add some corrective notes :',
                              style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 12,
                                  height: 1.5
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10,),
                            Scrollbar(
                              child: TextField(
                                maxLines: 4,
                                cursorColor: Colors.grey,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                          color: Color(0xFF029FE6)
                                      )
                                  ),
                                  child: TextButton(
                                    onPressed: () => Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel',
                                      style: TextStyle(
                                          color: Color(0xFF029FE6)
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFF029FE6),
                                      borderRadius: BorderRadius.circular(6)
                                  ),
                                  width: 100,
                                  child: TextButton(
                                    onPressed: () => Navigator.pop(context, 'Confirm'),
                                    child: const Text('Confirm',
                                      style: TextStyle(
                                          color: Colors.white
                                      ),),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFDC2626),
                      elevation: 0,
                    ),
                    icon: Icon(
                      Icons.close,
                      size: 13,
                      color: Colors.white,),
                    label: Text("Reject",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                      ),),
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 1,
                      minWidth: MediaQuery.of(context).size.width * 0.3,
                      minHeight: 48,
                      maxHeight: 50
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFF029FE6),
                    ),
                    borderRadius: BorderRadius.circular(4
                    ),),
                  child: ElevatedButton.icon(
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/icons/return.png')
                                  )
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text('Are you sure?',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Do you really want to return this document?',
                              style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 12
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text('Please explain your reason for returning this document or add some corrective notes :',
                              style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 12,
                                  height: 1.5
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10,),
                            Scrollbar(
                              child: TextField(
                                maxLines: 4,
                                cursorColor: Colors.grey,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                          color: Color(0xFF029FE6)
                                      )
                                  ),
                                  child: TextButton(
                                    onPressed: () => Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel',
                                      style: TextStyle(
                                          color: Color(0xFF029FE6)
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF029FE6),
                                      borderRadius: BorderRadius.circular(6)
                                  ),
                                  child: TextButton(
                                    onPressed: () => Navigator.pop(context, 'Confirm'),
                                    child: const Text('Confirm',
                                      style: TextStyle(
                                          color: Colors.white
                                      ),),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        elevation: 0
                    ),
                    icon: Icon(
                        Icons.undo_rounded,
                        size: 13,
                        color: Color(0xFF2481CF)
                    ),
                    label: Text("Return",
                      style: TextStyle(
                          color: Color(0xFF2481CF),
                          fontSize: 16
                      ),),
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 1,
                      minWidth: MediaQuery.of(context).size.width * 0.3,
                      minHeight: 48,
                      maxHeight: 50
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/icons/complete.png')
                                  )
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text('Are you sure?',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Do you really want to approve this document?',
                              style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 12
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text('Please explain your reason for approving this document or add some corrective notes :',
                              style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 12,
                                  height: 1.5
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10,),
                            Scrollbar(
                              child: TextField(
                                maxLines: 4,
                                cursorColor: Colors.grey,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                          color: Color(0xFF029FE6)
                                      )
                                  ),
                                  child: TextButton(
                                    onPressed: () => Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel',
                                      style: TextStyle(
                                          color: Color(0xFF029FE6)
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF029FE6),
                                      borderRadius: BorderRadius.circular(6)
                                  ),
                                  child: TextButton(
                                    onPressed: () => Navigator.pop(context, 'Confirm'),
                                    child: const Text('Confirm',
                                      style: TextStyle(
                                          color: Colors.white
                                      ),),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFF1FA463),
                        elevation: 0
                    ),
                    icon: Icon(
                        Icons.check,
                        size: 13,
                        color: Colors.white
                    ),
                    label: Text("Approve",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                      ),),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,)
          ],
        ),
      ),
    );

  }

  Widget buildSegment(String text){
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 1,
        minWidth: MediaQuery.of(context).size.width * 1,
      ),
      padding: EdgeInsets.all(12),
      child: Text(text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}
