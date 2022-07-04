import 'dart:convert';

import 'package:flutter/material.dart';
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
                var queryInbox = mains.objectbox.boxSurat.query(SuratModel_.kategori.equals('sent')).build();
                List<SuratModel> listSurat = queryInbox.find().toList();
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
                                      const Positioned(
                                        left: 0,
                                        top: 9,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Image(image: AssetImage('assets/images/pdf.png'),width: 50,),
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
                                            Text(
                                              mains.objectbox.boxUser.get(1)!.userName!,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
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
                                            child: date.isAfter(DateTime.parse(listSurat[index].tglBuat!))?
                                            Text(
                                              DateFormat('dd MMM yyyy').format(DateTime.parse(listSurat[index].tglBuat!)).toString(),
                                              style: const TextStyle(
                                                  fontSize: 11
                                              ),
                                            )
                                            :
                                            Text(
                                              DateFormat.Hm().format(DateTime.parse(listSurat[index].tglBuat!)).toString(),
                                              style: const TextStyle(
                                                  fontSize: 11
                                              ),
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

    //encode Map to JSON
    //var body = "?api_key="+this.apiKey;

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
              );

              mains.objectbox.boxSurat.put(surat);
              setState(() {

              });
              // mains.objectbox.boxSurat.remove(query.find().first.id);
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
              );

              mains.objectbox.boxSurat.put(surat);

              setState(() {

              });
            }
          }
        }
      }
      else{
        print(suratMap['code']);
        print(suratMap['message']);
        print(response.statusCode);
      }
    }
    else{
      print("Gagal terhubung ke server!");
    }
    return response;
  }

}
