import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:militarymessenger/models/NewsModel.dart';
import 'package:militarymessenger/post.dart';
import 'objectbox.g.dart';
import 'package:http/http.dart' as http;
import 'main.dart' as mains;
import 'Home.dart' as homes;

class FeedTabScreen extends StatefulWidget {

  const FeedTabScreen({Key? key}) : super(key: key);

  @override
  State<FeedTabScreen> createState() => _FeedTabScreenState();
}

class _FeedTabScreenState extends State<FeedTabScreen> {
  Store? store;

  @override
  void initState() {
    getNews();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: StreamBuilder<List<NewsModel>>(
              stream: homes.listControllerNews.stream,
              builder: (context, snapshot) {
                if(mains.objectbox.boxNews.isEmpty()){
                  return Container(
                      margin: const EdgeInsets.only(top: 15.0),
                      width: MediaQuery.of(context).size.width,
                      child :const Text(
                        'No news yet.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13,),
                      )
                  );
                }else{
                  var queryBuilder = mains.objectbox.boxNews.query( ( NewsModel_.id.notNull()) )..order(NewsModel_.created_at);
                  var query = queryBuilder.build();
                  List<NewsModel> listNews = query.find().reversed.toList();

                  DateTime now = DateTime.now();
                  DateTime date = DateTime(now.year, now.month, now.day);

                  return Column(
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listNews.length,
                      itemBuilder:(BuildContext context,index)=>
                         Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        backgroundColor: Color(0xffF2F1F6),
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(listNews[index].nameUploader.toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              date.isBefore(DateTime.parse(listNews[index].created_at!))?
                                              Container()
                                                  :
                                              Text(DateFormat('dd MMM yyyy').format(DateTime.parse(listNews[index].created_at!)).toString(),
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 13,
                                                    height: 2
                                                ),
                                              ),
                                              const SizedBox(width: 7,),
                                              Text(DateFormat.Hm().format(DateTime.parse(listNews[index].created_at!)).toString(),
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 13,
                                                    height: 2
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => PostPage(listNews[index])),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                child: listNews[index].image==null?
                                                Container()
                                                    :
                                                Container(
                                                  height: MediaQuery.of(context).size.width * 0.45,
                                                  width: MediaQuery.of(context).size.width * 1,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage('https://eoffice.dev.digiprimatera.co.id/${listNews[index].image}'),
                                                        fit: BoxFit.cover,
                                                      ),
                                                      borderRadius: BorderRadius.circular(6)
                                                  ),
                                                )
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        SizedBox(
                                          height: 100,
                                          child: Html(
                                            data: (listNews[index].text!),
                                            customRender: {
                                              "table": (context, child){
                                                return Container();
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.thumb_up_outlined,
                                              color: listNews[index].status_like! ? const Color(0xFF2481CF) : Colors.grey,
                                              size: 15,
                                            ),
                                            const SizedBox(width: 5,),
                                            Text(
                                              listNews[index].count_like.toString(),
                                              style: TextStyle(
                                                  color: listNews[index].status_like! ? const Color(0xFF2481CF) : Colors.grey,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400
                                              ),
                                            )
                                          ],
                                        ),
                                        Text( jsonDecode(listNews[index].comments!).length == 0 ?
                                          "0 Comments"
                                          :
                                          "${jsonDecode(listNews[index].comments!).length.toString()} Comments",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10,
                                              color: Color(0xFF94A3B8)
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    margin: const EdgeInsets.only(top: 10),
                                    color: Colors.grey.withOpacity(.2),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton.icon(
                                        onPressed: () {
                                          like(listNews[index].idNews!);
                                        } ,
                                        icon: Icon(Icons.thumb_up_outlined,
                                          color: listNews[index].status_like! ? const Color(0xFF2481CF) : Colors.grey,
                                          size: 15,
                                        ),
                                        label: Text("Like",
                                          style: TextStyle(
                                              color: listNews[index].status_like! ? const Color(0xFF2481CF) : Colors.grey,
                                              fontSize: 14
                                          ),
                                        ),
                                      ),
                                      TextButton.icon(
                                        onPressed: () {
                                          Navigator.push(context,
                                            MaterialPageRoute(builder: (context) => PostPage(listNews[index])),
                                          );
                                        },
                                        icon: const Icon(Icons.chat_bubble_outline_rounded,
                                          color: Color(0xFF94A3B8),
                                          size: 15,
                                        ),
                                        label: const Text("Comment",
                                          style: TextStyle(
                                              color: Color(0xFF94A3B8),
                                              fontSize: 14
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }
            ),
          )
      ),
    );
  }

  Future<http.Response> getNews() async {

    String url ='https://eoffice.dev.digiprimatera.co.id/api/getNews/';

    var response = await http.get(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );
    if(response.statusCode == 200){
      Map<String, dynamic> newsMap = jsonDecode(response.body);

      var query = mains.objectbox.boxNews.query(NewsModel_.id.notNull()).build();
      if(query.find().isNotEmpty) {
        mains.objectbox.boxNews.remove(query.find().first.id);
      }

      if(newsMap['message'] == 'Success'){
          for(int i = 0; i < newsMap['data'].length; i++) {
            var dataNews = Map<String, dynamic>.from(newsMap['data'][i]);

            var dataLike = Map<String, dynamic>.from(dataNews['like']);

            List<dynamic> likers = dataLike['data'];

            bool liked = false;

            if(dataLike['total'] > 0){
              for(int i=0;i<dataLike['total'];i++){
                if(likers[i]['users_id']==mains.objectbox.boxUser.get(1)!.userId){
                  liked = true;
                  break;
                }
              }
            }

            var query = mains.objectbox.boxNews.query(NewsModel_.idNews.equals(dataNews['id'])).build();
            if(query.find().isNotEmpty) {
              // mains.objectbox.boxNews.remove(query.find().first.id);
              final news = NewsModel(
                id: query.find().first.id,
                idNews: dataNews['id'],
                idUploader: dataNews['id_user'],
                nameUploader: dataNews['uploader'],
                text: dataNews['text'],
                image: dataNews['image'],
                video: dataNews['video'],
                file: dataNews['file'],
                created_at: dataNews['created_at'],
                updated_at: dataNews['updated_at'],
                count_like: dataLike['total'],
                status_like: liked,
                comments: jsonEncode(dataNews['comments']),
              );

              mains.objectbox.boxNews.put(news);
              setState(() {});
            }
            else{
              final news = NewsModel(
                idNews: dataNews['id'],
                idUploader: dataNews['id_user'],
                nameUploader: dataNews['uploader'],
                text: dataNews['text'],
                image: dataNews['image'],
                video: dataNews['video'],
                file: dataNews['file'],
                created_at: dataNews['created_at'],
                updated_at: dataNews['updated_at'],
                count_like: dataLike['total'],
                status_like: liked,
                comments: jsonEncode(dataNews['comments']),
              );

              mains.objectbox.boxNews.put(news);
              setState(() {

              });
            }
          }
      }
      else{
        EasyLoading.showError(newsMap['message']);
      }
    }
    else{
      EasyLoading.showError('${response.statusCode}, "Gagal terhubung ke server!"');
    }
    return response;
  }

  Future<http.Response> like(int idNews) async {

    String url ='https://eoffice.dev.digiprimatera.co.id/api/likes';

    Map<String, dynamic> data = {
      'payload': {
        'id_news': idNews,
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
      Map<String, dynamic> likeMap = jsonDecode(response.body);

      if(likeMap['code'] != 95){
        if(likeMap['code'] == 1){
          var query = mains.objectbox.boxNews.query(NewsModel_.idNews.equals(idNews)).build();
          if(query.find().isNotEmpty) {
            final news = NewsModel(
              id: query.find().first.id,
              idNews: query.find().first.idNews,
              idUploader: query.find().first.idUploader,
              nameUploader: query.find().first.nameUploader,
              text: query.find().first.text,
              image: query.find().first.image,
              video: query.find().first.video,
              file: query.find().first.file,
              created_at: query.find().first.created_at,
              updated_at: query.find().first.updated_at,
              count_like: query.find().first.count_like+1,
              status_like: true,
              comments: query.find().first.comments,
            );

            mains.objectbox.boxNews.put(news);
            setState(() {});
          }
        }
        else{
          var query = mains.objectbox.boxNews.query(NewsModel_.idNews.equals(idNews)).build();
          if(query.find().isNotEmpty) {
            final news = NewsModel(
              id: query.find().first.id,
              idNews: query.find().first.idNews,
              idUploader: query.find().first.idUploader,
              nameUploader: query.find().first.nameUploader,
              text: query.find().first.text,
              image: query.find().first.image,
              video: query.find().first.video,
              file: query.find().first.file,
              created_at: query.find().first.created_at,
              updated_at: query.find().first.updated_at,
              count_like: query.find().first.count_like-1,
              status_like: false,
              comments: query.find().first.comments,
            );

            mains.objectbox.boxNews.put(news);
            setState(() {});
          }
        }
      }
      else{
        EasyLoading.showError(likeMap['message']);
      }
    }
    else{
      EasyLoading.showError('${response.statusCode}, Gagal terhubung ke server!');
    }
    return response;
  }

}