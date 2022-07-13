import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:militarymessenger/document.dart';
import 'package:militarymessenger/models/SuratModel.dart';
import 'package:militarymessenger/objectbox.g.dart';
import 'main.dart' as mains;
import 'Home.dart' as homes;

class SignedPage extends StatefulWidget {
  const SignedPage({Key? key}) : super(key: key);

  @override
  _SignedPageState createState() => _SignedPageState();
}

class _SignedPageState extends State<SignedPage> {

  @override
  void initState() {
    // TODO: implement initState
    getDataSurat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signed'.toUpperCase(),
          style: const TextStyle(
              fontSize: 17
          ),
        ),
        centerTitle: true,
        // backgroundColor: Color(0xFF2381d0),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<List<SuratModel>>(
            stream: homes.listControllerSurat.stream,
            builder: (context, snapshot) {
              if(mains.objectbox.boxSurat.isEmpty()){
                return Container(
                    margin: const EdgeInsets.only(top: 15.0),
                    width: MediaQuery.of(context).size.width,
                    child : const Text(
                      'No signed yet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13,),
                    )
                );
              }
              else{
                var querySigned = mains.objectbox.boxSurat.query(SuratModel_.kategori.equals('sent'))..order(SuratModel_.tglSelesai, flags: Order.descending);
                var query = querySigned.build();
                List<SuratModel> listSurat = query.find().toList();
                if(listSurat.isEmpty){
                  return Container(
                      margin: const EdgeInsets.only(top: 15.0),
                      width: MediaQuery.of(context).size.width,
                      child :const Text(
                        'No signed yet.',
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
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: listSurat.length,
                      itemBuilder:(BuildContext context,index)=>
                          InkWell(
                            onTap: (){
                              Navigator.push(
                                context, MaterialPageRoute(builder: (context) => DocumentPage(listSurat[index])),
                              );
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
                                        top: 9,
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
                                        top: 8,
                                        bottom: 5,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                  maxWidth: 190
                                              ),
                                              child: Text(
                                                listSurat[index].perihal!,
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
                                            //   ),
                                            // ),
                                            Text(
                                              listSurat[index].jenisSurat!,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                                height: 1.5,
                                              ),
                                            ),
                                            Text(
                                              listSurat[index].nomorSurat == null ?
                                              ""
                                                  :
                                              listSurat[index].nomorSurat!,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                height: 1.5,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
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
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                    ),
                  );
                }
              }
            }
        ),
      ),
    );
  }

  Future<http.Response> getDataSurat() async {

    String url ='https://eoffice.dev.digiprimatera.co.id/api/getSuratKirim';

    Map<String, dynamic> data = {
      'payload': {
        'id_user': mains.objectbox.boxUser.get(1)!.userId,
      }
    };

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );
    if(response.statusCode == 200){
      Map<String, dynamic> suratMap = jsonDecode(response.body);

      var query = mains.objectbox.boxSurat.query(SuratModel_.kategori.equals('sent')).build();
      List<SuratModel> suratList = query.find().toList();
      for(var surat in suratList){
        mains.objectbox.boxSurat.remove(surat.id);
      }

      if(suratMap['code'] == 0){
        if(suratMap['count']>0){
          for(int i = 0; i < suratMap['data'].length; i++) {
            var dataSurat = Map<String, dynamic>.from(suratMap['data'][i]);
            var query = mains.objectbox.boxSurat.query(SuratModel_.idSurat.equals(dataSurat['id'].toString()) & SuratModel_.kategori.equals('sent')).build();
            if(query.find().isNotEmpty) {
              final surat = SuratModel(
                id: query.find().first.id,
                idSurat: dataSurat['surat_id'],
                perihal: dataSurat['perihal'],
                namaSurat: dataSurat['perihal'],
                nomorSurat: dataSurat['nomor'],
                tglSelesai: dataSurat['tgl_selesai'],
                tipeSurat: dataSurat['tipe_surat'],
                url: dataSurat['isi_surat'],
                kategori: 'sent',
                tglBuat: dataSurat['tgl_buat'],
                approver: jsonEncode(dataSurat['approv']),
                penerima: jsonEncode(dataSurat['penerima']),
                editor: dataSurat['editor'],
                isMeterai: dataSurat['isMeterai'],
                jenisSurat: dataSurat['jenis_surat'],
              );

              mains.objectbox.boxSurat.put(surat);
              setState(() {

              });
            }
            else{
              final surat = SuratModel(
                idSurat: dataSurat['surat_id'],
                perihal: dataSurat['perihal'],
                namaSurat: dataSurat['perihal'],
                nomorSurat: dataSurat['nomor'],
                tglSelesai: dataSurat['tgl_selesai'],
                tipeSurat: dataSurat['tipe_surat'],
                url: dataSurat['isi_surat'],
                kategori: 'sent',
                tglBuat: dataSurat['tgl_buat'],
                approver: jsonEncode(dataSurat['approv']),
                penerima: jsonEncode(dataSurat['penerima']),
                editor: dataSurat['editor'],
                isMeterai: dataSurat['isMeterai'],
                jenisSurat: dataSurat['jenis_surat'],
              );

              mains.objectbox.boxSurat.put(surat);

              setState(() {

              });
            }
          }
        }
      }
      else{
        EasyLoading.showError(suratMap['message']);
      }
    }
    else{
      EasyLoading.showError('${response.statusCode}, Gagal terhubung ke server!');
    }
    return response;
  }

}
