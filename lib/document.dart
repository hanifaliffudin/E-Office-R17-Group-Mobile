import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:militarymessenger/Signed.dart';
import 'package:militarymessenger/models/SuratModel.dart';
import 'package:militarymessenger/objectbox.g.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'main.dart' as mains;


class DocumentPage extends StatefulWidget {
  SuratModel? surat;

  DocumentPage(this.surat, {Key? key}) : super(key: key);

  @override
  State<DocumentPage> createState() => _DocumentPageState(surat);
}

class _DocumentPageState extends State<DocumentPage> {
  SuratModel? surat;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _pinPutFocusNode = FocusNode();

  _DocumentPageState(this.surat);

  List<Approver> cardApprover = [];
  List listApprover = [];

  int groupValue = 0;
  bool detailVisible = true;
  bool editorVisible = false;
  bool approverVisible = false;

  TextEditingController inputTextControllerApprove = TextEditingController();
  TextEditingController inputTextControllerReturn = TextEditingController();
  TextEditingController inputTextControllerCancel = TextEditingController();

  @override
  void initState() {
    _pinPutFocusNode.requestFocus();

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
      key: _scaffoldKey,
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 0,
        title: Text(surat!.perihal!,
          style: const TextStyle(
              fontSize: 16
          ),),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 15, right: 15, left: 15),
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
                      color: const Color(0xFFD1D1D6),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                          child: surat!.kategori == 'inbox' ?
                          const PDF(
                            enableSwipe: true,
                            swipeHorizontal: true,
                            autoSpacing: false,
                            pageFling: false,
                          ).cachedFromUrl(
                            'https://eoffice.dev.digiprimatera.co.id/public/${surat!.url!}',
                            placeholder: (progress) => Center(child: Text('$progress %')),
                            errorWidget: (error) => Center(child: Text(error.toString())),
                            whenDone: (done) {
                                if(surat!.status == '1'){
                                  readSurat(surat!.idSurat!);
                                }
                              },
                          )
                        :
                          const PDF(
                            enableSwipe: true,
                            swipeHorizontal: true,
                            autoSpacing: false,
                            pageFling: false,
                          ).cachedFromUrl(
                            surat!.url!,
                            placeholder: (progress) => Center(child: Text('$progress %')),
                            errorWidget: (error) => Center(child: Text(error.toString())),
                          ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    CupertinoSegmentedControl<int>(
                      padding: const EdgeInsets.all(8),
                      groupValue: groupValue,
                      selectedColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
                      unselectedColor: Theme.of(context).cardTheme.color,
                      borderColor: Theme.of(context).scaffoldBackgroundColor,
                      pressedColor: const Color(0xFFF8FAFC),
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
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: const [
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
                                  const SizedBox(width: 10,),
                                  Text(surat!.nomorSurat == null ? '-' : surat!.nomorSurat!,
                                    style: const TextStyle(
                                        fontSize: 12
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height:20),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: const [
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
                                  const SizedBox(width: 10,),
                                  SizedBox(
                                    width: 200,
                                    child: Text(surat!.perihal == null ? '-' : surat!.perihal!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 1,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 20,),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: const [
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
                                  const SizedBox(width: 10,),
                                  const Text('-',
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
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                child: Icon(Icons.person),
                                radius: 18,
                              ),
                              const SizedBox(width: 10,),
                              Text(surat!.editor == null ? '' : surat!.editor! ,
                                style: const TextStyle(
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
                          padding: const EdgeInsets.all(15),
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
                                        const CircleAvatar(
                                          child: Icon(Icons.person),
                                          radius: 18,
                                        ),
                                        const SizedBox(width: 10,),
                                        SizedBox(
                                            width: 170,
                                            child: Text(
                                              cardApprover[index].name!,
                                              style: const TextStyle(
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
                                          const Color(0xFFECFDF5)
                                          :
                                          cardApprover[index].status! == 'Canceled' ?
                                          const Color(0xFFFFEBEA)
                                          :
                                          cardApprover[index].status! == 'Returned' ?
                                          const Color(0xFFEAF6FF)
                                          :
                                          const Color(0xFFECEFF1),
                                        ),
                                        child: Text(
                                          cardApprover[index].status!,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color:
                                              cardApprover[index].status! == 'Approved' ?
                                              const Color(0xFF1FA463)
                                                  :
                                              cardApprover[index].status! == 'Canceled' ?
                                              const Color(0xFFDC2626)
                                                  :
                                              cardApprover[index].status! == 'Returned' ?
                                              const Color(0xFF2481CF)
                                                  :
                                              const Color(0xFF94A3B8)
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
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/icons/reject.png')
                                  )
                              ),
                            ),
                            const SizedBox(height: 10,),
                            const Text('Are you sure?',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text('Do you really want to cancel this document?',
                              style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 12
                              ),
                            ),
                            const SizedBox(height: 10,),
                            const Text('Please explain your reason for canceling this document or add some corrective notes :',
                              style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 12,
                                  height: 1.5
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10,),
                            Scrollbar(
                              child: TextField(
                                controller: inputTextControllerCancel,
                                maxLines: 4,
                                cursorColor: Colors.grey,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                          color: const Color(0xFF029FE6)
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
                                      color: const Color(0xFF029FE6),
                                      borderRadius: BorderRadius.circular(6)
                                  ),
                                  width: 100,
                                  child: TextButton(
                                    onPressed: () {
                                      if(inputTextControllerCancel.text == ""){
                                        Flushbar(
                                          backgroundColor: Colors.red,
                                          message: 'Silahkan isi catatan terlebih dahulu',
                                          duration: const Duration(seconds: 2),
                                        ).show(context);
                                      }else{
                                        EasyLoading.show(status: 'canceling...');
                                        cancel(surat!.idSurat!, inputTextControllerCancel.text);
                                        inputTextControllerCancel.clear();
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
                      primary: const Color(0xFFDC2626),
                      elevation: 0,
                    ),
                    icon: const Icon(
                      Icons.close,
                      size: 13,
                      color: Colors.white,),
                    label: const Text("Cancel",
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
                      color: const Color(0xFF029FE6),
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
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/icons/return.png')
                                  )
                              ),
                            ),
                            const SizedBox(height: 10,),
                            const Text('Are you sure?',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text('Do you really want to return this document?',
                              style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 12
                              ),
                            ),
                            const SizedBox(height: 10,),
                            const Text('Please explain your reason for returning this document or add some corrective notes :',
                              style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 12,
                                  height: 1.5
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10,),
                            Scrollbar(
                              child: TextField(
                                controller: inputTextControllerReturn,
                                maxLines: 4,
                                cursorColor: Colors.grey,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                          color: const Color(0xFF029FE6)
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
                                      color: const Color(0xFF029FE6),
                                      borderRadius: BorderRadius.circular(6)
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      if(inputTextControllerReturn.text == ""){
                                        Flushbar(
                                          backgroundColor: Colors.red,
                                          message: 'Silahkan isi catatan terlebih dahulu',
                                          duration: const Duration(seconds: 2),
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
                    icon: const Icon(
                        Icons.undo_rounded,
                        size: 13,
                        color: Color(0xFF2481CF)
                    ),
                    label: const Text("Return",
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
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/icons/approve.png')
                                  )
                              ),
                            ),
                            const SizedBox(height: 10,),
                            const Text('Are you sure?',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text('Do you really want to approve this document?',
                              style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 12
                              ),
                            ),
                            const SizedBox(height: 10,),
                            const Text('Please explain your reason for approving this document or add some corrective notes :',
                              style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 12,
                                  height: 1.5
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10,),
                            Scrollbar(
                              child: TextField(
                                maxLines: 4,
                                controller: inputTextControllerApprove,
                                cursorColor: Colors.grey,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                          color: const Color(0xFF029FE6)
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
                                      color: const Color(0xFF029FE6),
                                      borderRadius: BorderRadius.circular(6)
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                        EasyLoading.show(status: 'approving...');
                                        approve(surat!.idSurat!, inputTextControllerApprove.text);
                                        inputTextControllerApprove.clear();
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
                        primary: const Color(0xFF1FA463),
                        elevation: 0
                    ),
                    icon: const Icon(
                        Icons.check,
                        size: 13,
                        color: Colors.white
                    ),
                    label: const Text("Approve",
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
                        const SizedBox(height: 10,),
                        const Text('Are you sure?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: const Color(0xFF029FE6)
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
                                  color: const Color(0xFF029FE6),
                                  borderRadius: BorderRadius.circular(6)
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);

                                  if(surat!.jenisSurat == 'Internal'){

                                    getOtpBulk(surat!.idSurat!);

                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                        insetPadding: const EdgeInsets.symmetric(horizontal: 7),
                                        content: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text('OTP',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24
                                              ),
                                            ),
                                            const SizedBox(height: 20,),
                                            Scrollbar(
                                              child: buildPinPut(surat!.idSurat!),
                                            ),
                                            const SizedBox(height: 20,),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  else if(surat!.jenisSurat == 'External'){

                                    List otpData = await getOtpBulkEksternal(surat!.idSurat!);

                                    EasyLoading.dismiss();

                                    showDialog<String>(
                                      context: _scaffoldKey.currentContext!,
                                      builder: (BuildContext context) => AlertDialog(
                                        insetPadding: const EdgeInsets.symmetric(horizontal: 7),
                                        content: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text('OTP',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24
                                              ),
                                            ),
                                            const SizedBox(height: 20,),
                                            Scrollbar(
                                              child: buildPinPutEksternal(surat!.idSurat!, otpData[0], otpData[1]),
                                            ),
                                            const SizedBox(height: 20,),
                                          ],
                                        ),
                                      ),
                                    );
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
                    primary: const Color(0xFF2481CF),
                    elevation: 0
                ),

                child: const Text("Sign",
                  style: TextStyle(
                      color: Color(0xFFfffffF),
                      fontSize: 16
                  ),),
              ),
            )
                :
            mains.objectbox.boxSurat.get(surat!.id)!.kategori! == "approved" || (mains.objectbox.boxSurat.get(surat!.id)!.kategori! == 'history' && mains.objectbox.boxSurat.get(surat!.id)!.status == 'APPROVE') ?
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 1,
                  minWidth: MediaQuery.of(context).size.width * 1,
                  minHeight: 48,
                  maxHeight: 50
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFECFDF5)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
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
            mains.objectbox.boxSurat.get(surat!.id)!.kategori! == "returned" || (mains.objectbox.boxSurat.get(surat!.id)!.kategori! == 'history' && mains.objectbox.boxSurat.get(surat!.id)!.status == 'RETURN') ?
            Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 1,
                    minWidth: MediaQuery.of(context).size.width * 1,
                    minHeight: 48,
                    maxHeight: 50
                ),
                decoration: const BoxDecoration(
                    color: Color(0xFFeaf6ff)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
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
            mains.objectbox.boxSurat.get(surat!.id)!.kategori! == "canceled" || (mains.objectbox.boxSurat.get(surat!.id)!.kategori! == 'history' && mains.objectbox.boxSurat.get(surat!.id)!.status == 'REJECT') ?
            Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 1,
                    minWidth: MediaQuery.of(context).size.width * 1,
                    minHeight: 48,
                    maxHeight: 50
                ),
                decoration: const BoxDecoration(
                    color: Color(0xFFffebea)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.clear,
                      color: Color(0xFFdc2626),
                      size: 16,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Canceled',
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
                decoration: const BoxDecoration(
                    color: Color(0xFFECFDF5)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
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
            const SizedBox(height: 5,),
            mains.objectbox.boxSurat.get(surat!.id)!.kategori! == "needApprove"?
            Container()
                :
            mains.objectbox.boxSurat.get(surat!.id)!.kategori! == "approved" || (mains.objectbox.boxSurat.get(surat!.id)!.kategori! == 'history' && mains.objectbox.boxSurat.get(surat!.id)!.status == 'APPROVE') ?
            Container()
                :
            mains.objectbox.boxSurat.get(surat!.id)!.kategori! == "returned" || (mains.objectbox.boxSurat.get(surat!.id)!.kategori! == 'history' && mains.objectbox.boxSurat.get(surat!.id)!.status == 'RETURN') ?
            Container()
                :
            mains.objectbox.boxSurat.get(surat!.id)!.kategori! == "canceled" || (mains.objectbox.boxSurat.get(surat!.id)!.kategori! == 'history' && mains.objectbox.boxSurat.get(surat!.id)!.status == 'REJECT') ?
            Container()
                :
            ElevatedButton.icon(
              onPressed: (){
                EasyLoading.show(status: 'loading...');
                download(surat!.idSurat!, surat!.perihal!);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width, 40) ,
                  primary: const Color(0xFF1FA463),
                  elevation: 0,
              ),
              icon: const Icon(
                  Icons.download_rounded,
                  size: 13,
                  color: Colors.white
              ),
              label: const Text("Download",
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

  Widget buildPinPut(String idSurat) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Pinput(
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      length: 6,
      focusNode: _pinPutFocusNode,
      onCompleted: (pin) {
        EasyLoading.show(status: 'loading...');
        // signingBulk(pin, , idSurat);
        },
    );
  }

  Widget buildPinPutEksternal(String idSurat, String token, String bulkId) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Pinput(
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      length: 6,
      focusNode: _pinPutFocusNode,
      onCompleted: (otp) {
        EasyLoading.show(status: 'loading...');
        signingBulkEksternal(token, bulkId, otp, idSurat);
        },
    );
  }

  Widget buildSegment(String text){
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 1,
        minWidth: MediaQuery.of(context).size.width * 1,
      ),
      padding: const EdgeInsets.all(12),
      child: Text(text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }

  Future<http.Response> approve(String idSurat, String catatan) async {

    String url ='https://eoffice.dev.digiprimatera.co.id/api/approve';

    Map<String, dynamic> data = {
      'payload': {
        'id_surat': idSurat,
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
          var query = mains.objectbox.boxSurat.query(SuratModel_.idSurat.equals(idSurat)).build();
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
              isSelected: query.find().first.isSelected,
              isMeterai: query.find().first.isMeterai,
              jenisSurat: query.find().first.jenisSurat,
            );

            mains.objectbox.boxSurat.put(surat);
            setState(() {});
            EasyLoading.showSuccess('Berhasil approve!');
            Navigator.pop(context);
          }
        }
      else{
        EasyLoading.showError(approveMap['message'].toString());
      }
    }
    else{
      EasyLoading.showError('${response.statusCode}, Gagal terhubung ke server!');
    }
    return response;
  }

  Future<http.Response> returnSurat(String idSurat, String catatan) async {

    String url ='https://eoffice.dev.digiprimatera.co.id/api/return';

    Map<String, dynamic> data = {
      'payload': {
        'id_surat': idSurat,
        'id_user': mains.objectbox.boxUser.get(1)!.userId,
        'catatan': catatan,
      }
    };

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );
    if(response.statusCode == 200){
      Map<String, dynamic> returnMap = jsonDecode(response.body);

      if(returnMap['code'] != 95){
        if(returnMap['code'] == 0){
          var query = mains.objectbox.boxSurat.query(SuratModel_.idSurat.equals(idSurat)).build();
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
              isSelected: query.find().first.isSelected,
              isMeterai: query.find().first.isMeterai,
              jenisSurat: query.find().first.jenisSurat,
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
      }
    }
    else{
      EasyLoading.showError('${response.statusCode}, Gagal terhubung ke server!');
    }
    return response;
  }

  Future<http.Response> cancel(String idSurat, String catatan) async {

    String url ='https://eoffice.dev.digiprimatera.co.id/api/reject';

    Map<String, dynamic> data = {
      'payload': {
        'id_surat': idSurat,
        'id_user': mains.objectbox.boxUser.get(1)!.userId,
        'catatan': catatan,
      }
    };

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );
    if(response.statusCode == 200){
      Map<String, dynamic> rejectMap = jsonDecode(response.body);

      if(rejectMap['code'] == 0){
          var query = mains.objectbox.boxSurat.query(SuratModel_.idSurat.equals(idSurat)).build();
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
              kategori: 'canceled',
              tglBuat: query.find().first.tglBuat,
              tipeSurat: query.find().first.tipeSurat,
              approver: query.find().first.approver,
              penerima: query.find().first.penerima,
              isSelected: query.find().first.isSelected,
              isMeterai: query.find().first.isMeterai,
              jenisSurat: query.find().first.jenisSurat,
            );

            mains.objectbox.boxSurat.put(surat);
            setState(() {});
            EasyLoading.showSuccess('Berhasil cancel!');
            Navigator.pop(context);
          }
        }
      else{
        EasyLoading.showError(rejectMap['message']);
      }
    }
    else{
      EasyLoading.showError('${response.statusCode}, Gagal terhubung ke server!');
    }
    return response;
  }

  Future<http.Response> readSurat(String idSurat) async {

    String url ='https://eoffice.dev.digiprimatera.co.id/api/reader';

    Map<String, dynamic> data = {
      'payload': {
        'id_surat': idSurat,
        'id_user': mains.objectbox.boxUser.get(1)!.userId,
      }
    };

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );
    if(response.statusCode == 200){
      Map<String, dynamic> readMap = jsonDecode(response.body);

      if(readMap['code'] == 0){
      }
      else{
        EasyLoading.showError(readMap['message']);
      }
    }
    else{
      EasyLoading.showError('${response.statusCode}, Gagal terhubung ke server!');
    }
    return response;
  }

  Future<http.Response> download(String idSurat, String namaSurat) async {

    String url ='https://eoffice.dev.digiprimatera.co.id/api/download';

    Map<String, dynamic> data = {
      'payload': {
        'id_user': mains.objectbox.boxUser.get(1)!.userId,
        'id_surat': idSurat,
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
          var contentFile = _createFileFromUint(base64.decode(downloadMap['data']), namaSurat);
          OpenFile.open(await contentFile);
      }
      else{
        EasyLoading.showError(downloadMap['message']);
      }
    }
    else{
      EasyLoading.showError("${response.statusCode}, Gagal terhubung ke server!");
    }
    return response;
  }

  Future<http.Response> getOtpBulk(String idSurat) async {
    EasyLoading.showToast('Sending OTP');

    String url ='https://eoffice.dev.digiprimatera.co.id/api/getOtpBulk';

    Map<String, dynamic> data = {
      'payload': {
        'users_id': mains.objectbox.boxUser.get(1)!.userId.toString(),
        'surat': [{"id": idSurat}],
      }
    };

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );

    if(response.statusCode == 200){
      Map<String, dynamic> otpMap = jsonDecode(response.body);

      if(otpMap['code'] == 0){
        EasyLoading.show(status: 'loading...');
        signingBulk(otpMap['otp'], otpMap['bulkId'], idSurat);
      }
      else{
        EasyLoading.showError(otpMap['message']);
      }
    }
    else{
      EasyLoading.showError('${response.statusCode}, Gagal terhubung ke server!');
    }
    return response;
  }

  Future<http.Response> signingBulk(String otp, String bulkId, String idSurat) async {

    String url ='https://eoffice.dev.digiprimatera.co.id/api/bulkSigning';

    Map<String, dynamic> data = {
      'payload': {
        'users_id': mains.objectbox.boxUser.get(1)!.userId,
        'bulk_id': bulkId,
        "token": otp,
      }
    };

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );
    if(response.statusCode == 200){
      Map<String, dynamic> signingMap = jsonDecode(response.body);

      if(signingMap['code'] == 0){
        var query = mains.objectbox.boxSurat.query(SuratModel_.idSurat.equals(idSurat)).build();
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
            kategori: 'signed',
            tglBuat: query.find().first.tglBuat,
            tipeSurat: query.find().first.tipeSurat,
            approver: query.find().first.approver,
            penerima: query.find().first.penerima,
            isSelected: query.find().first.isSelected,
            isMeterai: query.find().first.isMeterai,
            jenisSurat: query.find().first.jenisSurat,
          );

          mains.objectbox.boxSurat.put(surat);

          EasyLoading.showSuccess('Silahkan menunggu antrian signing!');
          Navigator.pop(context);
          Navigator.pop(context);
          setState(() {});

        }
      }
      else{
        EasyLoading.showError(signingMap['message']);
      }
    }
    else{
      EasyLoading.showError("${response.statusCode}, Gagal terhubung ke server!");
    }
    return response;
  }

  Future<List> getOtpBulkEksternal(String idSurat) async {
    EasyLoading.show(status: 'Sending OTP');

    String url ='https://eoffice.dev.digiprimatera.co.id/api/otpSignEksternal';

    Map<String, dynamic> data = {
      'payload': {
        'users_id': mains.objectbox.boxUser.get(1)!.userId.toString(),
        'surat': [{"id": idSurat}],
      }
    };

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );

    if(response.statusCode == 200){
      Map<String, dynamic> otpMap = jsonDecode(response.body);

      if(otpMap['code'] == 0){
        return [otpMap['data']['token'], otpMap['data']['dataIdBulk']];
      }
      else{
        EasyLoading.showError(otpMap['message']);
      }
    }
    else{
      EasyLoading.showError('${response.statusCode}, Gagal terhubung ke server!');
    }
    // return response;
    return [];
  }

  Future<http.Response> signingBulkEksternal(String token, String bulkId, String otp, String idSurat) async {

    String url ='https://eoffice.dev.digiprimatera.co.id/api/signEksternalBulk';

    Map<String, dynamic> data = {
      'payload': {
        // 'users_id': mains.objectbox.boxUser.get(1)!.userId,
        'dataIdBulk': bulkId,
        'tokenCodeBulk': token,
        'otpCodeBulk': otp,
      }
    };

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );
    if(response.statusCode == 200){
      Map<String, dynamic> signingMap = jsonDecode(response.body);

      if(signingMap['code'] == 0){
        var query = mains.objectbox.boxSurat.query(SuratModel_.idSurat.equals(idSurat)).build();
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
            kategori: 'signed',
            tglBuat: query.find().first.tglBuat,
            tipeSurat: query.find().first.tipeSurat,
            approver: query.find().first.approver,
            penerima: query.find().first.penerima,
            isSelected: query.find().first.isSelected,
            isMeterai: query.find().first.isMeterai,
            jenisSurat: query.find().first.jenisSurat,
          );

          mains.objectbox.boxSurat.put(surat);

          EasyLoading.showSuccess('Silahkan menunggu antrian signing!');
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          setState(() {});

        }
      }
      else{
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