import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart' as mains;
import 'Home.dart' as homes;

class ApprovedPage extends StatefulWidget {
  const ApprovedPage({Key? key}) : super(key: key);

  @override
  _ApprovedPageState createState() => _ApprovedPageState();
}

class _ApprovedPageState extends State<ApprovedPage> {

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
        title: Text('Approved'.toUpperCase(),
          style: TextStyle(
              fontSize: 17
          ),
        ),
        centerTitle: true,
        // backgroundColor: Color(0xFF2381d0),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 5),
                height: 80,
                width: 500,
                child: Card(
                  margin: EdgeInsets.only(top: 3, bottom: 3),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          child: Container(
                            height: 50,
                            width: 50,
                            margin: EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/images/pdf.png")
                                )
                            ),
                          ),
                        ),
                        Positioned(
                          left: 55,
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
                                  "Penunjukan Menteri Dalam Negeri.pdf",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                "Jul 17, 2021 15.34",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  height: 2,
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
                              child: Icon(
                                Icons.check_rounded,
                                color: Color(0xFF059669),
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5),
                height: 80,
                width: 500,
                child: Card(
                  margin: EdgeInsets.only(top: 3, bottom: 3),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          child: Container(
                            height: 50,
                            width: 50,
                            margin: EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/images/pdf.png")
                                )
                            ),
                          ),
                        ),
                        Positioned(
                          left: 55,
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
                                  "Penunjukan Menteri Dalam Negeri.pdf",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                "Jul 17, 2021 15.34",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  height: 2,
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
                              child: Icon(
                                Icons.check_rounded,
                                color: Color(0xFF059669),
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<http.Response> getDataSurat() async {

    String url ='http://eoffice.dev.digiprimatera.co.id/api/getSuratKirim';

    Map<String, dynamic> data = {
      // 'api_key': this.apiKey,
      // 'email': mains.objectbox.boxUser.get(1)?.email,
      'payload': {
        'id_user': '22',
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
            print(dataSurat['surat_id']);
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
