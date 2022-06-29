import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:militarymessenger/models/ChatModel.dart';
import 'package:militarymessenger/models/UserModel.dart';
import 'package:militarymessenger/objectbox.g.dart';
import 'main.dart' as mains;

class ChatSearchScreen extends StatefulWidget {
  const ChatSearchScreen({Key? key}) : super(key: key);

  @override
  State<ChatSearchScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ChatSearchScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<ChatModel> _chats = [];
  List<ChatModel> _chatsTemp = [];
  final UserModel _self = mains.objectbox.boxUser.get(1)!;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var queryBuilder = mains.objectbox.boxChat.query()..order(ChatModel_.date);
    var query = queryBuilder.build();
    List<ChatModel> chats = query.find().reversed.toList();
    // _chats = chats;
    _chatsTemp = chats;
  }
  
  void searchOnChanged(String text) {
    List<ChatModel> temp = [];

    if (text.isNotEmpty) {
      // var queryBuilder = mains.objectbox.boxChat.query(ChatModel_.text.startsWith(text))..order(ChatModel_.date);
      // var query = queryBuilder.build();
      // List<ChatModel> chats = query.find().reversed.toList();
      // temp = chats;
      temp = _chatsTemp.where((element) => element.text.toLowerCase().contains(text.toLowerCase())).toList();
    } else {
      temp = [];
    }

    setState(() {
      _chats = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(63.0),
        child: AppBar(
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(
              top: 4.0,
            ),
            child: IconButton(
            icon: const Icon(
              Icons.arrow_back, 
              color: Colors.white
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          ),
          titleSpacing: 0,
          title: Container(
            margin: const EdgeInsets.only(
              top: 5.0,
              right: 30.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
            ),
            height: 42,
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    left: 13.0,
                    right: 10.0,
                  ),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 22,
                  ),
                ),
                Flexible(
                  child: TextField(
                    controller: _messageController,
                    cursorColor: Colors.blue,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16
                    ),
                    maxLines: 1,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.only(
                        left: 0,
                      ),
                      border: InputBorder.none,
                      hintText: 'Search a message...',
                      hintStyle: TextStyle(
                        color: Color(0xff99999B),
                        fontSize: 16
                      ),
                    ),
                    onChanged: (String text) => searchOnChanged(text),

                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: _chats.length,
          itemBuilder: (BuildContext context, index) {
            print('idSelf: ${_self.userId}');
            print('idSender: ${_chats[index].idSender} ${_chats[index].nameSender}');

            return Padding(
              padding: EdgeInsets.only(
                left: 10.0,
                right: 10.0,
                top: index == 0 ? 10.0 : 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(DateFormat('HH:mm').format(DateTime.parse(_chats[index].date)))
                    ],
                  ),
                  Text(
                    _chats[index].text,
                    maxLines: 3,
                  ),
                  Divider(),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}