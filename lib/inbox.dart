import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:militarymessenger/document.dart';
import 'package:militarymessenger/models/SuratModel.dart';
import 'package:militarymessenger/objectbox.g.dart';
import 'main.dart' as mains;
import 'Home.dart' as homes;

class InboxPage extends StatefulWidget {
  const InboxPage({Key? key}) : super(key: key);

  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  String apiKey = homes.apiKeyCore;

  @override
  void initState() {
    // TODO: implement initState
    getDataSurat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Inbox'.toUpperCase(),
        style: TextStyle(
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
                child :Text(
                  'No inbox yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13,),
                )
            );
          }
          else{
            var queryInbox = mains.objectbox.boxSurat.query(SuratModel_.kategori.equals('inbox')).build();
            List<SuratModel> listSurat = queryInbox.find().toList();
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
                        context, MaterialPageRoute(builder: (context) => DocumentPage()),
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
                                  child: Icon(Icons.mail),
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
                                        listSurat[index].pengirim!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      listSurat[index].perihal!,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        height: 1.5,
                                        // color: Color(0xFF171717),
                                      ),
                                    ),
                                    Text(
                                      listSurat[index].nomorSurat == null ?
                                      ""
                                      :
                                      listSurat[index].nomorSurat!,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        height: 1.5,
                                        // color: Color(0xFF171717),
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
                                      '13.45',
                                      style: TextStyle(
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
      ),
    ),
  );

  Future<http.Response> getDataSurat() async {

    String url ='http://eoffice.dev.digiprimatera.co.id/api/getSuratMasuk';

    Map<String, dynamic> data = {
      // 'api_key': this.apiKey,
      // 'email': mains.objectbox.boxUser.get(1)?.email,
      'payload': {
        'id_user': '20',
      }
    };

    //encode Map to JSON
    //var body = "?api_key="+this.apiKey;

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );
    if(response.statusCode == 200){
      //print("${response.body}");
      Map<String, dynamic> suratMap = jsonDecode(response.body);

      if(suratMap['code'] == 0){
        if(suratMap['count']>0){
          print(suratMap['data']);
          var listSurat = suratMap['data'];
          for(int i = 0; i < suratMap['data'].length; i++) {
            var dataSurat = Map<String, dynamic>.from(suratMap['data'][i]);
            print(dataSurat['id']);
            var query = mains.objectbox.boxSurat.query(SuratModel_.idSurat.equals(dataSurat['id'].toString()) & SuratModel_.kategori.equals('inbox')).build();
            if(query.find().isNotEmpty) {
              // final surat = SuratModel(
              //   id: query.find().first.id,
              //   idSurat: query.find().first.idSurat,
              //   namaSurat: query.find().first.namaSurat,
              //   nomorSurat: query.find().first.nomorSurat,
              //   pengirim: query.find().first.pengirim,
              //   perihal: query.find().first.perihal,
              //   status: query.find().first.status,
              //   tglSelesai: query.find().first.tglSelesai,
              // );

              // mains.objectbox.boxSurat.remove(query.find().first.id);
            }
            else{
              final surat = SuratModel(
                idSurat: dataSurat['id'],
                namaSurat: dataSurat['perihal'],
                nomorSurat: dataSurat['nomor'],
                pengirim: dataSurat['pengirim'],
                perihal: dataSurat['perihal'],
                status: dataSurat['status'],
                tglSelesai: dataSurat['tgl_selesai'],
                kategori: 'inbox',
                url: dataSurat['url'],
              );

              mains.objectbox.boxSurat.put(surat);
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
