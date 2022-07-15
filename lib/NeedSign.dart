import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/instance_manager.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:militarymessenger/controllers/state_controllers.dart';
import 'package:militarymessenger/document.dart';
import 'package:militarymessenger/models/GroupNotifModel.dart';
import 'package:militarymessenger/models/SuratModel.dart';
import 'package:militarymessenger/objectbox.g.dart';
import 'package:pinput/pinput.dart';
import 'main.dart' as mains;
import 'Home.dart' as homes;
import 'main.dart';

class NeedSign extends StatefulWidget {
  const NeedSign({Key? key}) : super(key: key);

  @override
  _NeedSignState createState() => _NeedSignState();
}

List<SuratModel> suratSelected = [];

class _NeedSignState extends State<NeedSign> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _pinPutFocusNode = FocusNode();
  final StateController _stateController = Get.put(StateController());
  late StreamSubscription<String> _documentCategoryListener;
  late StreamSubscription<String> _otpCodeSmsListener;
  final TextEditingController _pinPutInternalTextController = TextEditingController();
  final TextEditingController _pinPutEksternalTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _pinPutFocusNode.requestFocus();
    getNeedSign();
    _addDocumentCategoryListener();
    _removeNotifByType();
    _addOtpCodeSmsListener();
  }

  @override
  void dispose() {
    clearSelect();
    _removeDocumentCategoryListener();
    _removeOtpCodeSmsListener();

    super.dispose();
  }

  void _addDocumentCategoryListener() {
    _documentCategoryListener = _stateController.documentCategory.listen((p0) {
      if (p0 == 'needSign') {
        getNeedSign();
        _stateController.changeDocumentCategory('');
      }
    });
  }

  void _removeDocumentCategoryListener() {
    _documentCategoryListener.cancel();
  }

  void _addOtpCodeSmsListener() {
    _otpCodeSmsListener = _stateController.otpCodeSms.listen((p0) {
      if (p0 != '') {
        _pinPutEksternalTextController.setText(p0);
        _stateController.changeOtpCodeSms('');
      }
    });
  }

  void _removeOtpCodeSmsListener() {
    _otpCodeSmsListener.cancel();
  }

  void _removeNotifByType() {
    var query = mains.objectbox.boxGroupNotif.query(GroupNotifModel_.type.equals('dokumenneedSign')).build();

    if (query.find().isNotEmpty) {
      List<GroupNotifModel> groupNotifs = query.find().toList();

      for (var i = 0; i < groupNotifs.length; i++) {
        flutterLocalNotificationsPlugin.cancel(groupNotifs[i].hashcode!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Need Sign'.toUpperCase(),
          style: const TextStyle(
              fontSize: 17
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert),
            color: Colors.white,
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              const PopupMenuItem<int>(
                value: 0,
                child: Text('Select All Internal',
                  style: TextStyle(
                      fontSize: 15
                  ),
                ),
                textStyle: TextStyle(color: Colors.black,fontSize: 17),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text('Select All External',
                  style: TextStyle(
                      fontSize: 15
                  ),
                ),
                textStyle: TextStyle(color: Colors.black,fontSize: 17),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text('Cancel',
                  style: TextStyle(
                      fontSize: 15
                  ),
                ),
                textStyle: TextStyle(color: Colors.black,fontSize: 17),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: StreamBuilder<List<SuratModel>>(
                  stream: homes.listControllerSurat.stream,
                  builder: (context, snapshot) {
                    if(mains.objectbox.boxSurat.isEmpty()){
                      return Container(
                          margin: const EdgeInsets.only(top: 15.0),
                          width: MediaQuery.of(context).size.width,
                          child :const Text(
                            'No need sign yet.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13,),
                          )
                      );
                    }
                    else{
                      var queryInbox = mains.objectbox.boxSurat.query(SuratModel_.kategori.equals('needSign')).build();
                      List<SuratModel> listSurat = queryInbox.find().toList();
                      if(listSurat.isEmpty){
                        return Container(
                            margin: const EdgeInsets.only(top: 15.0),
                            width: MediaQuery.of(context).size.width,
                            child :const Text(
                              'No need sign yet.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13,),
                            )
                        );
                      }
                      else{
                        DateTime now = DateTime.now();
                        DateTime date = DateTime(now.year, now.month, now.day);

                        return Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: listSurat.length,
                                itemBuilder:(BuildContext context,index)=>
                                    GestureDetector(
                                      onTap: (){
                                        if(suratSelected.isNotEmpty){
                                          if(suratSelected[0].jenisSurat == 'Internal' && listSurat[index].jenisSurat == 'Internal'){
                                              var query = mains.objectbox.boxSurat.query(SuratModel_.idSurat.equals(listSurat[index].idSurat!) & SuratModel_.kategori.equals('needSign')).build();
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
                                                  kategori: query.find().first.kategori,
                                                  url: query.find().first.url,
                                                  tipeSurat: query.find().first.tipeSurat,
                                                  tglBuat: query.find().first.tglBuat,
                                                  approver: query.find().first.approver,
                                                  penerima: query.find().first.penerima,
                                                  isSelected: !listSurat[index].isSelected,
                                                  isMeterai: query.find().first.isMeterai,
                                                  jenisSurat: query.find().first.jenisSurat,
                                                );

                                                mains.objectbox.boxSurat.put(surat);
                                                setState(() {});
                                                if(listSurat[index].isSelected==false){
                                                  suratSelected.add(listSurat[index]);
                                                }else{
                                                  suratSelected.removeWhere((item) => item.idSurat == listSurat[index].idSurat);
                                                }
                                              }
                                          }else if(suratSelected[0].jenisSurat == 'External' && listSurat[index].jenisSurat == 'External'){
                                            var query = mains.objectbox.boxSurat.query(SuratModel_.idSurat.equals(listSurat[index].idSurat!) & SuratModel_.kategori.equals('needSign')).build();
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
                                                kategori: query.find().first.kategori,
                                                url: query.find().first.url,
                                                tipeSurat: query.find().first.tipeSurat,
                                                tglBuat: query.find().first.tglBuat,
                                                approver: query.find().first.approver,
                                                penerima: query.find().first.penerima,
                                                isSelected: !listSurat[index].isSelected,
                                                isMeterai: query.find().first.isMeterai,
                                                jenisSurat: query.find().first.jenisSurat,
                                              );

                                              mains.objectbox.boxSurat.put(surat);
                                              setState(() {});
                                              if(listSurat[index].isSelected==false){
                                                suratSelected.add(listSurat[index]);
                                              }else{
                                                suratSelected.removeWhere((item) => item.idSurat == listSurat[index].idSurat);
                                              }
                                            }
                                          }
                                        }else{
                                          Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => DocumentPage(listSurat[index])),
                                          ).then((value) => getNeedSign());
                                        }
                                      },
                                      onLongPress: (){
                                        if(suratSelected.isNotEmpty){
                                          if(suratSelected[0].jenisSurat == 'Internal' && listSurat[index].jenisSurat == 'Internal'){
                                            var query = mains.objectbox.boxSurat.query(SuratModel_.idSurat.equals(listSurat[index].idSurat!) & SuratModel_.kategori.equals('needSign')).build();
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
                                                kategori: query.find().first.kategori,
                                                url: query.find().first.url,
                                                tipeSurat: query.find().first.tipeSurat,
                                                tglBuat: query.find().first.tglBuat,
                                                approver: query.find().first.approver,
                                                penerima: query.find().first.penerima,
                                                isSelected: !listSurat[index].isSelected,
                                                isMeterai: query.find().first.isMeterai,
                                                jenisSurat: query.find().first.jenisSurat,
                                              );

                                              mains.objectbox.boxSurat.put(surat);
                                              setState(() {});
                                              if(listSurat[index].isSelected==false){
                                                suratSelected.add(listSurat[index]);
                                              }else{
                                                suratSelected.removeWhere((item) => item.idSurat == listSurat[index].idSurat);
                                              }
                                            }
                                          }else if(suratSelected[0].jenisSurat == 'External' && listSurat[index].jenisSurat == 'External'){
                                            var query = mains.objectbox.boxSurat.query(SuratModel_.idSurat.equals(listSurat[index].idSurat!) & SuratModel_.kategori.equals('needSign')).build();
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
                                                kategori: query.find().first.kategori,
                                                url: query.find().first.url,
                                                tipeSurat: query.find().first.tipeSurat,
                                                tglBuat: query.find().first.tglBuat,
                                                approver: query.find().first.approver,
                                                penerima: query.find().first.penerima,
                                                isSelected: !listSurat[index].isSelected,
                                                isMeterai: query.find().first.isMeterai,
                                                jenisSurat: query.find().first.jenisSurat,
                                              );

                                              mains.objectbox.boxSurat.put(surat);
                                              setState(() {});
                                              if(listSurat[index].isSelected==false){
                                                suratSelected.add(listSurat[index]);
                                              }else{
                                                suratSelected.removeWhere((item) => item.idSurat == listSurat[index].idSurat);
                                              }
                                            }
                                          }
                                        }else{
                                          var query = mains.objectbox.boxSurat.query(SuratModel_.idSurat.equals(listSurat[index].idSurat!) & SuratModel_.kategori.equals('needSign')).build();
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
                                              kategori: query.find().first.kategori,
                                              url: query.find().first.url,
                                              tipeSurat: query.find().first.tipeSurat,
                                              tglBuat: query.find().first.tglBuat,
                                              approver: query.find().first.approver,
                                              penerima: query.find().first.penerima,
                                              isSelected: !listSurat[index].isSelected,
                                              isMeterai: query.find().first.isMeterai,
                                              jenisSurat: query.find().first.jenisSurat,

                                            );

                                            mains.objectbox.boxSurat.put(surat);
                                            setState(() {});
                                            if(listSurat[index].isSelected==false){
                                              suratSelected.add(listSurat[index]);
                                            }else{
                                              suratSelected.removeWhere((item) => item.idSurat == listSurat[index].idSurat);
                                            }
                                          }
                                        }

                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 5),
                                        height: 95,
                                        width: 500,
                                        child: Card(
                                          margin: const EdgeInsets.symmetric(vertical: 3),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  left: 0,
                                                  top: 5,
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors.transparent,
                                                    child: Image(
                                                      image: listSurat[index].isMeterai == 0 ?
                                                      const AssetImage('assets/images/pdf.png')
                                                          :
                                                      const AssetImage('assets/images/pdf-emeterai.png'),
                                                      width: 50,
                                                    ),
                                                    radius: 25,
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 65,
                                                  top: 5,
                                                  bottom: 5,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      ConstrainedBox(
                                                        constraints: const BoxConstraints(
                                                            maxWidth: 250
                                                        ),
                                                        child: Text(
                                                          listSurat[index].namaSurat!,
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      // Text(
                                                      //   listSurat[index].editor!,
                                                      //   overflow: TextOverflow.ellipsis,
                                                      //   maxLines: 1,
                                                      //   style: const TextStyle(
                                                      //     fontSize: 12,
                                                      //     fontWeight: FontWeight.normal,
                                                      //     height: 1.5,
                                                      //     // color: Color(0xFF171717),
                                                      //   ),
                                                      // ),
                                                      Text(
                                                        listSurat[index].jenisSurat == null ? "" : listSurat[index].jenisSurat!,
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.normal,
                                                          height: 1.5,
                                                          // color: Color(0xFF171717),
                                                        ),
                                                      ),
                                                      Text(
                                                        listSurat[index].nomorSurat!,
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w400,
                                                          height: 1.5,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                suratSelected.isEmpty ?
                                                // show date
                                                Positioned(
                                                  right: 5,
                                                  top: 10,
                                                  child: Padding(
                                                      padding: const EdgeInsets.only(left: 20),
                                                      child: Text(
                                                        listSurat[index].tglSelesai == null ?
                                                        ""
                                                            :
                                                        date.isAfter(DateTime.parse(listSurat[index].tglSelesai!))?
                                                        DateFormat('dd MMM yyyy \n H:mm').format(DateTime.parse(listSurat[index].tglSelesai!)).toString()
                                                            :
                                                        DateFormat.Hm().format(DateTime.parse(listSurat[index].tglSelesai!)).toString()
                                                        ,
                                                        style: const TextStyle(
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.normal,
                                                        ),
                                                        textAlign: TextAlign.right,
                                                      )
                                                  ),
                                                )
                                                    :
                                                suratSelected[0].jenisSurat == 'Internal' ?
                                                    listSurat[index].jenisSurat == 'Internal' ?
                                                // show checkbox internal
                                                Positioned(
                                                  right: 5,
                                                  top: 10,
                                                  child: Padding(
                                                      padding: const EdgeInsets.only(left: 20),
                                                      child: Checkbox(
                                                          value: listSurat[index].isSelected,
                                                          onChanged: (bool? value) {
                                                            var query = mains.objectbox.boxSurat.query(SuratModel_.idSurat.equals(listSurat[index].idSurat!) & SuratModel_.kategori.equals('needSign')).build();
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
                                                                kategori: query.find().first.kategori,
                                                                url: query.find().first.url,
                                                                tipeSurat: query.find().first.tipeSurat,
                                                                tglBuat: query.find().first.tglBuat,
                                                                approver: query.find().first.approver,
                                                                penerima: query.find().first.penerima,
                                                                isSelected: !listSurat[index].isSelected,
                                                                isMeterai: query.find().first.isMeterai,
                                                                jenisSurat: query.find().first.jenisSurat,
                                                              );

                                                              mains.objectbox.boxSurat.put(surat);
                                                              setState(() {});
                                                              if(listSurat[index].isSelected==false){
                                                                suratSelected.add(listSurat[index]);
                                                              }else{
                                                                suratSelected.removeWhere((item) => item.idSurat == listSurat[index].idSurat);
                                                              }
                                                            }
                                                          }
                                                      )
                                                  ),
                                                ) : SizedBox()
                                                    :
                                                listSurat[index].jenisSurat == 'External' ?
                                                // show checkbox external
                                                Positioned(
                                                  right: 5,
                                                  top: 10,
                                                  child: Padding(
                                                      padding: const EdgeInsets.only(left: 20),
                                                      child: Checkbox(
                                                          value: listSurat[index].isSelected,
                                                          onChanged: (bool? value) {
                                                            var query = mains.objectbox.boxSurat.query(SuratModel_.idSurat.equals(listSurat[index].idSurat!) & SuratModel_.kategori.equals('needSign')).build();
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
                                                                kategori: query.find().first.kategori,
                                                                url: query.find().first.url,
                                                                tipeSurat: query.find().first.tipeSurat,
                                                                tglBuat: query.find().first.tglBuat,
                                                                approver: query.find().first.approver,
                                                                penerima: query.find().first.penerima,
                                                                isSelected: !listSurat[index].isSelected,
                                                                isMeterai: query.find().first.isMeterai,
                                                                jenisSurat: query.find().first.jenisSurat,
                                                              );

                                                              mains.objectbox.boxSurat.put(surat);
                                                              setState(() {});
                                                              if(listSurat[index].isSelected==false){
                                                                suratSelected.add(listSurat[index]);
                                                              }else{
                                                                suratSelected.removeWhere((item) => item.idSurat == listSurat[index].idSurat);
                                                              }
                                                            }
                                                          }
                                                      )
                                                  ),
                                                ) : SizedBox()
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              ),
                            ],
                          ),
                        );
                      }
                    }

                  }
              ),
            ),
          ),
          suratSelected.isNotEmpty && suratSelected[0].jenisSurat == 'Internal' ?
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton.icon(
              onPressed: (){
                List listMapSurat = [];

                for(var surat in suratSelected){
                  Map mapSurat = { 'id': '${surat.idSurat}' };
                  listMapSurat.add(mapSurat);
                }

                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10,),
                        const Text('Are you sure to sign all the selected internal documents?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),
                          textAlign: TextAlign.center,
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

                                  Map<String, dynamic>? otpData = await getOtpBulk(listMapSurat);

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
                                            child: buildPinPut(listMapSurat, otpData!['bulkId']),
                                          ),
                                          const SizedBox(height: 20,),
                                        ],
                                      ),
                                    ),
                                  );

                                  Future.delayed(
                                    const Duration(seconds: 1), 
                                    () {
                                      _pinPutInternalTextController.setText(otpData!['otp']);
                                    },
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
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width, 50) ,
                primary: const Color(0xFF1FA463),
                elevation: 0,
              ),
              icon: const Icon(
                  Icons.check,
                  size: 13,
                  color: Colors.white
              ),
              label: const Text("Sign Internal Selected Document",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),),
            ),
          )
              :
          suratSelected.isNotEmpty && suratSelected[0].jenisSurat == 'External' ?
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton.icon(
              onPressed: (){
                List listMapSurat = [];

                for(var surat in suratSelected){
                  Map mapSurat = { 'id': '${surat.idSurat}' };
                  listMapSurat.add(mapSurat);
                }

                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10,),
                        const Text('Are you sure to sign all the selected external documents?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),
                          textAlign: TextAlign.center,
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

                                  List otpData = await getOtpBulkEksternal(listMapSurat);

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
                                            child: buildPinPutEksternal(listMapSurat, otpData[0], otpData[1]),
                                          ),
                                          const SizedBox(height: 20,),
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
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width, 50) ,
                primary: const Color(0xFF1FA463),
                elevation: 0,
              ),
              icon: const Icon(
                  Icons.check,
                  size: 13,
                  color: Colors.white
              ),
              label: const Text("Sign External Selected Document",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),),
            ),
          )
              :
          const SizedBox()
        ],
      ),
    );
  }

  Widget buildPinPut(List listIdSurat, String bulkId) {
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
      controller: _pinPutInternalTextController,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      length: 6,
      focusNode: _pinPutFocusNode,
      onCompleted: (pin) {
        EasyLoading.show(status: 'loading...');
        signingBulk(pin, bulkId, listIdSurat);
      },
    );
  }

  Widget buildPinPutEksternal(List listIdSurat, String token, String bulkId) {
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
      controller: _pinPutEksternalTextController,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      length: 6,
      focusNode: _pinPutFocusNode,
      onCompleted: (otp) {
        EasyLoading.show(status: 'loading...');
        signingBulkEksternal(token, bulkId, otp, listIdSurat);
      },
    );
  }


  void onSelected(BuildContext context, int item)  {
    switch (item) {
      case 0:
        clearSelect();

        var queryInbox = mains.objectbox.boxSurat.query(SuratModel_.kategori.equals('needSign') & SuratModel_.jenisSurat.equals('Internal')).build();
        List<SuratModel> listSurat = queryInbox.find().toList();
        for(var item in listSurat) {
          var query = mains.objectbox.boxSurat.query(SuratModel_.id.equals(item.id)).build();
          if (query.find().isNotEmpty) {
            final surat = SuratModel(
              id: query.find().first.id,
              idSurat: query.find().first.idSurat,
              namaSurat: query.find().first.namaSurat,
              nomorSurat: query.find().first.nomorSurat,
              editor: query.find().first.editor,
              perihal: query.find().first.perihal,
              status: query.find().first.status,
              tglSelesai: query.find().first.tglSelesai,
              kategori: query.find().first.kategori,
              url: query.find().first.url,
              tipeSurat: query.find().first.tipeSurat,
              tglBuat: query.find().first.tglBuat,
              approver: query.find().first.approver,
              penerima: query.find().first.penerima,
              isSelected: true,
              jenisSurat: query.find().first.jenisSurat,
              isMeterai: query.find().first.isMeterai,
            );

            mains.objectbox.boxSurat.put(surat);
            setState(() {});
          }
        }
        suratSelected.clear();
        suratSelected.addAll(listSurat);
        break;
        case 1:
          clearSelect();

        var queryInbox = mains.objectbox.boxSurat.query(SuratModel_.kategori.equals('needSign') & SuratModel_.jenisSurat.equals('External')).build();
        List<SuratModel> listSurat = queryInbox.find().toList();
        for(var item in listSurat) {
          var query = mains.objectbox.boxSurat.query(SuratModel_.id.equals(item.id)).build();
          if (query.find().isNotEmpty) {
            final surat = SuratModel(
              id: query.find().first.id,
              idSurat: query.find().first.idSurat,
              namaSurat: query.find().first.namaSurat,
              nomorSurat: query.find().first.nomorSurat,
              editor: query.find().first.editor,
              perihal: query.find().first.perihal,
              status: query.find().first.status,
              tglSelesai: query.find().first.tglSelesai,
              kategori: query.find().first.kategori,
              url: query.find().first.url,
              tipeSurat: query.find().first.tipeSurat,
              tglBuat: query.find().first.tglBuat,
              approver: query.find().first.approver,
              penerima: query.find().first.penerima,
              isSelected: true,
              jenisSurat: query.find().first.jenisSurat,
              isMeterai: query.find().first.isMeterai,
            );

            mains.objectbox.boxSurat.put(surat);
            setState(() {});
          }
        }
        suratSelected.clear();
        suratSelected.addAll(listSurat);
        break;
      case 2:
        setState(() {
          clearSelect();
        });
        break;
    }
  }

  Future<http.Response> getNeedSign() async {

    String url ='https://eoffice.dev.digiprimatera.co.id/api/getNeedSign';

    Map<String, dynamic> data = {
      'payload': {
        'id_user': mains.objectbox.boxUser.get(1)!.userId!,
      }
    };

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );
    if(response.statusCode == 200){
      Map<String, dynamic> suratMap = jsonDecode(response.body);

      var query = mains.objectbox.boxSurat.query(SuratModel_.kategori.equals('needSign')).build();
      List<SuratModel> suratList = query.find().toList();
      for(var surat in suratList){
        mains.objectbox.boxSurat.remove(surat.id);
      }

      if(suratMap['data'] != null){
        for(int i = 0; i < suratMap['data'].length; i++) {
          var dataSurat = Map<String, dynamic>.from(suratMap['data'][i]);
          var query = mains.objectbox.boxSurat.query(SuratModel_.idSurat.equals(dataSurat['surat_id'].toString()) & SuratModel_.kategori.equals('needSign')).build();
          if(query.find().isNotEmpty) {
            final surat = SuratModel(
              id: query.find().first.id,
              idSurat: dataSurat['surat_id'],
              namaSurat: dataSurat['perihal'],
              nomorSurat: dataSurat['nomor'],
              editor: dataSurat['editor'],
              perihal: dataSurat['perihal'],
              status: query.find().first.status,
              tglSelesai: dataSurat['tgl_selesai'],
              kategori: 'needSign',
              url: dataSurat['isi_surat'],
              tipeSurat: dataSurat['tipe_surat'],
              tglBuat: query.find().first.tglBuat,
              approver: jsonEncode(dataSurat['approv']),
              penerima: jsonEncode(dataSurat['penerima']),
              isMeterai: dataSurat['isMeterai'],
              jenisSurat: dataSurat['jenis_surat'],
            );

            mains.objectbox.boxSurat.put(surat);
          }
          else{
            final surat = SuratModel(
              idSurat: dataSurat['surat_id'],
              namaSurat: dataSurat['perihal'],
              nomorSurat: dataSurat['nomor'],
              editor: dataSurat['editor'],
              perihal: dataSurat['perihal'],
              status: dataSurat['status'],
              tglSelesai: dataSurat['tgl_selesai'],
              kategori: 'needSign',
              url: dataSurat['isi_surat'],
              tipeSurat: dataSurat['tipe_surat'],
              tglBuat: dataSurat['tgl_buat'],
              approver: jsonEncode(dataSurat['approv']),
              penerima: jsonEncode(dataSurat['penerima']),
              isMeterai: dataSurat['isMeterai'],
              jenisSurat: dataSurat['jenis_surat'],
            );

            mains.objectbox.boxSurat.put(surat);
          }
        }
        setState(() {});
      }


    }
    else{
      EasyLoading.showError('${response.statusCode}, Gagal terhubung ke server!');
    }
    return response;
  }

  Future<Map<String, dynamic>?> getOtpBulk(List listIdSurat) async {
    try {
      EasyLoading.show(status: 'Sending OTP');

      String url ='https://eoffice.dev.digiprimatera.co.id/api/getOtpBulk';

      Map<String, dynamic> data = {
        'payload': {
          'users_id': mains.objectbox.boxUser.get(1)!.userId.toString(),
          'surat': listIdSurat,
        }
      };

      var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body:jsonEncode(data),
      );

      if(response.statusCode == 200){
        Map<String, dynamic> otpMap = jsonDecode(response.body);

        if(otpMap['code'] == 0){
          return {
            'otp': otpMap['otp'],
            'bulkId': otpMap['bulkId'],
          };
          // signingBulk(otpMap['otp'], otpMap['bulkId'], listIdSurat);
        }
        else{
          EasyLoading.showError(otpMap['message']);
        }
      }
      else{
        EasyLoading.showError('${response.statusCode}, Gagal terhubung ke server!');
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<http.Response> signingBulk(String otp, String bulkId, List listIdSurat) async {

    String url ='https://eoffice.dev.digiprimatera.co.id/api/bulkSigning';

    Map<String, dynamic> data = {
      'payload': {
        'users_id': mains.objectbox.boxUser.get(1)!.userId,
        'bulk_id': bulkId,
        'token': otp,
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
        for(var idSurat in listIdSurat){
          var query = mains.objectbox.boxSurat.query(SuratModel_.idSurat.equals(idSurat['id'])).build();
          if(query.find().isNotEmpty) {
            mains.objectbox.boxSurat.remove(query.find().first.id);
          }
        }
        EasyLoading.showSuccess('Silahkan menunggu antrian signing!');
        Navigator.pop(context);
        setState(() {
          clearSelect();
        });
        _pinPutInternalTextController.setText('');
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

  Future<List> getOtpBulkEksternal(List listIdSurat) async {
    EasyLoading.show(status: 'Sending OTP');

    String url ='https://eoffice.dev.digiprimatera.co.id/api/otpSignEksternal';

    Map<String, dynamic> data = {
      'payload': {
        'users_id': mains.objectbox.boxUser.get(1)!.userId.toString(),
        'surat': listIdSurat,
      }
    };

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );

    if(response.statusCode == 200){
      Map<String, dynamic> otpMap = jsonDecode(response.body);

      if(otpMap['code'] == 0){
        // signingBulkEksternal(otpMap['otp'], otpMap['bulkId'], listIdSurat, otpMap['tokenCodeBulk']);
        return [otpMap['data']['token'], otpMap['data']['dataIdBulk']];
      }
      else{
        EasyLoading.showError(otpMap['message']);
      }
    }
    else{
      EasyLoading.showError('${response.statusCode}, Gagal terhubung ke server!');
    }
    return [];
  }

  Future<http.Response> signingBulkEksternal(String token, String bulkId, String otp, List listIdSurat) async {

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
        for(var idSurat in listIdSurat){
          var query = mains.objectbox.boxSurat.query(SuratModel_.idSurat.equals(idSurat['id'])).build();
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
          }
        }
        EasyLoading.showSuccess('Silahkan menunggu antrian signing!');
        Navigator.pop(context);
        setState(() {
          clearSelect();
        });
        _pinPutEksternalTextController.setText('');
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

void clearSelect(){
  var queryInbox = mains.objectbox.boxSurat.query(SuratModel_.kategori.equals('needSign')).build();
  List<SuratModel> listSurat = queryInbox.find().toList();
  for(var item in listSurat) {
    var query = mains.objectbox.boxSurat.query(SuratModel_.id.equals(item.id)).build();
    if (query.find().isNotEmpty) {
      final surat = SuratModel(
        id: query.find().first.id,
        idSurat: query.find().first.idSurat,
        namaSurat: query.find().first.namaSurat,
        nomorSurat: query.find().first.nomorSurat,
        editor: query.find().first.editor,
        perihal: query.find().first.perihal,
        status: query.find().first.status,
        tglSelesai: query.find().first.tglSelesai,
        kategori: query.find().first.kategori,
        url: query.find().first.url,
        tipeSurat: query.find().first.tipeSurat,
        tglBuat: query.find().first.tglBuat,
        approver: query.find().first.approver,
        penerima: query.find().first.penerima,
        isSelected: false,
        jenisSurat: query.find().first.jenisSurat,
        isMeterai: query.find().first.isMeterai,
      );

      mains.objectbox.boxSurat.put(surat);
    }
  }
  suratSelected = [];
}
