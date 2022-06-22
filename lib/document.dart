import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:militarymessenger/PinVerification.dart';
import 'package:militarymessenger/models/BadgeModel.dart';
import 'package:militarymessenger/models/SuratModel.dart';
import 'package:militarymessenger/objectbox.g.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pinput/pinput.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'main.dart' as mains;
import 'Home.dart' as homes;


class DocumentPage extends StatefulWidget {
  SuratModel? surat;

  DocumentPage(this.surat);

  @override
  State<DocumentPage> createState() => _DocumentPageState(surat);
}

class _DocumentPageState extends State<DocumentPage> {
  SuratModel? surat;

  _DocumentPageState(this.surat);

  List<Approver> cardApprover = [];
  List listApprover = [];

  int groupValue = 0;
  bool detailVisible = true;
  bool editorVisible = false;
  bool approverVisible = false;

  TextEditingController inputTextControllerApprove = new TextEditingController();
  TextEditingController inputTextControllerReturn = new TextEditingController();
  TextEditingController inputTextControllerReject = new TextEditingController();

  void initState() {
    if(surat!.approver != null){
      listApprover = jsonDecode(surat!.approver!);
      for(int i=0;i<listApprover.length;i++){
        var dataApprover = Map<String, dynamic>.from(listApprover[i]);
        cardApprover.add(
            Approver(
              name: dataApprover['name'],
              status: dataApprover['status'],
            )
        );
      }
    }

    super.initState();
  }

