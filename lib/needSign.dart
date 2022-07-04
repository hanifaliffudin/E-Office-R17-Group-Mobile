import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:militarymessenger/document.dart';
import 'package:militarymessenger/models/SuratModel.dart';
import 'package:militarymessenger/objectbox.g.dart';
import 'package:pinput/pinput.dart';
import 'main.dart' as mains;
import 'Home.dart' as homes;

class NeedSign extends StatefulWidget {
  const NeedSign({Key? key}) : super(key: key);

  @override
  _NeedSignState createState() => _NeedSignState();
}

List<SuratModel> suratSelected = [];

class _NeedSignState extends State<NeedSign> {

  @override
  void initState() {
    // TODO: implement initState
    getNeedSign();
    super.initState();
  }

  @override
  void dispose() {
    clearSelect();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Need Sign'.toUpperCase(),
          style: TextStyle(
              fontSize: 17
          ),
        ),
        centerTitle: true,
        actions: [
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.white,
              textTheme: TextTheme().apply(bodyColor: Colors.white),
            ),
            child: PopupMenuButton<int>(
              icon: Icon(Icons.more_vert),
              color: Colors.white,
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text('Select All',
                    style: TextStyle(
                        fontSize: 15
                    ),
                  ),
                  textStyle: TextStyle(color: Colors.black,fontSize: 17),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text('Cancel',
                    style: TextStyle(
                        fontSize: 15
                    ),
                  ),
                  textStyle: TextStyle(color: Colors.black,fontSize: 17),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                return Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: listSurat.length,
                          itemBuilder:(BuildContext context,index)=>
                          GestureDetector(
                            onTap: (){
                              if(suratSelected.isNotEmpty){
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
                                  );

                                  mains.objectbox.boxSurat.put(surat);
                                  setState(() {});
                                  if(listSurat[index].isSelected==false){
                                    suratSelected.add(listSurat[index]);
                                  }else{
                                    suratSelected.removeWhere((item) => item.idSurat == listSurat[index].idSurat);
                                  }
                                }
                              }else{
                                Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => DocumentPage(listSurat[index])),
                                );
                              }
                            },
                            onLongPress: (){
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
                                );

                                mains.objectbox.boxSurat.put(surat);
                                setState(() {});
                                if(listSurat[index].isSelected==false){
                                  suratSelected.add(listSurat[index]);
                                }else{
                                  suratSelected.removeWhere((item) => item.idSurat == listSurat[index].idSurat);
                                }
                              }
                            },
                            child: Container(
                            margin: EdgeInsets.only(bottom: 5),
                            height: 95,
                            width: 500,
                            child: Card(
                              margin: EdgeInsets.symmetric(vertical: 3),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      top: 5,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(Icons.person),
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
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            listSurat[index].tglSelesai!,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              height: 1.5,
                                            ),
                                          ),
                                          Text(
                                            listSurat[index].nomorSurat!,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              height: 1.5,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    suratSelected.isNotEmpty ?
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
                                    )
                                    :
                                    SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                        ),
                          ),
                      ),
                      suratSelected.isNotEmpty ?
                      ElevatedButton.icon(
                        onPressed: (){
                          if(suratSelected.length > 1){
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
                                    const Text('Are you sure to sign all the selected documents?',
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
                                            onPressed: () {
                                              Navigator.pop(context);

                                              getOtpBulk(listMapSurat);

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
                                                        child: buildPinPut(listMapSurat),
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
                          }
                          else{
                            Flushbar(
                              backgroundColor: Colors.red,
                              message: 'At least 2 documents must be selected.',
                              duration: const Duration(seconds: 2),
                            ).show(context);
                          }

                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(MediaQuery.of(context).size.width, 40) ,
                          primary: const Color(0xFF1FA463),
                          elevation: 0,
                        ),
                        icon: const Icon(
                            Icons.check,
                            size: 13,
                            color: Colors.white
                        ),
                        label: const Text("Sign Selected Document",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16
                          ),),
                      )
                          :
                      SizedBox()
                    ],
                  ),
                );
              }
            }

          }
        ),
      ),
    );
  }

  Widget buildPinPut(List listIdSurat) {
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
      onCompleted: (pin) {
        EasyLoading.show(status: 'loading...');
        // signingBulk(idSurat, pin);
      },
    );
  }

  void onSelected(BuildContext context, int item)  {
    switch (item) {
      case 0:
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
              isSelected: true,
            );

            mains.objectbox.boxSurat.put(surat);
            setState(() {});
          }
        }
        suratSelected.clear();
        suratSelected.addAll(listSurat);
        break;
      case 1:
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

    //encode Map to JSON
    //var body = "?api_key="+this.apiKey;

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );
    if(response.statusCode == 200){
      // print("${response.body}");
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
            );

            mains.objectbox.boxSurat.put(surat);
            setState(() {});
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
            );

            mains.objectbox.boxSurat.put(surat);
            setState(() {});
          }
        }
      }


    }
    else{
      print(response.statusCode);
      print("Gagal terhubung ke server!");
    }
    return response;
  }

  Future<http.Response> getOtpBulk(List listIdSurat) async {
    EasyLoading.showToast('Sending OTP');

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
        EasyLoading.show(status: 'loading...');
        signingBulk(otpMap['otp'], otpMap['bulkId'], listIdSurat);
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

  Future<http.Response> signingBulk(String otp, String bulkId, List listIdSurat) async {

    String url ='https://eoffice.dev.digiprimatera.co.id/api/bulkSigning';

    Map<String, dynamic> data = {
      'payload': {
        'users_id': mains.objectbox.boxUser.get(1)!.userId,
        'bulk_id': bulkId,
        "token": otp,
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
            // final surat = SuratModel(
            //   id: query.find().first.id,
            //   idSurat: query.find().first.idSurat,
            //   namaSurat: query.find().first.namaSurat,
            //   nomorSurat: query.find().first.nomorSurat,
            //   editor: query.find().first.editor,
            //   perihal: query.find().first.perihal,
            //   status: query.find().first.status,
            //   tglSelesai: query.find().first.tglSelesai,
            //   url: signingMap['data'],
            //   kategori: 'signed',
            //   tglBuat: query.find().first.tglBuat,
            //   tipeSurat: query.find().first.tipeSurat,
            //   approver: query.find().first.approver,
            //   penerima: query.find().first.penerima,
            // );
            //
            // mains.objectbox.boxSurat.put(surat);
            EasyLoading.showSuccess('Berhasil Signing!');
            setState(() {});
            Navigator.pop(context);
            // Navigator.push(
            //   context, MaterialPageRoute(builder: (context) => DocumentPage(surat)),
            // );
          }
        }
      }
      else{
        print(signingMap['message']);
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
      );

      mains.objectbox.boxSurat.put(surat);
    }
  }
  suratSelected = [];
}