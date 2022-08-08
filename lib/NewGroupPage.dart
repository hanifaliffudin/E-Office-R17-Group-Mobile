import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:militarymessenger/NewGroupDetail.dart';
import 'package:militarymessenger/models/ContactModel.dart';
import 'package:militarymessenger/objectbox.g.dart';
import 'package:militarymessenger/utils/variable_util.dart';
import 'package:militarymessenger/widgets/cache_image_provider_widget.dart';
import 'main.dart' as mains;
import 'Home.dart' as homes;
import 'package:fluttertoast/fluttertoast.dart';

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    Key? key,
    required this.label,
    required this.padding,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final EdgeInsets padding;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(child: Text(label)),
            Checkbox(
              value: value,
              onChanged: (bool? newValue) {
                onChanged(newValue!);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NewGroupPage extends StatefulWidget {

  @override
  State<NewGroupPage> createState() => _NewGroupPageState();
}

class _NewGroupPageState extends State<NewGroupPage> {
  var contactData,contactName;
  List<ContactModel> groups = [];

  List<ContactModel> contactList = mains.objectbox.boxContact.getAll().toList();

  List<ContactModel> _foundContact = [];

  @override
  void initState() {
    _foundContact = contactList;
    clearSelect();
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  void _runFilter(String enteredKeyword){
    List<ContactModel> results = [];
    if(enteredKeyword.isEmpty){
      results = contactList;
    }else{
      results = contactList.where((element) => element.userName!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    }

    setState(() {
      _foundContact = results;
    });
  }
  
  late FToast fToast;

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.grey,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Atleast 1 contact must be selected"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      elevation: 0,
      centerTitle: true,
      title: Text('add participants'.toUpperCase(),
        style: TextStyle(
          fontSize: 17,
        ),),
      actions: [
        InkWell(
            onTap: () {
              if(groups.length>0){
                Navigator.push(context,MaterialPageRoute(builder: (context) => (NewGroupDetail(groups))),);
              }else{
                _showToast();
              }
            },
            child: Center(
                child: Text('Next')
            )
        ),
        SizedBox(width: 25,)
      ],
    ),
    body: Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Container(
            color: Theme.of(context).appBarTheme.backgroundColor,
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Container(
              padding: EdgeInsets.only(right: 8, left: 8),
              margin: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.search,
                    color: Color(0xff99999B),
                    size: 20,
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: TextField(
                      cursorColor: Colors.grey,
                      onChanged: (value) {
                        _runFilter(value);
                      },
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search contact...',
                          hintStyle: TextStyle(
                              color: Color(0xff94A3B8),
                              fontSize: 15
                          )
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // SizedBox(height: 20,),
          Expanded(
            child: StreamBuilder<List<ContactModel>>(
                stream: homes.listControllerContact.stream,
                builder: (context, snapshot){
                  if(mains.objectbox.boxContact.isEmpty()){
                    return
                      Container(
                          margin: const EdgeInsets.only(top: 15.0),
                          child :Text(
                            'Belum ada kontak.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: Theme.of(context).inputDecorationTheme.labelStyle?.color),
                          ));
                  }
                  else
                  {
                    return ListView.builder(
                      itemCount: _foundContact.length,
                      itemBuilder:(BuildContext context,index)=>
                          Column(
                            children: [
                              InkWell(

                                child: Container(
                                  margin: EdgeInsets.only(right: 20, left: 20),
                                  padding: EdgeInsets.only(bottom: 10, top: 10),
                                  width: 1000,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                              padding: const EdgeInsets.only(right: 15),
                                              child: _foundContact[index].photo == '' ? CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Color(0xffdde1ea),
                                                child:  Icon(
                                                  Icons.person,
                                                  color: Colors.grey,
                                                ),
                                              ) :CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Color(0xffF2F1F6),
                                                // backgroundImage: _getPhoto(_foundContact[index]),
                                                backgroundImage: CacheImageProviderWidget(_foundContact[index].userId.toString(), base64.decode(_foundContact[index].photo!)),
                                              )
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxWidth: 250
                                                ),
                                                child: Text(_foundContact[index].userName!,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: Theme.of(context).inputDecorationTheme.labelStyle?.color
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Theme(
                                        data: ThemeData(
                                            unselectedWidgetColor: Colors.grey
                                        ),
                                        child: Checkbox(
                                          activeColor: Color(0xFF2481CF),
                                          shape: CircleBorder(
                                              side: BorderSide(
                                                  color: Colors.grey
                                              )
                                          ),
                                          checkColor: Colors.white,
                                          value: _foundContact[index].select,
                                          onChanged: (value) {
                                            setState(() {
                                              _foundContact[index].select = !_foundContact[index].select;

                                              if(_foundContact[index].select==true){
                                                groups.add(_foundContact[index]);
                                              }else{
                                                groups.removeWhere((item) => item.email == _foundContact[index].email);
                                              }
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 1,
                                // margin: EdgeInsets.only(top: 5),
                                color: Colors.grey.withOpacity(.2),
                              ),
                            ],
                          ),

                    );
                  }
                }
            ),
          ),
        ],
      ),
    ),
  );


  void clearSelect(){
    List<ContactModel> contactList = mains.objectbox.boxContact.getAll().toList();
    for(var item in contactList) {
      var query = mains.objectbox.boxContact.query(ContactModel_.email.equals(item.email.toString())).build();
      if (query.find().isNotEmpty) {
        final contact = ContactModel(
            id: query.find().first.id,
            userId:query.find().first.userId,
            userName: query.find().first.userName,
            email:query.find().first.email,
            photo:query.find().first.photo,
            phone: query.find().first.phone,
            select: false
        );
        mains.objectbox.boxContact.put(contact);
      }
    }
  }


}