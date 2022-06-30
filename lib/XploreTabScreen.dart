import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:militarymessenger/NeedApprove.dart';
import 'package:militarymessenger/models/BadgeModel.dart';
import 'package:militarymessenger/models/SuratModel.dart';
import 'objectbox.g.dart';
import 'package:badges/badges.dart';
import 'document.dart';
import 'package:militarymessenger/needSign.dart';
import 'package:militarymessenger/inbox.dart';
import 'package:militarymessenger/Signed.dart';
import 'package:militarymessenger/document.dart';
import 'package:http/http.dart' as http;
import 'main.dart' as mains;
import 'Home.dart' as homes;


class XploreTabScreen extends StatefulWidget {
  const XploreTabScreen({Key? key}) : super(key: key);


  @override
  State<XploreTabScreen> createState() => _XploreTabScreenState();
}

class _XploreTabScreenState extends State<XploreTabScreen> {

  @override
  void initState() {
    // TODO: implement initState
    getBadgeInbox();
    getBadgeSign();
    getBadgeNeedApprove();
    getRecent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const NeedApprove()),
                      );
                    },
                    child: Column(
                      children: [
                        Badge(
                          position: BadgePosition.bottomEnd(end: 0, bottom: -6),
                          showBadge: mains.objectbox.boxBadge.get(1) != null ?
                          mains.objectbox.boxBadge.get(1)!.badgeNeedApprove == 0 ? false : true
                              :
                          false,
                          badgeContent: Text(
                            mains.objectbox.boxBadge.get(1) != null ?
                            mains.objectbox.boxBadge.get(1)!.badgeNeedApprove.toString()
                                :
                            '',
                            style: const TextStyle(
                                color: Colors.white
                            ),
                          ),
                          badgeColor: const Color(0xFFE2574C),
                          child: const CircleAvatar(
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
                          'Need Approve',
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
                        MaterialPageRoute(builder: (context) => const NeedSign()),
                      );
                    },
                    child: Column(
                      children: [
                        Badge(
                          position: BadgePosition.bottomEnd(end: 0, bottom: -6),
                          showBadge: mains.objectbox.boxBadge.get(1) != null ?
                          mains.objectbox.boxBadge.get(1)!.badgeNeedSign == 0 ? false : true
                              :
                          false,
                          badgeContent: Text(
                            mains.objectbox.boxBadge.get(1) != null ?
                            mains.objectbox.boxBadge.get(1)!.badgeNeedSign.toString()
                                :
                            '',
                            style: const TextStyle(
                                color: Colors.white
                            ),
                          ),
                          badgeColor: const Color(0xFFE2574C),
                          child: const CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xFF9EADBD),
                            child: CircleAvatar(
                              backgroundImage: AssetImage('assets/icons/draft_icon2.png'),
                              backgroundColor: Color(0xFF9EADBD),
                              radius: 20,
                            ),
                          ),
                        ),
                        const Text(
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
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const InboxPage()),
                      );
                    },
                    child: Column(
                      children: [
                        Badge(
                              position: BadgePosition.bottomEnd(end: 0, bottom: -6),
                              showBadge:mains.objectbox.boxBadge.get(1) != null ?
                              mains.objectbox.boxBadge.get(1)!.badgeInbox == 0 ? false : true
                                  :
                              false,
                              badgeContent: Text(
                                mains.objectbox.boxBadge.get(1) != null ?
                                mains.objectbox.boxBadge.get(1)!.badgeInbox.toString()
                                    :
                                '',
                                style: const TextStyle(
                                    color: Colors.white,
                                ),
                              ),
                              badgeColor: const Color(0xFFE2574C),
                              child: const CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xFF5584AC),
                                child: CircleAvatar(
                                  backgroundImage: AssetImage('assets/icons/inbox_icon2.png'),
                                  backgroundColor: Color(0xFF5584AC),
                                  radius: 20,
                                ),
                              ),
                            ),
                        const Text(
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
                        MaterialPageRoute(builder: (context) => const SignedPage()),
                      );
                    },
                    child: Column(
                      children: const [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(0xFFE49D23),
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/icons/sent_icon2.png'),
                            backgroundColor: Color(0xFFE49D23),
                            radius: 20,
                          ),
                        ),
                        Text(
                          'Signed',
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
                      children: const [
                        Text(
                          "Recents",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // Text(
                        //   "More",
                        //   style: TextStyle(
                        //       color: Color(0xFF2481CF),
                        //       fontSize: 12,
                        //       fontWeight: FontWeight.w600,
                        //       height: 1.3
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: StreamBuilder<List<SuratModel>>(
                      stream: homes.listControllerSurat.stream,
                      builder: (context, snapshot){
                        if(mains.objectbox.boxSurat.isEmpty()){
                          return Container(
                              margin: const EdgeInsets.only(top: 15.0),
                              width: MediaQuery.of(context).size.width,
                              child :  const Text(
                                'No recents yet.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13,),
                              )
                          );
                        }
                        else{
                          var queryNeedApprove = mains.objectbox.boxSurat.query(SuratModel_.kategori.equals('history'))..order(SuratModel_.tglBuat);
                          var query = queryNeedApprove.build();
                          List<SuratModel> listSurat = query.find().reversed.toList();
                          if(listSurat.isEmpty){
                            return Container(
                                margin: const EdgeInsets.only(top: 15.0),
                                width: MediaQuery.of(context).size.width,
                                child :const Text(
                                  'No recents yet.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13,),
                                )
                            );
                          }
                          else{
                            return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: listSurat.length,
                                itemBuilder:(BuildContext context,index){
                                  return InkWell(
                                    onTap: () {
                                      if(listSurat[index].kategori == 'history'){
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
                                      }else{
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => DocumentPage(listSurat[index])),
                                        );
                                      }
                                    },
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(right: 20.0),
                                                  child: const Image(image: AssetImage('assets/images/pdf.png'),width: 50,),
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ConstrainedBox(
                                                      constraints: const BoxConstraints(
                                                          maxWidth: 200
                                                      ),
                                                      child: Text(listSurat[index].perihal!,
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        style: const TextStyle(fontWeight: FontWeight.bold),),
                                                    ),
                                                    const SizedBox(height: 5,),
                                                    Text(listSurat[index].tglBuat!),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Container(
                                              height: 50,
                                              width: 30,
                                              decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage("assets/icons/download_icon.png")
                                                  )
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }

                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
          var query = mains.objectbox.boxBadge.query(BadgeModel_.id.equals(1)).build();
          if(query.find().isNotEmpty) {
            var badge = BadgeModel(
              id: 1,
              badgeInbox: suratMap['count unread'],
              badgeNeedSign: query.find().first.badgeNeedSign,
              badgeNeedApprove: query.find().first.badgeNeedApprove,
            );

            mains.objectbox.boxBadge.put(badge);
            setState(() {

            });
          }else{
            var badge = BadgeModel(
              badgeInbox: suratMap['count unread'],
            );

            mains.objectbox.boxBadge.put(badge);
            setState(() {

            });
          }
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

  Future<http.Response> getBadgeSign() async {
    String url ='http://eoffice.dev.digiprimatera.co.id/api/badgeSign';

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

      if(suratMap['message'] == 'success' || suratMap['message'] == 'No Document'){
          var query = mains.objectbox.boxBadge.query(BadgeModel_.id.equals(1)).build();
          if(query.find().isNotEmpty) {
            var badge = BadgeModel(
              id: 1,
              badgeInbox: query.find().first.badgeInbox,
              badgeNeedApprove: query.find().first.badgeNeedApprove,
              badgeNeedSign: suratMap['data'],
            );

            mains.objectbox.boxBadge.put(badge);
            setState(() {});
          }else{
            var badge = BadgeModel(
              badgeNeedSign: suratMap['data'],
            );

            mains.objectbox.boxBadge.put(badge);
            setState(() {});
          }
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
      // print("${response.body}");
      Map<String, dynamic> suratMap = jsonDecode(response.body);

      if(suratMap['message'] == 'sukses' ){
          var query = mains.objectbox.boxBadge.query(BadgeModel_.id.equals(1)).build();
          if(query.find().isNotEmpty) {
            var badge = BadgeModel(
              id: 1,
              badgeInbox: query.find().first.badgeInbox,
              badgeNeedSign: query.find().first.badgeNeedSign,
              badgeNeedApprove: suratMap['total'],
            );

            mains.objectbox.boxBadge.put(badge);
            setState(() {});
          }else{
            var badge = BadgeModel(
              badgeNeedApprove: suratMap['total'],
            );

            // mains.objectbox.boxBadge.put(badge);
            setState(() {});
          }
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

  Future<http.Response> getRecent() async {

    String url ='http://eoffice.dev.digiprimatera.co.id/api/recent';

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