    Future<String> _createFileFromUint(Uint8List bytes, String nameFile) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File(
        "$dir/" + nameFile + ".pdf");
    await file.writeAsBytes(bytes);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 0,
        title: Text(surat!.perihal!,
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
                        child: surat!.kategori == 'inbox' ?
                        SfPdfViewer.network('http://eoffice.dev.digiprimatera.co.id/public/${surat!.url!}',
                          pageLayoutMode: PdfPageLayoutMode.single,
                          scrollDirection: PdfScrollDirection.horizontal,
                          interactionMode: PdfInteractionMode.selection,
                          onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                          if(surat!.kategori=='inbox')
                            readSurat(surat!.idSurat!);
                          },
                        )
                        :
                        SfPdfViewer.network('${surat!.url!}',
                          pageLayoutMode: PdfPageLayoutMode.single,
                          scrollDirection: PdfScrollDirection.horizontal,
                          onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                            if(surat!.kategori=='inbox')
                              readSurat(surat!.idSurat!);
                          },
                        ),
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
                                  Text(surat!.nomorSurat == null ? '-' : surat!.nomorSurat!,
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
                                    child: Text(surat!.perihal == null ? '-' : surat!.perihal!,
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
                                child: Icon(Icons.person),
                                radius: 18,
                              ),
                              SizedBox(width: 10,),
                              Text(surat!.editor! == null ? '': surat!.editor!,
                                style: TextStyle(
                                    fontSize: 14,
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
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: cardApprover.length,
                                itemBuilder: (BuildContext context, index)=>
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          child: Icon(Icons.person),
                                          radius: 18,
                                        ),
                                        SizedBox(width: 10,),
                                        SizedBox(
                                            width: 170,
                                            child: Text(
                                              cardApprover[index].name!,
                                              style: TextStyle(
                                                  fontSize: 14,
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
                                          primary:
                                          cardApprover[index].status! == 'Approved' ?
                                          Color(0xFFECFDF5)
                                          :
                                          cardApprover[index].status! == 'Rejected' ?
                                          Color(0xFFFFEBEA)
                                          :
                                          cardApprover[index].status! == 'Returned' ?
                                          Color(0xFFEAF6FF)
                                          :
                                          Color(0xFFECEFF1),
                                        ),
                                        child: Text(
                                          cardApprover[index].status!,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color:
                                              cardApprover[index].status! == 'Approved' ?
                                              Color(0xFF1FA463)
                                                  :
                                              cardApprover[index].status! == 'Rejected' ?
                                              Color(0xFFDC2626)
                                                  :
                                              cardApprover[index].status! == 'Returned' ?
                                              Color(0xFF2481CF)
                                                  :
                                              Color(0xFF94A3B8)
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                    )
                  ],
                ),
              ),
            ),
            mains.objectbox.boxSurat.get(surat!.id)!.kategori! == "needApprove"?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                controller: inputTextControllerReject,
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
                                    onPressed: () {
                                      if(inputTextControllerReject.text == ""){
                                        Flushbar(
                                          backgroundColor: Colors.red,
                                          message: 'Silahkan isi catatan terlebih dahulu',
                                          duration: Duration(seconds: 2),
                                        ).show(context);
                                      }else{
                                        EasyLoading.show(status: 'rejecting...');
                                        reject(surat!.idSurat!, inputTextControllerReject.text);
                                        inputTextControllerReject.clear();
                                      }
                                    },
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
                surat!.tipeSurat == 1 ?
                Container()
                    :
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
                                controller: inputTextControllerReturn,
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
                                    onPressed: () {
                                      if(inputTextControllerReturn.text == ""){
                                        Flushbar(
                                          backgroundColor: Colors.red,
                                          message: 'Silahkan isi catatan terlebih dahulu',
                                          duration: Duration(seconds: 2),
                                        ).show(context);
                                      }else{
                                        EasyLoading.show(status: 'returning...');
                                        returnSurat(surat!.idSurat!, inputTextControllerReturn.text);
                                        inputTextControllerReturn.clear();
                                      }
                                    },
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
                                      image: AssetImage('assets/icons/approve.png')
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
                                controller: inputTextControllerApprove,
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
                                    onPressed: () {
                                      if(inputTextControllerApprove.text == ""){
                                        Flushbar(
                                          backgroundColor: Colors.red,
                                          message: 'Silahkan isi catatan terlebih dahulu',
                                          duration: Duration(seconds: 2),
                                        ).show(context);
                                      }else{
                                        EasyLoading.show(status: 'approving...');
                                        approve(surat!.idSurat!, inputTextControllerApprove.text);
                                        inputTextControllerApprove.clear();
                                      }
                                    },
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
            )
                :
            mains.objectbox.boxSurat.get(surat!.id)!.kategori! == "needSign"?
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 1,
                  minWidth: MediaQuery.of(context).size.width ,
                  minHeight: 48,
                  maxHeight: 50
              ),
              child: ElevatedButton(
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                                onPressed: () {
                                  Navigator.pop(context);

                                  getOtp(surat!.idSurat!);

                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      insetPadding: EdgeInsets.symmetric(horizontal: 7),
                                      content: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('OTP',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24
                                            ),
                                          ),
                                          SizedBox(height: 20,),
                                          Scrollbar(
                                            child: buildPinPut(surat!.idSurat!),
                                          ),
                                          SizedBox(height: 20,),
                                        ],
                                      ),
                                    ),
                                  );
                                },
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
                    primary: Color(0xFF2481CF),
                    elevation: 0
                ),

                child: Text("Sign",
                  style: TextStyle(
                      color: Color(0xFFfffffF),
                      fontSize: 16
                  ),),
              ),
            )
                :
            mains.objectbox.boxSurat.get(surat!.id)!.kategori! == "approved"?
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 1,
                  minWidth: MediaQuery.of(context).size.width * 1,
                  minHeight: 48,
                  maxHeight: 50
              ),
              decoration: BoxDecoration(
                color: Color(0xFFECFDF5)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                      Icons.check,
                    color: Color(0xFF1FA463),
                    size: 16,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                      'Approved',
                    style: TextStyle(
                      color: Color(0xFF1FA463),
                      fontWeight: FontWeight.w600,
                      fontSize: 16
                    ),
                  ),
                ],
              )

            )
                :
            mains.objectbox.boxSurat.get(surat!.id)!.kategori! == "returned"?
            Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 1,
                    minWidth: MediaQuery.of(context).size.width * 1,
                    minHeight: 48,
                    maxHeight: 50
                ),
                decoration: BoxDecoration(
                    color: Color(0xFFeaf6ff)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check,
                      color: Color(0xFF2481cf),
                      size: 16,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Returned',
                      style: TextStyle(
                          color: Color(0xFF2481cf),
                          fontWeight: FontWeight.w600,
                          fontSize: 16
                      ),
                    ),
                  ],
                )

            )
                :
            mains.objectbox.boxSurat.get(surat!.id)!.kategori! == "rejected"?
            Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 1,
                    minWidth: MediaQuery.of(context).size.width * 1,
                    minHeight: 48,
                    maxHeight: 50
                ),
                decoration: BoxDecoration(
                    color: Color(0xFFffebea)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.clear,
                      color: Color(0xFFdc2626),
                      size: 16,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Rejected',
                      style: TextStyle(
                          color: Color(0xFFdc2626),
                          fontWeight: FontWeight.w600,
                          fontSize: 16
                      ),
                    ),
                  ],
                )

            )
                :
            mains.objectbox.boxSurat.get(surat!.id)!.kategori! == "signed"?
            Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 1,
                    minWidth: MediaQuery.of(context).size.width * 1,
                    minHeight: 48,
                    maxHeight: 50
                ),
                decoration: BoxDecoration(
                    color: Color(0xFFECFDF5)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check,
                      color: Color(0xFF1FA463),
                      size: 16,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Signed',
                      style: TextStyle(
                          color: Color(0xFF1FA463),
                          fontWeight: FontWeight.w600,
                          fontSize: 16
                      ),
                    ),
                  ],
                )

            )
                :
            Container()
            ,
            SizedBox(height: 5,),
            mains.objectbox.boxSurat.get(surat!.id)!.kategori! == "needApprove"?
            Container()
                :
            mains.objectbox.boxSurat.get(surat!.id)!.kategori! == "approved"?
            Container()
                :
            mains.objectbox.boxSurat.get(surat!.id)!.kategori! == "returned"?
            Container()
                :
            mains.objectbox.boxSurat.get(surat!.id)!.kategori! == "rejected"?
            Container()
                :
            ElevatedButton.icon(
              onPressed: (){
                EasyLoading.show(status: 'loading...');
                download(surat!.idSurat!, surat!.perihal!);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width, 40) ,
                  primary: Color(0xFF1FA463),
                  elevation: 0,
              ),
              icon: Icon(
                  Icons.download_rounded,
                  size: 13,
                  color: Colors.white
              ),
              label: Text("Download",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),),
            )
          ],
        ),
      ),
    );

  }

  Widget buildPinPut(String id_surat) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Pinput(
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      length: 6,
      onCompleted: (pin) {
        EasyLoading.show(status: 'loading...');
        signing(id_surat, pin);
        },
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

  Future<http.Response> approve(String id_surat, String catatan) async {

    String url ='http://eoffice.dev.digiprimatera.co.id/api/approve';

    Map<String, dynamic> data = {
      'payload': {
        'id_surat': id_surat,
        'id_user': mains.objectbox.boxUser.get(1)!.userId,
        'catatan': catatan,
      }
    };

    //encode Map to JSON
    //var body = "?api_key="+this.apiKey;

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );
    if(response.statusCode == 200){
      Map<String, dynamic> approveMap = jsonDecode(response.body);

      if(approveMap['code'] == 0){
          var query = mains.objectbox.boxSurat.query(SuratModel_.idSurat.equals(id_surat)).build();
          if(query.find().isNotEmpty) {
            final surat = SuratModel(
              id: query.find().first.id,
              idSurat: query.find().first.idSurat,
              namaSurat: query.find().first.namaSurat,
              nomorSurat: query.find().first.nomorSurat,
              editor: query.find().first.editor,
              perihal: query.find().first.perihal,
              status: query.find().first.status,
              tglSelesai: query.find().first.tglSelesai,
              url: query.find().first.url,
              kategori: 'approved',
              tglBuat: query.find().first.tglBuat,
              tipeSurat: query.find().first.tipeSurat,
              approver: query.find().first.approver,
              penerima: query.find().first.penerima,
            );

            mains.objectbox.boxSurat.put(surat);
            setState(() {});
            EasyLoading.showSuccess('Berhasil approve!');
            Navigator.pop(context);
          }
        }
      else{
        EasyLoading.showError(approveMap['message']);
        print(approveMap['code']);
      }
    }
    else{
      EasyLoading.showError('${response.statusCode}, Gagal terhubung ke server!');
    }
    return response;
  }

  Future<http.Response> returnSurat(String id_surat, String catatan) async {

    String url ='http://eoffice.dev.digiprimatera.co.id/api/return';

    Map<String, dynamic> data = {
      'payload': {
        'id_surat': id_surat,
        'id_user': mains.objectbox.boxUser.get(1)!.userId,
        'catatan': catatan,
      }
    };

    //encode Map to JSON
    //var body = "?api_key="+this.apiKey;

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );
    if(response.statusCode == 200){
      Map<String, dynamic> returnMap = jsonDecode(response.body);

      if(returnMap['code'] != 95){
        if(returnMap['code'] == 0){
          var query = mains.objectbox.boxSurat.query(SuratModel_.idSurat.equals(id_surat)).build();
          if(query.find().isNotEmpty) {
            final surat = SuratModel(
              id: query.find().first.id,
              idSurat: query.find().first.idSurat,
              namaSurat: query.find().first.namaSurat,
              nomorSurat: query.find().first.nomorSurat,
              editor: query.find().first.editor,
              perihal: query.find().first.perihal,
              status: query.find().first.status,
              tglSelesai: query.find().first.tglSelesai,
              url: query.find().first.url,
              kategori: 'returned',
              tglBuat: query.find().first.tglBuat,
              tipeSurat: query.find().first.tipeSurat,
              approver: query.find().first.approver,
              penerima: query.find().first.penerima,
            );

            mains.objectbox.boxSurat.put(surat);
            setState(() {});
            EasyLoading.showSuccess('Berhasil return!');
            Navigator.pop(context);
          }
        }else{
          EasyLoading.showError(returnMap['message']);
        }
      }
      else{
        EasyLoading.showError(returnMap['message']);
        print(returnMap['code']);
      }
    }
    else{
      EasyLoading.showError('${response.statusCode}, Gagal terhubung ke server!');
    }
    return response;
  }

  Future<http.Response> reject(String id_surat, String catatan) async {

    String url ='http://eoffice.dev.digiprimatera.co.id/api/reject';

    Map<String, dynamic> data = {
      'payload': {
        'id_surat': id_surat,
        'id_user': mains.objectbox.boxUser.get(1)!.userId,
        'catatan': catatan,
      }
    };

    //encode Map to JSON
    //var body = "?api_key="+this.apiKey;

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );
    if(response.statusCode == 200){
      Map<String, dynamic> rejectMap = jsonDecode(response.body);

      if(rejectMap['code'] == 0){
          var query = mains.objectbox.boxSurat.query(SuratModel_.idSurat.equals(id_surat)).build();
          if(query.find().isNotEmpty) {
            final surat = SuratModel(
              id: query.find().first.id,
              idSurat: query.find().first.idSurat,
              namaSurat: query.find().first.namaSurat,
              nomorSurat: query.find().first.nomorSurat,
              editor: query.find().first.editor,
              perihal: query.find().first.perihal,
              status: query.find().first.status,
              tglSelesai: query.find().first.tglSelesai,
              url: query.find().first.url,
              kategori: 'rejected',
              tglBuat: query.find().first.tglBuat,
              tipeSurat: query.find().first.tipeSurat,
              approver: query.find().first.approver,
              penerima: query.find().first.penerima,
            );

            mains.objectbox.boxSurat.put(surat);
            setState(() {});
            EasyLoading.showSuccess('Berhasil reject!');
            Navigator.pop(context);
          }
        }
      else{
        EasyLoading.showError(rejectMap['message']);
        print(rejectMap['code']);
        print(rejectMap['message']);
      }
    }
    else{
      EasyLoading.showError('${response.statusCode}, Gagal terhubung ke server!');
    }
    return response;
  }

  Future<http.Response> readSurat(String id_surat) async {

    String url ='http://eoffice.dev.digiprimatera.co.id/api/reader';

    Map<String, dynamic> data = {
      'payload': {
        'id_surat': id_surat,
        'id_user': mains.objectbox.boxUser.get(1)!.userId,
      }
    };

    //encode Map to JSON
    //var body = "?api_key="+this.apiKey;

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );
    if(response.statusCode == 200){
      Map<String, dynamic> approveMap = jsonDecode(response.body);

      if(approveMap['code'] == 0){}
      else{
        print(approveMap['code']);
        print(approveMap['message']);
      }
    }
    else{
      print("Gagal terhubung ke server!");
      print(response.statusCode);
    }
    return response;
  }

  Future<http.Response> download(String id_surat, String nama_surat) async {

    String url ='http://eoffice.dev.digiprimatera.co.id/api/download';

    Map<String, dynamic> data = {
      'payload': {
        'id_user': mains.objectbox.boxUser.get(1)!.userId,
        'id_surat': id_surat,
      }
    };

    //encode Map to JSON
    //var body = "?api_key="+this.apiKey;

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );
    if(response.statusCode == 200){
      Map<String, dynamic> downloadMap = jsonDecode(response.body);

      if(downloadMap['code'] == 0){
          EasyLoading.dismiss();
          var contentFile = _createFileFromUint(base64.decode(downloadMap['data']), nama_surat);
          OpenFile.open(await contentFile);
      }
      else{
        print(downloadMap['code']);
        print(downloadMap['message']);
        print(response.statusCode);
        EasyLoading.showError(downloadMap['message']);
      }
    }
    else{
      EasyLoading.showError("${response.statusCode}, Gagal terhubung ke server!");
    }
    return response;
  }

  Future<http.Response> getOtp(String id_surat) async {
    EasyLoading.showToast('Sending OTP');

    String url ='http://eoffice.dev.digiprimatera.co.id/api/getOtp';

    Map<String, dynamic> data = {
      'payload': {
        'users_id': mains.objectbox.boxUser.get(1)!.userId,
        'surat_id': id_surat,
      }
    };

    //encode Map to JSON
    //var body = "?api_key="+this.apiKey;

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );
    if(response.statusCode == 200){
      Map<String, dynamic> otpMap = jsonDecode(response.body);

      if(otpMap['code'] == 0){
          EasyLoading.show(status: 'loading...');
          signing(id_surat, otpMap['otp']);
        }
      else{
        EasyLoading.showError(otpMap['message']);
        print(otpMap['code']);
        print(otpMap['message']);
        print(response.statusCode);
      }
    }
    else{
      print("Gagal terhubung ke server!");
      print(response.statusCode);
    }
    return response;
  }

  Future<http.Response> signing(String id_surat, String token) async {

    String url ='http://eoffice.dev.digiprimatera.co.id/api/signing';

    Map<String, dynamic> data = {
      'payload': {
        'users_id': mains.objectbox.boxUser.get(1)!.userId,
        'surat_id': id_surat,
        "token": token,
      }
    };

    //encode Map to JSON
    //var body = "?api_key="+this.apiKey;

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );
    if(response.statusCode == 200){
      Map<String, dynamic> signingMap = jsonDecode(response.body);

      if(signingMap['code'] == 0){
        print(signingMap['data']);
          var query = mains.objectbox.boxSurat.query(SuratModel_.idSurat.equals(id_surat)).build();
          if(query.find().isNotEmpty) {
            final surat = SuratModel(
              id: query.find().first.id,
              idSurat: query.find().first.idSurat,
              namaSurat: query.find().first.namaSurat,
              nomorSurat: query.find().first.nomorSurat,
              editor: query.find().first.editor,
              perihal: query.find().first.perihal,
              status: query.find().first.status,
              tglSelesai: query.find().first.tglSelesai,
              url: signingMap['data'],
              kategori: 'signed',
              tglBuat: query.find().first.tglBuat,
              tipeSurat: query.find().first.tipeSurat,
              approver: query.find().first.approver,
              penerima: query.find().first.penerima,
            );

            mains.objectbox.boxSurat.put(surat);
            setState(() {});
            setState(() {});
            EasyLoading.showSuccess('Berhasil Signing!');
            Navigator.pop(context);
          }
        }
      else{
        // print(signingMap['code']);
        print(signingMap['message']);
        // print(response.statusCode);
        EasyLoading.showError(signingMap['message']);
      }
    }
    else{
      EasyLoading.showError("${response.statusCode}, Gagal terhubung ke server!");
    }
    return response;
  }

}

class Approver{
  String? name;
  String? status;

  Approver({this.name, this.status});
}