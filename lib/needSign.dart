import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:militarymessenger/document.dart';
import 'package:militarymessenger/models/SuratModel.dart';
import 'package:militarymessenger/objectbox.g.dart';
import 'main.dart' as mains;
import 'Home.dart' as homes;

class NeedSign extends StatefulWidget {
  const NeedSign({Key? key}) : super(key: key);

  @override
  _NeedSignState createState() => _NeedSignState();
}

class _NeedSignState extends State<NeedSign> {

  @override
  void initState() {
    // TODO: implement initState
    getNeedSign();
    super.initState();
  }

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
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<List<SuratModel>>(
          stream: homes.listControllerSurat.stream,
          builder: (context, snapshot) {
            if(mains.objectbox.boxSurat.isEmpty()){
              return Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  width: MediaQuery.of(context).size.width,
                  child :Text(
                    'No need sign yet.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13,),
                  )
              );
            }
            else{
              var queryInbox = mains.objectbox.boxSurat.query(SuratModel_.kategori.equals('needSign')).build();
              List<SuratModel> listSurat = queryInbox.find().toList();
              if(listSurat.length==0){
                return Container(
                    margin: const EdgeInsets.only(top: 15.0),
                    width: MediaQuery.of(context).size.width,
                    child :Text(
                      'No need sign yet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13,),
                    )
                );
              }else{
                return Container(
                  padding: EdgeInsets.all(20),
                  child: ListView.builder(
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
                                        constraints: BoxConstraints(
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
                                // Positioned(
                                //   right: 5,
                                //   top: 10,
                                //   child: Padding(
                                //       padding: const EdgeInsets.only(left: 20),
                                //       child: Text(
                                //         '09.45',
                                //         style: TextStyle(
                                //             fontSize: 11
                                //         ),
                                //       )
                                //   ),
                                // ),
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

  Future<http.Response> getNeedSign() async {

    String url ='http://eoffice.dev.digiprimatera.co.id/api/getNeedSign';

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

}
