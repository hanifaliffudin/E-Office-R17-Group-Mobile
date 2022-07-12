import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:militarymessenger/Canceled.dart';
import 'package:militarymessenger/NeedReview.dart';
import 'package:militarymessenger/models/BadgeModel.dart';
import 'package:militarymessenger/models/SuratModel.dart';
import 'package:militarymessenger/tracking.dart';
import 'objectbox.g.dart';
import 'package:badges/badges.dart';
import 'document.dart';
import 'package:militarymessenger/NeedSign.dart';
import 'package:militarymessenger/inbox.dart';
import 'package:militarymessenger/Signed.dart';
import 'package:militarymessenger/document.dart';
import 'package:http/http.dart' as http;
import 'main.dart' as mains;
import 'Home.dart' as homes;


class EOfficeTabScreen extends StatefulWidget {
  const EOfficeTabScreen({Key? key}) : super(key: key);


  @override
  State<EOfficeTabScreen> createState() => _EOfficeTabScreenState();
}

class _EOfficeTabScreenState extends State<EOfficeTabScreen> {

  @override
  void initState() {
    // TODO: implement initState
    getAllBadge();
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
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const InboxPage()),
                      ).then((value) {
                          getAllBadge();
                          getRecent();
                      });
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
                                backgroundImage: AssetImage('assets/icons/inbox.png'),
                                backgroundColor: Color(0xFF5584AC),
                                radius: 30,
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
                        )
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const NeedSign()),
                      ).then((value) {
                          getAllBadge();
                          getRecent();
                      });
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
                            backgroundImage: AssetImage('assets/icons/need-sign.png'),
                            backgroundColor: Color(0xFF9EADBD),
                            radius: 30,
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
                        MaterialPageRoute(builder: (context) => const NeedReview()),
                      ).then((value) {
                          getAllBadge();
                          getRecent();
                      });
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
                            backgroundImage: AssetImage('assets/icons/need-review.png'),
                            backgroundColor: Color(0xFF3B8880),
                            radius: 30,
                          ),
                        ),
                        const Text(
                          'Need Review',
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const SignedPage()),
                      );
                    },
                    child: Column(
                      children: const [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/icons/signed-icon.png'),
                          backgroundColor: Color(0xFFE49D23),
                          radius: 30,
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
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const CanceledPage()),
                      );
                    },
                    child: Column(
                      children: [
                        Badge(
                          position: BadgePosition.bottomEnd(end: 0, bottom: -6),
                          showBadge: false,
                          badgeContent: const Text('',
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                          badgeColor: const Color(0xFFE2574C),
                          child: const CircleAvatar(
                            backgroundImage: AssetImage('assets/icons/canceled.png'),
                            backgroundColor: Color(0xFFF54040),
                            radius: 30,
                          ),
                        ),
                        const Text(
                          'Canceled',
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
                        MaterialPageRoute(builder: (context) => const TrackingPage()),
                      );
                    },
                    child: Column(
                      children: [
                        Badge(
                          position: BadgePosition.bottomEnd(end: 0, bottom: -6),
                          showBadge: false,
                          badgeContent: const Text('',
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                          badgeColor: const Color(0xFFE2574C),
                          child: const CircleAvatar(
                            backgroundImage: AssetImage('assets/icons/tracking.png'),
                            backgroundColor: Color(0xFFF5C840),
                            radius: 30,
                          ),
                        ),
                        const Text(
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
                          var queryRecents = mains.objectbox.boxSurat.query(SuratModel_.kategori.equals('history'))..order(SuratModel_.tglBuat);
                          var query = queryRecents.build();
                          List<SuratModel> listSurat = query.find().reversed.toList();
                          if(listSurat.isEmpty){
                            return Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                width: MediaQuery.of(context).size.width,
                                child :const Text(
                                  'No recents yet.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13,),
                                )
                            );
                          }
                          else{
                            DateTime now = DateTime.now();
                            DateTime date = DateTime(now.year, now.month, now.day);

                            return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: listSurat.length,
                                itemBuilder:(BuildContext context,index){
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => DocumentPage(listSurat[index])),);
                                    },
                                    child: Card(
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

  void getAllBadge(){
    getBadgeInbox();
    getBadgeSign();
    getBadgeNeedApprove();
  }

  Future<http.Response> getBadgeInbox() async {
    String url ='https://eoffice.dev.digiprimatera.co.id/api/badgeInbox';

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
        EasyLoading.showError(suratMap['message']);
      }
    }
    else{
      EasyLoading.showError('${response.statusCode}, Gagal terhubung ke server!');
    }
    return response;
  }

  Future<http.Response> getBadgeSign() async {
    String url ='https://eoffice.dev.digiprimatera.co.id/api/badgeSign';

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
        EasyLoading.showError(suratMap['message']);
      }
    }
    else{
      EasyLoading.showError('${response.statusCode}, Gagal terhubung ke server!');
    }
    return response;
  }

  Future<http.Response> getBadgeNeedApprove() async {
    String url ='https://eoffice.dev.digiprimatera.co.id/api/badgeNeedApprove';

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

            mains.objectbox.boxBadge.put(badge);
            setState(() {});
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