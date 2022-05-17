import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart' as mains;
import 'Home.dart' as homes;

class SentPage extends StatefulWidget {
  const SentPage({Key? key}) : super(key: key);

  @override
  _SentPageState createState() => _SentPageState();
}

class _SentPageState extends State<SentPage> {

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
        title: Text('Sent'.toUpperCase(),
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
                            radius: 25,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(
                              'assets/images/defaultuser.png',
                            ),
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
                                  "To: albertus@digiprimatera.co.id ",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                "New Open Shift Available",
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
                                "Dear Albertus, a new open shift is available",
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
                                '09.45',
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
              Container(
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
                            radius: 25,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(
                              'assets/images/defaultuser.png',
                            ),
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
                                  "To: albertus@digiprimatera.co.id ",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                "Your Planning Shift DT",
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
                                "Dear Albertus, your planning shift DT is",
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
                                '09.45',
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
