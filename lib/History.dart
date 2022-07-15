import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:militarymessenger/document.dart';
import 'package:militarymessenger/models/SuratModel.dart';
import 'objectbox.g.dart';
import 'package:http/http.dart' as http;
import 'main.dart' as mains;
import 'Home.dart' as homes;

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Store? store;

  @override
  void initState()  {
    // getRecent();
    super.initState();
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
                  child :const Text(
                    'No history yet.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13,),
                  )
              );
            }
            else{
              var queryInbox = mains.objectbox.boxSurat.query(SuratModel_.kategori.equals('history')).build();
              List<SuratModel> listSurat = queryInbox.find().toList();

              DateTime now = DateTime.now();
              DateTime date = DateTime(now.year, now.month, now.day);

              if(listSurat.isEmpty){
                return Container(
                    margin: const EdgeInsets.only(top: 15.0),
                    width: MediaQuery.of(context).size.width,
                    child :const Text(
                      'No history yet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13,),
                    )
                );
              }else{
                return Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: listSurat.length,
                      itemBuilder:(BuildContext context,index)=>
                          InkWell(
                            onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => DocumentPage(listSurat[index])),);
                            },
                            child: Card(
                              margin: const EdgeInsets.fromLTRB(20,10,20,0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(right: 20.0),
                                          child: Image(
                                            image: listSurat[index].isMeterai == 0 ?
                                            const AssetImage('assets/images/pdf.png')
                                                :
                                            const AssetImage('assets/images/pdf-emeterai.png'),
                                            width: 50,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                  maxWidth: 200
                                              ),
                                              child: Text(listSurat[index].namaSurat!,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(fontWeight: FontWeight.bold),),
                                            ),
                                            const SizedBox(height: 5,),
                                            date.isBefore(DateTime.parse(listSurat[index].tglBuat!))?
                                            Text(DateFormat.Hm().format(DateTime.parse(listSurat[index].tglBuat!)).toString())
                                            :
                                            Text(DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(listSurat[index].tglBuat!)).toString()),
                                            const SizedBox(height: 5,),
                                            Text(listSurat[index].status!),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 50,
                                      width: 30,

                                      child:
                                      listSurat[index].status == "APPROVE" ?
                                      const Image(image: AssetImage("assets/icons/approved.png"))
                                          :
                                      listSurat[index].status == "RETURN" ?
                                      const Image(image: AssetImage("assets/icons/returned.png"))
                                          :
                                      listSurat[index].status == "REJECT" ?
                                      const Image(image: AssetImage("assets/icons/rejected.png"))
                                          :
                                      listSurat[index].status == "READ" ?
                                      const Image(image: AssetImage("assets/icons/read.png"))
                                          :
                                      listSurat[index].status == "SUBMIT" ?
                                      const Image(image: AssetImage("assets/icons/submit.png"))
                                          :
                                      listSurat[index].status == "APPROVED" ?
                                      const Image(image: AssetImage("assets/icons/approved.png"))
                                          :
                                      listSurat[index].status == "SIGNED" && listSurat[index].isMeterai == 1 ?
                                      const Image(image: AssetImage("assets/icons/signed-meterai.png"))
                                          :
                                      listSurat[index].status == "SIGNED" && listSurat[index].isMeterai == 0 ?
                                      const Image(image: AssetImage("assets/icons/signed.png"))
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
              isMeterai: dataSurat['isMeterai'],
              url: dataSurat['isi_surat'],
              approver: jsonEncode(dataSurat['approv']),
              penerima: jsonEncode(dataSurat['penerima']),
              editor: dataSurat['editor'],
              jenisSurat: dataSurat['jenis_surat'],
            );

            mains.objectbox.boxSurat.put(surat);
          }
        }
        setState(() {});
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
