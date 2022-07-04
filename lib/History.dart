import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:militarymessenger/document.dart';
import 'package:militarymessenger/models/SuratModel.dart';
import 'objectbox.g.dart';
import 'package:http/http.dart' as http;
import 'main.dart' as mains;
import 'Home.dart' as homes;

class History extends StatefulWidget {
  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Store? store;

  void initState()  {
    getRecent();
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder<List<SuratModel>>(
          stream: homes.listControllerSurat.stream,
          builder: (context, snapshot) {
            if(mains.objectbox.boxSurat.isEmpty()){
              return Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  width: MediaQuery.of(context).size.width,
                  child :Text(
                    'No history yet.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13,),
                  )
              );
            }
            else{
              var queryInbox = mains.objectbox.boxSurat.query(SuratModel_.kategori.equals('history')).build();
              List<SuratModel> listSurat = queryInbox.find().toList();

              DateTime now = new DateTime.now();
              DateTime date = new DateTime(now.year, now.month, now.day);

              if(listSurat.length==0){
                return Container(
                    margin: const EdgeInsets.only(top: 15.0),
                    width: MediaQuery.of(context).size.width,
                    child :Text(
                      'No history yet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13,),
                    )
                );
              }else{
                return Container(
                  padding: EdgeInsets.only(top: 10),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: listSurat.length,
                      itemBuilder:(BuildContext context,index)=>
                          InkWell(
                            onTap: () {
                              String kategori =
                              listSurat[index].status == "APPROVE" ?
                              'approved'
                                  :
                              listSurat[index].status == "RETURN" ?
                              'returned'
                                  :
                              listSurat[index].status == "REJECT" ?
                              'rejected'
                                  :
                              listSurat[index].status == "READ" ?
                              'inbox'
                                  :
                              listSurat[index].status == "SUBMIT" ?
                              'sent'
                                  :
                              listSurat[index].status == "APPROVED" ?
                              'approved'
                                  :
                              listSurat[index].status == "SIGNED" ?
                              'signed'
                                  :
                              '';

                              var query = mains.objectbox.boxSurat.query(SuratModel_.idSurat.equals(listSurat[index].idSurat!) & SuratModel_.kategori.equals(kategori)).build();
                              if(query.find().isNotEmpty) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => DocumentPage(mains.objectbox.boxSurat.get(query.find().first.id))),);
                              }
                            },
                            child: Card(
                              margin: EdgeInsets.fromLTRB(20,10,20,0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(right: 20.0),
                                            child: Image(image: AssetImage('assets/images/pdf.png'),width: 50,),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxWidth: 200
                                                ),
                                                child: Text(listSurat[index].namaSurat!,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(fontWeight: FontWeight.bold),),
                                              ),
                                              SizedBox(height: 5,),
                                              date.isBefore(DateTime.parse(listSurat[index].tglBuat!))?
                                              Text(DateFormat.Hm().format(DateTime.parse(listSurat[index].tglBuat!)).toString())
                                              :
                                              Text(DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(listSurat[index].tglBuat!)).toString()),
                                              SizedBox(height: 5,),
                                              Text(listSurat[index].status!),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      width: 30,

                                      child:
                                      listSurat[index].status == "APPROVE" ?
                                      Image(image: AssetImage("assets/icons/approve.png"))
                                      :
                                      listSurat[index].status == "RETURN" ?
                                      Image(image: AssetImage("assets/icons/return.png"))
                                          :
                                      listSurat[index].status == "REJECT" ?
                                      Image(image: AssetImage("assets/icons/reject.png"))
                                          :
                                      listSurat[index].status == "READ" ?
                                      Icon(Icons.mark_email_read_rounded,color: Colors.black,)
                                          :
                                      listSurat[index].status == "SUBMIT" ?
                                      Icon(Icons.upload_file_rounded, color: Colors.black,)
                                          :
                                      listSurat[index].status == "APPROVED" ?
                                      Image(image: AssetImage("assets/icons/approve.png"))
                                          :
                                      listSurat[index].status == "SIGNED" ?
                                      Image(image: AssetImage("assets/icons/approve.png"))
                                          :
                                      Container()
                                      ,
                                    ),
                                  ],
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

  Future<http.Response> getRecent() async {

    String url ='https://eoffice.dev.digiprimatera.co.id/api/recent';

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

      var query = mains.objectbox.boxSurat.query(SuratModel_.kategori.equals('history')).build();
      List<SuratModel> suratList = query.find().toList();
      for(var surat in suratList){
        mains.objectbox.boxSurat.remove(surat.id);
      }

      if(suratMap['code'] == 0){
          for(int i = 0; i < suratMap['data'].length; i++) {
            var dataSurat = Map<String, dynamic>.from(suratMap['data'][i]);
            var query = mains.objectbox.boxSurat.query(SuratModel_.idSurat.equals(dataSurat['id'].toString()) & SuratModel_.kategori.equals('history')).build();
            if(query.find().isNotEmpty) {
            }
            else{
              final surat = SuratModel(
                idSurat: dataSurat['surat_id'],
                namaSurat: dataSurat['perihal'],
                perihal: dataSurat['perihal'],
                status: dataSurat['action'],
                tglBuat: dataSurat['created_at'],
                kategori: 'history',
              );

              mains.objectbox.boxSurat.put(surat);
              setState(() {});
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
