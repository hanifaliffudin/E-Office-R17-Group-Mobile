import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:militarymessenger/models/SuratModel.dart';
import 'package:militarymessenger/objectbox.g.dart';
import 'package:militarymessenger/utils/variable_util.dart';
import 'main.dart' as mains;
import 'Home.dart' as homes;

class TrackingPage extends StatefulWidget {
  const TrackingPage({Key? key}) : super(key: key);

  @override
  _TrackingPageState createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  final VariableUtil _variableUtil = VariableUtil();

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
        title: Text('Tracking'.toUpperCase(),
          style: const TextStyle(
              fontSize: 17
          ),
        ),
        centerTitle: true,
        // backgroundColor: Color(0xFF2381d0),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<Object>(
          stream: homes.listControllerSurat.stream,
          builder: (context, snapshot) {
            if(mains.objectbox.boxSurat.isEmpty()){
              return Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  width: MediaQuery.of(context).size.width,
                  child :const Text(
                    'No traced documents yet.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13,),
                  )
              );
            }
            else {
              var queryInbox = mains.objectbox.boxSurat.query(
                  SuratModel_.kategori.equals('tracking'))..order(SuratModel_.tglBuat);
              var query = queryInbox.build();
              List<SuratModel> listSurat = query.find().reversed.toList();
              if (listSurat.isEmpty) {
                return Container(
                    margin: const EdgeInsets.only(top: 15.0),
                    width: MediaQuery.of(context).size.width,
                    child :const Text(
                      'No traced documents yet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13,),
                    )
                );
              } else {
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
                      Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 10.0),
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
                                const Image(image: AssetImage("assets/icons/approve.png"))
                                    :
                                listSurat[index].status == "RETURN" ?
                                const Image(image: AssetImage("assets/icons/return.png"))
                                    :
                                listSurat[index].status == "REJECT" ?
                                const Image(image: AssetImage("assets/icons/reject.png"))
                                    :
                                listSurat[index].status == "READ" ?
                                const Icon(Icons.mark_email_read_rounded,color: Colors.black,)
                                    :
                                listSurat[index].status == "SUBMIT" ?
                                const Icon(Icons.upload_file_rounded, color: Colors.black,)
                                    :
                                listSurat[index].status == "APPROVED" ?
                                const Image(image: AssetImage("assets/icons/approve.png"))
                                    :
                                listSurat[index].status == "SIGNED" ?
                                const Image(image: AssetImage("assets/icons/approve.png"))
                                    :
                                Container()
                                ,
                              ),
                            ],
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

    String url ='${_variableUtil.eOfficeUrl}/api/getTrack';

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

      var query = mains.objectbox.boxSurat.query(SuratModel_.kategori.equals('tracking')).build();
      List<SuratModel> suratList = query.find().toList();
      for(var surat in suratList){
        mains.objectbox.boxSurat.remove(surat.id);
      }

      if(suratMap['code'] == 0){
          for(int i = 0; i < suratMap['data'].length; i++) {
            var dataSurat = Map<String, dynamic>.from(suratMap['data'][i]);
            var query = mains.objectbox.boxSurat.query(SuratModel_.perihal.equals(dataSurat['perihal'].toString()) & SuratModel_.kategori.equals('tracking')).build();
            if(query.find().isNotEmpty) {
              final surat = SuratModel(
                id: query.find().first.id,
                idSurat: dataSurat['id'],
                perihal: dataSurat['perihal'],
                namaSurat: dataSurat['perihal'],
                tglBuat: dataSurat['tgl_buat'],
                kategori: 'tracking',
                status: dataSurat['stat'],
                isMeterai: dataSurat['isMeterai'],
                editor: dataSurat['name'],
                jenisSurat: dataSurat['jenis_surat'],
              );

              mains.objectbox.boxSurat.put(surat);
              setState(() {});
            }
            else{
              final surat = SuratModel(
                idSurat: dataSurat['id'],
                perihal: dataSurat['perihal'],
                namaSurat: dataSurat['perihal'],
                tglBuat: dataSurat['tgl_buat'],
                kategori: 'tracking',
                status: dataSurat['stat'],
                isMeterai: dataSurat['isMeterai'],
                editor: dataSurat['name'],
                jenisSurat: dataSurat['jenis_surat'],
              );

              mains.objectbox.boxSurat.put(surat);
              setState(() {});
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
