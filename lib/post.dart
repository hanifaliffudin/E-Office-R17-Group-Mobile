import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:militarymessenger/models/NewsModel.dart';
import 'package:http/http.dart' as http;
import 'package:militarymessenger/objectbox.g.dart';
import 'main.dart' as mains;

class PostPage extends StatefulWidget {
  NewsModel? news;

  PostPage(this.news, {Key? key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState(news);
}


class _PostPageState extends State<PostPage> {
  NewsModel? news;

  _PostPageState(this.news);

  final _focusNode = FocusNode();
  bool isLiked = false;
  int likeCount = 0;
  bool likeButton = false;

  List<Comment> bubbleComments = [];
  List listComments = [];

  TextEditingController inputTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    listComments = jsonDecode(news!.comments!);
    for(int i=0;i<listComments.length;i++){
      var dataComments = Map<String, dynamic>.from(listComments[i]);
      bubbleComments.add(
          Comment(
            commenter_id: dataComments['commenter_id'].runtimeType == String ? int.parse(dataComments['commenter_id']) : dataComments['commenter_id'],
            name: dataComments['nama'],
            comment: dataComments['comment'],
            created_at: dataComments['created_at'],
            updated_at: dataComments['updated_at'],
          )
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(news!.nameUploader!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(DateFormat('dd MMM yyyy').format(DateTime.parse(news!.created_at!)).toString(),
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,
                                            height: 2
                                        ),
                                      ),
                                      const SizedBox(width: 7,),
                                      Text(DateFormat.Hm().format(DateTime.parse(news!.created_at!)).toString(),
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
                          Row(
                            children: [
                              Expanded(
                                  child: news!.image==null?
                                  Container()
                                      :
                                  Container(
                                    height: MediaQuery.of(context).size.width * 0.45,
                                    width: MediaQuery.of(context).size.width * 1,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage('https://eoffice.dev.digiprimatera.co.id/${news!.image}'),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(6)
                                    ),
                                  )
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Html(
                              data: news!.text!,
                            customRender: {
                                "table": (context, child){
                                  return Container();
                                }
                            },
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
                                      color: mains.objectbox.boxNews.get(news!.id)!.status_like! ? const Color(0xFF2481CF) : Colors.grey,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 5,),
                                    Text(mains.objectbox.boxNews.get(news!.id)!.count_like.toString(),
                                      style: TextStyle(
                                          color: mains.objectbox.boxNews.get(news!.id)!.status_like! ? const Color(0xFF2481CF) : Colors.grey,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400
                                      ),
                                    )
                                  ],
                                ),
                                Text(jsonDecode(news!.comments!).length == 0 ?
                                "0 Comments"
                                    :
                                "${jsonDecode(news!.comments!).length.toString()} Comments",
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
                                  like(news!.idNews!);
                                },
                                icon: Icon(Icons.thumb_up_outlined,
                                  color: mains.objectbox.boxNews.get(news!.id)!.status_like! ? const Color(0xFF2481CF) : Colors.grey,
                                  size: 15,
                                ),
                                label: Text("Like",
                                  style: TextStyle(
                                      color: mains.objectbox.boxNews.get(news!.id)!.status_like! ? const Color(0xFF2481CF) : Colors.grey,
                                      fontSize: 14
                                  ),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {

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
                          ),
                          const SizedBox(height: 10,),
                          // Container(
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Text('Reactions',
                          //         style: TextStyle(
                          //             color: Color(0xFF94A3B8),
                          //             fontSize: 10,
                          //             fontWeight: FontWeight.w400
                          //         ),
                          //       ),
                          //       SizedBox(height: 10,),
                          //       Row(
                          //         children: [
                          //           Stack(
                          //             children: [
                          //               CircleAvatar(
                          //                 backgroundColor: Colors.grey,
                          //                 backgroundImage: AssetImage(
                          //                     'assets/images/avatar1.png'
                          //                 ),
                          //               ),
                          //               Positioned(
                          //                 bottom: 0,
                          //                 right: 0,
                          //                 child: Container(
                          //                   padding: EdgeInsets.all(3),
                          //                   decoration: BoxDecoration(
                          //                     borderRadius: BorderRadius.circular(10),
                          //                     color: Color(0xFFEAF6FF),
                          //                   ),
                          //                   child: Icon(
                          //                     Icons.thumb_up_alt_outlined,
                          //                     color: Color(0xFF2481CF),
                          //                     size: 12,
                          //                   ),
                          //                 ),
                          //               )
                          //             ],
                          //           ),
                          //           SizedBox(width: 10,),
                          //           Stack(
                          //             children: [
                          //               CircleAvatar(
                          //                 backgroundColor: Colors.grey,
                          //                 backgroundImage: AssetImage(
                          //                     'assets/images/avatar2.png'
                          //                 ),
                          //               ),
                          //               Positioned(
                          //                 bottom: 0,
                          //                 right: 0,
                          //                 child: Container(
                          //                   padding: EdgeInsets.all(3),
                          //                   decoration: BoxDecoration(
                          //                     borderRadius: BorderRadius.circular(10),
                          //                     color: Color(0xFFEAF6FF),
                          //                   ),
                          //                   child: Icon(
                          //                     Icons.thumb_up_alt_outlined,
                          //                     color: Color(0xFF2481CF),
                          //                     size: 12,
                          //                   ),
                          //                 ),
                          //               )
                          //             ],
                          //           ),
                          //           SizedBox(width: 10,),
                          //           Stack(
                          //             children: [
                          //               CircleAvatar(
                          //                 backgroundColor: Colors.grey,
                          //                 backgroundImage: AssetImage(
                          //                     'assets/images/avatar3.png'
                          //                 ),
                          //               ),
                          //               Positioned(
                          //                 bottom: 0,
                          //                 right: 0,
                          //                 child: Container(
                          //                   padding: EdgeInsets.all(3),
                          //                   decoration: BoxDecoration(
                          //                     borderRadius: BorderRadius.circular(10),
                          //                     color: Color(0xFFEAF6FF),
                          //                   ),
                          //                   child: Icon(
                          //                     Icons.thumb_up_alt_outlined,
                          //                     color: Color(0xFF2481CF),
                          //                     size: 12,
                          //                   ),
                          //                 ),
                          //               )
                          //             ],
                          //           ),
                          //         ],
                          //       )
                          //     ],
                          //   ),
                          // ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Comments',
                                style: TextStyle(
                                    color: Color(0xFF94A3B8),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                              const SizedBox(height: 20,),
                              ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: bubbleComments.length,
                                  itemBuilder: (BuildContext context, index)=>
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const CircleAvatar(
                                                backgroundColor: Colors.grey,
                                                child: Icon(
                                                    Icons.person,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(width: 15,),
                                              Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: <Widget>[
                                                      Stack(
                                                        children: <Widget>[
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12,),
                                                            // margin: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                                            decoration: BoxDecoration(
                                                              color: const Color(0xFFEEEEEE),
                                                              borderRadius: BorderRadius.circular(5),
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text( bubbleComments[index].commenter_id == mains.objectbox.boxUser.get(1)!.userId ?
                                                                mains.objectbox.boxUser.get(1)!.userName!
                                                                  :
                                                                bubbleComments[index].name == null ? "Unknown" : bubbleComments[index].name!,
                                                                  style: const TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 15
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 5,),
                                                                Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: <Widget>[
                                                                    Container(
                                                                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                                                                      child:
                                                                      Text(
                                                                        bubbleComments[index].comment!,
                                                                        style: const TextStyle(fontSize: 14, color: Colors.black),
                                                                        textAlign: TextAlign.left,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(width: 5,),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Text(DateFormat.Hm().format(DateTime.parse(bubbleComments[index].created_at!)).toString(),
                                                            style: const TextStyle(
                                                                fontSize: 11,
                                                                color: Color(0xFF94A3B8)
                                                            ),),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10,)
                                        ],
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Theme.of(context).backgroundColor,
              padding: const EdgeInsets.only(right: 10, left: 10, top: 7, bottom: 25),
              child: Row(
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      constraints: BoxConstraints(
                        minHeight: 25.0,
                        maxHeight: 100,
                        minWidth: MediaQuery.of(context).size.width,
                        maxWidth: MediaQuery.of(context).size.width,
                      ),
                      child: Scrollbar(
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                focusNode: _focusNode,
                                cursorColor: const Color(0xFF2481CF),
                                keyboardType: TextInputType.multiline,
                                controller: inputTextController,
                                maxLines: null,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.all(13),
                                    border: InputBorder.none,
                                    hintText: 'Type something...',
                                    hintStyle: TextStyle(
                                        color: Color(0xff99999B),
                                        fontSize: 12
                                    )
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 20, right: 8),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).floatingActionButtonTheme.backgroundColor
                          ),
                        ),
                        onPressed: (){
                          if(inputTextController.text == ""){

                          }else{
                            List comments = jsonDecode(news!.comments!);
                            comments.add(
                                {
                                  "comment": inputTextController.text,
                                  "commenter_id": mains.objectbox.boxUser.get(1)!.userId.toString(),
                                  "created_at": DateTime.now().toString(),
                                  "updated_at": DateTime.now().toString(),
                                  "nama": mains.objectbox.boxUser.get(1)!.userName,
                                }
                            );
                            postComment(news!.idNews!, inputTextController.text, jsonEncode(comments));
                            inputTextController.clear();
                          }
                        },
                        child: Text('Post', style: TextStyle(color: Theme.of(context).inputDecorationTheme.labelStyle?.color),),
                      )
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Future<http.Response> like(int idNews) async {

    String url ='https://eoffice.dev.digiprimatera.co.id/api/likes';

    Map<String, dynamic> data = {
      'payload': {
        'id_news': idNews,
        'id_user': mains.objectbox.boxUser.get(1)!.userId,
      }
    };

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
        print(likeMap['code']);
        print(likeMap['message']);
      }
    }
    else{
      print("Gagal terhubung ke server!");
      print(response.statusCode);
    }
    return response;
  }

  Future<http.Response> postComment(int idNews, String comment, String comments) async {

    String url ='https://eoffice.dev.digiprimatera.co.id/api/postComment';

    Map<String, dynamic> data = {
      'payload': {
        'id_news': idNews,
        'id_user': mains.objectbox.boxUser.get(1)!.userId,
        'comment': comment,
      }
    };

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );
    if(response.statusCode == 200){
      Map<String, dynamic> postCommentMap = jsonDecode(response.body);

      if(postCommentMap['code'] != 95){
        if(postCommentMap['code'] == 0){
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
              count_like: query.find().first.count_like,
              status_like: query.find().first.status_like,
              comments: comments,
            );

            bubbleComments.add(
                Comment(
                  commenter_id: mains.objectbox.boxUser.get(1)!.userId,
                  name: mains.objectbox.boxUser.get(1)!.userName,
                  comment: comment,
                  created_at: DateTime.now().toString(),
                  updated_at: DateTime.now().toString(),
                )
            );

            mains.objectbox.boxNews.put(news);
            setState(() {});
          }
        }
      }
      else{
        print(postCommentMap['code']);
        print(postCommentMap['message']);
      }
    }
    else{
      print("Gagal terhubung ke server!");
      print(response.statusCode);
    }
    return response;
  }

}

class Comment{
  int? commenter_id;
  String? name;
  String? comment;
  String? created_at;
  String? updated_at;

  Comment({this.commenter_id, this.name, this.comment, this.created_at, this.updated_at});
}