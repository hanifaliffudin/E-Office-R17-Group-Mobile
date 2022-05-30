import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:militarymessenger/models/SuratModel.dart';
import 'objectbox.g.dart';
import 'package:badges/badges.dart';
import 'document.dart';
import 'package:militarymessenger/tracking.dart';
import 'package:militarymessenger/needSign.dart';
import 'package:militarymessenger/inbox.dart';
import 'package:militarymessenger/sent.dart';
import 'package:militarymessenger/document.dart';
import 'package:http/http.dart' as http;
import 'main.dart' as mains;
import 'Home.dart' as homes;



class XploreTabScreen extends StatefulWidget {

  @override
  State<XploreTabScreen> createState() => _XploreTabScreenState();
}

class _XploreTabScreenState extends State<XploreTabScreen> {

  @override
  void initState() {
    // TODO: implement initState
    // getBadgeInbox();
    getDataSuratNeedApprove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => InboxPage()),
                      );
                    },
                    child: Column(
                      children: [
                        Badge(
                          position: BadgePosition.bottomEnd(end: 0, bottom: -6),
                          badgeContent: Text(
                            '3',
                            style: TextStyle(
                                color: Colors.white,
                            ),
                          ),
                          badgeColor: Color(0xFFE2574C),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xFF5584AC),
                            child: CircleAvatar(
                              backgroundImage: AssetImage('assets/icons/inbox_icon2.png'),
                              backgroundColor: Color(0xFF5584AC),
                              radius: 20,
                            ),
                          ),
                        ),
                        Text(
                          'Inbox',
                          style: TextStyle(
                            height: 2,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SentPage()),
                      );
                    },
                    child: Column(
                      children: [
                        Badge(
                          position: BadgePosition.bottomEnd(end: 0, bottom: -6),
                          badgeContent: Text(
                            '3',
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                          badgeColor: Color(0xFFE2574C),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xFFE49D23),
                            child: CircleAvatar(
                              backgroundImage: AssetImage('assets/icons/sent_icon2.png'),
                              backgroundColor: Color(0xFFE49D23),
                              radius: 20,
                            ),
                          ),
                        ),
                        Text(
                          'Sent',
                          style: TextStyle(
                            height: 2,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TrackingPage()),
                      );
                    },
                    child: Column(
                      children: [
                        Badge(
                          position: BadgePosition.bottomEnd(end: 0, bottom: -6),
                          badgeContent: Text(
                            '3',
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                          badgeColor: Color(0xFFE2574C),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xFF3B8880),
                            child: CircleAvatar(
                              backgroundImage: AssetImage('assets/icons/approved_icon2.png'),
                              backgroundColor: Color(0xFF3B8880),
                              radius: 20,
                            ),
                          ),
                        ),
                        Text(
                          'Tracking',
                          style: TextStyle(
                            height: 2,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NeedSign()),
                      );
                    },
                    child: Column(
                      children: [
                        Badge(
                          position: BadgePosition.bottomEnd(end: 0, bottom: -6),
                          badgeContent: Text(
                            '3',
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                          badgeColor: Color(0xFFE2574C),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xFF9EADBD),
                            child: CircleAvatar(
                              backgroundImage: AssetImage('assets/icons/draft_icon2.png'),
                              backgroundColor: Color(0xFF9EADBD),
                              radius: 20,
                            ),
                          ),
                        ),
                        Text(
                          'Need Sign',
                          style: TextStyle(
                            height: 2,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Need Approve",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "More",
                          style: TextStyle(
                              color: Color(0xFF2481CF),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 1.3
                          ),
                        )
                      ],
                    ),
                  ),
                  StreamBuilder<List<SuratModel>>(
                    stream: homes.listControllerSurat.stream,
                    builder: (context, snapshot){
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
                        var queryNeedApprove = mains.objectbox.boxSurat.query(SuratModel_.kategori.equals('needApprove'))..order(SuratModel_.tglBuat);
                        var query = queryNeedApprove.build();
                        List<SuratModel> listSurat = query.find().reversed.toList();
                        return Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                                itemCount: listSurat.length,
                                itemBuilder:(BuildContext context,index)=>
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => DocumentPage(listSurat[index])),
                                        );
                                      },
                                      child: Card(
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
                                                          child: Text(listSurat[index].perihal!,
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                            style: TextStyle(fontWeight: FontWeight.bold),),
                                                        ),
                                                        SizedBox(height: 5,),
                                                        Text(listSurat[index].tglBuat!),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 50,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage("assets/icons/download_icon.png")
                                                    )
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<http.Response> getDataSuratNeedApprove() async {

    String url ='http://eoffice.dev.digiprimatera.co.id/api/needApprover';

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
      //print("${response.body}");
      Map<String, dynamic> suratMap = jsonDecode(response.body);

      var query = mains.objectbox.boxSurat.query(SuratModel_.kategori.equals('needApprove')).build();
      if(query.find().isNotEmpty) {
        mains.objectbox.boxSurat.remove(query.find().first.id);
      }

      if(suratMap['message'] == 'success'){
        if(suratMap['count']>0){
          for(int i = 0; i < suratMap['data'].length; i++) {
            var dataSurat = Map<String, dynamic>.from(suratMap['data'][i]);
            var query = mains.objectbox.boxSurat.query(SuratModel_.idSurat.equals(dataSurat['id'].toString()) & SuratModel_.kategori.equals('needApprove')).build();
            if(query.find().isNotEmpty) {
              final surat = SuratModel(
                id: query.find().first.id,
                idSurat: dataSurat['id'],
                namaSurat: query.find().first.namaSurat,
                nomorSurat: dataSurat['nomor'],
                pengirim: query.find().first.pengirim,
                perihal: dataSurat['perihal'],
                status: query.find().first.status,
                tglSelesai: query.find().first.tglSelesai,
                url: dataSurat['isi_surat'],
                kategori: 'needApprove',
                tglBuat: dataSurat['tgl_buat'],
                tipeSurat: dataSurat['tipe_surat'],
              );


              mains.objectbox.boxSurat.put(surat);
              setState(() {

              });
              // mains.objectbox.boxSurat.remove(query.find().first.id);

            }
            else{
              final surat = SuratModel(
                idSurat: dataSurat['id'],
                nomorSurat: dataSurat['nomor'],
                perihal: dataSurat['perihal'],
                tglBuat: dataSurat['tgl_buat'],
                kategori: 'needApprove',
                url: dataSurat['isi_surat'],
                tipeSurat: dataSurat['tipe_surat'],
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
      }
    }
    else{
      print("Gagal terhubung ke server!");
    }
    return response;
  }

  Future<http.Response> getBadgeInbox() async {
    String url ='http://eoffice.dev.digiprimatera.co.id/api/badgeInbox';

    Map<String, dynamic> data = {

      'payload': {
        'users_id': mains.objectbox.boxUser.get(1)!.userId,
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

      if(suratMap['message'] == 'success'){
          // print(suratMap['count unread']);
      }
      else{
        print(suratMap['message']);
        print(response.statusCode);
      }
    }
    else{
      print("Gagal terhubung ke server!");
    }
    return response;
  }
  Future<http.Response> getBadgeSent() async {
    String url ='http://eoffice.dev.digiprimatera.co.id/api/badgeSent';

    Map<String, dynamic> data = {

      'payload': {
        'users_id': mains.objectbox.boxUser.get(1)!.userId,
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

      if(suratMap['message'] == 'success'){
          // print(suratMap['count unread']);
      }
      else{
        print(suratMap['message']);
        print(response.statusCode);
      }
    }
    else{
      print("Gagal terhubung ke server!");
    }
    return response;
  }
  Future<http.Response> getBadgeApproved() async {
    String url ='http://eoffice.dev.digiprimatera.co.id/api/badgeApproved';

    Map<String, dynamic> data = {

      'payload': {
        'users_id': mains.objectbox.boxUser.get(1)!.userId,
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

      if(suratMap['message'] == 'success'){
          print(suratMap['count unread']);
      }
      else{
        print(suratMap['message']);
        print(response.statusCode);
      }
    }
    else{
      print("Gagal terhubung ke server!");
    }
    return response;
  }
  Future<http.Response> getBadgeNeedApprove() async {
    String url ='http://eoffice.dev.digiprimatera.co.id/api/badgeNeedApprove';

    Map<String, dynamic> data = {
      'payload': {
        'users_id': mains.objectbox.boxUser.get(1)!.userId,
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

      if(suratMap['message'] == 'success'){
          print(suratMap['count unread']);
      }
      else{
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